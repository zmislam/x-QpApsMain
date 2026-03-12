import 'package:get/get.dart';

import '../../add%20website/controllers/add_website_controller.dart';


class AddWebsiteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddWebsiteController>(
      () => AddWebsiteController(),
    );
  }
}
