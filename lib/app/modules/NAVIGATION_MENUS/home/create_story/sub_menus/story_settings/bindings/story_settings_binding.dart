import 'package:get/get.dart';

import '../controllers/story_settings_controller.dart';

class StorySettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorySettingsController>(
      () => StorySettingsController(),
    );
  }
}
