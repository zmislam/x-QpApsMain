import 'package:get/get.dart';

import '../controllers/my_profile_friends_controller.dart';

class MyProfileFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyProfileFriendsController>(
      () => MyProfileFriendsController(),
    );
  }
}
