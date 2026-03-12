import 'package:get/get.dart';

import '../controllers/boost_post_controller.dart';

class BoostPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BoostPostController>(
      () => BoostPostController(),
    );
  }
}
