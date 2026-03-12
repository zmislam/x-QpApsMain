import 'package:get/get.dart';

import '../controllers/other_reels_video_controller.dart';

class OtherReelsVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherReelsVideoController>(
      () => OtherReelsVideoController(),
    );
  }
}
