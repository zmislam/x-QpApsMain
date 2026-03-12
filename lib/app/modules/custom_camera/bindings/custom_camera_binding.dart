import 'package:get/get.dart';

import '../controllers/custom_camera_controller.dart';

class CustomCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomCameraController>(
      () => CustomCameraController(),
    );
  }
}
