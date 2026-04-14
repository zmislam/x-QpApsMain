import 'package:get/get.dart';
import '../controllers/reels_editor_controller.dart';
import '../controllers/reels_effects_controller.dart';

/// Binding for the Reels V2 editor module.
class ReelsEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsEditorController>(() => ReelsEditorController());
    Get.lazyPut<ReelsEffectsController>(() => ReelsEffectsController());
  }
}
