import 'package:get/get.dart';

import '../controllers/create_story_controller.dart';

class CreateStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateStoryController>(
      () => CreateStoryController(),
    );
  }
}
