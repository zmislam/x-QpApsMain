import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_comment_controller.dart';
import '../../models/reel_comment_model.dart';
import '../../utils/reel_enums.dart';
import '../../utils/reel_helpers.dart';
import 'comment_reply_tile.dart';
import 'pinned_comment_badge.dart';

/// Single comment tile with threading support.
/// Shows: avatar, name, text, reactions, reply button, reply thread.
class CommentTile extends StatelessWidget {
  final ReelCommentModel comment;
  final bool isCreator;

  const CommentTile({
    super.key,
    required this.comment,
    this.isCreator = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsCommentController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pinned badge
          if (comment.isPinned == true)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: PinnedCommentBadge(),
            ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar — long-press for profile peek
              GestureDetector(
                onLongPress: () {
                  // Profile peek card (Phase 2)
                  _showProfilePeek(context, comment.user);
                },
                onTap: () {
                  if (comment.userId != null) {
                    Get.toNamed('/profile/${comment.userId}');
                  }
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[700],
                  backgroundImage: comment.user?.profileImg != null
                      ? NetworkImage(comment.user!.profileImg!)
                      : null,
                  child: comment.user?.profileImg == null
                      ? const Icon(Icons.person, size: 14, color: Colors.white54)
                      : null,
                ),
              ),
              const SizedBox(width: 10),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author name + time
                    Row(
                      children: [
                        Text(
                          comment.user?.displayName ?? 'User',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (comment.user?.isVerified == true) ...[
                          const SizedBox(width: 3),
                          const Icon(Icons.verified,
                              color: Color(0xFF1DA1F2), size: 12),
                        ],
                        const SizedBox(width: 6),
                        Text(
                          ReelHelpers.formatRelativeTime(comment.createdAt),
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                        if (comment.isEdited == true) ...[
                          const SizedBox(width: 4),
                          const Text(
                            '(edited)',
                            style: TextStyle(
                                color: Colors.white24, fontSize: 10),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // GIF or text
                    if (comment.gifUrl != null && comment.gifUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          comment.gifUrl!,
                          width: 150,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      )
                    else if (comment.text != null)
                      Text(
                        comment.text!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),

                    const SizedBox(height: 6),

                    // Actions: Like, Reply, More
                    Row(
                      children: [
                        // Like button with count
                        GestureDetector(
                          onTap: () => controller.reactToComment(
                            comment.id ?? '',
                            ReelReactionType.like,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                comment.myReaction != null
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 14,
                                color: comment.myReaction != null
                                    ? Colors.red
                                    : Colors.white38,
                              ),
                              if ((comment.likeCount ?? 0) > 0) ...[
                                const SizedBox(width: 3),
                                Text(
                                  ReelHelpers.formatCount(comment.likeCount ?? 0),
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Reply button
                        GestureDetector(
                          onTap: () => controller.replyTo(comment),
                          child: const Text(
                            'Reply',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // More options (pin for creator, delete for own)
                        GestureDetector(
                          onTap: () => _showOptions(context, controller),
                          child: const Icon(Icons.more_horiz,
                              color: Colors.white24, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Replies (2-level threading)
          if (comment.replies != null && comment.replies!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 42, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...comment.replies!.map(
                    (reply) => CommentReplyTile(reply: reply),
                  ),
                ],
              ),
            ),

          // View more replies button
          if ((comment.replyCount ?? 0) > (comment.replies?.length ?? 0))
            Padding(
              padding: const EdgeInsets.only(left: 42, top: 4),
              child: GestureDetector(
                onTap: () => controller.loadReplies(comment.id ?? ''),
                child: Text(
                  'View ${(comment.replyCount ?? 0) - (comment.replies?.length ?? 0)} more replies',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _defaultReaction() {
    return const Icon(Icons.favorite_border, color: Colors.white54, size: 16);
  }

  void _showOptions(BuildContext context, ReelsCommentController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCreator)
            ListTile(
              leading: Icon(
                comment.isPinned == true ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.white70,
              ),
              title: Text(
                comment.isPinned == true ? 'Unpin comment' : 'Pin comment',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                controller.togglePin(comment.id ?? '');
              },
            ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              controller.deleteComment(comment.id ?? '');
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined, color: Colors.white70),
            title: const Text('Report', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showProfilePeek(BuildContext context, CommentAuthorModel? user) {
    if (user == null) return;
    // Profile peek card shown as overlay
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (_) => Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user.profileImg != null
                    ? NetworkImage(user.profileImg!)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                user.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
