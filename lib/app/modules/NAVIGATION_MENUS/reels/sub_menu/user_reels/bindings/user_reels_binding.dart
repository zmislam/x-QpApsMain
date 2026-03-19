import 'package:get/get.dart';

import '../controllers/user_reels_controller.dart';

class UserReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserReelsController>(() => UserReelsController());
  }
}
