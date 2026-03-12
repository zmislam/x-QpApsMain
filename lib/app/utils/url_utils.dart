import 'package:flutter/material.dart';
import 'snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class UriUtils {
 static void launchUrlInBrowser(String url) {
  try {
    // Check if the URL already contains "http://" or "https://"
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      // Add "https://" by default if no scheme is present
      url = 'https://$url';
    }

    // Launch the URL
    launchUrl(Uri.parse(url));
  } catch (e) {
    debugPrint('Error: $e');
  }
}

  static void call(String number) {
    launchUrl(Uri.parse('tel://$number'));
  }

  static void sendMessage(String number) {
    launchUrl(Uri.parse('sms://$number'));
  }

  static void sendEmail(String email) {
    launchUrl(Uri.parse('mailto: $email'));
  }

  // ================================ reels share to whatsapp ================================
  static Future<void> shareToWhatsApp(String url) async {
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(url)}';

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication);
    } else {
      showErrorSnackkbar(message: 'Couldn\'t launch url');
    }
  }

  // ============================== share to facebook =================================
  static Future<void> shareToFacebook(String url) async {
    final facebookUrl =
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}';

    if (await canLaunchUrl(Uri.parse(facebookUrl))) {
      await launchUrl(Uri.parse(facebookUrl),
          mode: LaunchMode.externalApplication);
    } else {
      showErrorSnackkbar(message: 'Couldn\'t launch url');
    }
  }

  // ====================================== share to instagram ==================================
  static Future<void> shareToInstagram(String url) async {
    final instagramUrl =
        'https://www.instagram.com/direct/new/?text=${Uri.encodeComponent(url)}';

    if (await canLaunchUrl(Uri.parse(instagramUrl))) {
      await launchUrl(Uri.parse(instagramUrl),
          mode: LaunchMode.externalApplication);
    } else {
      showErrorSnackkbar(message: 'Couldn\'t launch url');
    }
  }
}
