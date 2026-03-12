import 'package:get/get.dart';

import '../controllers/create_image_story_controller.dart';

class CreateImageStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateImageStoryController>(
      () => CreateImageStoryController(),
    );
  }
}
