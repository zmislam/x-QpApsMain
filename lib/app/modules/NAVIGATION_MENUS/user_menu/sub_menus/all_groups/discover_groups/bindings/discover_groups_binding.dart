import 'package:get/get.dart';

import '../../group_feed/controllers/group_feed_controller.dart';
import '../controllers/discover_groups_controller.dart';

class DiscoverGroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiscoverGroupsController>(
      () => DiscoverGroupsController(),
    );
    Get.lazyPut<GroupFeedController>(
      () => GroupFeedController(),
      fenix: true,
    );
  }
}
