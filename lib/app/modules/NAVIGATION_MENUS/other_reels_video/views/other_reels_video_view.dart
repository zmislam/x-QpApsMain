import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../components/reels_component.dart';
import '../../../../components/share/share_sheet_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/bottom_sheet.dart';
import '../../user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../../reels/components/reels_campaign_comment_component.dart';
import '../../reels/components/reels_campaign_component.dart';
import '../../reels/components/reels_comment_component.dart';
import '../../reels/model/reels_campaign_model.dart';
import '../../reels/model/reels_model.dart';
import '../controllers/other_reels_video_controller.dart';

class OtherReelsVideoView extends GetView<OtherReelsVideoController> {
  const OtherReelsVideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
//     bool isFromTabView = Get.arguments == null; // Check if opened from TabView
// if (!isFromTabView) {
//   // Extract arguments safely
//   controller.reelsID = Get.arguments['reelsID'];
//   controller.username = Get.arguments['username'];

//   // Clear previous data
//   controller.reelsModelList.value.clear();

//   if (controller.reelsID != null && controller.username== '') {
//     isFromTabView= false;
//   controller.reelsModelList.value.clear();

//     // controller.getReelsById();
//     controller.getReels();
//      controller.getReelsCampaignList();
//   } else if (controller.reelsID != null && controller.username != null) {
//     isFromTabView= false;

//     controller.getReelsById();
//     controller.getIndividualReels();
//      controller.getReelsCampaignList();

//   }
//   // controller.getReelsCampaignList();
// } else {
//   controller.reelsModelList.value.clear();
//   controller.getReels();
//   controller.getReelsCampaignList();
// }

