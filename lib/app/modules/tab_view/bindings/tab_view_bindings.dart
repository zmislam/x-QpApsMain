import 'package:get/get.dart';

import '../../NAVIGATION_MENUS/reels_v2/bindings/reels_v2_binding.dart';
import '../controllers/tab_view_controller.dart';

class TabViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabViewController>(
      () => TabViewController(),
    );
    // Register ReelsV2 dependencies so they're available when V2 tab loads
    ReelsV2Binding().dependencies();
  }
}
