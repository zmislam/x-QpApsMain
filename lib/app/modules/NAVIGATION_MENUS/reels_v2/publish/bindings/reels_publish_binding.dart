import 'package:get/get.dart';
import '../controllers/reels_publish_controller.dart';

class ReelsPublishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsPublishController>(() => ReelsPublishController());
  }
}
