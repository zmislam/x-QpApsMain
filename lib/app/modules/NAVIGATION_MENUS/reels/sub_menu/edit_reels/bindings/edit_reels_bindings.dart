import 'package:get/get.dart';

import '../controllers/edit_reels_controller.dart';

class EditReelsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditReelsController>(() => EditReelsController());
  }
}
