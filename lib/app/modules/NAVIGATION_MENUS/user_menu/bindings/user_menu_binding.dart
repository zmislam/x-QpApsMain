import 'package:get/get.dart';

import '../controllers/user_menu_controller.dart';

class UserMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserMenuController>(
      () => UserMenuController(),
    );
  }
}
