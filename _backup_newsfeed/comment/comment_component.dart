// import 'dart:ffi';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:quantum_possibilities_flutter/app/extension/num.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';

import '../../config/constants/app_assets.dart';
import '../../models/comment_model.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../image.dart';
import 'comment_tile.dart';

class CommentComponent extends StatelessWidget {
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

  final FocusNode focusNode = FocusNode();

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
  Widget build(BuildContext context) {
    List<CommentModel> commentList = postModel.comments ?? [];
    // List<CommentReplay> commentList = postModel.comments[index].replies?? [];

    HomeController controller = Get.find();

    // RxBool emojiShowing = true.obs;
    RxBool isCommentValid = false.obs; // Reactive boolean for comment validity
    // RxBool isReplyValid = false.obs; // Reactive boolean for comment validity

    void validateComment(String value) {
      isCommentValid.value =
          value.trim().isNotEmpty; // Check if input is not empty or spaces
    }
    // void validateReply(String value) {
    //   isReplyValid.value =
    //       value.trim().isNotEmpty; // Check if input is not empty or spaces
    // }

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
                      child: PostReactionIcons(postModel),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      (postModel.reactionCount ?? 0).toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                ((postModel.totalComments == 0) ||
                        (postModel.totalComments == 1))
                    ? Text('${postModel.totalComments} ${'Comment'.tr}')
                    : Text('${postModel.totalComments} ${'Comment'.tr}')
              ],
            ),
          ),

          // ===================================================== Comment List =====================================================//
          Expanded(
            child: ListView.builder(
                physics: const ScrollPhysics(),
                itemCount: commentList.length,
                shrinkWrap: true,
                itemBuilder: (context, commentIndex) {
                  CommentModel commentModel = commentList[commentIndex];
                  return CommentTile(
                    onCommentEdit: onCommentEdit,
                    commentModel: commentModel,
                    inputNodes: focusNode,
                    textEditingController: commentController,
                    onSelectCommentReaction: (reaction) {
                      onSelectCommentReaction(reaction, commentModel.id ?? '');
                    },
                    onSelectCommentReplayReaction:
                        (reaction, commentRepliesId) {
                      onSelectCommentReplayReaction(
                          reaction, commentModel.id ?? '', commentRepliesId);
                    },
                    commentIndex: commentIndex,
                    onCommentDelete: onCommentDelete,
                    onCommentReplayDelete: onCommentReplayDelete,
                    onCommentReplayEdit: onCommentReplayEdit,
                  );
                }),
            //),
          ),
          // ===================================================== Post new Comment =====================================================//
          Column(
            children: [
              const Divider(),
              Obx(
                () => Visibility(
                    visible: controller.isReply.value &&
                        !controller.isReplyOfReply.value,
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                              'Reply to ${controller.commentModel.value.user_id?.first_name}'
                                  .tr),
                        )),
                        TextButton(
                            onPressed: () {
                              controller.isReply.value = false;
                              controller.isReplyOfReply.value = false;
                            },
                            child: Text('Cancel'.tr))
                      ],
                    )),
              ),
              Obx(
                () => Visibility(
                    visible: controller.isReplyOfReply.value,
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                              'Reply to ${controller.commentReplyModel.value.replies_user_id?.first_name}'
                                  .tr),
                        )),
                        TextButton(
                            onPressed: () {
                              controller.isReply.value = false;
                              controller.isReplyOfReply.value = false;
                            },
                            child: Text('Cancel'.tr))
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
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
                                controller: commentController,
                                cursorColor: PRIMARY_COLOR,
                                minLines: 1, // Minimum number of lines to show
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  isCollapsed: true,
                                  hintText: controller.isReply.value
                                      ? 'To ${controller.commentModel.value.user_id?.first_name} Comment as ${userModel.first_name} ...'
                                      : controller.isReplyOfReply.value
                                          ? 'To ${controller.commentReplyModel.value.replies_user_id?.first_name} Comment as ${userModel.first_name} ...'
                                          : ' Comment as ${userModel.first_name} ...',
                                  hintStyle: const TextStyle(fontSize: 15),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) => validateComment(value),
                                validator: (value) {
                                  if ((value == null || value.trim().isEmpty) &&
                                      controller.xfiles.value.isEmpty) {
                                    return 'Comment cannot be empty.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  debugPrint(
                                      '=============photo clicked======');
                                  controller.pickFiles();
                                },
                                child: Image(
                                    height: 24,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
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
                                  if (controller.isReply.value == false) {
                                    if (commentController.text
                                            .trim()
                                            .isNotEmpty ||
                                        isCommentValid.value ||
                                        controller.xfiles.value.isNotEmpty) {
                                      onTapSendComment();
                                    } else {
                                      null;
                                    }
                                  } else {
                                    if (commentController.text
                                            .trim()
                                            .isNotEmpty ||
                                        isCommentValid.value ||
                                        controller.processedCommentFileData
                                            .value.isNotEmpty) {
                                      onTapReplayComment(
                                          file: controller
                                              .processedCommentFileData.value,
                                          comment_id:
                                              controller.commentsID.value,
                                          commentReplay:
                                              commentController.text);
                                      controller.isReply.value = false;
                                      commentController.clear();
                                    } else {
                                      null;
                                    }
                                  }
                                },
                                child: Image(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    height: 24,
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
              ),
              MediaQuery.of(context).padding.bottom > 0 ? 30.h : 0.h,
            ],
          ),
          20.h,
          Obx(() => controller.xfiles.value.isEmpty
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
                            children: controller.xfiles.value
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image(
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                          image: FileImage(File(e.path))),
                                    ))
                                .toList()),
                        IconButton(
                            onPressed: () {
                              controller.xfiles.value.clear();
                              controller.xfiles.refresh();
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
          //       textEditingController: commentController,
          //       //scrollController: _scrollController,
          //       config: Config(
          //         height: 256,
          //         checkPlatformCompatibility: true,
          //         emojiViewConfig: EmojiViewConfig(
          //           // Issue: https://github.com/flutter/flutter/issues/28894
          //           emojiSizeMax: 28 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.2 : 1.0),
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
          //         searchViewConfig: const SearchViewConfig(backgroundColor: PRIMARY_COLOR),
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
