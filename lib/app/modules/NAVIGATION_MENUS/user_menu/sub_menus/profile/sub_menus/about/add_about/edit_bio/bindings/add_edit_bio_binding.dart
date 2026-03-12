import 'package:get/get.dart';
import '../controllers/add_edit_bio_controller.dart';


class AddYourBioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddYourBioController>(
      () => AddYourBioController(),
    );
  }
}
