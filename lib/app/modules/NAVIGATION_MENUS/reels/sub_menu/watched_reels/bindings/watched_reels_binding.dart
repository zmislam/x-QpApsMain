import 'package:get/get.dart';

import '../controllers/watched_reels_controller.dart';

class WatchedReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WatchedReelsController>(() => WatchedReelsController());
  }
}
