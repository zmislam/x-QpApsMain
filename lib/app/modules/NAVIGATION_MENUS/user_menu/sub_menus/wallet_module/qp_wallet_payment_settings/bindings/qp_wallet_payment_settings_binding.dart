import 'package:get/get.dart';

import '../controllers/qp_wallet_payment_settings_controller.dart';

class QpWalletPaymentSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QpWalletPaymentSettingsController>(
      () => QpWalletPaymentSettingsController(),
    );
  }
}
