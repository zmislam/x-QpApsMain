import 'package:get/get.dart';

import '../controllers/qp_wallet_add_balance_controller.dart';

class QpWalletAddBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QpWalletAddBalanceController>(
      () => QpWalletAddBalanceController(),
    );
  }
}
