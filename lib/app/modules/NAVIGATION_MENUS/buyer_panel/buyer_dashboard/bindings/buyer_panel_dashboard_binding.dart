import 'package:get/get.dart';

import '../controllers/buyer_panel_dashboard_controller.dart';

class BuyerPanelDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerPanelDashboardController>(
      () =>BuyerPanelDashboardController(),
    );
  }
}
