import 'package:get/get.dart';

import '../controllers/group_feed_controller.dart';

class GroupFeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupFeedController>(
      () => GroupFeedController(),
    );
  }
}
