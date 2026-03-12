import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import '../snackbar.dart';
import 'package:reown_appkit/reown_appkit.dart';

class ImprovedPermitSignature {
  final ReownAppKitModal appKit;
  final Web3Client web3Client;

  ImprovedPermitSignature({
    required this.appKit,
    required this.web3Client,
  });

  String structuredDataForSignature = '';

  // Get the current permit nonce for the user from the token contract
  Future<BigInt> getPermitNonce(String tokenAddress, String userAddress) async {
    try {
      final contract = DeployedContract(
        ContractAbi.fromJson('''[
          {
            "inputs": [{"name": "owner", "type": "address"}],
            "name": "nonces",
            "outputs": [{"name": "", "type": "uint256"}],
            "stateMutability": "view",
            "type": "function"
          }
        ]''', 'TokenContract'),
        EthereumAddress.fromHex(tokenAddress),
      );

      final result = await web3Client.call(
        contract: contract,
        function: contract.function('nonces'),
        params: [EthereumAddress.fromHex(userAddress)],
      );

      return result.first as BigInt;
    } catch (e) {
      debugPrint('Failed to get permit nonce: $e');
      return BigInt.zero; // Fallback to 0 if nonces function doesn't exist
    }
  }

  // Get domain separator from the token contract (if available)
  Future<String?> getDomainSeparator(String tokenAddress) async {
    try {
      final contract = DeployedContract(
        ContractAbi.fromJson('''[
          {
            "inputs": [],
            "name": "DOMAIN_SEPARATOR",
            "outputs": [{"name": "", "type": "bytes32"}],
            "stateMutability": "view",
            "type": "function"
          }
        ]''', 'TokenContract'),
        EthereumAddress.fromHex(tokenAddress),
      );

      final result = await web3Client.call(
        contract: contract,
        function: contract.function('DOMAIN_SEPARATOR'),
        params: [],
      );

      return '0x${(result.first as Uint8List).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
    } catch (e) {
      debugPrint('Failed to get domain separator: $e');
      return null;
    }
  }

