import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/cupertino.dart';
import 'package:reown_appkit/reown_appkit.dart';

class PermitSignature {
  final ReownAppKitModal appKit;

  PermitSignature({required this.appKit});

  // EIP-712 Domain Separator
  static const String EIP712_DOMAIN_TYPE =
      'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)';
  static const String PERMIT_TYPE =
      'Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)';

  Future<String> signPermit({
    required String tokenName,
    required String version,
    required int chainId,
    required String verifyingContract,
    required String owner,
    required String spender,
    required BigInt value,
    required BigInt nonce,
    required BigInt deadline,
  }) async {
    try {
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

      // Method 1: Try eth_signTypedData_v4 first (preferred)
      try {
        final signature = await appKit.request(
          topic: appKit.session!.topic,
          chainId: 'eip155:$chainId',
          request: SessionRequestParams(
            method: 'eth_signTypedData_v4',
            params: [
              owner,
              jsonEncode(structuredData),
            ],
          ),
        );
        return signature.toString();
      } catch (e) {
        debugPrint(
            'eth_signTypedData_v4 not supported, falling back to manual signing');
      }

      // Method 2: Fallback - Manual EIP-712 hash construction
      final hash = _constructEIP712Hash(
        tokenName: tokenName,
        version: version,
        chainId: chainId,
        verifyingContract: verifyingContract,
        owner: owner,
        spender: spender,
        value: value,
        nonce: nonce,
        deadline: deadline,
      );

      // Sign the hash using personal_sign
      final signature = await appKit.request(
        topic: appKit.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [
            '0x${hash.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
            owner,
          ],
        ),
      );

      return signature.toString();
    } catch (e) {
      throw Exception('Failed to sign permit: $e');
    }
  }

  // Manual EIP-712 hash construction for fallback
  Uint8List _constructEIP712Hash({
    required String tokenName,
    required String version,
    required int chainId,
    required String verifyingContract,
    required String owner,
    required String spender,
    required BigInt value,
    required BigInt nonce,
    required BigInt deadline,
  }) {
    // Domain separator hash
    final domainHash = _hashStruct(
      EIP712_DOMAIN_TYPE,
      [
        _hashString(tokenName),
        _hashString(version),
        _padToBytes32(BigInt.from(chainId)),
        _addressToBytes32(verifyingContract),
      ],
    );

    // Message hash
    final messageHash = _hashStruct(
      PERMIT_TYPE,
      [
        _addressToBytes32(owner),
        _addressToBytes32(spender),
        _padToBytes32(value),
        _padToBytes32(nonce),
        _padToBytes32(deadline),
      ],
    );

    // Final EIP-712 hash
    final finalHash = Uint8List.fromList([
      0x19, 0x01, // EIP-712 prefix
      ...domainHash,
      ...messageHash,
    ]);

    return Uint8List.fromList(crypto.sha256.convert(finalHash).bytes);
  }

  Uint8List _hashStruct(String typeString, List<Uint8List> values) {
    final typeHash = Uint8List.fromList(
        crypto.sha256.convert(utf8.encode(typeString)).bytes);
    final data = Uint8List.fromList([
      ...typeHash,
      ...values.expand((v) => v),
    ]);
    return Uint8List.fromList(crypto.sha256.convert(data).bytes);
  }

  Uint8List _hashString(String str) {
    return Uint8List.fromList(crypto.sha256.convert(utf8.encode(str)).bytes);
  }

  Uint8List _addressToBytes32(String address) {
    final cleanAddress = address.toLowerCase().replaceFirst('0x', '');
    final bytes = Uint8List(32);
    final addressBytes = _hexToBytes(cleanAddress);
    bytes.setRange(12, 32, addressBytes);
    return bytes;
  }

  Uint8List _padToBytes32(BigInt value) {
    final bytes = Uint8List(32);
    final valueBytes = _bigIntToBytes(value);
    bytes.setRange(32 - valueBytes.length, 32, valueBytes);
    return bytes;
  }

  Uint8List _bigIntToBytes(BigInt value) {
    final hex = value.toRadixString(16);
    final paddedHex = hex.length % 2 == 0 ? hex : '0$hex';
    return _hexToBytes(paddedHex);
  }

  Uint8List _hexToBytes(String hex) {
    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}

// Usage example
class TokenPermitExample {
  final PermitSignature permitSignature;

  TokenPermitExample({required this.permitSignature});

  Future<String> signTokenPermit({
    required String userAddress,
    required String tokenContractAddress,
    required String spenderAddress,
    required BigInt amount,
    required BigInt nonce,
    required BigInt deadline,
    required int chainId,
    String tokenName = 'QPG Token',
    String version = '1',
  }) async {
    return await permitSignature.signPermit(
      tokenName: tokenName,
      version: version,
      chainId: chainId,
      verifyingContract: tokenContractAddress,
      owner: userAddress,
      spender: spenderAddress,
      value: amount,
      nonce: nonce,
      deadline: deadline,
    );
  }
}

// Helper class to parse signature components
class SignatureComponents {
  final BigInt r;
  final BigInt s;
  final int v;

  SignatureComponents({required this.r, required this.s, required this.v});

  static SignatureComponents fromSignature(String signature) {
    final cleanSig = signature.replaceFirst('0x', '');

    final r = BigInt.parse(cleanSig.substring(0, 64), radix: 16);
    final s = BigInt.parse(cleanSig.substring(64, 128), radix: 16);
    final v = int.parse(cleanSig.substring(128, 130), radix: 16);

    return SignatureComponents(
      r: r,
      s: s,
      v: v < 27 ? v + 27 : v, // Ensure v is 27 or 28
    );
  }
}

// Convert your BigInt to proper bytes32 for contract calls
Uint8List bigIntToBytes32(BigInt value) {
  final bytes = Uint8List(32);
  var tempValue = value;

// Fill bytes from right to left (big-endian)
  for (int i = 31; i >= 0; i--) {
    bytes[i] = (tempValue & BigInt.from(0xff)).toInt();
    tempValue = tempValue >> 8;
  }

  return bytes;
}

BigInt parseAmountToWei(String input) {
  try {
    final cleaned = input.trim();
    if (cleaned.isEmpty) throw const FormatException('Empty input');

    // Split into whole and fractional parts
    final parts = cleaned.split('.');
    final whole = parts[0];
    final fraction = parts.length > 1 ? parts[1] : '';

    if (parts.length > 2) throw const FormatException('Invalid format');

    // Pad the fractional part to 18 digits (Ether has 18 decimals)
    final paddedFraction = fraction.padRight(18, '0').substring(0, 18);

    // Combine whole and fractional into a full number string
    final fullAmount = whole + paddedFraction;

    // Remove leading zeros
    final normalized = fullAmount.replaceFirst(RegExp(r'^0+(?=\d)'), '');

    final value = BigInt.parse(normalized.isEmpty ? '0' : normalized);

    debugPrint(
        '-----------------------------------------------------------------------------');
    debugPrint('💰 RECEIVED AMOUNT IN WEI 💰');
    debugPrint('💴 INPUT             : $input');
    debugPrint('💵 CONVERTED OUTPUT  : $value');
    debugPrint(
        '-----------------------------------------------------------------------------');

    return value;
  } catch (_) {
    throw Exception('Invalid amount format');
  }
}
