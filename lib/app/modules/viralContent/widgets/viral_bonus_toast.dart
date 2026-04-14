import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Viral bonus notification toast — shown when a post
/// reaches a viral tier. Label & multiplier from API.
class ViralBonusToast {
  ViralBonusToast._();

  static void show({
    required String label,
    required double multiplier,
    required String postPreview,
  }) {
    Get.snackbar(
      '🔥 $label!',
      'Your post is earning ${multiplier}x bonus!\n"$postPreview"',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      icon: const Icon(Icons.local_fire_department,
          color: Colors.orange, size: 28),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
