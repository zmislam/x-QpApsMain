import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../../../extension/num.dart';
import '../../../../extension/string/string_image_path.dart';

import '../../../../components/image.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../models/user.dart';
import '../../../../utils/mediaPreview.dart';
import '../controllers/reels_controller.dart';
import '../model/reels_comment_model.dart';
import '../model/reels_comment_reply_model.dart';
import '../model/reels_model.dart';
import 'reels_comment_tile.dart';

class ReelsCommentComponent extends StatelessWidget {
  ReelsCommentComponent({
    super.key,
    required this.reelsModel,
    required this.userModel,
    required this.onTapSendReelsComment,
    required this.reelsCommentController,
    required this.reelsCommentList,
    required this.onTapViewReactions,
    required this.onTapReelsReplayComment,
    required this.onSelectReelsCommentReplayReaction,
    required this.onReelsCommentEdit,
    required this.onReelsCommentDelete,
    required this.onReelsCommentReplayEdit,
    required this.onReelsCommentReplayDelete,
    required this.onSelectReelsCommentReaction,
  });

  static const List<String> _quickEmojis = [
    '😂', '❤️', '🔥', '👏', '😍', '😢', '😮', '🙏', '💯', '🎉',
    '👍', '😎', '🤣', '💪', '✨', '🥰', '😭', '🤔', '👀', '💀',
  ];

  final RxBool _showEmojiBar = false.obs;
  final ReelsModel reelsModel;
  final UserModel userModel;
  final TextEditingController reelsCommentController;
  final VoidCallback onTapSendReelsComment;
  final Function(String reaction, ReelsCommentModel reelsCommentModel)
      onSelectReelsCommentReaction;

  final Function(
    String reaction,
    String commentId,
    String commentRepliesId,
    String userId,
  ) onSelectReelsCommentReplayReaction;

  final Function({
    required String comment_id,
    required String commentReplay,
  required String file,
  }) onTapReelsReplayComment;

  final Function(ReelsCommentModel reelsCommentModel) onReelsCommentEdit;
  final Function(ReelsCommentModel reelsCommentModel) onReelsCommentDelete;
  final Function(ReelsCommentReplyModel reelsCommentReplayModel)
      onReelsCommentReplayEdit;

  final Function(String replyId, String postId, String key) onReelsCommentReplayDelete;

  final FocusNode focusNode = FocusNode();

  final List<ReelsCommentModel> reelsCommentList;
  final VoidCallback onTapViewReactions;

