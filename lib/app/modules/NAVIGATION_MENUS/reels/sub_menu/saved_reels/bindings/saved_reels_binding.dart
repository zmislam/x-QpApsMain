import 'package:get/get.dart';
import '../controllers/saved_reels_controller.dart';

class SavedReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedReelsController>(() => SavedReelsController());
  }
}
