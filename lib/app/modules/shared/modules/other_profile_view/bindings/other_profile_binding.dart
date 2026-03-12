import 'package:get/get.dart';

import '../controller/other_profile_controller.dart';

class OtherProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OthersProfileController>(() => OthersProfileController());
  }
}
