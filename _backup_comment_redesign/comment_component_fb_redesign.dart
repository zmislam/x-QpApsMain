// import 'dart:ffi';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';

import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';

import '../../config/constants/app_assets.dart';
import '../../models/comment_model.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import 'comment_sort_bottom_sheet.dart';
import 'comment_tile.dart';

// ─── Sort helpers (matches web implementation) ───

int _getEngagementScore(CommentModel comment) {
  final reactionCount = comment.comment_reactions?.length ?? 0;
  final replyCount = comment.replies?.length ?? 0;
  return reactionCount * 2 + replyCount;
}

List<CommentModel> sortComments(
    List<CommentModel> comments, CommentSortMode mode) {
  if (comments.isEmpty) return comments;

  final sorted = List<CommentModel>.from(comments);

  switch (mode) {
    case CommentSortMode.newest:
      sorted.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
        final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
        return dateB.compareTo(dateA); // newest first
      });
      break;

    case CommentSortMode.mostRelevant:
      sorted.sort((a, b) {
        final scoreA = _getEngagementScore(a);
        final scoreB = _getEngagementScore(b);
        if (scoreB != scoreA) return scoreB.compareTo(scoreA);
        // tie-break: newest first
        final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
        final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
        return dateB.compareTo(dateA);
      });
      break;

    case CommentSortMode.allComments:
      sorted.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
        final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
        return dateA.compareTo(dateB); // oldest first (chronological)
      });
      break;
  }

  return sorted;
}

class CommentComponent extends StatefulWidget {
  CommentComponent({
    super.key,
    required this.postModel,
    required this.userModel, // Current User
    required this.onTapSendComment,
    required this.commentController,
    required this.onSelectCommentReaction,
    required this.onSelectCommentReplayReaction,
    required this.onTapViewReactions,
    required this.onTapReplayComment,
    required this.onCommentEdit,
    required this.onCommentDelete,
    required this.onCommentReplayEdit,
    required this.onCommentReplayDelete,
  });

  final PostModel postModel;
  final UserModel userModel;
  final VoidCallback onTapSendComment;
  final TextEditingController commentController;
  final Function(String reaction, String commentId) onSelectCommentReaction;
  final Function(CommentModel commentModel) onCommentEdit;
  final Function(CommentModel commentModel) onCommentDelete;
  final Function(CommentReplay commentReplayModel) onCommentReplayEdit;

  final Function(String replyId, String postId) onCommentReplayDelete;

  final Function(
    String reaction,
    String commentId,
    String commentRepliesId,
  ) onSelectCommentReplayReaction;

  final VoidCallback onTapViewReactions;

  final Function({
    required String comment_id,
    required String commentReplay,
    required String file,
  }) onTapReplayComment;

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  final FocusNode focusNode = FocusNode();
  CommentSortMode _sortMode = CommentSortMode.mostRelevant;

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CommentModel> commentList =
        sortComments(widget.postModel.comments ?? [], _sortMode);

    HomeController controller = Get.find();

    // RxBool emojiShowing = true.obs;
    RxBool isCommentValid = false.obs; // Reactive boolean for comment validity

    void validateComment(String value) {
      isCommentValid.value =
          value.trim().isNotEmpty; // Check if input is not empty or spaces
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: Get.height - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ===================================================== Comment List Header =====================================================//

          // ── Drag handle ──
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: widget.onTapViewReactions,
                      child: PostReactionIcons(widget.postModel),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      (widget.postModel.reactionCount ?? 0).toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Text(
                  '${widget.postModel.totalComments} ${(widget.postModel.totalComments == 1) ? 'Comment'.tr : 'Comments'.tr}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),

          // ── Sort dropdown trigger ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: GestureDetector(
              onTap: () async {
                final result = await CommentSortBottomSheet.show(
                  context,
                  _sortMode,
                );
                if (result != null && result != _sortMode) {
                  setState(() {
                    _sortMode = result;
                  });
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    commentSortLabel(_sortMode),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFB0B3B8)
                          : const Color(0xFF65676B),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFB0B3B8)
                        : const Color(0xFF65676B),
                  ),
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),

