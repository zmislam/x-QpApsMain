import 'package:get/get.dart';

import '../controller/other_photos_gallery_controller.dart';

class OtherPhotosGalleryBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherPhotosGalleryController>(
      () => OtherPhotosGalleryController(),
    );
  }
}
