import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_comment_controller.dart';
import 'comment_tile.dart';
import 'comment_input_bar.dart';
import 'comment_sort_toggle.dart';

/// Full comment sheet for reels — shown at 60% height.
/// Contains: sort toggle, comment list (threaded), input bar.
class CommentSheet extends StatelessWidget {
  final String reelId;

  const CommentSheet({super.key, required this.reelId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsCommentController>();

    // Load comments when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadComments(reelId);
    });

    return Container(
      height: Get.height * 0.6,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Obx(() {
                  final count = controller.comments.length;
                  return Text(
                    'Comments${count > 0 ? ' ($count)' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }),
                const Spacer(),
                // Sort toggle
                CommentSortToggle(
                  onChanged: controller.changeSort,
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          // Comment list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                );
              }

              if (controller.comments.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: Colors.white24, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'No comments yet',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Be the first to comment',
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scroll) {
                  if (scroll.metrics.pixels >=
                      scroll.metrics.maxScrollExtent - 100) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: controller.comments.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= controller.comments.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    final comment = controller.comments[index];
                    return CommentTile(
                      comment: comment,
                      isCreator: false, // TODO: compare with reel author
                    );
                  },
                ),
              );
            }),
          ),

          // Mention autocomplete suggestions
          Obx(() {
            if (!controller.showMentionSuggestions.value ||
                controller.mentionSuggestions.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              constraints: const BoxConstraints(maxHeight: 120),
              color: const Color(0xFF222222),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.mentionSuggestions.length,
                itemBuilder: (context, index) {
                  final user = controller.mentionSuggestions[index];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundImage: user.profileImg != null
                          ? NetworkImage(user.profileImg!)
                          : null,
                      child: user.profileImg == null
                          ? const Icon(Icons.person, size: 14)
                          : null,
                    ),
                    title: Text(
                      user.displayName,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13),
                    ),
                    onTap: () => controller.insertMention(user),
                  );
                },
              ),
            );
          }),

          // Input bar
          CommentInputBar(reelId: reelId),
        ],
      ),
    );
  }
}
