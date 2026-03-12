import 'package:get/get.dart';

import '../controller/create_post_controller.dart';

class CreatePostBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePostController>(() => CreatePostController());
  }
}
