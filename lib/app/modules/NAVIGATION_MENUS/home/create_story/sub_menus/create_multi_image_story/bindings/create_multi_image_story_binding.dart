import 'package:get/get.dart';

import '../controllers/create_multi_image_story_controller.dart';

class CreateMultiImageStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateMultiImageStoryController>(
      () => CreateMultiImageStoryController(),
    );
  }
}
