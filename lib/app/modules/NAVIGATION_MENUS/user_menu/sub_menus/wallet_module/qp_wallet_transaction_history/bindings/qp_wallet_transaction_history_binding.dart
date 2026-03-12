import 'package:get/get.dart';

import '../controllers/qp_wallet_transaction_history_controller.dart';

class QpWalletTransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QpWalletTransactionHistoryController>(
      () => QpWalletTransactionHistoryController(),
    );
  }
}
