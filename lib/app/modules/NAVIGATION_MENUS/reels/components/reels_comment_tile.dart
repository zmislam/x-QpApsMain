import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/image.dart';
import '../../../../components/reaction_button.dart';
import '../../../../components/smart_text.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../data/login_creadential.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/networkMediaPreview.dart';
import '../../../../utils/post_utlis.dart';
import '../../../../utils/reels_comment_and_reply_reactions.dart';
import '../controllers/reels_controller.dart';
import '../model/reels_comment_model.dart';
import '../model/reels_comment_reply_model.dart';

class ReelsCommentTile extends StatelessWidget {
  final int index;
  final ReelsCommentModel reelsCommentModel;
  final FocusNode? inputNodes;
  final TextEditingController textEditingController;
  final Function(String reaction) onSelectReelsCommentReaction;
  final Function(ReelsCommentModel reelsCommentModel) onReelsCommentEdit;
  final Function(ReelsCommentModel reelsCommentModel) onReelsCommentDelete;
  final Function(ReelsCommentReplyModel reelsCommentReplayModel)?
      onReelsCommentReplayEdit;
  final Function(String replyId, String postId, String key) onReelsCommentReplayDelete;
  final Function(
    String reaction,
    String commentReplyId,
  ) onSelectReelsCommentReplyReaction;

  ReelsController videoController = Get.find();

  ReelsCommentTile({
    super.key,
    required this.reelsCommentModel,
    this.inputNodes,
    required this.onReelsCommentEdit,
    required this.onReelsCommentDelete,
    required this.onSelectReelsCommentReplyReaction,
    required this.onReelsCommentReplayEdit,
    required this.onReelsCommentReplayDelete,
    required this.textEditingController,
    required this.onSelectReelsCommentReaction,
    required this.index,
  });

