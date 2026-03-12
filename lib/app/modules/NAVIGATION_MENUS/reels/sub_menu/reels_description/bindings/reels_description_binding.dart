import 'package:get/get.dart';

import '../controllers/reels_description_controller.dart';

class ReelsDescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsDescriptionController>(
      () => ReelsDescriptionController(),
    );
  }
}
