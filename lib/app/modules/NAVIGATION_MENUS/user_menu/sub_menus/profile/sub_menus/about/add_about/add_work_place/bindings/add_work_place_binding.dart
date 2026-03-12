import 'package:get/get.dart';

import '../controllers/add_work_place_controller.dart';

class AddWorkPlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddWorkPlaceController>(
      () => AddWorkPlaceController(),
    );
  }
}
