import 'package:get/get.dart';
import '../controllers/reels_camera_controller.dart';

/// Binding for the Reels V2 camera module.
class ReelsCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsCameraController>(() => ReelsCameraController());
  }
}
