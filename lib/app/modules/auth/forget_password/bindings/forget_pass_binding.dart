import 'package:get/get.dart';

import '../controllers/forget_pass_controller.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
    );
  }
}
