import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_interaction_controller.dart';
import '../../models/reel_v2_model.dart';
import '../../utils/reel_helpers.dart';
import '../common/engagement_counter.dart';

/// Right-side vertical action bar for reels.
/// Buttons: Like, Comment, Share, Bookmark, More (⋯).
class ReelActionBar extends StatelessWidget {
  final ReelV2Model reel;

  const ReelActionBar({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsInteractionController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like
        Obx(() {
          final isLiked = controller.isReelLiked(reel.id ?? '');
          return _ActionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            iconColor: isLiked ? Colors.red : Colors.white,
            label: ReelHelpers.formatCount(reel.likeCount ?? 0),
            onTap: () => controller.likeReel(reel.id ?? ''),
          );
        }),
        const SizedBox(height: 20),

        // Comment
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          label: ReelHelpers.formatCount(reel.commentCount ?? 0),
          onTap: () => controller.openCommentSheet(reel.id ?? ''),
        ),
        const SizedBox(height: 20),

        // Share
        _ActionButton(
          icon: Icons.send_outlined,
          label: ReelHelpers.formatCount(reel.shareCount ?? 0),
          onTap: () => controller.openShareSheet(reel),
        ),
        const SizedBox(height: 20),

        // Bookmark
        Obx(() {
          final isBookmarked = controller.isReelBookmarked(reel.id ?? '');
          return _ActionButton(
            icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            iconColor: isBookmarked ? Colors.amber : Colors.white,
            label: ReelHelpers.formatCount(reel.saveCount ?? 0),
            onTap: () => controller.toggleBookmark(reel.id ?? ''),
          );
        }),
        const SizedBox(height: 20),

        // More menu (⋯)
        _ActionButton(
          icon: Icons.more_horiz,
          onTap: () => controller.showMoreMenu(reel),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String? label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.iconColor = Colors.white,
    this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28,
            shadows: const [
              Shadow(color: Colors.black38, blurRadius: 6),
            ],
          ),
          if (label != null) ...[
            const SizedBox(height: 2),
            EngagementCounter(
              count: label!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
