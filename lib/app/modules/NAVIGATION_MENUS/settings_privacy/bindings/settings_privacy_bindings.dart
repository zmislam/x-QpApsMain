import 'package:get/get.dart';
import '../controllers/settings_privacy_controller.dart';


class SettingsPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsPrivacyController>(
      () =>SettingsPrivacyController(),
    );
  }
}
