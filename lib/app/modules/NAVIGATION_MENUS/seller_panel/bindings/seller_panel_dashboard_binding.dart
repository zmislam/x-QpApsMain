import 'package:get/get.dart';

import '../controllers/seller_panel_dashboard_controller.dart';

class SellerPanelDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerPanelDashboardController>(
      () =>SellerPanelDashboardController(),
    );
  }
}
