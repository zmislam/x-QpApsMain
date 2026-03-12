import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../../../models/card_detail_model.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../../../../models/withdraw_model.dart';
import '../../../../../../../repository/wallet_repository.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../services/wallet_management_service.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../../../../../../utils/wallet_util/permit_signer_util.dart';

class QpWalletWithdrawController extends GetxController {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  final formKey = GlobalKey<FormState>();
  Rx<CardDetailsModel?> selectedCard = Rx(null);
  final amountController = TextEditingController();
  RxBool obscureText = true.obs;
  final passwordController = TextEditingController();
  final remarksController = TextEditingController();

  // Bank withdrawal form key
  final GlobalKey<FormState> bankFormKey = GlobalKey<FormState>();

// Bank withdrawal controllers
  final TextEditingController bankAmountController = TextEditingController();
  final TextEditingController bankPasswordController = TextEditingController();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController routingNumberController = TextEditingController();
  final TextEditingController bankRemarksController = TextEditingController();

  Rx<List<WithdrawMoneyModel>> withdrawHistoryList = Rx([]);
  RxBool withdrawHistoryIsLoading = true.obs;

  final ScrollController scrollController = ScrollController();
  RxBool showScrollToTop = false.obs;

  // @ FLAG FOR REFRESH
  bool needRefresh = false;

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  WITHDRAW MONEY USING THE CARD                                         ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> withdrawMoney() async {
    if (formKey.currentState!.validate() && selectedCard.value != null) {
      final response = await walletRepository.withdrawMoney(
        cardId: selectedCard.value!.id.toString(),
        amount: amountController.text.trim(),
        password: passwordController.text.trim(),
        remarks: remarksController.text.trim(),
      );

      if (response.isSuccessful) {
        Map<String, dynamic> dataMap = response.data as Map<String, dynamic>;
        final amountInWei = parseAmountToWei(amountController.text);
        await walletRepository.saveWithdrawRequest(
          requestId: dataMap['requestId'],
          amountInWei: amountInWei.toString(),
          signature: dataMap['signature'],
        );

        final walletEvent =
            await walletManagementService.withdrawMoneyToCard(params: [
          Uint8List.fromList(hexToBytes(dataMap['requestId'])), // requestId
          amountInWei, // amountInWei
          Uint8List.fromList(hexToBytes(dataMap['signature'])), // signature
        ], defaultParams: [
          dataMap['requestId'],
          amountInWei,
          dataMap['signature']
        ]);
        if (walletEvent != null) {
          clearAll();
          getWithDrawHistory();
          needRefresh = true;
          showSuccessSnackkbar(message: 'Money withdraw was successfully');
        }
      } else {
        showErrorSnackkbar(
            message: 'Failed to withdraw the amount, Please try again');
      }
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  WITHDRAW MONEY USING THE BANK                                         ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> withdrawMoneyWithBank() async {
    if (bankFormKey.currentState!.validate()) {
      final response = await walletRepository.withdrawMoneyToBank(
        amount: bankAmountController.text.trim(),
        password: bankPasswordController.text.trim(),
        remarks: bankRemarksController.text.trim(),
        accountHolderName: accountHolderNameController.text.trim(),
        accountNumber: int.parse(accountNumberController.text.trim()),
        bankName: bankNameController.text.trim(),
        routingNumber: int.parse(routingNumberController.text.trim()),
      );

      if (response.isSuccessful) {
        Map<String, dynamic> dataMap = response.data as Map<String, dynamic>;
        final amountInWei = parseAmountToWei(bankAmountController.text);
        await walletRepository.saveWithdrawRequest(
          requestId: dataMap['requestId'],
          amountInWei: amountInWei.toString(),
          signature: dataMap['signature'],
        );

        final walletEvent =
            await walletManagementService.withdrawMoneyToCard(params: [
          Uint8List.fromList(hexToBytes(dataMap['requestId'])), // requestId
          amountInWei, // amountInWei
          Uint8List.fromList(hexToBytes(dataMap['signature'])), // signature
        ], defaultParams: [
          dataMap['requestId'],
          amountInWei,
          dataMap['signature']
        ]);
        if (walletEvent != null) {
          clearAllBank();
          getWithDrawHistory();
          needRefresh = true;
          showSuccessSnackkbar(message: 'Money withdraw was successfully');
        }
      } else {
        showErrorSnackkbar(message: 'Please try again');
      }
    }
  }

  void clearAllBank() {
    bankAmountController.clear();
    bankPasswordController.clear();
    bankRemarksController.clear();
    accountHolderNameController.clear();
    accountNumberController.clear();
    bankNameController.clear();
    routingNumberController.clear();
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET SEND MONEY TRANSFER HISTORY                                      ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> getWithDrawHistory() async {
    withdrawHistoryList.value.clear();
    withdrawHistoryIsLoading.value = true;
    withdrawHistoryList.value = await walletRepository.getWithdrawMoneyList();
    withdrawHistoryIsLoading.value = false;
  }

  void clearAll() {
    selectedCard.value = null;
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
    getWithDrawHistory();
    walletManagementService.getAllUserCards();
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

  void goToAddCardPage() {
    Get.toNamed(Routes.QP_WALLET_PAYMENT_SETTINGS);
  }
}
