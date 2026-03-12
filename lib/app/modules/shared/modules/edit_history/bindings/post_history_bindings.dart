import 'package:get/get.dart';

import '../controller/post_history_controller.dart';

class PostHistoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostHistoryController>(() => PostHistoryController());
  }
}
