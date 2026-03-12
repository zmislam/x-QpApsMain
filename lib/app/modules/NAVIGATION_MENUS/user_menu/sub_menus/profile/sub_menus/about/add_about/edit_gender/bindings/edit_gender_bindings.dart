import 'package:get/get.dart';
import '../controllers/edit_gender_controller.dart';


class EditGenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditGenderController>(
      () => EditGenderController(),
    );
  }
}
