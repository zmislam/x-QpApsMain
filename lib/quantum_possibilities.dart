import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'app/config/constants/app_constant.dart';
import 'app/config/theme/core_app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/Localization/dynamicTransalationService.dart';
import 'app/utils/Localization/lib/app/modules/changeLanguage/controllers/languageController.dart';


class QuantumPossibilities extends StatelessWidget {
  const QuantumPossibilities({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return FutureBuilder<void>(
      future: Future.delayed(Duration.zero), // Ensures frame is built
      builder: (context, snapshot) {
        return Obx(() {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstant.APP_NAME,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeController.themeMode,
            translations: DynamicTranslations.instance,
            locale: Locale(languageController.getCurrentLanguageCode()),
            fallbackLocale: const Locale('en'),
            navigatorKey: Get.key,
            builder: (context, child) {
              return EasyLoading.init()(context, child);
            },
          );
        });
      },
    );
  }
}