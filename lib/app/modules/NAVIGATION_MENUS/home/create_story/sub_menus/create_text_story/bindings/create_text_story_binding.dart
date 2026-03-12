import 'package:get/get.dart';

import '../controllers/create_text_story_controller.dart';

class CreateTextStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTextStoryController>(
      () => CreateTextStoryController(),
    );
  }
}
