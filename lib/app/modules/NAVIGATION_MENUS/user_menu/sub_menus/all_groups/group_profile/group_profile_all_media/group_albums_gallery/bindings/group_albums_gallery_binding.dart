import 'package:get/get.dart';

import '../controllers/group_albums_gallery_controller.dart';

class GroupAlbumsGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupAlbumsGalleryController>(
      () => GroupAlbumsGalleryController(),
    );
  }
}
