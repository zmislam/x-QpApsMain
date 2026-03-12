import 'package:get/get.dart';

import '../controllers/qp_wallet_send_money_controller.dart';

class QpWalletSendMoneyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QpWalletSendMoneyController>(
      () => QpWalletSendMoneyController(),
    );
  }
}
