import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/button.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../components/custom_alert_dialog.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../../../../../../../utils/bottom_sheet.dart';
import '../../../../../../../utils/copy_to_clipboard_utils.dart';
import '../controllers/group_feed_controller.dart';
import '../../../../../../../components/comment/comment_component.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../shared/modules/multiple_image/views/multiple_image_view.dart';

class GroupFeedPostComponent extends StatelessWidget {
  final GroupFeedController controller;

  const GroupFeedPostComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';
    return SliverList(
      delegate: SliverChildListDelegate([
        // GroupProfileWritePostComponent(
        //   controller: controller,
        // ),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: controller.postList.value.length,
            itemBuilder: (context, postIndex) {
              PostModel postModel = controller.postList.value[postIndex];

              return PostCard(
                onTapBlockUser: () {
                  // controller.blockFriends(postModel.user_id?.id??'');
                  Get.dialog(
                    CustomAlertDialog(
                      icon: Icons.app_blocking,
                      title: 'Block User'.tr,
                      description:
                          'Are you sure you want to block this user? The user won\'t be able to interact with you or see your profile',
                      cancelButtonText: 'Cancel',
                      confirmButtonText: 'Block',
                      onCancel: () {
                        Get.back();
                      },
                      onConfirm: () {
                        // Get.back();
                        Get.back();
                        // Call the method to block the user
                        controller.blockFriends(postModel.user_id?.id ?? '');
                      },
                    ),
                  );
                },
                onSixSeconds: () {},
                adVideoLink:
                    controller.videoAdList.value.elementAtOrNull(postIndex) !=
                            null
                        ? (controller
                                    .videoAdList
                                    .value[controller.currentAdIndex.value]
                                    .campaignCoverPic?[0] ??
                                '')
                            .formatedAdsUrl
                        : null,
                campaignWebUrl:
                    controller.videoAdList.value.elementAtOrNull(postIndex) !=
                            null
                        ? (controller
                                .videoAdList
                                .value[controller.currentAdIndex.value]
                                .websiteUrl ??
                            '')
                        : null,
                campaignName:
                    controller.videoAdList.value.elementAtOrNull(postIndex) !=
                            null
                        ? (controller
                                .videoAdList
                                .value[controller.currentAdIndex.value]
                                .campaignName
                                ?.capitalizeFirst ??
                            '')
                        : null,
                campaignDescription:
                    controller.videoAdList.value.elementAtOrNull(postIndex) !=
                            null
                        ? (controller
                                .videoAdList
                                .value[controller.currentAdIndex.value]
                                .description ??
                            '')
                        : null,
                campaignCallToAction: () async {
                  controller.videoAdList.value.elementAtOrNull(postIndex) !=
                          null
                      ? await launchUrl(
                          Uri.parse(controller
                                  .videoAdList
                                  .value[controller.currentAdIndex.value]
                                  .websiteUrl ??
                              ''),
                          mode: LaunchMode.externalApplication)
                      : null;
                },
                model: postModel,
                onSelectReaction: (reaction) {
                  controller.reactOnPost(
                    postModel: postModel,
                    reaction: reaction,
                    index: postIndex,
                    key: postModel.key ?? '',
                  );
                  debugPrint(reaction);
                },
                onPressedComment: () {
                  Get.bottomSheet(
                    Obx(
                      () => CommentComponent(
                        onCommentEdit: (commentModel) async {
                          await Get.toNamed(Routes.EDIT_POST_COMMENT,
                              arguments: {
                                'post_comment': commentModel.comment_name,
                                'post_id': commentModel.post_id,
                                'comment_id': commentModel.id,
                                'comment_type': commentModel.comment_type,
                                'image_video': commentModel.image_or_video
                              });
                          controller.updatePostList(
                              commentModel.post_id ?? '', postIndex);
                        },
                        onCommentReplayEdit: (commentReplayModel) async {
                          await Get.toNamed(Routes.EDIT_REPLY_POST_COMMENT,
                              arguments: {
                                'reply_comment':
                                    commentReplayModel.replies_comment_name,
                                'replay_post_id': commentReplayModel.post_id,
                                'comment_replay_id': commentReplayModel.id,
                                'comment_type': commentReplayModel.comment_type,
                                'image_video': commentReplayModel.image_or_video,
                                'key': commentReplayModel.key,
                              });
                          controller.updatePostList(
                              commentReplayModel.post_id ?? '', postIndex);
                        },
                        onCommentDelete: (commentModel) {
                          controller.commentDelete(commentModel.id ?? '',
                              commentModel.post_id ?? '', postIndex);
                        },
                        onCommentReplayDelete: (replyId, postId) {
                          controller.replyDelete(replyId, postId, postIndex);
                        },
                        commentController: controller.commentController,
                        postModel: controller.postList.value[postIndex],
                        userModel: controller.userModel,
                        onTapSendComment: () {
                          controller.commentOnPost(postIndex, postModel);
                        },
                        onTapReplayComment: ({
                          required commentReplay,
                          required comment_id,
                          required file,
                        }) {
                          controller.commentReply(
                            comment_id: comment_id,
                            replies_comment_name: commentReplay,
                            post_id: postModel.id ?? '',
                            postIndex: postIndex,
                            file: file,
                          );
                        },
                        onSelectCommentReaction: (
                          reaction,
                          commentId,
                        ) {
                          controller.commentReaction(
                            postIndex: postIndex,
                            reaction_type: reaction,
                            post_id: postModel.id ?? '',
                            comment_id: commentId,
                          );
                        },
                        onSelectCommentReplayReaction: (
                          reaction,
                          commentId,
                          commentRepliesId,
                        ) {
                          controller.commentReplyReaction(postIndex, reaction,
                              postModel.id ?? '', commentId, commentRepliesId);
                        },
                        onTapViewReactions: () {
                          Get.toNamed(Routes.REACTIONS,
                              arguments: postModel.id);
                        },
                      ),
                    ),
                    // backgroundColor: Colors.white,
                    isScrollControlled: true,
                  );
                },
                onTapBodyViewMoreMedia: () {
                  Get.to(MultipleImageView(postModel: postModel));
                },
                onTapViewReactions: () {
                  Get.toNamed(Routes.REACTIONS, arguments: postModel.id);
                },
                onTapViewPostHistory: () {
                  Get.back();
                  Get.toNamed(Routes.EDIT_HISTORY, arguments: postModel.id);
                },
                onTapEditPost: () {
                  Get.back();
                  controller.onTapEditPost(postModel);
                },
                onTapHidePost: () {
                  controller.hidePost(1, postModel.id.toString(), postIndex);
                },
                onTapBookMardPost: () {
                  controller.bookmarkPost(postModel.id.toString(),
                      postModel.post_privacy.toString(), postIndex);
                },
                onTapRemoveBookMardPost: () {
                  controller.removeBookmarkPost(
                      postModel.bookmark?.id ?? '', postIndex);
                },
                onTapCopyPost: () async {
                  CopyToClipboardUtils.copyToClipboard(
                      '$baseUrl${postModel.id}', 'Post');
                  Get.back();
                },
                onTapViewOtherProfile: postModel.event_type == 'relationship'
                    ? () {
                        ProfileNavigator.navigateToProfile(
                            username:
                                postModel.lifeEventId?.toUserId?.username ?? '',
                            isFromReels: 'false');
                      }
                    : null,
                onTapShareViewOtherProfile: postModel.post_type == 'Shared'
                    ? () {
                        ProfileNavigator.navigateToProfile(
                            username: postModel.share_post_id?.lifeEventId
                                    ?.toUserId?.username ??
                                '',
                            isFromReels: 'false');
                      }
                    : null,

                /* ============Share Post BottoSheet ==========*/
                /* ============Share Post BottoSheet ==========*/
                onPressedShare: () {
                  String sharePostId = '';
                  if (postModel.share_post_id?.id == null) {
                    sharePostId = postModel.id ?? '';
                  } else {
                    sharePostId = postModel.share_post_id?.id ?? '';
                  }
                  showDraggableScrollableBottomSheet(context,
                      child: ShareSheetWidget(
                          report_id_key: 'post_id',
                          campaignId: postModel.campaign_id?.id ?? '',
                          userId: postModel.user_id?.id ?? '',
                          postId: sharePostId));
                },
                // onPressedShare: controller
                //             .postList.value[postIndex].post_privacy ==
                //         'public'
                //     ? () {
                //         Get.bottomSheet(
                //           SingleChildScrollView(
                //             child: Column(
                //               children: [
                //                 const SizedBox(
                //                   height: 10,
                //                 ),
                //                 Container(
                //                   padding: const EdgeInsets.symmetric(
                //                       vertical: 10, horizontal: 10),
                //                   child: Row(
                //                     children: [
                //                       NetworkCircleAvatar(
                //                           imageUrl: getFormatedProfileUrl(
                //                               LoginCredential()
                //                                       .getUserData()
                //                                       .profile_pic ??
                //                                   '')),
                //                       const SizedBox(
                //                         width: 5,
                //                       ),
                //                       Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                             '${LoginCredential().getUserData().first_name} ${LoginCredential().getUserData().last_name}',
                //                             style: const TextStyle(
                //                                 fontSize: 16,
                //                                 fontWeight: FontWeight.bold),
                //                           ),
                //                           Container(
                //                             height: 25,
                //                             width: Get.width / 4,
                //                             decoration: BoxDecoration(
                //                                 border: Border.all(
                //                                     color: PRIMARY_COLOR,
                //                                     width: 1),
                //                                 borderRadius:
                //                                     BorderRadius.circular(5)),
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.spaceEvenly,
                //                               children: [
                //                                 Obx(
                //                                   () => controller.dropdownValue
                //                                               .value ==
                //                                           'Public'
                //                                       ? const Icon(
                //                                           Icons.public,
                //                                           color: PRIMARY_COLOR,
                //                                           size: 15,
                //                                         )
                //                                       : controller.dropdownValue
                //                                                   .value ==
                //                                               'Friends'
                //                                           ? const Icon(
                //                                               Icons.group,
                //                                               color:
                //                                                   PRIMARY_COLOR,
                //                                               size: 15,
                //                                             )
                //                                           : const Icon(
                //                                               Icons.lock,
                //                                               color:
                //                                                   PRIMARY_COLOR,
                //                                               size: 15,
                //                                             ),
                //                                 ),
                //                                 Obx(() =>
                //                                     DropdownButton<String>(
                //                                       value: controller
                //                                           .dropdownValue.value,
                //                                       icon: const Icon(
                //                                         Icons.arrow_drop_down,
                //                                         color: PRIMARY_COLOR,
                //                                       ),
                //                                       elevation: 16,
                //                                       style: const TextStyle(
                //                                           color: PRIMARY_COLOR),
                //                                       underline: Container(
                //                                         height: 2,
                //                                         color:
                //                                             Colors.transparent,
                //                                       ),
                //                                       onChanged:
                //                                           (String? value) {
                //                                         controller.dropdownValue
                //                                             .value = value!;
                //                                         controller.postPrivacy
                //                                             .value = value;
                //                                       },
                //                                       items: privacyList.map<
                //                                               DropdownMenuItem<
                //                                                   String>>(
                //                                           (String value) {
                //                                         return DropdownMenuItem<
                //                                             String>(
                //                                           value: value,
                //                                           child: Text(
                //                                             value,
                //                                             style: const TextStyle(
                //                                                 fontSize: 12,
                //                                                 fontWeight:
                //                                                     FontWeight
                //                                                         .w400),
                //                                           ),
                //                                         );
                //                                       }).toList(),
                //                                     )),
                //                               ],
                //                             ),
                //                           )
                //                         ],
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   height: 200,
                //                   child: TextField(
                //                     controller:
                //                         controller.descriptionController,
                //                     maxLines: 10,
                //                     decoration: InputDecoration(
                //                       fillColor: Colors.white,
                //                       filled: true,
                //                       border: InputBorder.none,
                //                       hintText:
                //                           'What’s on your mind ${controller.userModel.first_name}?',
                //                     ),
                //                     onChanged: (value) {
                //                       debugPrint(
                //                           'Update model status code on chage.............${controller.descriptionController.text}');
                //                     },
                //                   ),
                //                 ),
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.end,
                //                   children: [
                //                     Obx(
                //                       () => Padding(
                //                         padding:
                //                             const EdgeInsets.only(right: 15),
                //                         child: ElevatedButton(
                //                           key: shareButtonKey,
                //                           onPressed: () async {
                //                             Get.back();
                //                             // PostModel model =
                //                             //     controller
                //                             //             .postList
                //                             //             .value[
                //                             //         postIndex];
                //                             controller.postList.value[postIndex]
                //                                         .post_type ==
                //                                     'Shared'
                //                                 ? await controller
                //                                     .shareUserPost(controller
                //                                             .postList
                //                                             .value[postIndex]
                //                                             .share_post_id
                //                                             ?.id ??
                //                                         '')
                //                                 : await controller
                //                                     .shareUserPost(controller
                //                                         .postList
                //                                         .value[postIndex]
                //                                         .id
                //                                         .toString());
                //                           },
                //                           // Disable the button if the condition is not met
                //                           style: ElevatedButton.styleFrom(
                //                             padding: const EdgeInsets.all(15),
                //                             shape: RoundedRectangleBorder(
                //                               borderRadius:
                //                                   BorderRadius.circular(5.0),
                //                             ),
                //                             backgroundColor: controller
                //                                         .dropdownValue.value ==
                //                                     'Public'
                //                                 ? PRIMARY_COLOR
                //                                 : Colors
                //                                     .grey, // Change color if disabled
                //                             textStyle: const TextStyle(
                //                               fontSize: 30,
                //                               fontWeight: FontWeight.bold,
                //                             ),
                //                           ),
                //                           child: const Text(
                //                             'Share Now',
                //                             style: TextStyle(
                //                               fontSize: 15,
                //                               color: Colors.white,
                //                               fontWeight: FontWeight.w600,
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //                 const Row(
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   children: [
                //                     Padding(
                //                       padding: EdgeInsets.only(left: 15.0),
                //                       child: Text(
                //                         'Share to',
                //                         style: TextStyle(
                //                             fontWeight: FontWeight.w600,
                //                             fontSize: 20),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //                 Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceEvenly,
                //                   children: [
                //                     /*=========================== ============= Facebook  =========================== =========================================*/
                //                     InkWell(
                //                       onTap: () {
                //                         controller.descriptionController.text
                //                                 .isNotEmpty
                //                             ? controller.launchURL(
                //                                 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent('${controller.descriptionController.text}\n$baseUrl${controller.postList.value[postIndex].id ?? ''}')}')
                //                             : controller.launchURL(
                //                                 'https://www.facebook.com/sharer/sharer.php?u=$baseUrl${Uri.encodeComponent(controller.postList.value[postIndex].id ?? '')}');
                //                       },
                //                       child: const Image(
                //                         height: 30,
                //                         image: AssetImage(
                //                             'assets/image/facebook-logo.png'),
                //                       ),
                //                     ),
                //                     /*=========================== ============= Messanger  =========================== =========================================*/
                //                     InkWell(
                //                       onTap: () {
                //                         controller.descriptionController.text
                //                                 .isNotEmpty
                //                             ? Share.share(
                //                                 'fb-messenger://share?link=${Uri.encodeComponent('${controller.descriptionController.text}\n$baseUrl${controller.postList.value[postIndex].id ?? ''}')}')
                //                             : Share.share(
                //                                 'fb-messenger://share?link=$baseUrl${Uri.encodeComponent(controller.postList.value[postIndex].id ?? '')}');
                //                       },
                //                       child: const Image(
                //                         height: 30,
                //                         image: AssetImage(
                //                             'assets/image/messenger-logo.png'),
                //                       ),
                //                     ),
                //                     /*=========================== ============= Twitter/X  =========================== =========================================*/
                //                     InkWell(
                //                       onTap: () {
                //                         controller.descriptionController.text
                //                                 .isNotEmpty
                //                             ? controller.launchURL(
                //                                 'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('${controller.descriptionController.text}\n$baseUrl${controller.postList.value[postIndex].id ?? ''}')}')
                //                             : controller.launchURL(
                //                                 'https://twitter.com/intent/tweet?text=$baseUrl${Uri.encodeComponent(controller.postList.value[postIndex].id ?? '')}');
                //                       },
                //                       child: const Image(
                //                         height: 30,
                //                         image: AssetImage(
                //                             'assets/image/x_logo.jpg'),
                //                       ),
                //                     ),
                //                     /*=========================== ============= WhatsApp  =========================== =========================================*/
                //                     InkWell(
                //                       onTap: () {
                //                         controller.descriptionController.text
                //                                 .isNotEmpty
                //                             ? controller.launchURL(
                //                                 'https://wa.me/?text=${Uri.encodeComponent('${controller.descriptionController.text}\n$baseUrl${controller.postList.value[postIndex].id ?? ''}')}')
                //                             : controller.launchURL(
                //                                 'https://wa.me/?text=$baseUrl${Uri.encodeComponent(controller.postList.value[postIndex].id ?? '')}');
                //                       },
                //                       child: const Image(
                //                         height: 30,
                //                         image: AssetImage(
                //                             'assets/image/whatsapp-logo.png'),
                //                       ),
                //                     ),
                //                     /*=========================== ============= Instagram =========================== =========================================*/
                //                     // InkWell(
                //                     //   onTap: () {
                //                     //     controller.descriptionController.text
                //                     //             .isNotEmpty
                //                     //         ? controller.launchURL(
                //                     //             'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('${controller.descriptionController.text}\n$baseUrl${controller.postList.value[postIndex].id ?? ''}')}')
                //                     //         : controller.launchURL(
                //                     //             'https://twitter.com/intent/tweet?text=$baseUrl${Uri.encodeComponent(controller.postList.value[postIndex].id ?? '')}');
                //                     //   },
                //                     //   child: const Image(
                //                     //     height: 50,
                //                     //     image: AssetImage(
                //                     //         'assets/image/instagram_logo.png'),
                //                     //   ),
                //                     // ),
                //                   ],
                //                 ),
                //                 const SizedBox(
                //                   height: 50,
                //                 ),
                //               ],
                //             ),
                //           ),
                //           // backgroundColor: Colors.white,
                //         ).whenComplete(() {
                //           controller.descriptionController.clear();
                //         });
                //       }
                //     : () {},
              );
            },
          ),
        ),
        Obx(() => controller.isLoadingNewsFeed.value
            ? const PostShimerLoader()
            : const SizedBox())
      ]),
    );
  }
}

class PostShimerLoader extends StatelessWidget {
  const PostShimerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  ShimmerLoader(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const CircleAvatar(
                        radius: 19,
                        backgroundColor: Color.fromARGB(255, 45, 185, 185),
                        child: CircleAvatar(
                          radius: 17,
                          backgroundImage:
                              AssetImage(AppAssets.DEFAULT_PROFILE_IMAGE),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoader(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border:
                                    Border.all(color: Colors.white, width: 0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              width: Get.width - 100,
                            ),
                            const SizedBox(height: 7),
                            Container(
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border:
                                    Border.all(color: Colors.white, width: 0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              width: Get.width / 2,
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ShimmerLoader(
              child: Container(
                width: double.maxFinite,
                height: 256,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.LIKE_ICON,
                    text: 'Like'.tr,
                    onPressed: () {},
                  ),
                ),
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.COMMENT_ACTION_ICON,
                    text: 'Comment'.tr,
                    onPressed: () {},
                  ),
                ),
                ShimmerLoader(
                  child: PostActionButton(
                    assetName: AppAssets.SHARE_ACTION_ICON,
                    text: 'Share'.tr,
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
