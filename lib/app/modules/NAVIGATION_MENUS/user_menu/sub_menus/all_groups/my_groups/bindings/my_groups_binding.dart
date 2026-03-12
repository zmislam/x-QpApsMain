import 'package:get/get.dart';

import '../controllers/my_groups_controller.dart';

class MyGroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyGroupsController>(
      () => MyGroupsController(),
    );
  }
}
