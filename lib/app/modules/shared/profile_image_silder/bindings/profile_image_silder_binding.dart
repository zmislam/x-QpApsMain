import 'package:get/get.dart';

import '../controllers/profile_image_silder_controller.dart';

class ProfileImageSilderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileImageSilderController>(
      () => ProfileImageSilderController(),
    );
  }
}
