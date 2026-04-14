import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../modules/NAVIGATION_MENUS/reels_v2/utils/reels_v2_integration_config.dart';

/// Handles V2 reel navigation from notifications and deep links.
/// Used when `ReelsV2IntegrationConfig.useV2Notifications` is true.
class ReelsV2DeepLinkHandler {
  ReelsV2DeepLinkHandler._();

  /// Handle a reel notification tap. Routes to V2 reel detail if V2 is default.
  /// Returns `true` if handled, `false` if V1 should handle it.
  static bool handleReelNotification({
    required String? reelId,
    String? commentId,
  }) {
    if (!ReelsV2IntegrationConfig.useV2Notifications) return false;
    if (reelId == null) return false;

    Get.toNamed(Routes.REELS_V2, arguments: {
      'reelId': reelId,
      'commentId': commentId,
    });
    return true;
  }

  /// Handle a deep link URL for V2 reels.
  /// Matches patterns like: /reels-v2/{reelId}
  /// Returns `true` if handled.
  static bool handleDeepLink(String path) {
    if (!ReelsV2IntegrationConfig.useV2AsDefault) return false;

    final reelMatch = RegExp(r'^/reels?/([a-zA-Z0-9]+)$').firstMatch(path);
    if (reelMatch != null) {
      final reelId = reelMatch.group(1);
      Get.toNamed(Routes.REELS_V2, arguments: {
        'reelId': reelId,
      });
      return true;
    }

    return false;
  }
}
