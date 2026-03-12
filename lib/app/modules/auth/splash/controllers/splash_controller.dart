import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../data/login_creadential.dart';
import '../../../../routes/app_pages.dart';

class SplashController extends GetxController {
  LoginCredential loginCredential = LoginCredential();

  @override
  void onInit() {
    super.onInit();
    // Start navigation after splash
    navigate();
  }

  void navigate() async {
    // Wait for splash duration
    await Future.delayed(const Duration(seconds: 3));

    // Navigate based on login status
    if (loginCredential.isUserLoggedIn()) {
      Get.offNamed(Routes.TAB);
      debugPrint('Splash Page');
      debugPrint('User Data: \n${loginCredential.getUserData()}');
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}
