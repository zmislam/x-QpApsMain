import 'package:get/get.dart';

import '../controllers/live_reels_controller.dart';


class LiveReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveReelsController>(
      () =>LiveReelsController(),
    );
  }
}
