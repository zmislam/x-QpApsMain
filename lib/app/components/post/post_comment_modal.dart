import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/components/image.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/feed_design_tokens.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/models/comment_model.dart';
import 'package:quantum_possibilities_flutter/app/models/post.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';

import '../comment/comment_tile.dart';

/// Full-screen modal for viewing and adding comments.
///
/// Anchored to the bottom of the screen with a draggable handle.
/// Features:
/// - Sticky input field at the bottom.
/// - Scrollable list of comments.
/// - Reply and reaction support.
class PostCommentModal extends GetView<HomeController> {
  final PostModel post;
  final int postIndex;

  const PostCommentModal({
    super.key,
    required this.post,
    required this.postIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure we have a valid controller
    final controller = Get.find<HomeController>();

    // Load comments on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (post.id != null) {
        controller.getSinglePostsComments(post.id!);
        controller.commentsID.value = post.id!; // Track current post for comments
      }
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: FeedDesignTokens.cardBg(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // ─── Header ───
              _buildHeader(context),

              // ─── Divider ───
              Divider(height: 1, color: FeedDesignTokens.divider(context)),

              // ─── Comments List ───
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingPostComment.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Use the fetched comments if available, otherwise post's embedded comments
                  // Note: Logic allows for either. Ideally we sync back to post model.
                  final comments = post.comments ?? [];

                  if (comments.isEmpty) {
                    return Center(
                      child: Text(
                        'No comments yet. Be the first to comment!',
                        style: TextStyle(
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: comments.length,
                    padding: const EdgeInsets.only(bottom: 80), // Space for input
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return CommentTile(
                        commentModel: comment,
                        commentIndex: index,
                        inputNodes: FocusNode(), // Dummy, we manage focus globally
                        textEditingController: TextEditingController(), // Dummy
                        onCommentEdit: (c) {
                          // TODO: Implement edit
                        },
                        onCommentDelete: (c) {
                          // TODO: call delete
                          // controller.commentDelete(...);
                        },
                        onCommentReplayEdit: (r) {
                          // TODO: Implement reply edit
                        },
                        onCommentReplayDelete: (rid, pid) {
                          // TODO: Implement reply delete
                        },
                        onSelectCommentReaction: (reaction) {
                          controller.commentReaction(
                            postId: post.id!,
                            reaction_type: reaction,
                            comment_id: comment.id!,
                          );
                        },
                        onSelectCommentReplayReaction: (reaction, rid) {
                          // TODO: Reply reaction
                        },

                      );
                    },
                  );
                }),
              ),

              // ─── Input Area ───
              _buildInputArea(context, controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: FeedDesignTokens.textSecondary(context).withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const SizedBox(width: 8), // Offset
                PostReactionIcons(post),
                const SizedBox(width: 8),
                Text(
                  '${post.reactionCount ?? 0}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                ),
                const Spacer(),
                // Sort Dropdown
                DropdownButton<String>(
                  value: 'Most Relevant', // TODO: Bind to controller.sortOrder
                  underline: const SizedBox(),
                  icon: Icon(Icons.keyboard_arrow_down, 
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: FeedDesignTokens.textPrimary(context),
                  ),
                  items: ['Most Relevant', 'Newest'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // TODO: Implement sort logic
                    // controller.sortComments(newValue);
                  },
                ),
                const SizedBox(width: 8),
                // Close Button
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, HomeController controller) {
    return Container(
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply Context Banner
          Obx(() {
            if (controller.isReply.value) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: FeedDesignTokens.inputBg(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                     Text(
                      'Replying to ${controller.commentModel.value.user_id?.first_name ?? "User"}',
                       style: TextStyle(fontSize: 12, color: FeedDesignTokens.textSecondary(context)),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        controller.isReply.value = false;
                        controller.commentsID.value = post.id!;
                      },
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Media Preview
          Obx(() => controller.xfiles.value.isNotEmpty
              ? SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.xfiles.value.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final file = controller.xfiles.value[index];
                return Stack(
                  children: [
                    Image.file(File(file.path), width: 80, height: 80, fit: BoxFit.cover),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          controller.xfiles.value.removeAt(index);
                          controller.xfiles.refresh();
                        },
                        child: Container(
                          color: Colors.black54,
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
              : const SizedBox.shrink()),

          // Input Row
          Row(
            children: [
              // User Avatar
              RoundCornerNetworkImage(
                imageUrl: (controller.userModel.profile_pic ?? '').formatedProfileUrl,
                height: 36,
                width: 36,
              ),
              const SizedBox(width: 12),
              // Text Field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: controller.commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      isDense: true,
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Media Button
              InkWell(
                onTap: controller.pickMediaFiles,
                 child: Icon(Icons.camera_alt_outlined, color: FeedDesignTokens.textSecondary(context)),
              ),
              const SizedBox(width: 12),
              // Send Button
              InkWell(
                onTap: () {
                   if (controller.isReply.value) {
                     controller.commentReply(
                       comment_id: controller.commentsID.value,
                       replies_comment_name: controller.commentController.text,
                       post_id: post.id!,
                       file: controller.processedCommentFileData.value,
                     );
                   } else {
                     controller.commentOnPost(post);
                   }
                },
                child: Icon(Icons.send, color: PRIMARY_COLOR),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Reuse the reaction icons helper from CommentComponent
Widget PostReactionIcons(PostModel postModel) {
  Set<Image> postReactionIcons = {};
  if (postModel.reactionTypeCountsByPost != null) {
    for (ReactionModel reactionModel in postModel.reactionTypeCountsByPost!) {
      switch (reactionModel.reaction_type) {
        case 'like':
          postReactionIcons.add(const Image(height: 18, width: 18, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
        case 'love':
          postReactionIcons.add(const Image(height: 18, width: 18, image: AssetImage(AppAssets.LOVE_ICON)));
          break;
        case 'haha':
          postReactionIcons.add(const Image(height: 18, width: 18, image: AssetImage(AppAssets.HAHA_ICON)));
          break;
        case 'wow':
          postReactionIcons.add(const Image(height: 18, width: 18, image: AssetImage(AppAssets.WOW_ICON)));
          break;
        case 'sad':
          postReactionIcons.add(const Image(height: 18, width: 18, image: AssetImage(AppAssets.SAD_ICON)));
          break;
        case 'angry':
          postReactionIcons.add(const Image(height: 18, width: 18, image: AssetImage(AppAssets.ANGRY_ICON)));
          break;
        default:
          postReactionIcons.add(const Image(height: 18, width: 18, image: AssetImage(AppAssets.LIKE_ICON)));
      }
    }
  }
  if (postReactionIcons.isEmpty) {
     return const Image(height: 18, width: 18, image: AssetImage(AppAssets.LIKE_ICON));
  }
  return Row(children: postReactionIcons.take(3).toList());
}
