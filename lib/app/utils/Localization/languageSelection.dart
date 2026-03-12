import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lib/app/modules/changeLanguage/controllers/languageController.dart';


import 'lib/app/modules/changeLanguage/views/change_language_view.dart';

class LanguageSelector extends StatelessWidget {
  LanguageSelector({super.key});

  final LanguageController languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        IconButton(
          icon: Stack(
            children: [
              Text(
                languageController.currentLanguage.value.flag,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          onPressed: () {
            Get.to(() => ChangeLanguageView());
          },
          tooltip: 'Change Language'.tr,
        ),
    );
  }
}