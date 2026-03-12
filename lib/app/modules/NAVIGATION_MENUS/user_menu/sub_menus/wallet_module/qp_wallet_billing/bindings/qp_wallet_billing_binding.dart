import 'package:get/get.dart';

import '../controllers/qp_wallet_billing_controller.dart';

class QpWalletBillingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QpWalletBillingController>(
      () => QpWalletBillingController(),
    );
  }
}
