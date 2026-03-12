import 'package:get/get.dart';
import '../controller/other_video_gallery_controller.dart';

class OtherVideoGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherVideoGalleryController>(
      () => OtherVideoGalleryController(),
    );
  }
}
