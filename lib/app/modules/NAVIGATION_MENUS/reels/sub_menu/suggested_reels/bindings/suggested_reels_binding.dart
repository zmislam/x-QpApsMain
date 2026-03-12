import 'package:get/get.dart';

import '../controllers/suggested_reels_controller.dart';

class SuggestedReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuggestedReelsController>(() => SuggestedReelsController());
  }
}
