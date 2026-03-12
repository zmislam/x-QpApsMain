import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import '../smart_text.dart';
import '../../extension/string/string_image_path.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants/api_constant.dart';
import '../../models/comment_model.dart';
import '../../models/reply_comment_user_model.dart';
import '../../models/user.dart';
import '../../models/user_id.dart';
import '../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../routes/app_pages.dart';
import '../../routes/profile_navigator.dart';
import '../../utils/comment.dart';
import '../../utils/post_utlis.dart';
import '../custom_cached_image_view.dart';
import '../image.dart';
import '../reaction_button/comment_reaction_button.dart';
import '../single_image.dart';
import '../video_player/post/newsfeed_post_video_player.dart';
import '../video_player/post/post_details_video_screen.dart';

class CommentTile extends StatelessWidget {
  final int commentIndex;
  final CommentModel commentModel;
  final FocusNode inputNodes;
  final TextEditingController textEditingController;
  final Function(String reaction) onSelectCommentReaction;
  final Function(CommentModel commentModel) onCommentEdit;
  final Function(CommentModel commentModel) onCommentDelete;
  final Function(CommentReplay commentReplayModel)? onCommentReplayEdit;

  final Function(String replyId, String postId) onCommentReplayDelete;
  final Function(
    String reaction,
    String commentReplayId,
  ) onSelectCommentReplayReaction;

  HomeController controller = Get.find();

  CommentTile({
    super.key,
    required this.commentModel,
    required this.inputNodes,
    required this.textEditingController,
    required this.onSelectCommentReaction,
    required this.onSelectCommentReplayReaction,
    required this.commentIndex,
    required this.onCommentEdit,
    required this.onCommentDelete,
    this.onCommentReplayEdit,
    required this.onCommentReplayDelete,
  });

