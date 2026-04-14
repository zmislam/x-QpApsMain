import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_interaction_controller.dart';
import '../../models/reel_v2_model.dart';
import '../common/follow_button.dart';
import '../common/verified_badge.dart';

/// Author info row for reels — avatar, name, verified badge, follow button.
class ReelAuthorInfo extends StatelessWidget {
  final ReelV2Model reel;

  const ReelAuthorInfo({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsInteractionController>();
    final author = reel.author;
    final authorId = reel.authorId ?? '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        GestureDetector(
          onTap: () => controller.navigateToProfile(authorId),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[800],
            backgroundImage: author?.profileImg != null
                ? NetworkImage(author!.profileImg!)
                : null,
            child: author?.profileImg == null
                ? const Icon(Icons.person, color: Colors.white54, size: 18)
                : null,
          ),
        ),
        const SizedBox(width: 10),

        // Name + Verified
        GestureDetector(
          onTap: () => controller.navigateToProfile(authorId),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                author?.displayName ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                ),
              ),
              if (author?.isVerified == true) ...[
                const SizedBox(width: 4),
                const VerifiedBadge(size: 14),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Follow button
        Obx(() {
          final isFollowing = controller.isFollowing(authorId);
          return FollowButton(
            isFollowing: isFollowing,
            onTap: () => controller.toggleFollow(authorId, reel.id ?? ''),
          );
        }),
      ],
    );
  }
}
