import 'package:get/get.dart';

import '../controllers/pages_controller.dart';

class PagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PagesController>(
      () => PagesController(),
    );
  }
}
