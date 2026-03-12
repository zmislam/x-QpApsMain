import 'package:get/get.dart';

import '../controllers/reels_setting_controller.dart';

class ReelsSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsSettingController>(
      () => ReelsSettingController(),
    );
  }
}
