import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../models/bill_type_model.dart';

import '../../../../../../../models/transaction_history_model.dart';
import '../../../../../../../repository/wallet_repository.dart';
import '../../../../../../../services/wallet_management_service.dart';

class QpWalletTransactionHistoryController extends GetxController {
  final WalletRepository walletRepository = WalletRepository();
  final WalletManagementService walletManagementService =
      Get.find<WalletManagementService>();

  Rx<List<TransactionHistoryModel>> transactionHistoryList = Rx([]);
  RxBool isTransactionHistoryLoading = true.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController scrollController = ScrollController();
  RxBool showScrollToTop = false.obs;

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  TRANSACTION HISTORY FILTER DRAWER FUNCTIONS                          ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  final searchController = TextEditingController();
  Rx<BillTypeModel?> selectedTransactionType = Rx(null);

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  RxString startDateValue = ''.obs;
  RxString endDateValue = ''.obs;

  RxString searchText = ''.obs;

  // ? GET TRANSACTION FILTERED LIST
  Future<void> getTransactionFilteredList() async {
    isTransactionHistoryLoading.value = true;
    transactionHistoryList.value.clear();
    transactionHistoryList.value =
        await walletRepository.getFilteredTransactionList(
      from: startDateValue.value,
      to: endDateValue.value,
      transactionId: searchController.text.trim(),
      type: selectedTransactionType.value?.value.toString(),
    );
    isTransactionHistoryLoading.value = false;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  FILTER CONTROL                                                        ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> applyFilter() async {
    Get.close(1);
    await getTransactionFilteredList();
  }

  Future<void> clearAll() async {
    searchController.clear();
    selectedTransactionType.value = null;

    startDateController.clear();
    endDateController.clear();

    startDateValue.value = '';
    endDateValue.value = '';

    Get.close(1);
    await getTransactionFilteredList();
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  STATE FUNCTIONS                                                       ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  @override
  void onInit() {
    super.onInit();
    walletManagementService.getAllTransactionBillTypes();
    getTransactionFilteredList();

    scrollController.addListener(
      () {
        if (scrollController.position.pixels > (Get.height - 150)) {
          showScrollToTop.value = true;
        } else {
          showScrollToTop.value = false;
        }
      },
    );
  }
}
