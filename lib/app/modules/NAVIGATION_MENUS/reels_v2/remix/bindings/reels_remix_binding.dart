import 'package:get/get.dart';
import '../controllers/reels_remix_controller.dart';

class ReelsRemixBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsRemixController>(() => ReelsRemixController());
  }
}
