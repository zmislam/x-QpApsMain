import 'package:get/get.dart';
import '../controllers/edit_relationship_controller.dart';


class EditRelationshipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditRelationshipController>(
      () => EditRelationshipController(),
    );
  }
}
