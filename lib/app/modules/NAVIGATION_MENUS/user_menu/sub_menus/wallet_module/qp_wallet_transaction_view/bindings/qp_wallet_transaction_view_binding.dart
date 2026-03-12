import 'package:get/get.dart';

import '../controllers/qp_wallet_transaction_view_controller.dart';

class QpWalletTransactionViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QpWalletTransactionViewController>(
      () => QpWalletTransactionViewController(),
    );
  }
}
