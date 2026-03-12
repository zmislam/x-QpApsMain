import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../../../../models/send_money_model.dart';
import '../../../../../../../repository/wallet_repository.dart';
import '../../../../../../../services/wallet_management_service.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../../../../../../utils/wallet_util/improved_permit_signer.dart';
import '../../../../../../../utils/wallet_util/permit_signer_util.dart';

class QpWalletSendMoneyController extends GetxController {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  final formKey = GlobalKey<FormState>();
  final walletAddressController = TextEditingController();
  final amountController = TextEditingController();
  RxBool obscureText = true.obs;
  final passwordController = TextEditingController();
  final remarksController = TextEditingController();

  Rx<List<SendMoneyHistoryModel>> sendHistoryList = Rx([]);
  RxBool sendMoneyHistoryIsLoading = true.obs;

  final ScrollController scrollController = ScrollController();
  RxBool showScrollToTop = false.obs;

  // @ FLAG FOR REFRESH
  bool needRefresh = false;

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  SEND MONEY TO AN USER WITH EMAIL                                      ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> sendMoney() async {
    if (formKey.currentState!.validate()) {
      final statusOfAddress = await walletManagementService
          .validateWalletAddress(walletAddress: walletAddressController.text);
      if (statusOfAddress) {
        final response = await walletRepository.sendMoney(
          recipientAddress: walletAddressController.text.trim(),
          amount: amountController.text.trim(),
          password: passwordController.text.trim(),
          remarks: remarksController.text.trim(),
        );

        if (response.isSuccessful && response.statusCode == 200) {
          Map<String, dynamic> dataMap =
              (response.data as Map<String, dynamic>)['data'];

          final deadline =
              BigInt.from(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600);
          final amountInWei = parseAmountToWei(amountController.text);

          walletRepository.saveSendMoneyRequest(
            requestId: dataMap['requestId'],
            amountInWei: amountInWei.toString(),
            signature: dataMap['signature'],
            to: walletAddressController.text,
          );

          final nonceResult = await walletManagementService.ethProvider.call(
            contract: walletManagementService.contractCoin,
            function: walletManagementService.contractCoin.function('nonces'),
            params: [
              EthereumAddress.fromHex(
                  walletManagementService.myCryptoAccountAddress.value)
            ],
          );

          // Extract nonce from the result list
          final BigInt nonce = nonceResult.first as BigInt;

          debugPrint(
              'TOKEN CONTRACT NAME: ${walletManagementService.contractCoin.abi.name}');
          debugPrint('TOKEN COIN NONCE VALUE: $nonce');

          final permitSigner = ImprovedPermitSignature(
            appKit: walletManagementService.appKitModal,
            web3Client: walletManagementService.ethProvider,
          );

          final PermitSignatureResult permitResult = await permitSigner.signPermitWithValidation(
            tokenName: walletManagementService.tokenName,
            version: '1',
            chainId: int.parse(walletManagementService.chainCode),
            verifyingContract:
                walletManagementService.contractCoin.address.hexEip55,
            owner: walletManagementService.myCryptoAccountAddress.value,
            spender: walletManagementService.contractEngin.address.hexEip55,
            value: amountInWei,
            deadline: deadline,
          );

          debugPrint(permitResult.toString());

          if (permitResult != null) {
            debugPrint('SIGNED STAFF');
            // Debug permit signature components
            debugPrint('=== PERMIT SIGNATURE DEBUG ===');
            debugPrint(
                'Owner (from permit): ${walletManagementService.contractCoin.address.hexEip55}');
            debugPrint(
                'Spender (from permit): ${walletManagementService.contractEngin.address.hexEip55}');
            debugPrint('Nonce (from permit): ${permitResult.nonce}');
            debugPrint('Deadline (from permit): ${permitResult.deadline}');
            debugPrint('V: ${permitResult.v}');
            debugPrint('R: 0x${permitResult.r.toRadixString(16)}');
            debugPrint('S: 0x${permitResult.s.toRadixString(16)}');
            debugPrint('');
            debugPrint('=== CONTRACT CALL PARAMETERS ===');
            debugPrint(
                'Connected Address: ${walletManagementService.myCryptoAccountAddress.value}');
            debugPrint(
                'Token Contract: ${walletManagementService.contractCoin.address.hexEip55}');
            debugPrint(
                'Spender Contract: ${walletManagementService.contractEngin.address.hexEip55}');
            debugPrint('To Address: ${walletAddressController.text}');
            debugPrint('Amount: $amountInWei');
            debugPrint('Deadline: $deadline');

            final rCore =
                '0x${permitResult.r.toRadixString(16).padLeft(64, '0')}';
            final sCore =
                '0x${permitResult.s.toRadixString(16).padLeft(64, '0')}';

            debugPrint(
                'VALIDATE THE SIGNER USING LOCAL OWNER _________________________________');
            final validateSigValue = await permitSigner.validatePermitSignature(
              tokenAddress:
                  walletManagementService.contractCoin.address.hexEip55,
              owner: EthereumAddress.fromHex(
                      walletManagementService.myCryptoAccountAddress.value)
                  .hexEip55,
              permitResult: permitResult,
            );
            debugPrint('$validateSigValue');
            if (!validateSigValue) {
              showErrorSnackkbar(
                  message: 'The signature is not valid, Please try again');
              return;
            }
            debugPrint('VALIDATE THE SIGNER _________________________________');

            final response = await walletManagementService
                .transferForRetailersWithPermit(params: [
              Uint8List.fromList(hexToBytes(dataMap['requestId'])), // requestId
              EthereumAddress.fromHex(walletAddressController.text), // to
              amountInWei, // amountInWei
              permitResult.deadline, // deadline
              BigInt.from(permitResult.v), // v
              Uint8List.fromList(hexToBytes(rCore)), // r
              Uint8List.fromList(hexToBytes(sCore)), // s
              Uint8List.fromList(hexToBytes(dataMap['signature'])), // signature
            ], defaultParams: [
              dataMap['requestId'],
              EthereumAddress.fromHex(walletAddressController.text),
              amountInWei,
              permitResult.deadline,
              BigInt.from(permitResult.v),
              rCore,
              sCore,
              dataMap['signature']
            ]
                    // value: BigInt.tryParse('0.000000000000001'),
                    );

            if (response != null) {
              clearAll();
              getMoneyTransferHistory();
              showSuccessSnackkbar(message: 'Money transfer was successfully');
            } else {
              // showErrorSnackkbar(message: 'Failed to transfer the amount, Please try again');
            }
          } else {
            showErrorSnackkbar(message: 'Sign request was rejected');
          }
          needRefresh = true;
          // ! Need to handel message case here
        } else if (response.isSuccessful && response.statusCode == 400) {
          showErrorSnackkbar(message: 'Wallet account number is invalid');
        } else {
          showErrorSnackkbar(
              message: 'Failed to transfer the amount, Please try again');
        }
      }
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃ CALCULATE COMMISSION AND RECEIVABLE                                   ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  RxString commissionPercent = ''.obs;
  RxString commissionAmount = ''.obs;
  RxString receivableAmount = ''.obs;

  Future<void> calculate() async {
    try {
      if (amountController.text.isEmpty ||
          amountController.text.contains('-')) {
        final data = num.parse(amountController.text.toString());
        if (data <= 0) {
          commissionPercent.value = '';
          commissionAmount.value = '';
          receivableAmount.value = '';
        }
      }

      int amount = int.parse(amountController.text);

      final percent = await walletManagementService
          .getSendMoneyFeeForRetailersInPercentage();
      commissionPercent.value = '$percent%';
      final cAmount =
          walletManagementService.calculateCommission(percent, amount);
      commissionAmount.value = '\$${cAmount.toStringAsFixed(3)}';
      receivableAmount.value = '\$${(amount - cAmount).toStringAsFixed(3)}';
    } catch (error) {
      commissionPercent.value = '';
      commissionAmount.value = '';
      receivableAmount.value = '';
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET SEND MONEY TRANSFER HISTORY                                      ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> getMoneyTransferHistory() async {
    sendHistoryList.value.clear();
    sendMoneyHistoryIsLoading.value = true;
    sendHistoryList.value = await walletRepository.getSendMoneyList();
    sendMoneyHistoryIsLoading.value = false;
  }

  void clearAll() {
    walletAddressController.clear();
    amountController.clear();
    passwordController.clear();
    remarksController.clear();
    obscureText.value = false;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  STATE FUNCTIONS                                                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    super.onInit();
    getMoneyTransferHistory();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels > (Get.height - 250)) {
          showScrollToTop.value = true;
        } else {
          showScrollToTop.value = false;
        }
      },
    );
  }

  @override
  void onClose() {
    if (needRefresh) {
      walletManagementService.getAllDataFromSummaryAndTransaction();
    }
    super.onClose();
  }
}
