import 'package:get/get.dart';

import '../controllers/invite_groups_controller.dart';

class InviteGroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InviteGroupsController>(
      () => InviteGroupsController(),
    );
  }
}
