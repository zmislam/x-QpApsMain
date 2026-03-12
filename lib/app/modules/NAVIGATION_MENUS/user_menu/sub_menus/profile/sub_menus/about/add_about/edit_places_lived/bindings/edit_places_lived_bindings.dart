import 'package:get/get.dart';
import '../controllers/edit_places_lived_controller.dart';


class EditPlacesLivedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPlacesLivedController>(
      () => EditPlacesLivedController(),
    );
  }
}
