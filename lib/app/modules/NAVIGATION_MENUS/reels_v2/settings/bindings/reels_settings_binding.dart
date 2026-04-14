import 'package:get/get.dart';
import '../controllers/reels_settings_controller.dart';

class ReelsSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsSettingsController>(() => ReelsSettingsController());
  }
}
