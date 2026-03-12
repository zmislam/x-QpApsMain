import 'package:get/get.dart';

import '../controllers/page_profile_controller.dart';

class PageProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageProfileController>(
      () => PageProfileController(),
    );
  }
}
