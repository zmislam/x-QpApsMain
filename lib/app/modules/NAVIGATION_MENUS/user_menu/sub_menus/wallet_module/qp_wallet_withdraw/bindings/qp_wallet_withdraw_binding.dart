import 'package:get/get.dart';

import '../controllers/qp_wallet_withdraw_controller.dart';

class QpWalletWithdrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QpWalletWithdrawController>(
      () => QpWalletWithdrawController(),
    );
  }
}
