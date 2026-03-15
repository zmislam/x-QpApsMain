import 'package:get/get.dart';

import '../controllers/advance_search_controller.dart';

class AdvanceSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdvanceSearchController>(() => AdvanceSearchController());
  }
}
