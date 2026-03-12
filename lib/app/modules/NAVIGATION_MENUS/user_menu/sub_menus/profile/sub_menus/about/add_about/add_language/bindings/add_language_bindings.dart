import 'package:get/get.dart';
import '../controllers/add_language_controller.dart';


class AddLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLanguageController>(
      () => AddLanguageController(),
    );
  }
}
