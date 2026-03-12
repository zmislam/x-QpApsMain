import 'package:get/get.dart';
import '../controller/others_album_gallery_controller.dart';

class OthersAlbumGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OthersAlbumGalleryController>(
      () => OthersAlbumGalleryController(),
    );
  }
}