    return SafeArea(
      top: true,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Obx(() {
            final mergedList = _getMergedList(controller.reelsModelList.value,
                controller.reelsCampaignResultList.value);
            return PageView.builder(
              controller: controller.pageController,
              scrollDirection: Axis.vertical,
              itemCount: mergedList.length,

              // itemCount: controller.reelsModelList.value.length,
              onPageChanged: (int index) {
                final item = mergedList[index];
                if (item is ReelsModel) {
                  controller.reelsViewClick(item.id ?? '');
                }
              },
              itemBuilder: (context, index) {
                final item = mergedList[index];
                if (item is ReelsModel) {
                  controller.reelsItem.value = mergedList[index];

                  bool myLike = false;
                  // ReelsModel reelsModel = controller.reelsModelList.value[index];
                  // ReelsCommentModel reelsCommentModel  = controller.reelsCommentModelList.value[index];
                  // ReelsCommentReplyModel reelsCommentReplyModel  = controller.reelsCommentReplyModelList.value[index];

                  for (ReelsReactionModel reels_model in item.reactions ?? []) {
                    if (reels_model.user_id?.id ==
                        controller.loginCredential.getUserData().id) {
                      myLike = true;
                    }
                  }
                  return ReelsComponent(
                    //========================= on  Tap  Delete============================//
                    onTapDelete: () async {
                      showDeleteAlertDialogs(
                        context: context,
                        deletingItemType: 'Reel',
                        onDelete: () {
                          controller.deleteReels(item.id ?? '', item.key ?? '');
                          Get.back();
                        },
                        onCancel: () {
                          Get.back();
                        },
                      );
                    },

                    //========================= on  Tap  Report============================//

                    onPressedReport: () async {
                      await controller.getReports();
                      CustomReportBottomSheet.showReportOptions(
                        context: context,
                        pageReportList: controller.pageReportList.value,
                        selectedReportType: controller.selectedReportType,
                        selectedReportId: controller.selectedReportId,
                        reportDescription: controller.reportDescription,
                        onCancel: () {
                          Get.back();
                        },
                        reportAction: (String report_type_id,
                            String report_type,
                            String page_id,
                            String description) {
                          controller.reportAPost(
                              report_type: report_type,
                              description: description,
                              post_id:
                                  controller.reelsModelList.value[index].id ??
                                      '',
                              report_type_id: report_type_id);
                        },
                      );
                    },
                    loginCredentials: controller.loginCredential,

                    //========================= on  Tap  View profile============================//

                    onPressedViewProfile: () {
                      ProfileNavigator.navigateToProfile(
                          username: item.reel_user?.username ?? '',
                          isFromReels: 'false');
                    },

                    //========================= on  Tap  Share Reels============================//

                    onPressedShareReels: () {
                      showDraggableScrollableBottomSheet(context,
                          child: ShareSheetWidget(
                            report_id_key: 'reel_id',
                            userId: item.reel_user?.id ?? '',
                            reelsId: item.id ?? '',
                          ));
                    },

                    //========================= on  Tap  View React============================//

                    onPressedViewReact: () {
                      Get.toNamed(Routes.REELS_REACTIONS, arguments: item.id);
                    },
                    isLiked: myLike,
                    carouselController: carouselController,
                    // controller: controller.videoPlayController,
                    reelsModel: item,

                    //==========================On Tap Reaction =========================//
                    onPressedReaction: (String reactionType) {
                      final reelsIndex = controller.reelsModelList.value
                          .indexWhere((reel) => reel.id == item.id);
                      if (reelsIndex != -1) {
                        controller.reelsReaction(
                            item.id ?? '', reelsIndex, reactionType);
                      }
                    },

                    //==========================On Tap Like =========================//

                    onPressedLike: () {
                      final reelsIndex = controller.reelsModelList.value
                          .indexWhere((reel) => reel.id == item.id);
                      if (reelsIndex != -1) {
                        controller.reelsLike(item.id ?? '',
                            reelsIndex); // Pass the correct index
                      }
                    },
                    //==========================On Tap Comment =========================//

                    onPressedComment: () {
                      controller.getReelCommentList(item.id ?? '');

                      Get.bottomSheet(Obx(() => ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                  30.0), // Adjust the radius value as needed
                              topRight: Radius.circular(
                                  30.0), // Adjust the radius value as needed
                            ),
                            child: ReelsCommentComponent(
                              reelsCommentList:
                                  controller.reelsCommentModelList.value,
                              reelsModel: item,
                              //==========================On Tap View Reaction =========================//

                              onTapViewReactions: () {
                                Get.toNamed(Routes.REELS_REACTIONS,
                                    arguments: item.id);
                              },
                              //==========================On Tap Send Reels Comment =========================//

                              onTapSendReelsComment: () {
                                controller.reelsComments(
                                    item.id ?? '',
                                    controller.reelsCommentController.text,
                                    index,
                                    controller.processedCommentFileData.value,
                                    item.key ?? '');
                                controller.reelsCommentController.clear();
                              },
                              reelsCommentController:
                                  controller.reelsCommentController,
                              userModel:
                                  controller.loginCredential.getUserData(),
                              //==========================On Tap Send Reels Comment Reply=========================//

                              onTapReelsReplayComment: ({
                                required commentReplay,
                                required comment_id,
                                required file,
                              }) {
                                controller.reelsCommentsReply(
                                    key: item.key!,
                                    comment_id: comment_id,
                                    replies_comment_name: commentReplay,
                                    post_id: item.id ?? '',
                                    replies_user_id: controller.loginCredential
                                            .getUserData()
                                            .id ??
                                        '',
                                    file: file);
                              },
                              //==========================On Tap Select Reels Comment Reply Reactions=========================//

                              onSelectReelsCommentReplayReaction:
                                  (String reaction, String commentId,
                                      String commentRepliesId, String userId) {
                                controller.reelsReplyCommentReaction(
                                    reactionType: reaction,
                                    post_id: item.id ?? '',
                                    comment_id: commentId,
                                    comment_reply_id: commentRepliesId,
                                    userId: userId);
                              },
                              //==========================On Tap Select Reels Comment Edit=========================//

                              onReelsCommentEdit: (reelsCommentModel) async {
                                await Get.toNamed(Routes.EDIT_REELS_COMMENT,
                                    arguments: {
                                      'post_comment':
                                          reelsCommentModel.comment_name,
                                      'post_id': reelsCommentModel.post_id,
                                      'comment_id': reelsCommentModel.id,
                                      'comment_type':
                                          reelsCommentModel.comment_type,
                                      'image_video':
                                          reelsCommentModel.image_or_video,
                                      'key': reelsCommentModel.key,
                                    });
                                controller.getReelCommentList(
                                    reelsCommentModel.post_id ?? '');
                              },
                              //==========================On Tap  Reels Comment Delete=========================//

                              onReelsCommentDelete: (reelsCommentModel) {
                                controller.reelsCommentDelete(
                                    reelsCommentModel.id ?? '',
                                    reelsCommentModel.post_id ?? '',
                                    index,
                                    reelsCommentModel.key ?? '');
                              },
                              //==========================On Tap  Reels Comment Reply Edit=========================//

                              onReelsCommentReplayEdit:
                                  (reelsCommenReplytModel) async {
                                await Get.toNamed(
                                    Routes.EDIT_REELS_REPLY_COMMENT,
                                    arguments: {
                                      'reply_comment': reelsCommenReplytModel
                                          .replies_comment_name,
                                      'replay_post_id':
                                          reelsCommenReplytModel.post_id,
                                      'comment_replay_id':
                                          reelsCommenReplytModel.id,
                                      'comment_type':
                                          reelsCommenReplytModel.comment_type,
                                      'image_video':
                                          reelsCommenReplytModel.image_or_video,
                                      'key': reelsCommenReplytModel.key,
                                    });
                                controller.getReelCommentList(
                                    reelsCommenReplytModel.post_id ?? '');
                              },
                              onReelsCommentReplayDelete:
                                  (replyId, postId, key) {
                                controller.reelsCommentReplyDelete(
                                    replyId, postId, index, item.key ?? '');
                              },
                              //==========================On Tap  Reels Comment Reactions=========================//

                              onSelectReelsCommentReaction:
                                  (reaction, reelsCommentModel) {
                                controller.reelsCommentReaction(
                                    reactionType: reaction,
                                    post_id: item.id ?? '',
                                    comment_id: reelsCommentModel.id ?? '',
                                    userId:
                                        reelsCommentModel.user_id?.id ?? '');
                              },
                            ),
                          )));
                    },
                    onPressedReelsEye: () {
                      Get.toNamed(
                        Routes.USER_REELS,
                        arguments: {
                          'userId': item.reel_user?.id ?? '',
                          'username': item.reel_user?.username ?? '',
                          'userFullName': '${item.reel_user?.first_name ?? ''} ${item.reel_user?.last_name ?? ''}'.trim(),
                          'userProfilePic': item.reel_user?.profile_pic ?? '',
                        },
                      );
                    },
                    onTapEditReel: () {},
                  );
                } else if (item is ReelsCampaignResults) {
                  bool myLike = item.reactions?.any((reaction) =>
                          reaction.userId ==
                          controller.loginCredential.getUserData().id) ??
                      false;

                  return ReelsCampaignComponent(
                    onPressedReelsEye: () {
                      Get.toNamed(
                        Routes.USER_REELS,
                        arguments: {
                          'userId': item.reelUser?.id ?? '',
                          'username': item.reelUser?.username ?? '',
                          'userFullName': '${item.reelUser?.firstName ?? ''} ${item.reelUser?.lastName ?? ''}'.trim(),
                          'userProfilePic': item.reelUser?.profilePic ?? '',
                        },
                      );
                    },
                    onPressedMessanger: () {},

                    onPressedViewProfile: () {
                      // Get.toNamed(
                      //   Routes.OTHERS_PROFILE,
                      //   arguments: item.reelUser?.username,
                      // );
                    },
                    onPressedShareReels: () {
                      showDraggableScrollableBottomSheet(context,
                          child: ShareSheetWidget(
                              userId:
                                  controller.loginCredential.getUserData().id ??
                                      '',
                              reelsId: item.id ?? ''));
                    },
                    onPressedViewReact: () {
                      Get.toNamed(Routes.REELS_REACTIONS, arguments: item.id);
                    },
                    isLiked: myLike,
                    carouselController: carouselController,
                    // controller: controller.videoPlayController,
                    // : reelsCampaignModel,
                    onPressedLike: () {
                      // Handle like for ReelsCampaignResults if applicable
                      final campaignIndex = controller
                          .reelsCampaignResultList.value
                          .indexWhere((campaign) => campaign.id == item.id);
                      if (campaignIndex != -1) {
                        controller.reelsAdsLike(item.id ?? '', campaignIndex,
                            item.key ?? ''); // Pass the correct index
                      }
                    },
                    onPressedComment: () {
                      controller.getReelAdsCommentList(item.id ?? '');

                      Get.bottomSheet(Obx(() => ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                  30.0), // Adjust the radius value as needed
                              topRight: Radius.circular(
                                  30.0), // Adjust the radius value as needed
                            ),
                            child: ReelsCampaignCommentComponent(
                              reelsCommentList:
                                  controller.reelsCommentModelList.value,
                              reelsCampaignModel: item,
                              onTapViewReactions: () {
                                Get.toNamed(Routes.REELS_REACTIONS,
                                    arguments: item.id);
                              },
                              onTapSendReelsComment: () {
                                controller.reelsAdsComments(
                                    item.id ?? '',
                                    controller.reelsCommentController.text,
                                    index,
                                    item.key ?? '');
                                controller.reelsCommentController.clear();
                              },
                              reelsCommentController:
                                  controller.reelsCommentController,
                              userModel:
                                  controller.loginCredential.getUserData(),
                              onTapReelsReplayComment: ({
                                required commentReplay,
                                required comment_id,
                                required file,
                              }) {
                                controller.reelsAdsCommentsReply(
                                    comment_id: comment_id,
                                    replies_comment_name: commentReplay,
                                    post_id: item.id ?? '',
                                    replies_user_id: controller.loginCredential
                                            .getUserData()
                                            .id ??
                                        '',
                                    file: file);
                              },
                              onSelectReelsCommentReplayReaction:
                                  (String reaction, String commentId,
                                      String commentRepliesId, String userId) {
                                controller.reelsReplyCommentReaction(
                                    reactionType: reaction,
                                    post_id: item.id ?? '',
                                    comment_id: commentId,
                                    comment_reply_id: commentRepliesId,
                                    userId: userId);
                              },
                              onReelsCommentEdit: (reelsCommentModel) async {
                                await Get.toNamed(Routes.EDIT_REELS_COMMENT,
                                    arguments: {
                                      'post_comment':
                                          reelsCommentModel.comment_name,
                                      'post_id': reelsCommentModel.post_id,
                                      'comment_id': reelsCommentModel.id,
                                      'comment_type':
                                          reelsCommentModel.comment_type,
                                      'image_video':
                                          reelsCommentModel.image_or_video,
                                      'key': reelsCommentModel.key,
                                    });
                                controller.getReelAdsCommentList(
                                    reelsCommentModel.post_id ?? '');
                              },
                              onReelsCommentDelete: (reelsCommentModel) {
                                controller.reelsAdsCommentDelete(
                                    reelsCommentModel.id ?? '',
                                    reelsCommentModel.post_id ?? '',
                                    index,
                                    reelsCommentModel.key ?? '');
                              },
                              onReelsCommentReplayEdit:
                                  (reelsCommenReplytModel) async {
                                await Get.toNamed(
                                    Routes.EDIT_REELS_REPLY_COMMENT,
                                    arguments: {
                                      'reply_comment': reelsCommenReplytModel
                                          .replies_comment_name,
                                      'replay_post_id':
                                          reelsCommenReplytModel.post_id,
                                      'comment_replay_id':
                                          reelsCommenReplytModel.id,
                                      'comment_type':
                                          reelsCommenReplytModel.comment_type,
                                      'image_video':
                                          reelsCommenReplytModel.image_or_video,
                                      'key': reelsCommenReplytModel.key,
                                    });
                                controller.getReelAdsCommentList(
                                    reelsCommenReplytModel.post_id ?? '');
                              },
                              //==========================On Tap  Reels Comment Reply Delete=========================//

                              onReelsCommentReplayDelete:
                                  (replyId, postId, key) {
                                controller.reelsAdsCommentReplyDelete(
                                    replyId, postId, index, key);
                              },
                              //==========================On Tap  Reels Comment Reactions=========================//

                              onSelectReelsCommentReaction:
                                  (reaction, reelsCommentModel) {
                                controller.reelsCommentReaction(
                                    reactionType: reaction,
                                    post_id: item.id ?? '',
                                    comment_id: reelsCommentModel.id ?? '',
                                    userId:
                                        reelsCommentModel.user_id?.id ?? '');
                              },
                            ),
                          )));
                    },
                    // onPressedReelsEye: () {
                    //   Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
                    //     'username': item.reelUser?.username,
                    //     'isFromReels': 'true'
                    //   });
                    // },
                    reelsCampaignModel: item,
                    onPressedReportReelsCampaign: () async {
                      await controller.getReports();
                      CustomReportBottomSheet.showReportOptions(
                        context: context,
                        pageReportList: controller.pageReportList.value,
                        selectedReportType: controller.selectedReportType,
                        selectedReportId: controller.selectedReportId,
                        reportDescription: controller.reportDescription,
                        onCancel: () {
                          Get.back();
                        },
                        reportAction: (String report_type_id,
                            String report_type,
                            String page_id,
                            String description) {
                          controller.reportAPost(
                              report_type: report_type,
                              description: description,
                              post_id: item.id ?? '',
                              report_type_id: report_type_id);
                        },
                      );
                    },
                  );
                }
                return null;
              },
            );
          })),
    );
  }

  List<dynamic> _getMergedList(
      List<ReelsModel> reels, List<ReelsCampaignResults> campaigns) {
    List<dynamic> mergedList = [];
    int campaignIndex = 0;

    for (int i = 0; i < reels.length; i++) {
      mergedList.add(reels[i]);

      if ((i + 1) % 5 == 0) {
        if (campaigns.isNotEmpty) {
          mergedList.add(campaigns[campaignIndex]);
          campaignIndex = (campaignIndex + 1) % campaigns.length;
        }
      }
    }

    return mergedList;
  }
}
