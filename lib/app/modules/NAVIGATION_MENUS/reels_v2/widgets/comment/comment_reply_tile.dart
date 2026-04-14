import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_comment_controller.dart';
import '../../models/reel_comment_model.dart';
import '../../utils/reel_enums.dart';
import '../../utils/reel_helpers.dart';

/// Reply tile for threaded comments (2nd level).
/// Simplified version of CommentTile without further nesting.
class CommentReplyTile extends StatelessWidget {
  final ReelCommentModel reply;

  const CommentReplyTile({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsCommentController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[700],
            backgroundImage: reply.user?.profileImg != null
                ? NetworkImage(reply.user!.profileImg!)
                : null,
            child: reply.user?.profileImg == null
                ? const Icon(Icons.person, size: 10, color: Colors.white54)
                : null,
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author + time
                Row(
                  children: [
                    Text(
                      reply.user?.displayName ?? 'User',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (reply.user?.isVerified == true) ...[
                      const SizedBox(width: 3),
                      const Icon(Icons.verified,
                          color: Color(0xFF1DA1F2), size: 10),
                    ],
                    const SizedBox(width: 4),
                    Text(
                      ReelHelpers.formatRelativeTime(reply.createdAt),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // GIF or Text
                if (reply.gifUrl != null && reply.gifUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      reply.gifUrl!,
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  )
                else if (reply.text != null)
                  Text(
                    reply.text!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),

                const SizedBox(height: 4),

                // Actions
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.reactToComment(
                        reply.id ?? '',
                        ReelReactionType.like,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            reply.myReaction != null
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 12,
                            color: reply.myReaction != null
                                ? Colors.red
                                : Colors.white38,
                          ),
                          if ((reply.likeCount ?? 0) > 0) ...[
                            const SizedBox(width: 2),
                            Text(
                              ReelHelpers.formatCount(reply.likeCount ?? 0),
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => controller.replyTo(reply),
                      child: const Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
