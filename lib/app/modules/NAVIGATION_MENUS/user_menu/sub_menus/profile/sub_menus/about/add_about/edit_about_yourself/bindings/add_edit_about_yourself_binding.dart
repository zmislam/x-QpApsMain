import 'package:get/get.dart';
import '../controllers/add_edit_about_yourself_controller.dart';


class AddAboutYourselfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAboutYourselfController>(
      () => AddAboutYourselfController(),
    );
  }
}
