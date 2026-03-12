import 'package:get/get.dart';

import '../controllers/edit_birth_date_controller.dart';

class EditBirthDateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBirthDateController>(
      () => EditBirthDateController(),
    );
  }
}