  Future<PermitSignatureResult> signPermitWithValidation({
    required String tokenName,
    required String version,
    required int chainId,
    required String verifyingContract,
    required String owner,
    required String spender,
    required BigInt value,
    required BigInt deadline,
    BigInt? providedNonce, // Fixed: Make nonce optional parameter
    bool autoGetNonce = true,
  }) async {
    try {
      // Validate deadline
      final currentTime =
          BigInt.from(DateTime.now().millisecondsSinceEpoch ~/ 1000);
      if (deadline <= currentTime) {
        throw Exception('Deadline has already passed');
      }

      // Get current nonce automatically if requested
      BigInt nonce;
      if (autoGetNonce) {
        nonce = await getPermitNonce(verifyingContract, owner);
        debugPrint('📝 Auto-fetched permit nonce: $nonce');
      } else {
        if (providedNonce == null) {
          throw Exception('Nonce must be provided when autoGetNonce is false');
        }
        nonce = providedNonce;
      }

      // Validate chain ID matches connected wallet
      final session = appKit.session;
      if (session == null) {
        throw Exception('No active wallet session');
      }

      // Validate that connected chain matches the requested chainId
      final connectedChainId = session.namespaces?['eip155']?.accounts
          .firstWhere(
            (element) => element.contains(':421614:'),
          )
          .split(':')[1];
      debugPrint(session.namespaces?['eip155']?.accounts.toString());
      if (connectedChainId != chainId.toString()) {
        showErrorSnackkbar(
            message: 'Please disconnect & reconnect to the wallet');
        throw Exception(
            'Connected chain ($connectedChainId) does not match requested chain ($chainId)');
      }

      // Create the EIP-712 structured data
      final structuredData = {
        'types': {
          'EIP712Domain': [
            {'name': 'name', 'type': 'string'},
            {'name': 'version', 'type': 'string'},
            {'name': 'chainId', 'type': 'uint256'},
            {'name': 'verifyingContract', 'type': 'address'},
          ],
          'Permit': [
            {'name': 'owner', 'type': 'address'},
            {'name': 'spender', 'type': 'address'},
            {'name': 'value', 'type': 'uint256'},
            {'name': 'nonce', 'type': 'uint256'},
            {'name': 'deadline', 'type': 'uint256'},
          ],
        },
        'primaryType': 'Permit',
        'domain': {
          'name': tokenName,
          'version': version,
          'chainId': chainId,
          'verifyingContract': verifyingContract,
        },
        'message': {
          'owner': owner,
          'spender': spender,
          'value': value.toString(),
          'nonce': nonce.toString(),
          'deadline': deadline.toString(),
        },
      };

      debugPrint('🔏 Signing permit with data:');
      debugPrint('  Owner: $owner');
      debugPrint('  Spender: $spender');
      debugPrint('  Value: $value');
      debugPrint('  Nonce: $nonce');
      debugPrint('  Deadline: $deadline');
      debugPrint('👨‍💻 Request params:\n ${jsonEncode(structuredData)}');

      // Try eth_signTypedData_v4 (the correct method for EIP-712)
      String signature;
      try {
        structuredDataForSignature = jsonEncode(structuredData);
        final result = await appKit.request(
          topic: session.topic,
          chainId: 'eip155:$chainId',
          request: SessionRequestParams(
            method: 'eth_signTypedData_v4',
            params: [
              owner,
              jsonEncode(structuredData),
            ],
          ),
        );
        signature = result.toString();
        debugPrint('✅ Successfully signed with eth_signTypedData_v4');
      } catch (e) {
        debugPrint('❌ eth_signTypedData_v4 failed: $e');
        throw Exception(
            'Wallet does not support EIP-712 signing (eth_signTypedData_v4). This is required for permit signatures.');
      }

      // Parse signature components
      final components = SignatureComponents.fromSignature(signature);

      return PermitSignatureResult(
        signature: signature,
        r: components.r,
        s: components.s,
        v: components.v,
        nonce: nonce,
        deadline: deadline,
        domain: structuredData['domain'] as Map<String, dynamic>,
        message: structuredData['message'] as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('🚫 Permit signing failed: $e');
      rethrow;
    }
  }

  // Validate signature before using it
  Future<bool> validatePermitSignature({
    required String tokenAddress,
    required String owner,
    required PermitSignatureResult permitResult,
  }) async {
    try {
      // Check if nonce is still valid
      final currentNonce = await getPermitNonce(tokenAddress, owner);
      if (currentNonce != permitResult.nonce) {
        debugPrint(
            '❌ Nonce mismatch: expected ${permitResult.nonce}, got $currentNonce');
        return false;
      }

      // Check deadline
      final currentTime =
          BigInt.from(DateTime.now().millisecondsSinceEpoch ~/ 1000);
      if (permitResult.deadline <= currentTime) {
        debugPrint('❌ Permit deadline has expired');
        return false;
      }

      debugPrint('✅ Permit signature validation passed');
      return true;
    } catch (e) {
      debugPrint('❌ Permit validation error: $e');
      return false;
    }
  }
}

// Updated SignatureComponents class with better validation
class SignatureComponents {
  final BigInt r;
  final BigInt s;
  final int v;

  SignatureComponents({required this.r, required this.s, required this.v});

  static SignatureComponents fromSignature(String signature) {
    // Remove '0x' prefix if present
    final cleanSig =
        signature.startsWith('0x') ? signature.substring(2) : signature;

    if (cleanSig.length != 130) {
      throw Exception(
          'Invalid signature length: expected 130 characters, got ${cleanSig.length}');
    }

    // Extract r, s, v components
    final rHex = cleanSig.substring(0, 64);
    final sHex = cleanSig.substring(64, 128);
    final vHex = cleanSig.substring(128, 130);

    // Parse components
    final r = BigInt.parse(rHex, radix: 16);
    final s = BigInt.parse(sHex, radix: 16);
    var v = int.parse(vHex, radix: 16);

    // Validate ECDSA signature bounds
    final secp256k1N = BigInt.parse(
        'fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141',
        radix: 16);
    if (r <= BigInt.zero || r >= secp256k1N) {
      throw Exception('Invalid signature: r value out of range');
    }
    if (s <= BigInt.zero || s >= secp256k1N) {
      throw Exception('Invalid signature: s value out of range');
    }

    // Check for malleable signatures (EIP-2: s should be in lower half)
    final halfN = secp256k1N >> 1;
    if (s > halfN) {
      throw Exception(
          'Invalid signature: s value too high (malleable signature)');
    }

    // Normalize v value (should be 27 or 28 for Ethereum)
    // If v is 0 or 1, add 27 to get the correct recovery value
    if (v < 27) {
      v += 27;
    }

    // Validate v value
    if (v != 27 && v != 28) {
      throw Exception('Invalid signature: v must be 27 or 28, got $v');
    }

    debugPrint('🔍 Parsed signature components:');
    debugPrint('  R: 0x${r.toRadixString(16)}');
    debugPrint('  S: 0x${s.toRadixString(16)}');
    debugPrint('  V: $v');

    return SignatureComponents(r: r, s: s, v: v);
  }

