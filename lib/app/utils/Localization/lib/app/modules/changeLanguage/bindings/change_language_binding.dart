import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/utils/Localization/lib/app/modules/changeLanguage/controllers/languageController.dart';


class ChangeLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(
      () => LanguageController(),
    );
  }
}
