import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Toast/snackbar for rate limit warnings.
/// Message dynamic from API — not hardcoded.
class RateLimitWarning {
  RateLimitWarning._();

  static void show({String? message}) {
    Get.snackbar(
      'Slow Down',
      message ?? 'You are performing actions too quickly. Please wait.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber.shade50,
      colorText: Colors.amber.shade900,
      icon: Icon(Icons.speed, color: Colors.amber.shade700, size: 24),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      isDismissible: true,
    );
  }
}
