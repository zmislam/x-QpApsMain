import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reels_comment_controller.dart';

/// Comment input bar at bottom of comment sheet.
/// Contains: text field with @mention detection, GIF button, send button.
/// Shows reply indicator when replying to a comment.
class CommentInputBar extends StatelessWidget {
  final String reelId;

  const CommentInputBar({super.key, required this.reelId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsCommentController>();

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF222222),
        border: Border(
          top: BorderSide(color: Colors.white12, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply indicator
          Obx(() {
            if (controller.replyingToCommentId.value == null) {
              return const SizedBox.shrink();
            }
            return Container(
              padding: const EdgeInsets.only(left: 4, right: 4, bottom: 6),
              child: Row(
                children: [
                  Text(
                    'Replying to ${controller.replyingToUsername.value ?? 'user'}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => controller.cancelReply(),
                    child: const Icon(Icons.close,
                        color: Colors.white38, size: 16),
                  ),
                ],
              ),
            );
          }),

          // Input row
          Row(
            children: [
              // GIF button
              GestureDetector(
                onTap: () => _showGifPicker(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Text(
                    'GIF',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Text input
              Expanded(
                child: TextField(
                  controller: controller.textController,
                  focusNode: controller.focusNode,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 3,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: controller.onTextChanged,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: const TextStyle(
                        color: Colors.white30, fontSize: 14),
                    filled: true,
                    fillColor: const Color(0xFF333333),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Send button
              Obx(() {
                final isSubmitting = controller.isSubmitting.value;
                return GestureDetector(
                  onTap: isSubmitting ? null : () => controller.submitComment(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white70,
                            size: 22,
                          ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showGifPicker(BuildContext context) {
    // GIF picker placeholder — integrates with GIPHY API
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text(
            'GIF Picker\n(GIPHY integration)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
