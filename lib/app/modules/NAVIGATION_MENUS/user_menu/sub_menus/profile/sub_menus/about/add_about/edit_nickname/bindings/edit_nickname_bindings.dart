import 'package:get/get.dart';
import '../controllers/edit_nickname_controller.dart';


class EditNickNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditNickNameController>(
      () => EditNickNameController(),
    );
  }
}
