import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/constants/color.dart';

void showSnackkbar(String s, {required String titile, required String message}) {
  Get.snackbar(
    titile.tr,
    message.tr,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: PRIMARY_COLOR,
    colorText: Colors.white,
  );
}

void showSuccessSnackkbar({String? titile, required String message, Color? bgColor}) {
  Get.snackbar(
    titile?.tr ?? 'SUCCESS!'.tr,
    message.tr,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: bgColor?? PRIMARY_COLOR,
    colorText: Colors.white,
  );
}

void showWarningSnackkbar({String? titile, required String message}) {
  Get.snackbar(
    titile?.tr ?? 'WARNING!'.tr,
    message.tr,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.yellow,
    colorText: Colors.black,
  );
}

void showErrorSnackkbar({String? titile, required String message}) {
  Get.snackbar(
    titile?.tr ?? 'ERROR!'.tr,
    message.tr,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

/// Convenience wrapper for calling snackbar helpers via class syntax.
class AppSnackbar {
  static void showSuccess(String message) =>
      showSuccessSnackkbar(message: message);
  static void showError(String message) =>
      showErrorSnackkbar(message: message);
  static void showWarning(String message) =>
      showWarningSnackkbar(message: message);
}