  @override
  Widget build(BuildContext context) {
    UserIdModel? commentedUserIdModel =
        commentModel.user_id; // User who did this comment
    UserModel currentUserModel = controller.userModel;
    final mediaPath = commentModel.image_or_video ?? '';
    final isVideo = mediaPath.toLowerCase().endsWith('.mp4') ||
        mediaPath.toLowerCase().endsWith('.mov') ||
        mediaPath.toLowerCase().endsWith('.mkv') ||
        mediaPath.toLowerCase().endsWith('.avi') ||
        mediaPath.toLowerCase().endsWith('.webm');

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          //============================================================== Main Comment Section ==============================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //========================================Profile Picture
              const SizedBox(width: 10),
              RoundCornerNetworkImage(
                imageUrl: commentedUserIdModel?.page_id != null
                    ? (commentedUserIdModel?.profile_pic?.formatedProfileUrl ??
                        ''.formatedProfileUrl)
                    : (commentedUserIdModel?.profile_pic?.formatedProfileUrl ??
                        ''.formatedProfileUrl),
              ),

              const SizedBox(width: 10),
              // ======================================== Comment with user Name + Action Section
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ============= On click Name of commenter ===================
                          InkWell(
                            onTap: () {
                              ProfileNavigator.navigateToProfile(
                                  username:
                                      commentedUserIdModel?.username ?? '',
                                  isFromReels: 'false');
                            },
                            child: Row(
                              children: [
                                Text(
                                  '${commentedUserIdModel?.first_name} ${commentedUserIdModel?.last_name}'
                                      .tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 4),
                                commentedUserIdModel?.isProfileVerified == true
                                    ? Icon(
                                        Icons.verified,
                                        color: PRIMARY_COLOR,
                                        size: 16,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          //================================= Text Comment=========================//
                          (commentModel.comment_name != null &&
                                  commentModel.comment_name != '' &&
                                  commentModel.comment_name != 'null')
                              ? LinkText(text: commentModel.comment_name ?? '')
                              : const SizedBox(),

                          //================================ Link Image============================//
                          (commentModel.link_image?.isNotEmpty ?? false)
                              ? InkWell(
                                  onTap: () async {
                                    await launchUrl(
                                        Uri.parse(commentModel.link ?? ''),
                                        mode: LaunchMode.externalApplication);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: PrimaryNetworkImage(
                                        imageUrl: commentModel.link_image!),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    //================================= Image Comment=========================//
                    mediaPath.isNotEmpty
                        ? Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: isVideo
                                ? NewsFeedPostVideoPlayer(
                                    onNavigate: () => Get.to(
                                      PostDetailsVideoScreen(
                                        videoSrc:
                                            '${ApiConstant.SERVER_IP_PORT}/$mediaPath',
                                      ),
                                    ),
                                    postId: '',
                                    videoSrc:
                                        '${ApiConstant.SERVER_IP_PORT}/$mediaPath',
                                  )
                                : InkWell(
                                    onTap: () {
                                      Get.to(() => SingleImage(
                                          imgURL:
                                              '${ApiConstant.SERVER_IP_PORT}/$mediaPath'));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CustomCachedNetworkImage(
                                        alignment: Alignment.centerLeft,
                                        imageUrl:
                                            '${ApiConstant.SERVER_IP_PORT}/$mediaPath',
                                        height: 240,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                          )
                        : const SizedBox.shrink(),
                    // ========================================= Main comments Action Section =========================================
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Text(
                            maxLines: 1,
                            getDynamicFormatedCommentTime(
                                '${commentModel.createdAt}'),
                          ),
                          const SizedBox(width: 10),
                          // ======================================== Do Comment Reaction ==================================
                          CommentReactionButton(
                            selectedReaction: getSelectedCommentReaction(
                                commentModel, currentUserModel.id ?? ''),
                            onChangedReaction: (reaction) {
                              onSelectCommentReaction(reaction.value);
                            },
                          ),
                          const SizedBox(width: 10),
                          // ======================================== Do Comment Replay ==================================
                          InkWell(
                            onTap: () {
                              controller.commentsID.value =
                                  '${commentModel.id}';
                              controller.postID.value =
                                  '${commentModel.post_id}';

                              FocusScope.of(context).requestFocus(inputNodes);

                              controller.isReply.value = true;

                              controller.commentModel.value = commentModel;
                            },
                            child: Text('Reply'.tr),
                          ),
                          const Expanded(child: SizedBox()),

                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.COMMENT_REACTIONS,
                                  arguments: commentModel);
                            },
                            child: CommentReactionIcons(commentModel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //======================================== More Action Icon

              currentUserModel.id == commentModel.user_id?.id
                  ? PopupMenuButton(
                      color: Theme.of(context).cardTheme.color,
                      offset: const Offset(-50, 00),
                      iconColor: Colors.grey,
                      icon: const Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context) {
                        List<PopupMenuEntry<int>> menuItems = [];
                        //====================================================== Edit Comment =======================================//

                        if (commentModel.image_or_video == null ||
                            commentModel.comment_name != '') {
                          menuItems.add(
                            PopupMenuItem(
                              onTap: () {
                                onCommentEdit(commentModel);
                              },
                              value: 1,
                              child: Text(
                                'Edit'.tr,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          );
                        }

                        //====================================================== Delete Comment =======================================//

                        menuItems.add(
                          PopupMenuItem(
                            onTap: () {
                              onCommentDelete(commentModel);
                            },
                            value: 2,
                            child: Text(
                              'Delete'.tr,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        );

                        return menuItems;
                      },
                    )
                  : const SizedBox(
                      height: 0,
                      width: 50,
                    ),
            ],
          ),

          //===================================================================== Comment Replay List =========================================//

          Container(
            margin: const EdgeInsets.only(left: 65),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: commentModel.replies?.length ?? 0,
                itemBuilder: (context, index) {
                  CommentReplay? commentReplay = commentModel.replies?[index];
                  ReplyCommentUserIdModel replyCommentUser =
                      commentReplay?.replies_user_id ??
                          ReplyCommentUserIdModel();
                  final replyMedia =
                      commentModel.replies?[index].image_or_video ?? '';
                  final isVideo = replyMedia.toLowerCase().endsWith('.mp4') ||
                      replyMedia.toLowerCase().endsWith('.mov') ||
                      replyMedia.toLowerCase().endsWith('.mkv') ||
                      replyMedia.toLowerCase().endsWith('.avi') ||
                      replyMedia.toLowerCase().endsWith('.webm');
                  return InkWell(
                    onTap: () {
                      ProfileNavigator.navigateToProfile(
                          username: replyCommentUser.username ?? '',
                          isFromReels: 'false');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //============================================== Comment Replay User Image
                        RoundCornerNetworkImage(
                            imageUrl: commentModel
                                    .replies?[index]
                                    .replies_user_id
                                    ?.profile_pic
                                    ?.formatedProfileUrl ??
                                ''.formatedProfileUrl),
                        const SizedBox(
                          width: 5,
                        ),
                        /////////////////////////////
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          //============================================== Comment Replay User Name ========================//
                                          Text(
                                            '${commentModel.replies?[index].replies_user_id?.first_name} ${commentModel.replies![index].replies_user_id?.last_name}'
                                                .tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          commentedUserIdModel!
                                                  .isProfileVerified!
                                              ? Icon(
                                                  Icons.verified,
                                                  color: PRIMARY_COLOR,
                                                  size: 16,
                                                )
                                              : const SizedBox.shrink()
                                        ],
                                      ),
                                    ),
                                    (commentModel.replies?[index]
                                                    .replies_comment_name !=
                                                null &&
                                            commentModel.replies?[index]
                                                    .replies_comment_name !=
                                                '' &&
                                            commentModel.replies?[index]
                                                    .replies_comment_name !=
                                                'null')
                                        ? SmartText(commentModel.replies![index]
                                                .replies_comment_name ??
                                            '')
                                        : const SizedBox(
                                            height: 5,
                                          ),

                                    //================================ Link Image============================//
                                    (commentModel.replies![index].link_image
                                                ?.isNotEmpty ??
                                            false)
                                        ? InkWell(
                                            onTap: () async {
                                              await launchUrl(
                                                  Uri.parse(commentModel
                                                          .replies![index]
                                                          .link ??
                                                      ''),
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: PrimaryNetworkImage(
                                                  imageUrl: commentModel
                                                      .replies![index]
                                                      .link_image!),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              //================================ Image or Video============================//
                              replyMedia.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: isVideo
                                          ? NewsFeedPostVideoPlayer(
                                              onNavigate: () => Get.to(
                                                PostDetailsVideoScreen(
                                                  videoSrc:
                                                      '${ApiConstant.SERVER_IP_PORT}/$replyMedia',
                                                ),
                                              ),
                                              postId: '',
                                              videoSrc:
                                                  '${ApiConstant.SERVER_IP_PORT}/$replyMedia',
                                            )
                                          : InkWell(
                                              onTap: () {
                                                Get.to(() => SingleImage(
                                                    imgURL:
                                                        '${ApiConstant.SERVER_IP_PORT}/$replyMedia'));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CustomCachedNetworkImage(
                                                  imageUrl:
                                                      '${ApiConstant.SERVER_IP_PORT}/$replyMedia',
                                                  height: 240,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                    )
                                  : const SizedBox.shrink(),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      maxLines: 1,
                                      getDynamicFormatedCommentTime(
                                          '${commentModel.replies![index].createdAt}'),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    //=============================================================== Comment Replay Reaction===============================================================
                                    CommentReactionButton(
                                      selectedReaction:
                                          getSelectedCommentReplayReaction(
                                              commentModel.replies![index],
                                              currentUserModel.id ?? ''),
                                      onChangedReaction: (reaction) {
                                        onSelectCommentReplayReaction(
                                            reaction.value,
                                            '${commentModel.replies?[index].id}');
                                      },
                                    ),
                                    //===============================================================Do Comment Replay ===============================================================

                                    InkWell(
                                      onTap: () {
                                        controller.commentsID.value =
                                            '${commentModel.id}';
                                        controller.postID.value =
                                            '${commentModel.post_id}';

                                        FocusScope.of(context)
                                            .requestFocus(inputNodes);
                                        controller.isReply.value = false;
                                        controller.isReplyOfReply.value = true;
                                        controller.commentReplyModel.value =
                                            commentModel.replies?[index] ??
                                                CommentReplay();
                                      },
                                      child: Text('Reply'.tr),
                                    ),
                                    const Spacer(),

                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                            Routes.COMMENT_REPLAY_REACTIONS,
                                            arguments:
                                                commentModel.replies?[index]);
                                      },
                                      child: ReplayReactionIcons(
                                          commentReplay ?? CommentReplay()),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        currentUserModel.id ==
                                commentModel.replies?[index].replies_user_id?.id
                            ? PopupMenuButton(
                                color: Colors.white,
                                offset: const Offset(140, 40),
                                iconColor: Colors.grey,
                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey,
                                ),
                                itemBuilder: (context) {
                                  List<PopupMenuEntry<int>> items = [];
                                  //       //====================================================== Edit Reply Comment =======================================//

                                  if (commentReplay?.image_or_video == null ||
                                      commentReplay?.replies_comment_name !=
                                          '') {
                                    items.add(
                                      PopupMenuItem(
                                        onTap: () {
                                          onCommentReplayEdit!(
                                            commentReplay ?? CommentReplay(),
                                          );
                                        },
                                        value: 1,
                                        child: Text(
                                          'Edit'.tr,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }

                                  //       //====================================================== Delete Reply Comment =======================================//

                                  items.add(
                                    PopupMenuItem(
                                      onTap: () {
                                        onCommentReplayDelete(
                                            '${commentModel.replies?[index].id}',
                                            '${commentModel.replies?[index].post_id}');
                                      },
                                      value: 2,
                                      child: Text(
                                        'Delete'.tr,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );

                                  return items;
                                },
                              )
                            : const SizedBox(
                                height: 0,
                                width: 50,
                              ),
                      ],
                    ),
                  );
                }),
          )

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ],
      ),
    );
  }

  // Widget ReactionIcon(String assetName) {
  //   return Image(height: 24, image: AssetImage(assetName));
  // }

  // Widget ReactionIcons(String reaction_type) {
  //   switch (reaction_type) {
  //     case 'like':
  //       return const Image(
  //           height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON));
  //     case 'love':
  //       return const Image(
  //           height: 24, width: 24, image: AssetImage(AppAssets.LOVE_ICON));
  //     case 'haha':
  //       return const Image(
  //           height: 24, width: 24, image: AssetImage(AppAssets.HAHA_ICON));
  //     case 'wow':
  //       return const Image(
  //           height: 24, width: 24, image: AssetImage(AppAssets.WOW_ICON));
  //     case 'sad':
  //       return const Image(
  //           height: 24, width: 24, image: AssetImage(AppAssets.SAD_ICON));
  //     case 'angry':
  //       return const Image(
  //           height: 24, width: 24, image: AssetImage(AppAssets.ANGRY_ICON));
  //     case 'dislike':
  //       return const Image(
  //           height: 24, width: 24, image: AssetImage(AppAssets.UNLIKE_ICON));
  //     default:
  //       return const Image(
  //           height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON));
  //   }
  // }
}
