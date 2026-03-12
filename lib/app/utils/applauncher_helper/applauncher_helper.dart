import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncherHelper {
  static Future<void> launchQPApp({
    required String deepLinkUrl,
    required String fallbackUrl,
  }) async {
    try {
      final Uri deepLink = Uri.parse(deepLinkUrl);
      final Uri fallback = Uri.parse(fallbackUrl);

      final bool isInstalled = await canLaunchUrl(deepLink);

      if (isInstalled) {
        await launchUrl(deepLink, mode: LaunchMode.externalApplication);
      } else {
        // Option 1: Open Play Store
        await launchUrl(fallback, mode: LaunchMode.externalApplication);

        // Option 2: Show custom dialog
        Get.dialog(
          AlertDialog(
            title: Text('App Required'.tr),
            content: Text('Please install QP Messenger'.tr),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel'.tr),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await launchUrl(fallback,
                      mode: LaunchMode.externalApplication);
                },
                child: Text('Install'.tr),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Launch error: $e');
      showErrorSnackkbar(message: 'Launch error due to unknown issue');
    }
  }
}
