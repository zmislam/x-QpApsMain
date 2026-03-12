import 'package:get/get.dart';

import '../controllers/albums_gallery_controller.dart';

class AlbumsGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlbumsGalleryController>(
      () => AlbumsGalleryController(),
    );
  }
}
