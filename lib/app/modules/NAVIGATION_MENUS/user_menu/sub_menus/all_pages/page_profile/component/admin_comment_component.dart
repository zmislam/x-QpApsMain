import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';

import '../../../../../../../components/comment/comment_tile.dart';
import '../../../../../../../components/image.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../models/comment_model.dart';
import '../../../../../../../models/post.dart';
import '../../../../../home/controllers/home_controller.dart';
import '../model/page_profile_model.dart';

class AdminCommentcomponent extends StatelessWidget {
  AdminCommentcomponent({
    super.key,
    required this.postModel,
    required this.pageProfileModel, // Current User
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
  final PageProfileModel pageProfileModel;
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
  }) onTapReplayComment;

  @override
  Widget build(BuildContext context) {
    List<CommentModel> commentList = postModel.comments ?? [];
    // List<CommentReplay> commentList = postModel.comments[index].replies?? [];

    HomeController controller = Get.find();

    RxBool emojiShowing = true.obs;

    return SizedBox(
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
                Text('${postModel.totalComments} Comments'.tr)
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

          Center(
            child: Obx(
              () => controller.isLoadingNewsFeed.value == true
                  ? const CircularProgressIndicator()
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ),
          ),

          // ===================================================== Post new Comment =====================================================//
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RoundCornerNetworkImage(
                    imageUrl: (pageProfileModel.pageDetails?.profilePic ?? '')
                        .formatedProfileUrl),
              ),
              Container(
                height: 40,
                width: Get.width - 80,
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey.withValues(
                        alpha: 0.1), //Color.fromARGB(135, 238, 238, 238),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: focusNode,
                        controller: commentController,
                        decoration: InputDecoration(
                            isCollapsed: true,
                            hintText: 'Comment as ${pageProfileModel.pageDetails?.pageUserName} ...'.tr,
                            hintStyle: const TextStyle(fontSize: 15),
                            border: InputBorder.none),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            debugPrint('=============photo clicked======');
                            controller.pickFiles();
                          },
                          child: const Image(
                              height: 24,
                              image: AssetImage(AppAssets.IMAGE_COMMENT_ICON)),
                        ),
                        const SizedBox(width: 10),

                        InkWell(
                          onTap: () {
                            if (emojiShowing.value == false) {
                              emojiShowing.value = true;
                            } else {
                              emojiShowing.value = false;
                            }

                            // _emojiShowing.value!=_emojiShowing.value;
                          },
                          child: const Image(
                              height: 24,
                              image: AssetImage(AppAssets.REACT_COMMENT_ICON)),
                        ),

                        ///////////////////////////////////////////////////////////////////////////////

                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            if (controller.isReply.value == false) {
                              onTapSendComment();
                            } else {
                              onTapReplayComment(
                                  comment_id: controller.commentsID.value,
                                  commentReplay: commentController.text);
                              controller.isReply.value = false;
                              commentController.clear();
                            }
                          },
                          child: const Image(
                              height: 24,
                              image: AssetImage(AppAssets.SEND_COMMENT_ICON)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

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
