import 'package:get/get.dart';

import '../controllers/group_videos_gallery_controller.dart';

class GroupVideosGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupVideosGalleryController>(
      () => GroupVideosGalleryController(),
    );
  }
}
