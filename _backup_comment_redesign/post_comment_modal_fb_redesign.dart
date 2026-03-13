import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/app_assets.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/feed_design_tokens.dart';
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 56,
                            color: FeedDesignTokens.textSecondary(context).withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No comments yet',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: FeedDesignTokens.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Be the first to comment.',
                            style: TextStyle(
                              fontSize: 13,
                              color: FeedDesignTokens.textSecondary(context),
                            ),
                          ),
                        ],
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
                            postIndex: postIndex,
                            reaction_type: reaction,
                            post_id: post.id!,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Drag Handle ──
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 8),
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: FeedDesignTokens.textSecondary(context).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // ── Reaction count + Comment count row ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  // View reactions
                },
                child: Row(
                  children: [
                    PostReactionIcons(post),
                    const SizedBox(width: 6),
                    Text(
                      '${post.reactionCount ?? 0}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${post.totalComments ?? 0} ${(post.totalComments == 1) ? 'Comment' : 'Comments'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: FeedDesignTokens.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        // ── Sort trigger (Facebook "Most relevant ▾") ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              Text(
                'Most relevant',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FeedDesignTokens.textSecondary(context),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: FeedDesignTokens.textSecondary(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea(BuildContext context, HomeController controller) {
    return Container(
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 8,
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
                    Icon(Icons.reply, size: 16, color: FeedDesignTokens.textSecondary(context)),
                    const SizedBox(width: 6),
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
                      child: Icon(Icons.close, size: 16, color: FeedDesignTokens.textSecondary(context)),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Media Preview
          Obx(() => controller.xfiles.value.isNotEmpty
              ? Container(
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.xfiles.value.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final file = controller.xfiles.value[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(file.path), width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: InkWell(
                              onTap: () {
                                controller.xfiles.value.removeAt(index);
                                controller.xfiles.refresh();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.close, color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : const SizedBox.shrink()),

          // ── Input Row (Facebook-style) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Camera icon (outside pill)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: InkWell(
                  onTap: controller.pickMediaFiles,
                  borderRadius: BorderRadius.circular(20),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 24,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Input pill
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.inputBg(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF4E4F50)
                          : const Color(0xFFCCD0D5),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.commentController,
                          decoration: InputDecoration(
                            hintText: 'Comment as ${controller.userModel.first_name ?? ""}',
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
                          onSubmitted: (value) {
                            if (controller.isReply.value) {
                              controller.commentReply(
                                comment_id: controller.commentsID.value,
                                replies_comment_name: controller.commentController.text,
                                post_id: post.id!,
                                postIndex: postIndex,
                                file: controller.processedCommentFileData.value,
                              );
                            } else {
                              controller.commentOnPost(postIndex, post);
                            }
                          },
                        ),
                      ),
                      // ── Icons inside pill (sticker, GIF, emoji) ──
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, right: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.emoji_emotions_outlined,
                                  size: 20,
                                  color: FeedDesignTokens.textSecondary(context),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: FeedDesignTokens.textSecondary(context),
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'GIF',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: FeedDesignTokens.textSecondary(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.tag_faces_outlined,
                                  size: 20,
                                  color: FeedDesignTokens.textSecondary(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Send Button
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: InkWell(
                  onTap: () {
                    if (controller.isReply.value) {
                      controller.commentReply(
                        comment_id: controller.commentsID.value,
                        replies_comment_name: controller.commentController.text,
                        post_id: post.id!,
                        postIndex: postIndex,
                        file: controller.processedCommentFileData.value,
                      );
                    } else {
                      controller.commentOnPost(postIndex, post);
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
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
