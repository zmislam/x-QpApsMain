import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../services/wallet_management_service.dart';

import '../../../../../../../models/transaction_history_model.dart';
import '../../../../../../../repository/wallet_repository.dart';

class QpWalletBillingController extends GetxController {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  Rx<List<TransactionHistoryModel>> billHistoryList = Rx([]);
  RxBool isBillHistoryLoading = true.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  TRANSACTION HISTORY FILTER DRAWER FUNCTIONS                          ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  RxString startDateValue = ''.obs;
  RxString endDateValue = ''.obs;

  // ? GET TRANSACTION FILTERED LIST
  Future<void> getBillFilteredList() async {
    isBillHistoryLoading.value = true;
    billHistoryList.value.clear();
    billHistoryList.value =
        await walletRepository.getFilteredBillIndividualList(
      from: startDateValue.value,
      to: endDateValue.value,
    );
    isBillHistoryLoading.value = false;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  FILTER CONTROL                                                        ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> applyFilter() async {
    Get.close(1);
    await getBillFilteredList();
  }

  Future<void> clearAll() async {
    startDateController.clear();
    endDateController.clear();

    startDateValue.value = '';
    endDateValue.value = '';

    Get.close(1);
    await getBillFilteredList();
  }

  final ScrollController scrollController = ScrollController();
  RxBool showScrollToTop = false.obs;

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  STATE FUNCTIONS                                                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    //! This needs to be REMOVED OR UPDATED AS DATA IS MISSING
    walletManagementService.getAllDataFromSummaryAndTransaction();
    getBillFilteredList();

    scrollController.addListener(
      () {
        if (scrollController.position.pixels > (Get.height - 150)) {
          showScrollToTop.value = true;
        } else {
          showScrollToTop.value = false;
        }
      },
    );
    super.onInit();
  }
}
