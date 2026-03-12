import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/login_creadential.dart';
import '../models/api_response.dart';
import '../repository/wallet_repository.dart';
import '../utils/snackbar.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/crypto.dart';
import '../models/bill_type_model.dart';
import '../models/card_detail_model.dart';
import '../models/transaction_history_model.dart';
import '../models/wallet_summery_model.dart';
import '../utils/wallet_util/permit_signer_util.dart';

class WalletManagementService extends GetxService {
  final WalletRepository walletRepository = WalletRepository();

  // * GET SAVED CARDS OF THE USER FOR ALL PAGES
  // * IF EXIST RETURN UNLESS FORCE PULL IS [true]
  Rx<List<CardDetailsModel>> userCardList = Rx([]);
  RxBool userCardIsLoading = true.obs;

  Future<void> getAllUserCards({bool? forcePull}) async {
    if (userCardList.value.isNotEmpty && !(forcePull ?? false)) return;
    userCardIsLoading.value = true;
    userCardList.value.clear();
    ApiResponse apiResponse = await walletRepository.getUserCardList();
    userCardList.value = apiResponse.data as List<CardDetailsModel>;
    userCardIsLoading.value = false;
  }

  // * GET TRANSACTION BILL TYPES FOR ALL PAGES
  // * IF EXIST RETURN UNLESS FORCE PULL IS [true]
  Rx<List<BillTypeModel>> transactionBillTypeList = Rx([]);
  RxBool transactionBillTypeIsLoading = true.obs;

  Future<void> getAllTransactionBillTypes({bool? forcePull}) async {
    if (transactionBillTypeList.value.isNotEmpty && !(forcePull ?? false)) {
      return;
    }
    transactionBillTypeIsLoading.value = true;
    transactionBillTypeList.value.clear();
    ApiResponse apiResponse = await walletRepository.getTransactionTypes();
    transactionBillTypeList.value = apiResponse.data as List<BillTypeModel>;
    transactionBillTypeIsLoading.value = false;
  }

  // * GET BILL TYPES FOR ALL PAGES
  // * IF EXIST RETURN UNLESS FORCE PULL IS [true]
  Rx<List<BillTypeModel>> billTypeList = Rx([]);
  RxBool billTypeIsLoading = true.obs;

  Future<void> getAllBillTypes({bool? forcePull}) async {
    if (transactionBillTypeList.value.isNotEmpty && !(forcePull ?? false)) {
      return;
    }
    billTypeIsLoading.value = true;
    billTypeList.value.clear();
    ApiResponse apiResponse = await walletRepository.getTransactionTypes();
    billTypeList.value = apiResponse.data as List<BillTypeModel>;
    billTypeIsLoading.value = false;
  }

  // * GET COUNTRY LIST
  Rx<List<String>> countryList = Rx([]);
  RxBool countryIsLoading = true.obs;

