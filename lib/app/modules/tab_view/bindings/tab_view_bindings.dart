import 'package:get/get.dart';

import '../controllers/tab_view_controller.dart';

class TabViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabViewController>(
      () => TabViewController(),
    );
  }
}
