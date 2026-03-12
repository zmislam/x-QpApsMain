import 'package:get/get.dart';

import '../controllers/feed_preferences_controller.dart';

class FeedPreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedPreferencesController>(
      () => FeedPreferencesController(),
    );
  }
}
