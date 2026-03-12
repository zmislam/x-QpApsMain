import 'package:get/get.dart';

import '../controllers/photos_gallery_controller.dart';

class PhotosGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotosGalleryController>(
      () => PhotosGalleryController(),
    );
  }
}
