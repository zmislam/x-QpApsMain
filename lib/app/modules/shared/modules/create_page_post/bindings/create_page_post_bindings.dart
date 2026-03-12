import 'package:get/get.dart';
import '../controller/create_page_post_controller.dart';

class CreatePagePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatePagePostController>(() => CreatePagePostController());
  }
}
