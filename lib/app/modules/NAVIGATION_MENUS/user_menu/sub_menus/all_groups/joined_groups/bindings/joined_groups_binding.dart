import 'package:get/get.dart';

import '../controllers/joined_groups_controller.dart';

class JoinedGroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoinedGroupsController>(
      () => JoinedGroupsController(),
    );
  }
}