  Future<void> getAllCountries({bool? forcePull}) async {
    if (countryList.value.isNotEmpty && !(forcePull ?? false)) return;
    countryIsLoading.value = true;
    countryList.value.clear();
    ApiResponse apiResponse = await walletRepository.getCountryList();
    countryList.value = apiResponse.data as List<String>;
    countryIsLoading.value = false;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET DATA OF TRANSACTION SUMMARY & LIST TO INIT THE DASHBOARD         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Rx<List<TransactionHistoryModel>> transactionList = Rx([]);
  Rx<WalletSummeryModel?> walletSummary = Rx(null);
  RxBool dataLoading = true.obs;

  // * GET WALLET SUMMARY
  Future<void> getWalletSummery() async {
    walletSummary.value = await walletRepository.getWalletSummary();
  }

  // * GET TRANSACTION LIST
  Future<void> getTransactionList() async {
    transactionList.value.clear();
    transactionList.value = await walletRepository.getTransactionList();
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET CORE SUMMARY AND TRANSACTION LIST                                ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> getAllDataFromSummaryAndTransaction() async {
    dataLoading.value = true;
    await getWalletSummery();
    await getTransactionList();
    dataLoading.value = false;
  }

  // $┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓━┓━┓
  // $┃ ┃ ┃ ┃ ┃ ┃ ┃          CONFIG FOR DEEP LINK            ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃
  // $┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛━┛━┛

  RxString deepLink = ''.obs;
  late LoginCredential loginCredential;
  final AppLinks _appLinks = AppLinks();

  // ? GETTING INITIAL DEEP LINK FOR MATCHING
  Future<void> getDeepLink() async {
    deepLink.value = await loginCredential.getDeepLinkURL() ?? '';
    debugPrint('RECEIVED DEEP LINK : $deepLink');
  }

  void deepLinkListener() {
    debugPrint(
        'STARTED THE DEEP LINK LISTENER -----------------------------------');
    // Listen for app links while app is running
    _appLinks.uriLinkStream.listen((uri) {
      debugPrint(
          'STARTED THE DEEP LINK LISTENER ----------------------------------- EVENT !!!');
      debugPrint('Deep link received: $uri');

      if (uri.scheme == 'qp' && uri.host == 'com.quanumpossibilities.qp') {
        final status = uri.queryParameters['status'];
        if (status == 'approved') {
          // Handle success
        } else {
          // Handle rejection
        }
      }
    });
  }

  // #┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓
  // #┃ ┃ ┃ ┃ ┃ ┃ ┃         CONFIG FOR DEEP LINK END          ┃ ┃ ┃ ┃ ┃ ┃ ┃
  // #┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛

  // *┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓
  // *┃ ┃ ┃ ┃ ┃ ┃ ┃       BLOCK CHAIN INSTIGATION START       ┃ ┃ ┃ ┃ ┃ ┃ ┃
  // *┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛

  Rx<ReownAppKitModalSession?> session = Rx(null);
  RxString account = ''.obs;
  RxString address = ''.obs;
  RxString topic = ''.obs;
  RxBool connected = false.obs;
  final tokenName = 'Quantum Possibilities Gold Coin';

  // * THIS IS THE [ethers.BrowserProvider]
  final ethProvider = Web3Client(
    // 'http://10.81.100.52:8545', // Replace with your custom RPC
    // 'http://217.73.238.134:8545', // Replace with your custom RPC
    'https://arb-sepolia.g.alchemy.com/v2/7aJwD9yTUzydYjeeawtuKFF3tgKQ9CID',
    // 'https://sepolia-rollup.arbitrum.io/rpc',
    http.Client(),
  );

  // * ABI CODE --- FOR CONTRACTS

  late EthPrivateKey ethEngin;
  late EthPrivateKey ethEnginCoin;

  late DeployedContract contractEngin;
  late DeployedContract contractCoin;

  late PermitSignature permitSignature;

  // ! REMOVE CONST LATER
  String projectID = '84811a3f97c47ce97d4ecac7d99bcb35';
  String chainId = 'eip155';
  String chainCode = '421614';
  String chainIdFull = 'eip155:421614';

  // String chainIdFull = 'eip155:1';

  Future<void> openMetaMask(String wcUri) async {
    final encodedUri = Uri.encodeComponent(wcUri);
    final metaMaskUri = 'metamask://wc?uri=$encodedUri';
    final fallbackUri =
        Uri.parse('https://play.google.com/store/apps/details?id=io.metamask');

    try {
      final launchUri = Uri.parse(metaMaskUri);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('MetaMask launch error: $e');
    }
  }

  // @***********************************************************************
  // @            ************** TRANSACTIONS *****************
  // @***********************************************************************

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  INIT THE CONTRACT JSON's WITH ENGIN                                  ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> initTheContractJsonWithEngin() async {
    try {
      final engineJson =
          jsonDecode(await rootBundle.loadString('assets/abi/QPGEngine.json'));
      // final coinJson = jsonDecode(await rootBundle.loadString('assets/abi/QPGStableCoin.json'));
      final coinJson = jsonDecode(
          await rootBundle.loadString('assets/abi/ERC20Permit.json'));

      ethEngin =
          EthPrivateKey.fromHex('0xe0ecfbe9d8fbcc5a577f45b76f1cc572b12c9f8f');
      // ethEnginCoin = EthPrivateKey.fromHex('0x003bca8228f6c513c30f1a0883f3581a0bdcb505');
      ethEnginCoin =
          EthPrivateKey.fromHex('0x3035c7015bb735f22493fa1b6bdf35d8c413bc3e');

      // ✅ FIXED: Only initialize contracts with addresses, no private keys
      contractEngin = DeployedContract(
        ContractAbi.fromJson(jsonEncode(engineJson['abi']), 'QPGEngine'),
        EthereumAddress.fromHex(
            '0xe0ecfbe9d8fbcc5a577f45b76f1cc572b12c9f8f'), // Contract address
      );

      contractCoin = DeployedContract(
        ContractAbi.fromJson(jsonEncode(coinJson['abi']), 'QPGStableCoin'),
        // EthereumAddress.fromHex('0x003bca8228f6c513c30f1a0883f3581a0bdcb505'), // Contract address
        EthereumAddress.fromHex(
            '0x3035c7015bb735f22493fa1b6bdf35d8c413bc3e'), // Contract address
      );

      debugPrint('CONTRACT INIT DONE ------------------------------');
      debugPrint('${ethEngin.address}');
      debugPrint('${ethEngin.privateKey}');
      debugPrint('${contractEngin.address}');
      debugPrint(contractCoin.abi.name);
    } catch (error) {
      debugPrint('ERROR ON CONTRACT INIT: $error');
    }
  }

  // Generic method to call a read function on a contract
  Future<dynamic> callContractReadFunction({
    required DeployedContract contract,
    required String functionName,
    List<dynamic> params = const [],
  }) async {
    try {
      final function = contract.function(functionName);
      final result = await ethProvider.call(
        contract: contract,
        function: function,
        params: params,
      );
      return result;
    } catch (error) {
      debugPrint('Error calling contract read function: $error');
      rethrow;
    }
  }

  Future<String> getConnectedAccountBalance() async {
    if (myCryptoAccountAddress.value.isEmpty) return '0';
    // Add balance check before simulation
    final tokenBalance = await ethProvider.call(
      contract: contractCoin,
      function: contractCoin.function('balanceOf'),
      params: [EthereumAddress.fromHex(myCryptoAccountAddress.value)],
    );
    if (tokenBalance.isEmpty) {
      return '0';
    }
    return tokenBalance.first.toString();
  }

  // * =============================================================================

  Future<double> getMintingFeeForRetailersInPercentage() async {
    if (myCryptoAccountAddress.value.isEmpty) return 0.0;
    final value = await ethProvider.call(
      contract: contractEngin,
      function: contractEngin.function('getMintingFeeForRetailersInPercentage'),
      params: [],
    );
    if (value.isEmpty) {
      return 0.0;
    }
    return double.parse(value.first.toString()) / 100;
  }

  Future<double> getSendMoneyFeeForRetailersInPercentage() async {
    if (myCryptoAccountAddress.value.isEmpty) return 0.0;
    final value = await ethProvider.call(
      contract: contractEngin,
      function:
          contractEngin.function('getSendMoneyFeeForRetailersInPercentage'),
      params: [],
    );
    if (value.isEmpty) {
      return 0.0;
    }
    return double.parse(value.first.toString()) / 100;
  }

  double calculateCommission(double commissionPercent, int amount) {
    return amount * (commissionPercent / 100);
  }

  // * ==============================================================================================

  Future<String?> callContractWriteFunction({
    required DeployedContract contract,
    required String functionName,
    List<dynamic> params = const [],
    List<dynamic> defaultParams = const [],
    BigInt? value,
  }) async {
    try {
      if (!appKitModal.isConnected) {
        showErrorSnackkbar(message: 'Please connect to your account first');
        return null;
      }

      // Get current gas prices from the network
      final gasPrice = await ethProvider.getGasPrice();
      final maxPriorityFeePerGas = BigInt.from(1.5 * 1e9); // 1.5 gwei
      final maxFeePerGas = gasPrice.getInWei + maxPriorityFeePerGas;

      final function = contract.function(functionName);
      final data = function.encodeCall(params);

      final transaction = {
        'from': EthereumAddress.fromHex(myCryptoAccountAddress.value).hexEip55,
        'to': contract.address.hexEip55,
        'data': '0x${bytesToHex(data)}',
        if (value != null) 'value': '0x${value.toRadixString(16)}',
        'maxFeePerGas': '0x${maxFeePerGas.toRadixString(16)}',
        'maxPriorityFeePerGas': '0x${maxPriorityFeePerGas.toRadixString(16)}',
        'chainId': chainIdFull.split(':').last,
      };

      final response = await appKitModal.request(
        topic: topic.value,
        chainId: chainIdFull,
        request: SessionRequestParams(
            method: 'eth_sendTransaction', params: [transaction]),
      );

      if (response is String) {
        // Wait for transaction confirmation
        final receipt = await ethProvider.getTransactionReceipt(response);
        if (receipt?.status == true) {
          if (defaultParams.isNotEmpty) {
            await walletRepository.updateMintRequest(
              requestId: defaultParams[0].toString(),
              isMinted: true,
            );
          }
          showSuccessSnackkbar(message: 'Transaction was successful');
          return response; // Return transaction hash
        } else {
          if (defaultParams.isNotEmpty) {
            await walletRepository.updateMintRequest(
              requestId: defaultParams[0].toString(),
              isMinted: false,
            );
          }
          showErrorSnackkbar(message: 'Transaction failed');
          return null;
        }
      } else if (response is Map) {
        if (defaultParams.isNotEmpty) {
          await walletRepository.updateMintRequest(
            requestId: defaultParams[0].toString(),
            isMinted: false,
          );
        }
        showErrorSnackkbar(message: 'Transaction was rejected');
        return null;
      }

      return null;
    } catch (error) {
      debugPrint('Error calling contract write function: $error');
      showErrorSnackkbar(message: 'Transaction failed: ${error.toString()}');
      rethrow;
    }
  }

  // await launchUrl(Uri.parse('metamask://'), mode: LaunchMode.externalApplication);

// Enhanced version with debugging and signer verification
  Future<String?> callContractWriteFunctionV3Alt({
    required DeployedContract contract,
    required String functionName,
    List<dynamic> params = const [],
    List<dynamic> defaultParams = const [],
    BigInt? value,
  }) async {
    try {
      if (!appKitModal.isConnected) {
        showErrorSnackkbar(message: 'Please connect to your account first');
        return null;
      }

      // Debug: Print current connected address
      final connectedAddress = myCryptoAccountAddress.value;
      debugPrint('Connected address: $connectedAddress');
      debugPrint('Contract address: ${contract.address.hex}');
      debugPrint('Function name: $functionName');
      debugPrint('Parameters: $params');

      // Verify the connected wallet address matches expected signer
      final walletAddress =
          appKitModal.session?.namespaces?.values.first.accounts
              .firstWhere(
                (element) => element.split(':')[1].compareTo(chainCode) == 0,
              )
              .split(':')[2];
      debugPrint('Wallet session address: $walletAddress');

      if (walletAddress != null &&
          walletAddress.toLowerCase() != connectedAddress.toLowerCase()) {
        showErrorSnackkbar(message: 'Address mismatch between wallet and app');
        return null;
      }

      final function = contract.function(functionName);
      final data = function.encodeCall(params);

      final result = await ethProvider.call(
        sender: EthereumAddress.fromHex(connectedAddress),
        contract: contractEngin,
        function: function,
        params: params,
      );

      debugPrint('RESULT______________________ $result');

      // Check balance before proceeding
      final balance = await ethProvider
          .getBalance(EthereumAddress.fromHex(connectedAddress));
      debugPrint(
          'Account balance: ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ETH)');

      debugPrint('SEND TO CONTRACT ADDRESS: ${contract.address}');

      final transaction = Transaction(
        from: EthereumAddress.fromHex(connectedAddress),
        to: contract.address,
        data: data,
        value: EtherAmount.inWei(value ?? BigInt.zero),
        // maxFeePerGas: EtherAmount.inWei(maxFeePerGas),
        // maxPriorityFeePerGas: EtherAmount.inWei(maxPriorityFeePerGas),
        // maxGas: gasLimit.toInt(),
        // nonce: nonce,
        // gasPrice: EtherAmount.inWei(value ?? BigInt.zero)
      );

      // Use wallet connect to sign and send
      final txHash = await appKitModal.requestWriteContract(
        deployedContract: contract,
        functionName: functionName,
        topic: topic.value,
        chainId: chainIdFull,
        transaction: transaction,
        parameters: params, // Make sure parameters are passed
      );

      debugPrint('&&&&&&&&&&&&&&& : $txHash');
      debugPrint('&&&&&&&&&&&&&&& : $txHash');
      debugPrint('&&&&&&&&&&&&&&& : $txHash');
      debugPrint('&&&&&&&&&&&&&&& : $txHash');
      debugPrint('&&&&&&&&&&&&&&& : $txHash');

      if (txHash is String) {
        debugPrint('Transaction hash: $txHash');
        debugPrintTransactionDetails(hash: txHash);

        // Wait for transaction confirmation
        TransactionReceipt? receipt;
        int attempts = 0;
        const maxAttempts = 60;

        while (receipt == null && attempts < maxAttempts) {
          await Future.delayed(const Duration(seconds: 1));
          try {
            receipt = await ethProvider.getTransactionReceipt(txHash);
          } catch (e) {
            debugPrint('Error getting receipt: $e');
          }
          attempts++;
        }

        if (receipt?.status == true) {
          if (defaultParams.isNotEmpty) {
            await walletRepository.updateMintRequest(
              requestId: defaultParams[0].toString(),
              isMinted: true,
            );
          }
          showSuccessSnackkbar(message: 'Transaction was successful');
          return txHash;
        } else {
          if (defaultParams.isNotEmpty) {
            await walletRepository.updateMintRequest(
              requestId: defaultParams[0].toString(),
              isMinted: false,
            );
          }
          showErrorSnackkbar(message: 'Transaction failed or timed out');
          return null;
        }
      } else {
        if (defaultParams.isNotEmpty) {
          await walletRepository.updateMintRequest(
            requestId: defaultParams[0].toString(),
            isMinted: false,
          );
        }
        showErrorSnackkbar(message: 'Transaction was rejected');
        return null;
      }
    } catch (error) {
      debugPrint('Error calling contract write function: $error');
      if (defaultParams.isNotEmpty) {
        await walletRepository.updateMintRequest(
          requestId: defaultParams[0].toString(),
          isMinted: false,
        );
      }
      showErrorSnackkbar(message: 'Transaction failed: ${error.toString()}');
      rethrow;
    }
  }

  Future<String?> validateAddBalancePayment(
      {required String requestId,
      required String signature,
      required String amount,
      required bool isUpdate}) async {
    if (!isUpdate) {
      await walletRepository.saveMintRequest(
        requestId: requestId,
        to: myCryptoAccountAddress.value,
        amountInWei: amount,
        signature: signature,
        isMinted: false,
      );
    }

    return await callContractWriteFunctionV3Alt(
      contract: contractEngin,
      functionName: 'mintWithPermit',
      params: [
        Uint8List.fromList(hexToBytes(requestId)),
        // wallet.EthereumAddress.fromHex(myCryptoAccountAddress.value),
        parseAmountToWei(amount),
        hexToBytes(signature),
      ],
      defaultParams: [
        requestId,
        // myCryptoAccountAddress.value,
        amount,
        signature,
      ],
      // value: BigInt.tryParse('0.000000000000001'),
    );
  }

  Future<String?> transferForRetailersWithPermit({
    List<dynamic> params = const [],
    List<dynamic>? defaultParams,
    String? sendToAddress,
    BigInt? value,
  }) async {
    try {
      if (!appKitModal.isConnected) {
        showErrorSnackkbar(message: 'Please connect to your account first');
        return null;
      }

      final connectedAddress = myCryptoAccountAddress.value;

      // Add detailed parameter logging
      debugPrint(
          '🟢=== TRANSFER PARAMETERS =======================================================');
      debugPrint('Request ID    : ${params[0]}');
      debugPrint('To Address    : ${params[1]}');
      debugPrint('Amount        : ${params[2]}');
      debugPrint('Deadline      : ${params[3]}');
      debugPrint('V             : ${params[4]}');
      debugPrint('R             : ${params[5]}');
      debugPrint('S             : ${params[6]}');
      debugPrint('Signature     : ${params[7]}');
      debugPrint(
          '🔴=== TRANSFER PARAMETERS =======================================================');

      // Add detailed parameter logging
      debugPrint(
          '🟢=== TRANSFER PARAMETERS =======================================================');
      debugPrint('Request ID    : ${defaultParams?[0]}');
      debugPrint('To Address    : ${defaultParams?[1]}');
      debugPrint('Amount        : ${defaultParams?[2]}');
      debugPrint('Deadline      : ${defaultParams?[3]}');
      debugPrint('V             : ${defaultParams?[4]}');
      debugPrint('R             : ${defaultParams?[5]}');
      debugPrint('S             : ${defaultParams?[6]}');
      debugPrint('Signature     : ${defaultParams?[7]}');
      debugPrint(
          '🔴=== TRANSFER PARAMETERS =======================================================');

      // Verify wallet connection
      final walletAddress =
          appKitModal.session?.namespaces?.values.first.accounts
              .firstWhere(
                (element) => element.split(':')[1].compareTo(chainCode) == 0,
              )
              .split(':')[2];

      if (walletAddress != null &&
          walletAddress.toLowerCase() != connectedAddress.toLowerCase()) {
        showErrorSnackkbar(message: 'Address mismatch between wallet and app');
        return null;
      }

      const functionName = 'transferForRetailersWithPermit';
      final function = contractEngin.function(functionName);

      // Add balance check before simulation
      final tokenBalance = await ethProvider.call(
        contract: contractCoin,
        function: contractCoin.function('balanceOf'),
        params: [EthereumAddress.fromHex(connectedAddress)],
      );
      debugPrint('Token Balance: $tokenBalance');

      // Add nonce check
      final currentNonce = await ethProvider.call(
        contract: contractCoin,
        function: contractCoin.function('nonces'),
        params: [EthereumAddress.fromHex(connectedAddress)],
      );
      debugPrint('Current Nonce: $currentNonce');

      try {
        final result = await ethProvider.call(
          sender: EthereumAddress.fromHex(connectedAddress),
          contract: contractEngin,
          function: function,
          params: params,
        );
        debugPrint('🟢Simulation Result🟢: $result');
      } catch (e) {
        debugPrint('🐞Simulation Error🐞: $e');
        // Check if it's a revert with a reason
        if (e.toString().contains('execution reverted')) {
          showErrorSnackkbar(
              message: 'Transaction would fail: ${e.toString()}');
        }
        return null;
      }

      // Rest of the function remains the same...
      final data = function.encodeCall(params);
      final transaction = Transaction(
        from: EthereumAddress.fromHex(connectedAddress),
        to: contractEngin.address,
        data: data,
        value: EtherAmount.inWei(value ?? BigInt.zero),
      );

      final txHash = await appKitModal.requestWriteContract(
        deployedContract: contractEngin,
        functionName: functionName,
        topic: topic.value,
        chainId: chainIdFull,
        transaction: transaction,
        parameters: params,
      );

      if (txHash is String) {
        debugPrint('Transaction hash: $txHash');
        debugPrintTransactionDetails(hash: txHash);

        // Wait for transaction confirmation
        TransactionReceipt? receipt;
        int attempts = 0;
        const maxAttempts = 60;

        while (receipt == null && attempts < maxAttempts) {
          await Future.delayed(const Duration(seconds: 1));
          try {
            receipt = await ethProvider.getTransactionReceipt(txHash);
          } catch (e) {
            debugPrint('Error getting receipt: $e');
          }
          attempts++;
        }

        if (receipt?.status == true) {
          await walletRepository.updateSendMoneyRequest(
              requestId: defaultParams![0], isSent: true);
          showSuccessSnackkbar(message: 'Transaction was successful');
          return txHash;
        } else {
          showErrorSnackkbar(message: 'Transaction failed or timed out');
          return null;
        }
      } else {
        showErrorSnackkbar(message: 'Transaction was rejected');
        return null;
      }
    } catch (error) {
      debugPrint('Error in transferForRetailersWithPermit: $error');
      showErrorSnackkbar(message: 'Transaction failed: ${error.toString()}');
      rethrow;
    }
  }

  Future<String?> withdrawMoneyToCard({
    List<dynamic> params = const [],
    List<dynamic>? defaultParams,
    BigInt? value,
  }) async {
    try {
      if (!appKitModal.isConnected) {
        showErrorSnackkbar(message: 'Please connect to your account first');
        return null;
      }

      final connectedAddress = myCryptoAccountAddress.value;

      // Add detailed parameter logging
      debugPrint(
          '🟢=== TRANSFER PARAMETERS =======================================================');
      debugPrint('Request ID    : ${params[0]}');
      debugPrint('Amount        : ${params[1]}');
      debugPrint('Signature     : ${params[2]}');
      debugPrint(
          '🔴=== TRANSFER PARAMETERS =======================================================');

      // Add detailed parameter logging
      debugPrint(
          '🟢=== TRANSFER PARAMETERS =======================================================');
      debugPrint('Request ID    : ${defaultParams?[0]}');
      debugPrint('Amount        : ${defaultParams?[1]}');
      debugPrint('Signature     : ${defaultParams?[2]}');
      debugPrint(
          '🔴=== TRANSFER PARAMETERS =======================================================');

      // Verify wallet connection
      final walletAddress =
          appKitModal.session?.namespaces?.values.first.accounts
              .firstWhere(
                (element) => element.split(':')[1].compareTo(chainCode) == 0,
              )
              .split(':')[2];

      if (walletAddress != null &&
          walletAddress.toLowerCase() != connectedAddress.toLowerCase()) {
        showErrorSnackkbar(message: 'Address mismatch between wallet and app');
        return null;
      }

      final result = await withdrawApprovalFunction(amount: params[1]);
      if (result != null) {
        const functionName = 'redeemCollateralAndBurnQPGForRetailers';
        final function = contractEngin.function(functionName);

        // Add balance check before simulation
        final tokenBalance = await ethProvider.call(
          contract: contractCoin,
          function: contractCoin.function('balanceOf'),
          params: [EthereumAddress.fromHex(connectedAddress)],
        );
        debugPrint('Token Balance: $tokenBalance');

        // Add nonce check
        final currentNonce = await ethProvider.call(
          contract: contractCoin,
          function: contractCoin.function('nonces'),
          params: [EthereumAddress.fromHex(connectedAddress)],
        );
        debugPrint('Current Nonce: $currentNonce');

        try {
          final result = await ethProvider.call(
            sender: EthereumAddress.fromHex(connectedAddress),
            contract: contractEngin,
            function: function,
            params: params,
          );
          debugPrint('🟢Simulation Result🟢: $result');
        } catch (e) {
          debugPrint('🐞Simulation Error🐞: $e');
          // Check if it's a revert with a reason
          if (e.toString().contains('execution reverted')) {
            showErrorSnackkbar(
                message: 'Transaction would fail: ${e.toString()}');
          }
          return null;
        }

        // Rest of the function remains the same...
        final data = function.encodeCall(params);
        final transaction = Transaction(
          from: EthereumAddress.fromHex(connectedAddress),
          to: contractEngin.address,
          data: data,
          value: EtherAmount.inWei(value ?? BigInt.zero),
        );

        final txHash = await appKitModal.requestWriteContract(
          deployedContract: contractEngin,
          functionName: functionName,
          topic: topic.value,
          chainId: chainIdFull,
          transaction: transaction,
          parameters: params,
        );

        if (txHash is String) {
          debugPrint('Transaction hash: $txHash');
          debugPrintTransactionDetails(hash: txHash);

          // Wait for transaction confirmation
          TransactionReceipt? receipt;
          int attempts = 0;
          const maxAttempts = 60;

          while (receipt == null && attempts < maxAttempts) {
            await Future.delayed(const Duration(seconds: 1));
            try {
              receipt = await ethProvider.getTransactionReceipt(txHash);
            } catch (e) {
              debugPrint('Error getting receipt: $e');
            }
            attempts++;
          }

          if (receipt?.status == true) {
            await walletRepository.updateWithdrawRequest(
                requestId: defaultParams![0], isWithdrawn: true);
            showSuccessSnackkbar(message: 'Withdrawn was successful');
            return txHash;
          } else {
            showErrorSnackkbar(message: 'Withdrawn failed or timed out');
            return null;
          }
        } else {
          showErrorSnackkbar(message: 'Withdrawn was rejected');
          return null;
        }
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('Error in transferForRetailersWithPermit: $error');
      showErrorSnackkbar(message: 'Transaction failed: ${error.toString()}');
      rethrow;
    }
  }

  Future<String?> withdrawApprovalFunction({required BigInt amount}) async {
    const functionName = 'approve';
    final function = contractCoin.function(functionName);

    final connectedAddress = myCryptoAccountAddress.value;

    try {
      final result = await ethProvider.call(
        sender: EthereumAddress.fromHex(connectedAddress),
        contract: contractCoin,
        function: function,
        params: [contractEngin.address, amount],
      );
      debugPrint('🟢Simulation Result🟢: $result');
    } catch (e) {
      debugPrint('🐞Simulation Error🐞: $e');
      // Check if it's a revert with a reason
      if (e.toString().contains('execution reverted')) {
        showErrorSnackkbar(message: 'Transaction would fail: ${e.toString()}');
      }
      return null;
    }

    // Rest of the function remains the same...
    final data = function.encodeCall([contractEngin.address, amount]);
    final transaction = Transaction(
      from: EthereumAddress.fromHex(connectedAddress),
      to: contractCoin.address,
      data: data,
      value: EtherAmount.inWei(BigInt.zero),
    );

    final txHash = await appKitModal.requestWriteContract(
      deployedContract: contractCoin,
      functionName: functionName,
      topic: topic.value,
      chainId: chainIdFull,
      transaction: transaction,
      parameters: [contractEngin.address, amount],
    );

    if (txHash is String) {
      debugPrint('Transaction hash: $txHash');
      debugPrintTransactionDetails(hash: txHash);

      // Wait for transaction confirmation
      TransactionReceipt? receipt;
      int attempts = 0;
      const maxAttempts = 60;

      while (receipt == null && attempts < maxAttempts) {
        await Future.delayed(const Duration(seconds: 1));
        try {
          receipt = await ethProvider.getTransactionReceipt(txHash);
        } catch (e) {
          debugPrint('Error getting receipt: $e');
        }
        attempts++;
      }

      if (receipt?.status == true) {
        return txHash;
      } else {
        return null;
      }
    } else {
      showErrorSnackkbar(message: 'Withdrawn was rejected');
      return null;
    }
  }

  Future<bool> validateWalletAddress({required String walletAddress}) async {
    try {
      final data = await ethProvider.getBlockNumber();
      await ethProvider.getBalance(EthereumAddress.fromHex(walletAddress),
          atBlock: BlockNum.exact(data));
      // * EXPECTED STRING : EtherAmount: 9999999964234759375720 wei
      // * EXPECTED STRING : EtherAmount: 0 wei
      return true;
    } catch (error) {
      debugPrint('INVALID ADDRESS RECEIVED FROM INPUT FROM SEND MONEY');
      showErrorSnackkbar(message: 'Please provide a valid a public address');
      return false;
    }
  }

// #┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓━┓━┓
// #┃ ┃ ┃ ┃ ┃ ┃ ┃        BLOCK CHAIN INSTIGATION END       ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃
// #┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛━┛━┛

  // *┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓━┓━┓
  // *┃ ┃ ┃ ┃ ┃ ┃ ┃        BLOCK CHAIN API INSTIGATION START      ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃
  // *┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛━┛━┛

  RxString myCryptoAccountAddress = ''.obs;

  Future<void> getCryptoWalletActiveAccount() async {
    myCryptoAccountAddress.value =
        await walletRepository.getCryptoWalletPublicAddress();
    if (myCryptoAccountAddress.value.isNotEmpty) {
      updateCryptoWalletStatus(status: true);
    } else {
      await updateCryptoWalletStatus(status: false);
    }
    debugPrint(
        'COLLECTED PUBLIC ADDRESS FROM DB: ${myCryptoAccountAddress.value}');
  }

  Future<String> getCryptoWalletAddress() async {
    return await walletRepository.getCryptoWalletPublicAddress();
  }

  Future<void> saveCryptoWalletActiveAccount(
      {required String publicAddress}) async {
    final address = await getCryptoWalletAddress();

    // ? HANDLING ACCOUNT MATCH CASE
    if (address.isNotEmpty && address.compareTo(publicAddress) == 0) {
      await getCryptoWalletActiveAccount();
      await updateCryptoWalletStatus(status: true);
      showSuccessSnackkbar(message: 'Wallet connected successfully');
    }
    // ? HANDLING ACCOUNT CREATION CASE
    else if (address.isEmpty) {
      final bool responseStatus = await walletRepository
          .saveCryptoWalletPublicAddress(publicAddress: publicAddress);
      if (responseStatus) {
        await getCryptoWalletActiveAccount();
        await updateCryptoWalletStatus(status: true);
        showSuccessSnackkbar(message: 'Wallet connected successfully');
      } else {
        // ? HANDLING ACCOUNT CONNECTION REJECTION CASE
        myCryptoAccountAddress.value = '';
        await updateCryptoWalletStatus(status: false);
        showErrorSnackkbar(
            message: 'This wallet is already connected to another account');
        // ? 2 SECOND DELAY BEFORE DISCONNECTION
        await Future.delayed(const Duration(seconds: 2));
        appKitModal.disconnect(disconnectAllSessions: true);
      }
    } else {
      // ? HANDLING UNDEFINED CASE
      myCryptoAccountAddress.value = '';
      await updateCryptoWalletStatus(status: false);
      showErrorSnackkbar(message: 'Wallet connection failed');
    }
  }

  Future<void> updateCryptoWalletStatus({required bool status}) async {
    String walletToSend = '';
    if (appKitModal.isConnected) {
      walletToSend = myCryptoAccountAddress.value;
    } else {
      walletToSend = await getCryptoWalletAddress();
    }
    await walletRepository.updateCryptoWalletConnectionStatus(
        status: status, publicAddress: walletToSend);
  }

  Future<bool> matchConnectedWallet(
      {required String publicAddress, bool? showMessage}) async {
    await getCryptoWalletActiveAccount();

    if (myCryptoAccountAddress.value.isEmpty) {
      saveCryptoWalletActiveAccount(publicAddress: publicAddress);
      if (showMessage ?? false) {
        showSuccessSnackkbar(message: 'Wallet connected successfully');
      }
      return true;
    } else if (myCryptoAccountAddress.value
            .toLowerCase()
            .compareTo(publicAddress.toLowerCase()) ==
        0) {
      await updateCryptoWalletStatus(status: true);
      if (showMessage ?? false) {
        showSuccessSnackkbar(message: 'Wallet connected successfully');
      }
      return true;
    } else {
      myCryptoAccountAddress.value = '';
      await appKitModal.disconnect(disconnectAllSessions: true);
      showErrorSnackkbar(
          message:
              'Your account is already connected to another wallet account');
      await updateCryptoWalletStatus(status: false);
      return false;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET NONCES                                                           ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<BigInt?> getNonce() async {
    final data = await appKitModal.requestReadContract(
      topic: topic.value,
      chainId: chainIdFull,
      deployedContract: contractCoin,
      functionName: 'nonces',
    );
    debugPrint('$data');
    return BigInt.tryParse(data.first);
  }

  // #┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓━┓━┓
  // #┃ ┃ ┃ ┃ ┃ ┃ ┃        BLOCK CHAIN API INSTIGATION END        ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃ ┃
  // #┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛━┛━┛

  // *┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓
  // *┃ ┃ ┃ ┃ ┃ ┃ ┃       BLOCK CHAIN NEW CONNECTION START        ┃ ┃ ┃ ┃ ┃ ┃ ┃
  // *┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛

  late ReownAppKitModal appKitModal;
  RxBool initComplete = false.obs;

  // EVENTS ----------------------------------------------------------------------------------

  void _onModalConnect(ModalConnect? event) {
    debugPrint('🟡 EVENT: $event');
    if (event != null) {
      debugPrint('🟡 EVENT TOPIC: ${event.session.topic}');
      topic.value = event.session.topic ?? '';
    }
  }

  Future<void> _onSessionEvent(SessionEvent? event) async {
    if (event != null) {
      debugPrint('🟢 EVENT: $event');
      topic.value = event.topic;
    } else {
      debugPrint('🟢 EVENT: COULD NOT FIND ANY EVENT.. REJECTED');
    }
  }

  void _onModalDisconnect(ModalDisconnect? event) {
    debugPrint('📒 EVENT: $event');
  }

  // EVENTS ----------------------------------------------------------------------------------

  void initAppKit({required BuildContext context}) {
    appKitModal = ReownAppKitModal(
      context: context,
      logLevel: LogLevel.all,
      projectId: '84811a3f97c47ce97d4ecac7d99bcb35',
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:421614', 'eip155:1'],
          methods: [
            'eth_sendTransaction',
            'eth_signTransaction',
            'personal_sign',
            'eth_signTypedData_v4', // -> eth_signTypedData_v4
            'eth_requestAccounts', // -> Prompts user to connect wallet
          ],
          events: [
            'accountsChanged',
            'chainChanged',
            'connect',
            'session_event',
            'session_update',
            'session_delete',
          ],
        ),
      },
      metadata: const PairingMetadata(
        name: 'wallet_test',
        description: 'Connect your wallet to QP',
        url: 'https://qposs.com',
        icons: [
          'https://qposs.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Flogo.3507ce8d.png&w=48&q=75'
        ],
        // redirect: Redirect(
        //   native: 'qp://com.quanumpossibilities.qp?status=done',
        //   // universal: 'https://wallet_test.com/app',
        //   // See https://docs.reown.com/appkit/flutter/core/link-mode on how to enable Link Mode
        //   // linkMode: true,
        // ),
      ),
    );

    appKitModal.init().then(
      (value) {
        initComplete.value = true;
      },
    );

    // More events at https://docs.reown.com/appkit/flutter/core/events
    appKitModal.onModalConnect.subscribe(_onModalConnect);
    appKitModal.onSessionEventEvent.subscribe(_onSessionEvent);
    appKitModal.onModalDisconnect.subscribe(_onModalDisconnect);

    // Init Signer

    permitSignature = PermitSignature(appKit: appKitModal);
  }

  Future<void> checkStatusOfConnectionAndReconnect() async {
    debugPrint('CHECKING SESSION STATUS');

    if (initComplete.value) {
      session.value = appKitModal.session;
      debugPrint(
          '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      debugPrint('${session.value?.sessionService}');
      debugPrint(session.value?.topic);
      debugPrint(session.value?.pairingTopic);
      debugPrint(session.value?.chainId);
      debugPrint('${session.value?.expiry}');
      debugPrint('${session.value?.namespaces!.values.first.accounts}');
      debugPrint(
          session.value?.namespaces!.values.first.accounts.first.split(':')[2]);
      debugPrint(
          '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

      if (session.value != null) {
        String? fullAccount = '';

        // ! FIRST TIME IN ANY PROGRAMMING LANGUAGE I HAVE SEEN THIS ISSUE
        // ! DART IS STUPID....
        if (session.value?.namespaces!.values.first.accounts.length == 1) {
          fullAccount = session.value?.namespaces!.values.first.accounts.first
              .split(':')[2];
        } else {
          fullAccount =
              session.value!.namespaces!.values.first.accounts.firstWhereOrNull(
            (element) => element.split(':')[1].compareTo(chainCode) == 0,
          );
        }

        address.value = fullAccount != null ? fullAccount.split(':').last : '';
        final connectionStatus = await matchConnectedWallet(
            publicAddress: address.value, showMessage: false);

        debugPrint('CHECKING SESSION --> SESSION CONNECTION IS PRESENT');
        debugPrint('SESSION DETAILS:');
        debugPrint('FULL ACCOUNT    : $fullAccount');

        if (!connectionStatus) {
          appKitModal.disconnect(disconnectAllSessions: true);
          myCryptoAccountAddress.value = '';
          await updateCryptoWalletStatus(status: false);
        }
      } else {
        debugPrint('CHECKING SESSION --> SESSION CONNECTION NOT PRESENT');
        appKitModal.disconnect(disconnectAllSessions: true);
        myCryptoAccountAddress.value = '';
        await updateCryptoWalletStatus(status: false);
      }
    }
  }

  Future<void> debugPrintTransactionDetails({required String hash}) async {
    final data = await ethProvider.getTransactionByHash(hash);
    final receipt = await ethProvider.getTransactionReceipt(hash);
    debugPrint('📦 Ethereum Transaction Details');
    debugPrint('----------------------------------');
    debugPrint('🔢 Value                 : ${data?.value}');
    debugPrint('📤 From                  : ${data?.from}');
    debugPrint('🧾 Input                 : ${data?.input}');
    debugPrint('🔁 Nonce                 : ${data?.nonce}');
    debugPrint('🧩 r                     : ${data?.r}');
    debugPrint('🧩 s                     : ${data?.s}');
    debugPrint('🔐 v                     : ${data?.v}');
    debugPrint('🔗 Block Hash            : ${data?.blockHash}');
    debugPrint('✍️ Signature             : ${data?.signature}');
    debugPrint('🔢 Transaction Index     : ${data?.transactionIndex}');
    debugPrint('----------------------------------');

    debugPrint('📦 Ethereum Transaction Receipt');
    debugPrint('----------------------------------');
    debugPrint('📝 status                : ${receipt?.status}');
    debugPrint('🔢 blockHash             : ${receipt?.blockHash}');
    debugPrint('📤 transactionIndex      : ${receipt?.transactionIndex}');
    debugPrint('🧾 from                  : ${receipt?.from}');
    debugPrint('🔁 blockNumber           : ${receipt?.blockNumber}');
    debugPrint('🧩 contractAddress       : ${receipt?.contractAddress}');
    debugPrint('🧩 cumulativeGasUsed     : ${receipt?.cumulativeGasUsed}');
    debugPrint('🔐 effectiveGasPrice     : ${receipt?.effectiveGasPrice}');
    debugPrint('🔗 gasUsed               : ${receipt?.gasUsed}');
    debugPrint('✍️ logs                  : ${receipt?.logs}');
    debugPrint('🔢 to                    : ${receipt?.to}');
    debugPrint('🔢 transactionHash       : ${receipt?.transactionHash}');
    debugPrint('----------------------------------');
  }

  Future<void> deleteConnectedAndStoredPublicAddress(
      {String? storedWalletAddress}) async {
    try {
      bool deleteCallStatus = false;

      if (appKitModal.isConnected) {
        deleteCallStatus = await walletRepository.deleteConnectedPublicAddress(
            publicAddress: myCryptoAccountAddress.value);
      } else {
        deleteCallStatus = await walletRepository.deleteConnectedPublicAddress(
            publicAddress: storedWalletAddress ?? '');
      }

      if (deleteCallStatus == true) {
        showSuccessSnackkbar(message: 'Wallet removed');
        appKitModal.disconnect(disconnectAllSessions: true);
        await getCryptoWalletActiveAccount();
      } else {
        showErrorSnackkbar(message: 'Please try again');
      }
    } catch (error) {
      showErrorSnackkbar(message: 'Please try again');
    }
  }

  // !┏━┏━┏━┏━┏━┏━┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓━┓━┓━┓━┓━┓━┓
  // !┃ ┃ ┃ ┃ ┃ ┃ ┃       BLOCK CHAIN NEW CONNECTION  END         ┃ ┃ ┃ ┃ ┃ ┃ ┃
  // !┗━┗━┗━┗━┗━┗━┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛━┛━┛━┛━┛━┛━┛

  @override
  void onInit() {
    loginCredential = LoginCredential();
    getDeepLink();
    deepLinkListener();

    initAppKit(context: Get.context!);

    initTheContractJsonWithEngin();
    checkStatusOfConnectionAndReconnect();

    super.onInit();
  }

  @override
  void onClose() {
    EasyLoading.dismiss();
    super.onClose();
  }
}
