import 'package:get/get.dart';

import '../controllers/discover_groups_controller.dart';

class DiscoverGroupsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiscoverGroupsController>(
      () => DiscoverGroupsController(),
    );
  }
}
