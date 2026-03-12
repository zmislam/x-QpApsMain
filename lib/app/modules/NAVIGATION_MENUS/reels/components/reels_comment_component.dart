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

          // ===================================================== Reels Comment List  =====================================================//

          Expanded(
            child: ListView.builder(
              physics: const ScrollPhysics(),
              itemCount: reelsCommentList.length,
              shrinkWrap: true,
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
              const Divider(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RoundCornerNetworkImage(
                        imageUrl:
                            (userModel.profile_pic ?? '').formatedProfileUrl),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Expanded(
                            child: TextFormField(
                              focusNode: focusNode,
                              cursorColor: PRIMARY_COLOR,
                              minLines: 1, // Minimum number of lines to show
                              maxLines: null,
                              controller: reelsCommentController,
                              onChanged: (value) => validateComment(value),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Comment cannot be empty.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  isCollapsed: true,
                                  hintText: videoController.isReply.value
                                      ? 'To ${videoController.reelsCommentModel.value.user_id?.first_name} Comment as ${userModel.first_name} ...'
                                      : videoController.isReplyOfReply.value
                                          ? 'To ${videoController.reelsCommentReplyModel.value.replies_user_id?.first_name} Comment as ${userModel.first_name} ...'
                                          : ' Comment as ${userModel.first_name} ...',
                                  hintStyle: TextStyle(fontSize: 15),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                debugPrint('=============photo clicked======');
                                videoController.pickFiles();
                              },
                              child: Image(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  height: 24,
                                  image: const AssetImage(
                                      AppAssets.IMAGE_COMMENT_ICON)),
                            ),
                            // const SizedBox(width: 10),
                            //
                            // InkWell(
                            //   onTap: () {
                            //     if (emojiShowing.value == false) {
                            //       emojiShowing.value = true;
                            //     } else {
                            //       emojiShowing.value = false;
                            //     }
                            //
                            //     // _emojiShowing.value!=_emojiShowing.value;
                            //   },
                            //   child: const Image(height: 24, image: AssetImage(AppAssets.REACT_COMMENT_ICON)),
                            // ),

                            ///////////////////////////////////////////////////////////////////////////////

                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                if (videoController.isReply.value == false) {
                                  if (reelsCommentController.text
                                          .trim()
                                          .isNotEmpty ||
                                      isCommentValid.value ||
                                      videoController.xfiles.value.isNotEmpty) {
                                    onTapSendReelsComment();
                                  } else {
                                    null;
                                  }
                                } else {
                                  if (reelsCommentController.text
                                          .trim()
                                          .isNotEmpty ||
                                      isCommentValid.value ||
                                      videoController.xfiles.value.isNotEmpty) {
                                    onTapReelsReplayComment(
                                        comment_id: videoController
                                            .reelsCommentID.value,
                                        commentReplay:
                                            reelsCommentController.text, file: videoController.processedCommentFileData.value);
                                    videoController.isReply.value = false;
                                    reelsCommentController.clear();
                                  } else {
                                    null;
                                  }
                                }
                              },
                              child: Image(
                                  height: 24,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  image: const AssetImage(
                                      AppAssets.SEND_COMMENT_ICON)),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          MediaQuery.of(context).padding.bottom > 0 ? 40.h : 0.h,
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

          // Obx(
          //   () => Offstage(
          //     offstage: emojiShowing.value,
          //     child: EmojiPicker(
          //       textEditingController: reelsCommentController,
          //       //scrollController: _scrollController,
          //       config: Config(
          //         height: 256,
          //         checkPlatformCompatibility: true,
          //         emojiViewConfig: EmojiViewConfig(
          //           // Issue: https://github.com/flutter/flutter/issues/28894
          //           emojiSizeMax: 28 *
          //               (foundation.defaultTargetPlatform == TargetPlatform.iOS
          //                   ? 1.2
          //                   : 1.0),
          //         ),
          //         swapCategoryAndBottomBar: false,
          //         skinToneConfig: const SkinToneConfig(),
          //         categoryViewConfig: const CategoryViewConfig(
          //           indicatorColor: PRIMARY_COLOR,
          //           iconColorSelected: PRIMARY_COLOR,
          //         ),
          //         bottomActionBarConfig: const BottomActionBarConfig(
          //           backgroundColor: Colors.transparent,
          //           buttonColor: Colors.transparent,
          //           buttonIconColor: Colors.grey,
          //         ),
          //         searchViewConfig:
          //             const SearchViewConfig(backgroundColor: PRIMARY_COLOR),
          //       ),
          //     ),
          //   ),
          // ),

          const SizedBox(
            height: 10,
          )
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
