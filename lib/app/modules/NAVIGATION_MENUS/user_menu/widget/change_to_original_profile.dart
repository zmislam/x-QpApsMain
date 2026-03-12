import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/qp_icons_icons.dart';

import '../../../../routes/app_pages.dart';
import '../controllers/user_menu_controller.dart';

class ChangeToOriginalProfile extends GetView<UserMenuController> {
  const ChangeToOriginalProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        controller.profileSwitch().then((value) {
          Get.offAndToNamed(Routes.ACCOUNT_SWITCH_PAGE);
        });
      },
      icon: const Icon(
        QpIcon.changeProfile,
        size: 30,
      ),
    );
  }
}
