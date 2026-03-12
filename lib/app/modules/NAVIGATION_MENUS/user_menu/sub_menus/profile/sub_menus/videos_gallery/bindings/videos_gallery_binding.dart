import 'package:get/get.dart';

import '../controllers/videos_gallery_controller.dart';

class VideosGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideosGalleryController>(
      () => VideosGalleryController(),
    );
  }
}