  Reaction<String>? getPlaceholder(ReelsCommentModel reelsCommentModel) {
    List<ReelsCommentReactionModel> comment_reactions =
        reelsCommentModel.comment_reactions ?? [];
    ReelsCommentReactionModel commentReaction = comment_reactions.firstWhere(
        (commentReaction) =>
            commentReaction.user_id?.id == LoginCredential().getUserData().id,
        orElse: () => ReelsCommentReactionModel(v: -1));
    if ((commentReaction.v ?? 0) == -1) {
      return Reaction<String>(
        value: 'like',
        icon: Row(
          children: [
            Text('Like'.tr,
            )
          ],
        ),
      );
    } else {
      return Reaction<String>(
          value: commentReaction.reaction_type,
          icon: ReactionIcons(
            commentReaction.reaction_type ?? '',
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    ReelsUserIdModel? userIdModel =
        reelsCommentModel.user_id; // User who did this comment
    // ! CODE MARK
    // videoController.getPageDetails(pageUserName: userIdModel?.username ?? '');
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //========================================Profile Picture
              const SizedBox(width: 10),
              RoundCornerNetworkImage(
                imageUrl: (userIdModel?.profile_pic ?? '').formatedProfileUrl,
              ),
              const SizedBox(width: 10),
              // ======================================== Comment with user Name + Action Section
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
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
                                  username: userIdModel?.username ?? '',
                                  isFromReels: 'false');
                            },
                            child: Text('${userIdModel?.first_name} ${userIdModel?.last_name}'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 4),
                          //================================= Text Comment=========================//
                          (reelsCommentModel.comment_name?.isNotEmpty ?? false)
                              ? SmartText(
                                  reelsCommentModel.comment_name!,
                                  expandText: 'See more',
                                  maxLines: 2,
                                  collapseText: 'See less',
                                  // style: TextStyle(
                                  //     color: reelsCommentModel.link != null
                                  //         ? Colors.blue
                                  //         : Colors.black,
                                  //     fontWeight: FontWeight.w400),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    //================================ Link Image============================//
                    (reelsCommentModel.link_image?.isNotEmpty ?? false)
                        ? InkWell(
                            onTap: () async {
                              await launchUrl(
                                  Uri.parse(reelsCommentModel.link ?? ''),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: PrimaryNetworkImage(
                                  imageUrl: reelsCommentModel.link_image!),
                            ),
                          )
                        : const SizedBox(),
                    //================================= Image Comment=========================//
                    NetworkMediaPreview(
                      mediaPath: reelsCommentModel.image_or_video,
                      serverBase: ApiConstant.SERVER_IP_PORT,
                      // optional: thumbnailUrl: '${ApiConstant.SERVER_IP_PORT}/thumbs/${reelsCommentModel.image_or_video}.jpg',
                      width: 100,
                      height: 100,
                    ),
                    // ========================================= Main comments Action Section =========================================
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Get.width / 4,
                            child: Text(
                              maxLines: 1,
                              getDynamicFormatedCommentTime(
                                  '${reelsCommentModel.createdAt}'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // ======================================== Do Reaction ==================================
                          CommentReactionButton(
                            onReactionChanged: (Reaction<String>? reaction) {
                              onSelectReelsCommentReaction(
                                  reaction?.value ?? '');
                            },
                            placeholderIconSize: 24,
                            placeholder: getPlaceholder(reelsCommentModel),
                          ),
                          const SizedBox(width: 10),
                          // ======================================== Do Reaction ==================================
                          InkWell(
                            onTap: () {
                              videoController.reelsCommentID.value =
                                  '${reelsCommentModel.id}';
                              videoController.reelsPostID.value =
                                  '${reelsCommentModel.post_id}';

                              FocusScope.of(context).requestFocus(inputNodes);

                              videoController.isReply.value = true;
                              videoController.reelsCommentModel.value =
                                  reelsCommentModel;
                            },
                            child: Text('Reply'.tr),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.REELS_COMMENT_REACTIONS,
                                  arguments: reelsCommentModel);
                            },
                            child: ReelsCommentReactionIcons(reelsCommentModel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //======================================== More Action Icon
              LoginCredential().getUserData().id ==
                      reelsCommentModel.user_id?.id
                  ? PopupMenuButton(
                      color: Theme.of(context).cardTheme.color,
                      offset: const Offset(-50, 00),
                      iconColor: Colors.grey,
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context) {
                        List<PopupMenuEntry<int>> menuItems = [];
                        //       //====================================================== Edit Comment =======================================//

                        if (reelsCommentModel.image_or_video == null ||
                            reelsCommentModel.comment_name != '') {
                          menuItems.add(
                            PopupMenuItem(
                              onTap: () {
                                onReelsCommentEdit(reelsCommentModel);
                              },
                              value: 1,
                              child: Text('Edit'.tr,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          );
                        }

                        //       //====================================================== Delete Comment =======================================//

                        menuItems.add(
                          PopupMenuItem(
                            onTap: () {
                              onReelsCommentDelete(reelsCommentModel);
                            },
                            value: 2,
                            child: Text('Delete'.tr,
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

              // Text(reelsCommentModel.comment_name ?? ''),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 65),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: reelsCommentModel.replies?.length ?? 0,
                itemBuilder: (context, index) {
                  ReelsCommentReplyModel? reelsCommentReply =
                      reelsCommentModel.replies?[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //============================================== Comment Replay User Image
                        RoundCornerNetworkImage(
                          imageUrl: (reelsCommentModel.replies?[index]
                                      .replies_user_id?.profile_pic ??
                                  '')
                              .formatedProfileUrl,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        /////////////////////////////
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width / 1.8,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: Get.width / 1.9,
                                    child: InkWell(
                                      onTap: () {
                                        ProfileNavigator.navigateToProfile(
                                            username: reelsCommentModel
                                                    .replies?[index]
                                                    .replies_user_id
                                                    ?.username ??
                                                '',
                                            isFromReels: 'false');
                                      },
                                      child: Row(
                                        children: [
                                          //============================================== Comment Replay User Name
                                          SizedBox(
                                            width: Get.width / 2.5,
                                            child: Text('${reelsCommentModel.replies?[index].replies_user_id?.first_name} ${reelsCommentModel.replies![index].replies_user_id?.last_name}'.tr,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  (reelsCommentModel
                                              .replies?[index]
                                              .replies_comment_name
                                              ?.isNotEmpty ??
                                          false)
                                      ? LinkText(
                                          text: '${reelsCommentModel.replies![index].replies_comment_name}'.tr)
                                      : const SizedBox(height: 5),

                                  //================================ Link Image============================//
                                  (reelsCommentModel.replies![index].link_image
                                              ?.isNotEmpty ??
                                          false)
                                      ? InkWell(
                                          onTap: () async {
                                            await launchUrl(
                                                Uri.parse(reelsCommentModel
                                                        .replies![index].link ??
                                                    ''),
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: PrimaryNetworkImage(
                                                imageUrl: reelsCommentModel
                                                    .replies![index]
                                                    .link_image!),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            //================================ Image or Video============================//
                            Center(
                              child: NetworkMediaPreview(
                                mediaPath: reelsCommentModel.image_or_video,
                                serverBase: ApiConstant.SERVER_IP_PORT,
                                // optional: thumbnailUrl: '${ApiConstant.SERVER_IP_PORT}/thumbs/${reelsCommentModel.image_or_video}.jpg',
                                width: 100,
                                height: 100,
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width / 6,
                                  child: Text(
                                    maxLines: 1,
                                    getDynamicFormatedCommentTime(
                                        '${reelsCommentModel.replies![index].createdAt}'),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: CommentReactionButton(
                                    placeholderIconSize: 24,
                                    onReactionChanged:
                                        (Reaction<String>? reaction) {
                                      onSelectReelsCommentReplyReaction(
                                          reaction?.value ?? '',
                                          '${reelsCommentModel.replies?[index].id}');
                                    },
                                    placeholder: Reaction<String>(
                                      value: 'like',
                                      icon: Row(
                                        children: [
                                          Text('Like'.tr,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    videoController.reelsCommentID.value =
                                        '${reelsCommentModel.id}';
                                    videoController.reelsPostID.value =
                                        '${reelsCommentModel.post_id}';

                                    FocusScope.of(context)
                                        .requestFocus(inputNodes);
                                    videoController.isReply.value = false;
                                    videoController.isReplyOfReply.value = true;
                                    videoController
                                            .reelsCommentReplyModel.value =
                                        reelsCommentModel.replies?[index] ??
                                            ReelsCommentReplyModel();
                                  },
                                  child: Text('Reply'.tr),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                        Routes.REELS_COMMENT_REPLY_REACTIONS,
                                        arguments:
                                            reelsCommentModel.replies?[index]);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    width: Get.width / 8,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  reelsCommentModel
                                                      .replies![index]
                                                      .replies_comment_reactions!
                                                      .length;
                                              i++)
                                            Container(
                                              child: ReactionIcons(
                                                  '${reelsCommentModel.replies?[index].replies_comment_reactions?[i].reaction_type}'),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        LoginCredential().getUserData().id ==
                                reelsCommentModel
                                    .replies?[index].replies_user_id?.id
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

                                  if (reelsCommentReply?.image_or_video ==
                                          null ||
                                      reelsCommentReply?.replies_comment_name !=
                                          '') {
                                    items.add(
                                      PopupMenuItem(
                                        onTap: () {
                                          onReelsCommentReplayEdit!(
                                            reelsCommentReply ??
                                                ReelsCommentReplyModel(),
                                          );
                                        },
                                        value: 1,
                                        child: Text('Edit'.tr,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }

                                  //       //====================================================== Delete Reply Comment =======================================//

                                  items.add(
                                    PopupMenuItem(
                                      onTap: () {
                                        onReelsCommentReplayDelete(
                                            '${reelsCommentModel.replies?[index].id}',
                                            '${reelsCommentModel.replies?[index].post_id}',
                                            '${reelsCommentModel.key}');
                                      },
                                      value: 2,
                                      child: Text('Delete'.tr,
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
        ],
      ),
    );
  }

  Widget ReactionIcon(String assetName) {
    return Image(height: 24, image: AssetImage(assetName));
  }

  Widget ReactionIcons(String reaction_type) {
    switch (reaction_type) {
      case 'like':
        return const Image(
            height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON));
      case 'love':
        return const Image(
            height: 24, width: 24, image: AssetImage(AppAssets.LOVE_ICON));
      case 'haha':
        return const Image(
            height: 24, width: 24, image: AssetImage(AppAssets.HAHA_ICON));
      case 'wow':
        return const Image(
            height: 24, width: 24, image: AssetImage(AppAssets.WOW_ICON));
      case 'sad':
        return const Image(
            height: 24, width: 24, image: AssetImage(AppAssets.SAD_ICON));
      case 'angry':
        return const Image(
            height: 24, width: 24, image: AssetImage(AppAssets.ANGRY_ICON));
      case 'dislike':
        return const Image(
            height: 24, width: 24, image: AssetImage(AppAssets.UNLIKE_ICON));
      default:
        return const Image(
            height: 24, width: 24, image: AssetImage(AppAssets.LIKE_ICON));
    }
  }
}
