



import 'package:get/get.dart';

import '../controller/multiple_image_controller.dart';

class MultipleImage extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MultipleImageContoller>(() => MultipleImageContoller());

  }

}