import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants/feed_design_tokens.dart';
import '../../models/post.dart';
import '../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';

class FeedControlsBottomsheet extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onHide;

  const FeedControlsBottomsheet({
    super.key,
    required this.post,
    this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Handle bar ───
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: FeedDesignTokens.textSecondary(context).withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ─── Options ───
          _menuItem(
            context,
            icon: Icons.remove_circle_outline,
            label: 'Show less',
            subtitle: "See fewer posts like this",
            onTap: () {
              _handleShowLess();
            },
          ),

          _menuItem(
            context,
            icon: Icons.not_interested_outlined,
            label: 'Not Interested',
            subtitle: "We won't show this post again",
            onTap: () {
              _handleNotInterested();
            },
          ),

          if (post.user_id != null)
            _menuItem(
              context,
              icon: Icons.access_time,
              label: 'Snooze ${post.user_id?.first_name} for 30 days',
              subtitle: "Temporarily stop seeing posts",
              onTap: () {
                _handleSnooze();
              },
            ),

          Divider(height: 1, color: FeedDesignTokens.divider(context)),

          if (onHide != null)
            _menuItem(
              context,
              icon: Icons.visibility_off_outlined,
              label: 'Hide Post',
              onTap: () {
                Get.back();
                onHide?.call();
              },
            ),

          _menuItem(
            context,
            icon: Icons.info_outline,
            label: 'Why am I seeing this?',
            onTap: () {
              Get.back();
              _showWhyShownDialog(context);
            },
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Handle "Show less" — track engagement + remove post from feed.
  void _handleShowLess() {
    try {
      final controller = Get.find<HomeController>();
      controller.trackFeedEngagement('show_less');
      controller.removePostFromFeed(post.id ?? '');
    } catch (_) {}
    Get.back();
    Get.snackbar(
      'Feedback Received',
      'We\'ll show fewer posts like this.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  /// Handle "Not Interested" — track engagement + remove post from feed.
  void _handleNotInterested() {
    try {
      final controller = Get.find<HomeController>();
      controller.trackFeedEngagement('not_interested');
      controller.removePostFromFeed(post.id ?? '');
    } catch (_) {}
    Get.back();
    Get.snackbar(
      'Got It',
      'We won\'t show this post again.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  /// Handle "Snooze" — track engagement + remove all posts from user.
  void _handleSnooze() {
    final userId = post.user_id?.id;
    try {
      final controller = Get.find<HomeController>();
      controller.trackFeedEngagement('snooze');
      // Remove all posts from this user in the current feed
      if (userId != null) {
        final postsToRemove = controller.edgeRankPosts
            .where((p) => p.user_id?.id == userId)
            .map((p) => p.id ?? '')
            .where((id) => id.isNotEmpty)
            .toList();
        for (final postId in postsToRemove) {
          controller.removePostFromFeed(postId);
        }
      }
    } catch (_) {}
    Get.back();
    Get.snackbar(
      'Snoozed',
      'You won\'t see posts from ${post.user_id?.first_name} for 30 days.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
              color: FeedDesignTokens.textPrimary(context),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWhyShownDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: FeedDesignTokens.cardBg(context),
        title: Text(
          'Why you\'re seeing this post',
          style: TextStyle(color: FeedDesignTokens.textPrimary(context)),
        ),
        content: Text(
          post.whyShown ?? 'This post is relevant to your interests based on your recent activity.',
          style: TextStyle(color: FeedDesignTokens.textSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
