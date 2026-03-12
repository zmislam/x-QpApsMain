import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/live_stream/reels_live_stream_comment.dart';
import '../../../../components/video_player/live/details_live_video_player.dart';
import '../../../../data/login_creadential.dart';
import '../../../../models/live/live_stream_view_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/image_utils.dart';
import '../../reels/model/reels_model.dart';
import '../controllers/live_reels_controller.dart';
import '../widgets/live_reel_bottom_widget.dart';
import '../widgets/live_reel_top_widget.dart';

class LiveReelsView extends GetView<LiveReelsController> {
  const LiveReelsView({super.key});

  int getLiveViewCount({
    required LiveStreamViewModel liveStreamModel,
    required ReelsModel reelsModel,
  }) {
    if (liveStreamModel.reelsId == reelsModel.id) {
      return (liveStreamModel.viewers ?? []).length;
    } else {
      return reelsModel.view_count ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.reelsModelList.value.clear();
    // controller.fetchAllData();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Obx(
        () {
          if (controller.reelsModelList.value.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 32),
                    child: Text('No Live Available'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            );
          } else {
            final mergedList = controller.reelsModelList.value;

            //  _getMergedList(controller.reelsModelList.value,
            //     controller.reelsCampaignResultList.value);
            return PageView.builder(
              controller: controller.liveReelsTabPageController,
              scrollDirection: Axis.vertical,
              itemCount: mergedList.length,
              onPageChanged: (value) {
                controller.liveCommentList.value.clear();
                controller.getAllCommentsByReel(reelId: controller.reelsID);

                if (value == controller.reelsModelList.value.length - 1) {
                  controller.fetchAllData();
                }
              },
              itemBuilder: (context, index) {
                final item = mergedList[index];
                controller.reelsID = item.id ?? '';
                controller.reelIndex = index;

                controller.socketService.emitStartLiveReelStreamView(
                    controller.reelsID,
                    LoginCredential().getUserData().id ?? '');

                for (ReelsReactionModel reels_model in item.reactions ?? []) {
                  if (reels_model.user_id?.id ==
                      controller.loginCredential.getUserData().id) {}
                }
                return Obx(() => Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // ============================== video preview section =================
                        SizedBox(
                          height: Get.height,
                          width: Get.width,
                          child: DetailsLiveVideoPlayer(
                            hasLive: true,
                            videoSrc:
                                getFormatedLiveStreamViewUrl(item.url ?? ''),
                          ),
                        ),
                        // getFormatedReelUrl(item.video ?? '')),

                        // ====================== top section ==============================
                        Positioned(
                          top: 40,
                          left: 12,
                          right: 12,
                          child: Obx(() => LiveReelTopWidget(
                                onTapProfileView: () {
                                  ProfileNavigator.navigateToProfile(
                                      username: item.reel_user?.username ?? '',
                                      isFromReels: 'false');
                                },
                                hasFollow: item.reel_user?.isFollowing,
                                reactionCount: item.reaction_count ?? 0,
                                profilePic: item.reel_user?.profile_pic,
                                firstName: item.reel_user?.first_name,
                                lastName: item.reel_user?.last_name,
                                joinUserCount: getLiveViewCount(
                                    liveStreamModel:
                                        controller.liveStreamViewer.value ??
                                            LiveStreamViewModel(),
                                    reelsModel: item),
                                onLiveEnd: () {
                                  Get.back();
                                },
                                onTapFollow: () {
                                  controller.followUserInLiveStream(
                                      userId: item.reel_user?.id ?? '');
                                },
                              )),
                        ),

                        // =========================== animated reaction ==========================
                        ...controller.reactions.value,
                        // =========================== Live stream comment section =================

                        Positioned(
                          bottom:
                              160, // Adjust this value to avoid overlap with the bottom widget
                          left: 0,
                          right: 0,
                          child: Obx(() {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (controller.scrollController.hasClients) {
                                // Step 2: Scroll to the end when new items are added
                                controller.scrollController.animateTo(
                                  controller.scrollController.position
                                      .minScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                            return SizedBox(
                              height: 200, // Adjust height as needed

                              child: controller.reelsModelList.value[index]
                                      .comments!.isEmpty
                                  ? ListView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                              top: 320,
                                              bottom: 12),
                                          child: Text('Comment will start from here...'.tr,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ReelsLiveStreamComment(
                                      scrollController:
                                          controller.scrollController,
                                      commentList: controller.reelsModelList
                                          .value[index].comments!.reversed
                                          .toList()),
                            );
                          }),
                          // ========================= Live bottom action section =================
                        ),
                        Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: LiveReelBottomWidget(
                              onMessaegeTap: () {
                                controller.sendLiveStreamComment(
                                    reelsId: item.id);
                              },
                              onShareTap: () {},
                              onSelectReaction: (reaction) {
                                controller.reactOnPost(
                                    reaction: reaction, reelsId: item.id ?? '');
                              },
                              textEditingController:
                                  controller.commentController,
                              focusNode: controller.commentFocusNode,
                              shareCount: '0',
                              onFieldSubmitted: (value) {
                                controller.sendLiveStreamComment(
                                    reelsId: item.id);
                              },
                              onSendComment: () {
                                controller.sendLiveStreamComment(
                                    reelsId: item.id);
                              },
                            ))
                      ],
                    ));

                //  else if (item is ReelsCampaignResults) {
                //   bool myLike = item.reactions?.any((reaction) =>
                //           reaction.userId ==
                //           controller.loginCredential.getUserData().id) ??
                //       false;

                //   return ReelsCampaignComponent(
                //     onPressedReportReelsCampaign: () async {
                //       await controller.getReports();
                //       CustomReportBottomSheet.showReportOptions(
                //         pageReportList: controller.pageReportList.value,
                //         selectedReportType: controller.selectedReportType,
                //         selectedReportId: controller.selectedReportId,
                //         reportDescription: controller.reportDescription,
                //         onCancel: () {
                //           Get.back();
                //         },
                //         reportAction: (String report_type_id,
                //             String report_type,
                //             String page_id,
                //             String description) {
                //           controller.reportAPost(
                //               report_type: report_type,
                //               description: description,
                //               post_id: item.id ?? '',
                //               report_type_id: report_type_id);
                //         },
                //       );
                //     },
                //     onPressedMessanger: () {},

                //     onPressedViewProfile: () {
                //       // Get.toNamed(
                //       //   Routes.OTHERS_PROFILE,
                //       //   arguments: item.reelUser?.username,
                //       // );
                //     },
                //     onPressedShareReels: () {
                //       Get.bottomSheet(
                //         SingleChildScrollView(
                //           child: Column(
                //             children: [
                //               const SizedBox(
                //                 height: 10,
                //               ),
                //               Container(
                //                 padding: const EdgeInsets.symmetric(
                //                     vertical: 10, horizontal: 10),
                //                 child: Row(
                //                   children: [
                //                     NetworkCircleAvatar(
                //                         imageUrl: getFormatedProfileUrl(
                //                             LoginCredential()
                //                                     .getUserData()
                //                                     .profile_pic ??
                //                                 '')),
                //                     const SizedBox(
                //                       width: 5,
                //                     ),
                //                     Column(
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.start,
                //                       children: [
                //                         Text(
                //                           '${LoginCredential().getUserData().first_name} ${LoginCredential().getUserData().last_name}',
                //                           style: TextStyle(
                //                               fontSize: 16,
                //                               fontWeight: FontWeight.bold),
                //                         ),
                //                         Container(
                //                           height: 25,
                //                           width: Get.width / 4,
                //                           decoration: BoxDecoration(
                //                               border: Border.all(
                //                                   color: PRIMARY_COLOR,
                //                                   width: 1),
                //                               borderRadius:
                //                                   BorderRadius.circular(5)),
                //                           child: Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceEvenly,
                //                             children: [
                //                               Obx(
                //                                 () => controller.dropdownValue
                //                                             .value ==
                //                                         'Public'
                //                                     ? const Icon(
                //                                         Icons.public,
                //                                         color: PRIMARY_COLOR,
                //                                         size: 15,
                //                                       )
                //                                     : controller.dropdownValue
                //                                                 .value ==
                //                                             'Friends'
                //                                         ? const Icon(
                //                                             Icons.group,
                //                                             color:
                //                                                 PRIMARY_COLOR,
                //                                             size: 15,
                //                                           )
                //                                         : const Icon(
                //                                             Icons.lock,
                //                                             color:
                //                                                 PRIMARY_COLOR,
                //                                             size: 15,
                //                                           ),
                //                               ),
                //                               Obx(() => DropdownButton<String>(
                //                                     value: controller
                //                                         .dropdownValue.value,
                //                                     icon: const Icon(
                //                                       Icons.arrow_drop_down,
                //                                       color: PRIMARY_COLOR,
                //                                     ),
                //                                     elevation: 16,
                //                                     style: TextStyle(
                //                                         color: PRIMARY_COLOR),
                //                                     underline: Container(
                //                                       height: 2,
                //                                       color: Colors.transparent,
                //                                     ),
                //                                     onChanged: (String? value) {
                //                                       controller.dropdownValue
                //                                           .value = value!;
                //                                       controller.reelsPrivacy
                //                                           .value = value;
                //                                     },
                //                                     items: reelsPrivacyList.map<
                //                                             DropdownMenuItem<
                //                                                 String>>(
                //                                         (String value) {
                //                                       return DropdownMenuItem<
                //                                           String>(
                //                                         value: value,
                //                                         child: Text(
                //                                           value,
                //                                           style: TextStyle(
                //                                               fontSize: 12,
                //                                               fontWeight:
                //                                                   FontWeight
                //                                                       .w400),
                //                                         ),
                //                                       );
                //                                     }).toList(),
                //                                   )),
                //                             ],
                //                           ),
                //                         )
                //                       ],
                //                     )
                //                   ],
                //                 ),
                //               ),
                //               SizedBox(
                //                 height: 200,
                //                 child: TextField(
                //                   controller:
                //                       controller.reelsDescriptionController,
                //                   maxLines: 10,
                //                   decoration: InputDecoration(
                //                     fillColor: Colors.white,
                //                     filled: true,
                //                     border: InputBorder.none,
                //                     hintText:
                //                         'What’s on your mind ${controller.userModel.first_name}?',
                //                   ),
                //                   onChanged: (value) {
                //                     debugPrint(
                //                         'Update model status code on chage.............${controller.reelsDescriptionController.text}');
                //                   },
                //                 ),
                //               ),
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.end,
                //                 children: [
                //                   // Obx(
                //                   //   () =>
                //                   Padding(
                //                     padding: const EdgeInsets.only(right: 15),
                //                     child: ElevatedButton(
                //                       key: shareButtonKey,
                //                       onPressed: () async {
                //                         Get.back();
                //                         // PostModel model =
                //                         //     controller
                //                         //             .postList
                //                         //             .value[
                //                         //         postIndex];
                //                         await controller.shareReelsOnNewsFeed(
                //                             controller.reelsModelList
                //                                     .value[index].id ??
                //                                 '');
                //                       },
                //                       style: ElevatedButton.styleFrom(
                //                         padding: const EdgeInsets.all(15),
                //                         shape: RoundedRectangleBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(5.0),
                //                         ),
                //                         backgroundColor: PRIMARY_COLOR,
                //                         textStyle: TextStyle(
                //                           fontSize: 30,
                //                           fontWeight: FontWeight.bold,
                //                         ),
                //                       ),
                //                       child: Text(
                //                         'Share Now',
                //                         style: TextStyle(
                //                           fontSize: 15,
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.w600,
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   // )
                //                 ],
                //               ),
                //               const Row(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   Padding(
                //                     padding: EdgeInsets.only(left: 15.0),
                //                     child: Text(
                //                       'Share to',
                //                       style: TextStyle(
                //                           fontWeight: FontWeight.w600,
                //                           fontSize: 20),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceEvenly,
                //                 children: [
                //                   /*=========================== ============= Facebook  =========================== =========================================*/
                //                   InkWell(
                //                     onTap: () {
                //                       controller.reelsDescriptionController.text
                //                               .isNotEmpty
                //                           ? controller.launchURL(
                //                               'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent('${controller.reelsDescriptionController.text}\n$getFormatedReelUrl${controller.reelsModelList.value[index].id ?? ''}')}')
                //                           : controller.launchURL(
                //                               'https://www.facebook.com/sharer/sharer.php?u=$getFormatedReelUrl${Uri.encodeComponent(controller.reelsModelList.value[index].id ?? '')}');
                //                     },
                //                     child: const Image(
                //                       height: 30,
                //                       image: AssetImage(
                //                           'assets/image/facebook-logo.png'),
                //                     ),
                //                   ),
                //                   /*=========================== ============= Messanger  =========================== =========================================*/
                //                   InkWell(
                //                     onTap: () {
                //                       controller.reelsDescriptionController.text
                //                               .isNotEmpty
                //                           ? Share.share(
                //                               'fb-messenger://share?link=${Uri.encodeComponent('${controller.reelsDescriptionController.text}\n$getFormatedReelUrl${controller.reelsModelList.value[index].id ?? ''}')}')
                //                           : Share.share(
                //                               'fb-messenger://share?link=$getFormatedReelUrl${Uri.encodeComponent(controller.reelsModelList.value[index].id ?? '')}');
                //                     },
                //                     child: const Image(
                //                       height: 30,
                //                       image: AssetImage(
                //                           'assets/image/messenger-logo.png'),
                //                     ),
                //                   ),
                //                   /*=========================== ============= Twitter/X  =========================== =========================================*/
                //                   InkWell(
                //                     onTap: () {
                //                       controller.reelsDescriptionController.text
                //                               .isNotEmpty
                //                           ? controller.launchURL(
                //                               'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('${controller.reelsDescriptionController.text}\n$getFormatedReelUrl${controller.reelsModelList.value[index].id ?? ''}')}')
                //                           : controller.launchURL(
                //                               'https://twitter.com/intent/tweet?text=$getFormatedReelUrl${Uri.encodeComponent(controller.reelsModelList.value[index].id ?? '')}');
                //                     },
                //                     child: const Image(
                //                       height: 30,
                //                       image:
                //                           AssetImage('assets/image/x_logo.jpg'),
                //                     ),
                //                   ),
                //                   /*=========================== ============= WhatsApp  =========================== =========================================*/
                //                   InkWell(
                //                     onTap: () {
                //                       controller.reelsDescriptionController.text
                //                               .isNotEmpty
                //                           ? controller.launchURL(
                //                               'https://wa.me/?text=${Uri.encodeComponent('${controller.reelsDescriptionController.text}\n$getFormatedReelUrl${controller.reelsModelList.value[index].id ?? ''}')}')
                //                           : controller.launchURL(
                //                               'https://wa.me/?text=$getFormatedReelUrl${Uri.encodeComponent(controller.reelsModelList.value[index].id ?? '')}');
                //                     },
                //                     child: const Image(
                //                       height: 50,
                //                       image: AssetImage(
                //                         'assets/image/whatsapp-logo.png',
                //                       ),
                //                     ),
                //                   ),
                //                   /*=========================== ============= Instagram =========================== =========================================*/
                //                   InkWell(
                //                     onTap: () {
                //                       controller.reelsDescriptionController.text
                //                               .isNotEmpty
                //                           ? controller.launchURL(
                //                               'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('${controller.reelsDescriptionController.text}\n$getFormatedReelUrl${controller.reelsModelList.value[index].id ?? ''}')}')
                //                           : controller.launchURL(
                //                               'https://twitter.com/intent/tweet?text=$getFormatedReelUrl${Uri.encodeComponent(controller.reelsModelList.value[index].id ?? '')}');
                //                     },
                //                     child: const Image(
                //                       height: 30,
                //                       image: AssetImage(
                //                           'assets/image/instagram_logo.png'),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               const SizedBox(
                //                 height: 50,
                //               ),
                //             ],
                //           ),
                //         ),
                //         // backgroundColor: Colors.white,
                //       ).whenComplete(() {
                //         controller.reelsDescriptionController.clear();
                //       });
                //     },
                //     onPressedViewReact: () {
                //       Get.toNamed(Routes.REELS_REACTIONS, arguments: item.id);
                //     },
                //     isLiked: myLike,
                //     carouselController: carouselController,
                //     // controller: controller.videoPlayController,
                //     // : reelsCampaignModel,
                //     onPressedLike: () {
                //       final campaignIndex = controller
                //           .reelsCampaignResultList.value
                //           .indexWhere((campaign) => campaign.id == item.id);
                //       if (campaignIndex != -1) {
                //         controller.reelsAdsLike(item.id ?? '',
                //             campaignIndex); // Pass the correct index
                //       }
                //     },
                //     onPressedComment: () {
                //       controller.getReelAdsCommentList(item.id ?? '');

                //       Get.bottomSheet(Obx(() => ClipRRect(
                //             borderRadius: const BorderRadius.only(
                //               topLeft: Radius.circular(
                //                   30.0), // Adjust the radius value as needed
                //               topRight: Radius.circular(
                //                   30.0), // Adjust the radius value as needed
                //             ),
                //             child: ReelsCampaignCommentComponent(
                //               reelsCommentList:
                //                   controller.reelsCommentModelList.value,
                //               reelsCampaignModel: item,
                //               onTapViewReactions: () {
                //                 Get.toNamed(Routes.REELS_REACTIONS,
                //                     arguments: item.id);
                //               },
                //               onTapSendReelsComment: () {
                //                 controller.reelsAdsComments(
                //                     item.id ?? '',
                //                     controller.reelsCommentController.text,
                //                     index);
                //                 controller.reelsCommentController.clear();
                //               },
                //               reelsCommentController:
                //                   controller.reelsCommentController,
                //               userModel:
                //                   controller.loginCredential.getUserData(),
                //               onTapReelsReplayComment: ({
                //                 required commentReplay,
                //                 required comment_id,
                //               }) {
                //                 controller.reelsAdsCommentsReply(
                //                     comment_id: comment_id,
                //                     replies_comment_name: commentReplay,
                //                     post_id: item.id ?? '',
                //                     replies_user_id: controller.loginCredential
                //                             .getUserData()
                //                             .id ??
                //                         '');
                //               },
                //               onSelectReelsCommentReplayReaction:
                //                   (String reaction, String commentId,
                //                       String commentRepliesId, String userId) {
                //                 controller.reelsReplyCommentReaction(
                //                     reactionType: reaction,
                //                     post_id: item.id ?? '',
                //                     comment_id: commentId,
                //                     comment_reply_id: commentRepliesId,
                //                     userId: userId);
                //               },
                //               onReelsCommentEdit: (reelsCommentModel) async {
                //                 await Get.toNamed(Routes.EDIT_REELS_COMMENT,
                //                     arguments: {
                //                       'post_comment':
                //                           reelsCommentModel.comment_name,
                //                       'post_id': reelsCommentModel.post_id,
                //                       'comment_id': reelsCommentModel.id,
                //                       'comment_type':
                //                           reelsCommentModel.comment_type,
                //                       'image_video':
                //                           reelsCommentModel.image_or_video
                //                     });
                //                 controller.getReelAdsCommentList(
                //                     reelsCommentModel.post_id ?? '');
                //               },
                //               onReelsCommentDelete: (reelsCommentModel) {
                //                 controller.reelsAdsCommentDelete(
                //                     reelsCommentModel.id ?? '',
                //                     reelsCommentModel.post_id ?? '',
                //                     index);
                //               },
                //               onReelsCommentReplayEdit:
                //                   (reelsCommenReplytModel) async {
                //                 await Get.toNamed(
                //                     Routes.EDIT_REELS_REPLY_COMMENT,
                //                     arguments: {
                //                       'reply_comment': reelsCommenReplytModel
                //                           .replies_comment_name,
                //                       'replay_post_id':
                //                           reelsCommenReplytModel.post_id,
                //                       'comment_replay_id':
                //                           reelsCommenReplytModel.id,
                //                       'comment_type':
                //                           reelsCommenReplytModel.comment_type,
                //                       'image_video':
                //                           reelsCommenReplytModel.image_or_video
                //                     });
                //                 controller.getReelAdsCommentList(
                //                     reelsCommenReplytModel.post_id ?? '');
                //               },
                //               onReelsCommentReplayDelete: (replyId, postId) {
                //                 controller.reelsAdsCommentReplyDelete(
                //                     replyId, postId, index);
                //               },
                //               onSelectReelsCommentReaction:
                //                   (reaction, reelsCommentModel) {
                //                 controller.reelsCommentReaction(
                //                     reactionType: reaction,
                //                     post_id: item.id ?? '',
                //                     comment_id: reelsCommentModel.id ?? '',
                //                     userId:
                //                         reelsCommentModel.user_id?.id ?? '');
                //               },
                //             ),
                //           )));
                //     },
                //     // onPressedReelsEye: () {
                //     //   Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
                //     //     'username': item.reelUser?.username,
                //     //     'isFromReels': 'true'
                //     //   });
                //     // },
                //     reelsCampaignModel: item,
                //   );
                // }
              },
            );
          }
        },
      ),
    );
  }
}
