import 'package:get/get.dart';

import '../controller/create_group_post_controller.dart';

class CreateGroupPostBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateGroupPostController>(() => CreateGroupPostController());
  }
}