          // ===================================================== Comment List =====================================================//
          Expanded(
            child: commentList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 56,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF3E4042)
                              : const Color(0xFFCCD0D5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No comments yet'.tr,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Be the first to comment.'.tr,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                physics: const ScrollPhysics(),
                itemCount: commentList.length,
                shrinkWrap: true,
                itemBuilder: (context, commentIndex) {
                  CommentModel commentModel = commentList[commentIndex];
                  return CommentTile(
                    onCommentEdit: widget.onCommentEdit,
                    commentModel: commentModel,
                    inputNodes: focusNode,
                    textEditingController: widget.commentController,
                    onSelectCommentReaction: (reaction) {
                      widget.onSelectCommentReaction(reaction, commentModel.id ?? '');
                    },
                    onSelectCommentReplayReaction:
                        (reaction, commentRepliesId) {
                      widget.onSelectCommentReplayReaction(
                          reaction, commentModel.id ?? '', commentRepliesId);
                    },
                    commentIndex: commentIndex,
                    onCommentDelete: widget.onCommentDelete,
                    onCommentReplayDelete: widget.onCommentReplayDelete,
                    onCommentReplayEdit: widget.onCommentReplayEdit,
                  );
                }),
            //),
          ),
          // ===================================================== Post new Comment =====================================================//
          Column(
            children: [
              Divider(height: 1, color: Theme.of(context).dividerColor),

              // ── Reply indicator ──
              Obx(
                () => Visibility(
                    visible: controller.isReply.value &&
                        !controller.isReplyOfReply.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF3A3B3C)
                          : const Color(0xFFF0F2F5),
                      child: Row(
                        children: [
                          Icon(Icons.reply,
                              size: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                                'Replying to ${controller.commentModel.value.user_id?.first_name}'
                                    .tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                )),
                          ),
                          InkWell(
                              onTap: () {
                                controller.isReply.value = false;
                                controller.isReplyOfReply.value = false;
                              },
                              child: Icon(Icons.close,
                                  size: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color)),
                        ],
                      ),
                    )),
              ),
              Obx(
                () => Visibility(
                    visible: controller.isReplyOfReply.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF3A3B3C)
                          : const Color(0xFFF0F2F5),
                      child: Row(
                        children: [
                          Icon(Icons.reply,
                              size: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                                'Replying to ${controller.commentReplyModel.value.replies_user_id?.first_name}'
                                    .tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                )),
                          ),
                          InkWell(
                              onTap: () {
                                controller.isReply.value = false;
                                controller.isReplyOfReply.value = false;
                              },
                              child: Icon(Icons.close,
                                  size: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color)),
                        ],
                      ),
                    )),
              ),

              // ── Input row (Facebook-style) ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ── Camera icon (outside pill, like Facebook) ──
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        onTap: () => controller.pickFiles(),
                        borderRadius: BorderRadius.circular(20),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 24,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // ── Input pill ──
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF3A3B3C)
                                  : const Color(0xFFF0F2F5),
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
                              child: Obx(
                                () => TextFormField(
                                  focusNode: focusNode,
                                  controller: widget.commentController,
                                  cursorColor: PRIMARY_COLOR,
                                  minLines: 1,
                                  maxLines: 4,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    isCollapsed: true,
                                    hintText: controller.isReply.value
                                        ? 'Reply to ${controller.commentModel.value.user_id?.first_name}...'
                                        : controller.isReplyOfReply.value
                                            ? 'Reply to ${controller.commentReplyModel.value.replies_user_id?.first_name}...'
                                            : 'Comment as ${widget.userModel.first_name ?? ""}',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) =>
                                      validateComment(value),
                                  onFieldSubmitted: (value) {
                                    // Send on enter (Facebook behavior)
                                    if (controller.isReply.value == false) {
                                      if (widget.commentController.text
                                              .trim()
                                              .isNotEmpty ||
                                          isCommentValid.value ||
                                          controller.xfiles.value.isNotEmpty) {
                                        widget.onTapSendComment();
                                      }
                                    } else {
                                      if (widget.commentController.text
                                              .trim()
                                              .isNotEmpty ||
                                          isCommentValid.value ||
                                          controller.processedCommentFileData
                                              .value.isNotEmpty) {
                                        widget.onTapReplayComment(
                                            file: controller
                                                .processedCommentFileData.value,
                                            comment_id:
                                                controller.commentsID.value,
                                            commentReplay:
                                                widget.commentController.text);
                                        controller.isReply.value = false;
                                        widget.commentController.clear();
                                      }
                                    }
                                  },
                                  validator: (value) {
                                    if ((value == null ||
                                            value.trim().isEmpty) &&
                                        controller.xfiles.value.isEmpty) {
                                      return 'Comment cannot be empty.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            // ── Icons inside pill (Facebook-style: sticker, GIF, emoji) ──
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6, right: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // TODO: Open sticker picker
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.emoji_emotions_outlined,
                                        size: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // TODO: Open GIF picker
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color ??
                                                Colors.grey,
                                            width: 1.2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'GIF',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // TODO: Open emoji picker
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.tag_faces_outlined,
                                        size: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
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
                    // ── Send button ──
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: InkWell(
                        onTap: () {
                          if (controller.isReply.value == false) {
                            if (widget.commentController.text
                                    .trim()
                                    .isNotEmpty ||
                                isCommentValid.value ||
                                controller.xfiles.value.isNotEmpty) {
                              widget.onTapSendComment();
                            }
                          } else {
                            if (widget.commentController.text
                                    .trim()
                                    .isNotEmpty ||
                                isCommentValid.value ||
                                controller.processedCommentFileData
                                    .value.isNotEmpty) {
                              widget.onTapReplayComment(
                                  file: controller
                                      .processedCommentFileData.value,
                                  comment_id:
                                      controller.commentsID.value,
                                  commentReplay:
                                      widget.commentController.text);
                              controller.isReply.value = false;
                              widget.commentController.clear();
                            }
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
              ),
              if (MediaQuery.of(context).padding.bottom > 0)
                SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
          // ── Selected file preview ──
          Obx(() => controller.xfiles.value.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...controller.xfiles.value.map((e) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 80,
                                    image: FileImage(File(e.path))),
                              ),
                            )),
                        IconButton(
                            onPressed: () {
                              controller.xfiles.value.clear();
                              controller.xfiles.refresh();
                            },
                            icon: Icon(Icons.cancel_outlined,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color))
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}

Widget PostReactionIcons(PostModel postModel) {
  Set<Image> postReactionIcons = {};
  if (postModel.reactionTypeCountsByPost != null) {
    for (ReactionModel reactionModel in postModel.reactionTypeCountsByPost!) {
      if (reactionModel.reaction_type == '') {}
      switch (reactionModel.reaction_type) {
        case 'like':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
        case 'love':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LOVE_ICON)));
          break;
        case 'haha':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.HAHA_ICON)));
          break;
        case 'wow':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.WOW_ICON)));
          break;
        case 'sad':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.SAD_ICON)));
          break;
        case 'angry':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.ANGRY_ICON)));
          break;
        case 'dislike':
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.UNLIKE_ICON)));
          break;
        default:
          postReactionIcons.add(const Image(
              height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON)));
          break;
      }
    }
  }
  return Row(children: postReactionIcons.toList());
}
