import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Notification overlay when a tip is received.
class TipReceivedToast {
  TipReceivedToast._();

  static void show({
    required String fromUserName,
    required double amount,
    String? message,
  }) {
    Get.snackbar(
      '💰 Tip Received!',
      '${fromUserName} sent you \$${amount.toStringAsFixed(2)}${message != null ? '\n"$message"' : ''}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade900,
      icon: const Icon(Icons.monetization_on,
          color: Colors.green, size: 28),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
