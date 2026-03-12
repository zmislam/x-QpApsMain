import 'package:get/get.dart';
import '../controller/page_settings_controller.dart';

class PageSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageSettingsController>(() => PageSettingsController());
  }
}