  // Helper method to format r and s values for contract calls
  String getFormattedR() => '0x${r.toRadixString(16).padLeft(64, '0')}';
  String getFormattedS() => '0x${s.toRadixString(16).padLeft(64, '0')}';
}

// Result class to hold all permit signature data
class PermitSignatureResult {
  final String signature;
  final BigInt r;
  final BigInt s;
  final int v;
  final BigInt nonce;
  final BigInt deadline;
  final Map<String, dynamic> domain;
  final Map<String, dynamic> message;

  PermitSignatureResult({
    required this.signature,
    required this.r,
    required this.s,
    required this.v,
    required this.nonce,
    required this.deadline,
    required this.domain,
    required this.message,
  });

  // Check if signature is still valid
  bool get isExpired {
    final currentTime =
        BigInt.from(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    return deadline <= currentTime;
  }

  // Get time remaining until expiration
  Duration get timeUntilExpiration {
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = deadline.toInt() - currentTime;
    return Duration(seconds: remaining > 0 ? remaining : 0);
  }

  // Get formatted values for contract calls
  String get formattedR => '0x${r.toRadixString(16).padLeft(64, '0')}';
  String get formattedS => '0x${s.toRadixString(16).padLeft(64, '0')}';

  @override
  String toString() {
    return 'PermitSignatureResult{\n'
        '  signature: $signature,\n'
        '  r: $formattedR,\n'
        '  s: $formattedS,\n'
        '  v: $v,\n'
        '  nonce: $nonce,\n'
        '  deadline: $deadline,\n'
        '  isExpired: $isExpired\n'
        '}';
  }
}

// // Example usage with proper error handling and retry logic
// class SafeTokenPermitFlow {
//   final ImprovedPermitSignature permitSigner;
//   static const int maxRetries = 3;
//
//   SafeTokenPermitFlow({required this.permitSigner});
//
//   Future<PermitSignatureResult?> executePermitFlow({
//     required String userAddress,
//     required String tokenContractAddress,
//     required String spenderAddress,
//     required BigInt amount,
//     required Duration validityDuration,
//     String tokenName = 'QPG Token',
//     String version = '1',
//     required int chainId,
//     int retryCount = 0,
//   }) async {
//     try {
//       // Calculate deadline (current time + validity duration)
//       final deadline = BigInt.from(
//         (DateTime.now().add(validityDuration).millisecondsSinceEpoch ~/ 1000),
//       );
//
//       debugPrint('🚀 Starting permit flow (attempt ${retryCount + 1})...');
//       debugPrint('  Token: $tokenName');
//       debugPrint('  Amount: $amount');
//       debugPrint('  Deadline: $deadline');
//
//       // Sign the permit
//       final permitResult = await permitSigner.signPermitWithValidation(
//         tokenName: tokenName,
//         version: version,
//         chainId: chainId,
//         verifyingContract: tokenContractAddress,
//         owner: userAddress,
//         spender: spenderAddress,
//         value: amount,
//         deadline: deadline,
//         autoGetNonce: true,
//       );
//
//       debugPrint('✅ Permit signed successfully');
//       debugPrint(permitResult.toString());
//
//       // Validate the signature before returning
//       final isValid = await permitSigner.validatePermitSignature(
//         tokenAddress: tokenContractAddress,
//         owner: userAddress,
//         permitResult: permitResult,
//       );
//
//       if (!isValid) {
//         throw Exception('Permit signature validation failed');
//       }
//
//       return permitResult;
//     } catch (e) {
//       debugPrint('🚫 Permit flow failed (attempt ${retryCount + 1}): $e');
//
//       // Retry logic for certain errors
//       if (retryCount < maxRetries && _shouldRetry(e)) {
//         debugPrint('🔄 Retrying permit flow...');
//         await Future.delayed(Duration(seconds: retryCount + 1));
//         return executePermitFlow(
//           userAddress: userAddress,
//           tokenContractAddress: tokenContractAddress,
//           spenderAddress: spenderAddress,
//           amount: amount,
//           validityDuration: validityDuration,
//           tokenName: tokenName,
//           version: version,
//           chainId: chainId,
//           retryCount: retryCount + 1,
//         );
//       }
//
//       return null;
//     }
//   }
//
//   bool _shouldRetry(dynamic error) {
//     final errorString = error.toString().toLowerCase();
//     return errorString.contains('nonce') || errorString.contains('network') || errorString.contains('timeout');
//   }
// }