  @override
  Widget build(BuildContext context) {
    ReelsController videoController = Get.find();
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: onTapViewReactions,
                      child: PostReactionIcons(reelsModel),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      (reelsModel.reaction_count ?? 0).toString(),
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Text('${reelsModel.comment_count} Comments'.tr)
              ],
            ),
          ),

          // ===================================================== Comment Sort Bar =====================================================//
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Obx(() => InkWell(
                  onTap: () {
                    final current = videoController.commentSortMode.value;
                    videoController.commentSortMode.value =
                        current == 'most_relevant' ? 'newest' : 'most_relevant';
                  },
                  child: Row(
                    children: [
                      Icon(Icons.sort, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        videoController.commentSortMode.value == 'most_relevant'
                            ? 'Most relevant'
                            : 'Newest first',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey[600]),
                    ],
                  ),
                )),
          ),

          // ===================================================== Reels Comment List  =====================================================//

          Expanded(
            child: ListView.builder(
              physics: const ScrollPhysics(),
              itemCount: reelsCommentList.length,
              itemBuilder: (context, commentListIndex) {
                ReelsCommentModel reelsComentModel =
                    reelsCommentList[commentListIndex];
                return ReelsCommentTile(
                    onReelsCommentEdit: onReelsCommentEdit,
                    reelsCommentModel: reelsComentModel,
                    inputNodes: focusNode,
                    index: commentListIndex,
                    textEditingController: reelsCommentController,
                    onSelectReelsCommentReaction: (reaction) {
                      onSelectReelsCommentReaction(reaction, reelsComentModel);
                    },
                    onSelectReelsCommentReplyReaction:
                        (reaction, commentRepliesId) {
                      onSelectReelsCommentReplayReaction(
                          reaction,
                          reelsComentModel.id ?? '',
                          commentRepliesId,
                          reelsComentModel.user_id?.id ?? '');
                    },
                    onReelsCommentDelete: onReelsCommentDelete,
                    onReelsCommentReplayEdit: onReelsCommentReplayEdit,
                    onReelsCommentReplayDelete: onReelsCommentReplayDelete, key: key,);
              },
            ),
          ),
          // Center(
          //   child: Obx(
          //     () => videoController.isLoadingNewsFeed.value == true
          //         ? const CircularProgressIndicator()
          //         : const SizedBox(
          //             height: 0,
          //             width: 0,
          //           ),
          //   ),
          // ),
          // ===================================================== Post new Comment =====================================================//
          Column(
            children: [
              Obx(
                () => Visibility(
                    visible: videoController.isReply.value &&
                        !videoController.isReplyOfReply.value,
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('Reply to ${videoController.reelsCommentModel.value.user_id?.first_name}'.tr),
                        )),
                        TextButton(
                            onPressed: () {
                              videoController.isReply.value = false;
                              videoController.isReplyOfReply.value = false;
                            },
                            child: Text('Cancel'.tr))
                      ],
                    )),
              ),
              Obx(
                () => Visibility(
                    visible: videoController.isReplyOfReply.value,
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('Reply to ${videoController.reelsCommentReplyModel.value.replies_user_id?.first_name}'.tr),
                        )),
                        TextButton(
                            onPressed: () {
                              videoController.isReply.value = false;
                              videoController.isReplyOfReply.value = false;
                            },
                            child: Text('Cancel'.tr))
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 8, 10, 8 + MediaQuery.of(context).padding.bottom),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Camera icon — standalone, left of pill
                    GestureDetector(
                      onTap: () => videoController.pickFiles(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 24,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    // Rounded pill: text + icons inside
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 40),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF3A3B3C)
                              : const Color(0xFFF0F2F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text input
                            Expanded(
                              child: Obx(
                                () => TextFormField(
                                  focusNode: focusNode,
                                  cursorColor: PRIMARY_COLOR,
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: reelsCommentController,
                                  onChanged: (value) => validateComment(value),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    isCollapsed: true,
                                    hintText: videoController.isReply.value
                                        ? 'Reply to ${videoController.reelsCommentModel.value.user_id?.first_name}...'
                                        : videoController.isReplyOfReply.value
                                            ? 'Reply to ${videoController.reelsCommentReplyModel.value.replies_user_id?.first_name}...'
                                            : 'Comment as ${userModel.first_name ?? ''}',
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            // Right-side icons OR send button
                            Obx(() {
                              final hasText = isCommentValid.value || videoController.xfiles.value.isNotEmpty;
                              if (hasText) {
                                // Show send button when typing
                                return GestureDetector(
                                  onTap: () {
                                    if (videoController.isReply.value == false) {
                                      if (reelsCommentController.text.trim().isNotEmpty ||
                                          isCommentValid.value ||
                                          videoController.xfiles.value.isNotEmpty) {
                                        onTapSendReelsComment();
                                      }
                                    } else {
                                      if (reelsCommentController.text.trim().isNotEmpty ||
                                          isCommentValid.value ||
                                          videoController.xfiles.value.isNotEmpty) {
                                        onTapReelsReplayComment(
                                            comment_id: videoController.reelsCommentID.value,
                                            commentReplay: reelsCommentController.text,
                                            file: videoController.processedCommentFileData.value);
                                        videoController.isReply.value = false;
                                        reelsCommentController.clear();
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Icon(
                                      Icons.send,
                                      size: 20,
                                      color: PRIMARY_COLOR,
                                    ),
                                  ),
                                );
                              }
                              final iconColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // GIF icon
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: iconColor, width: 1.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'GIF',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: iconColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Emoji picker toggle
                                  GestureDetector(
                                    onTap: () => _showEmojiBar.toggle(),
                                    child: Icon(
                                      _showEmojiBar.value ? Icons.keyboard : Icons.emoji_emotions_outlined,
                                      size: 22,
                                      color: iconColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(() => videoController.xfiles.value.isEmpty
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : Container(
                  width: Get.width - 50,
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          children: videoController.xfiles.value.map((e) {
                            final file = File(e.path);
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: MediaPreview(file: file, width: 100, height: 100),
                            );
                          }).toList(),
                        ),
                        IconButton(
                            onPressed: () {
                              videoController.xfiles.value.clear();
                              videoController.xfiles.refresh();
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  ),
                )),

          // ─── Quick Emoji Bar ──────────────────────────────────────────
          Obx(() => _showEmojiBar.value
              ? Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickEmojis.length,
                    itemBuilder: (_, i) => InkWell(
                      onTap: () {
                        final text = reelsCommentController.text;
                        final sel = reelsCommentController.selection;
                        final offset = sel.isValid ? sel.baseOffset : text.length;
                        reelsCommentController.text =
                            text.substring(0, offset) + _quickEmojis[i] + text.substring(offset);
                        reelsCommentController.selection =
                            TextSelection.collapsed(offset: offset + _quickEmojis[i].length);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: Text(_quickEmojis[i], style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget PostReactionIcons(ReelsModel reelsModel) {
    Set<Image> postReactionIcons = {};
    if (reelsModel.reactions != null) {
      for (ReelsReactionModel reactionModel in reelsModel.reactions!) {
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
                height: 24,
                width: 24,
                image: AssetImage(AppAssets.ANGRY_ICON)));
            break;
          case 'dislike':
            postReactionIcons.add(const Image(
                height: 24,
                width: 24,
                image: AssetImage(AppAssets.UNLIKE_ICON)));
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
}
