import 'package:get/get.dart';
import '../controllers/viral_content_controller.dart';

class ViralContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViralContentController>(() => ViralContentController());
  }
}
