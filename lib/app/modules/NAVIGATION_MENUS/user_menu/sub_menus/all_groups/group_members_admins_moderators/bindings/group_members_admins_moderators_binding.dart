import 'package:get/get.dart';

import '../controllers/group_members_admins_moderators_controller.dart';

class GroupMembersAdminsModeratorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupMembersAdminsModeratorsController>(
      () => GroupMembersAdminsModeratorsController(),
    );
  }
}
