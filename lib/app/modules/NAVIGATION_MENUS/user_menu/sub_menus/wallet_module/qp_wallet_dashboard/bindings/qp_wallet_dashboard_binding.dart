import 'package:get/get.dart';
import '../../../../../../../services/wallet_management_service.dart';

import '../controllers/qp_wallet_dashboard_controller.dart';

class QpWalletDashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WalletManagementService>()) {
      Get.find<WalletManagementService>();
    }

    Get.lazyPut<QpWalletDashboardController>(
      () => QpWalletDashboardController(),
    );
  }
}
