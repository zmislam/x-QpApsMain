import 'package:get/get.dart';

import '../controllers/share_post_controller.dart';

class SharePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SharePostController>(
      () => SharePostController(),
    );
  }
}
