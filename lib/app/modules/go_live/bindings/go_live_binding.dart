import 'package:get/get.dart';

import '../controllers/go_live_controller.dart';

class GoLiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoLiveController>(
      () => GoLiveController(),
    );
  }
}
