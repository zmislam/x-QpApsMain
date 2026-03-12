import 'package:get/get.dart';

import '../controllers/group_photos_gallery_controller.dart';

class GroupPhotosGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupPhotosGalleryController>(
      () => GroupPhotosGalleryController(),
    );
  }
}
