import 'package:get/get.dart';

import '../controllers/earn_dashboard_controller.dart';

class EarnDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EarnDashboardController>(
      () => EarnDashboardController(),
    );
  }
}
