import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/share/share_sheet_widget.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/bottom_sheet.dart';
import '../../user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../components/reels_campaign_comment_component.dart';
import '../components/reels_campaign_component.dart';
import '../model/reels_campaign_model.dart';

import '../../../../routes/app_pages.dart';

import '../controllers/reels_controller.dart';

class ReelsCampaignView extends GetView<ReelsController> {
  const ReelsCampaignView({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();

    return Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() => PageView.builder(
              controller: controller.pageController,
              scrollDirection: Axis.vertical,
              itemCount: controller.reelsCampaignResultList.value.length,
              itemBuilder: (context, index) {
                bool myLike = false;
                ReelsCampaignResults reelsCampaignModel =
                    controller.reelsCampaignResultList.value[index];

                for (CampaignReactionModel reels_campaign_model
                    in reelsCampaignModel.reactions ?? []) {
                  if (reels_campaign_model.userId ==
                      controller.loginCredential.getUserData().id) {
                    myLike = true;
                  }
                }
                return ReelsCampaignComponent(
                  onPressedMessanger: () {},

                  onPressedViewProfile: () {
                    Get.toNamed(
                      Routes.OTHERS_PROFILE,
                      arguments: reelsCampaignModel.reelUser?.username,
                    );
                  },
                  onPressedShareReels: () {
                    showDraggableScrollableBottomSheet(context,
                        child: ShareSheetWidget(
                          report_id_key: 'reel_id',
                          userId: reelsCampaignModel.reelUser?.id ?? '',
                          campaignId:
                              reelsCampaignModel.reelsCampaign?.id ?? '',
                        ));
                  },
                  onPressedViewReact: () {
                    Get.toNamed(Routes.REELS_REACTIONS,
                        arguments: reelsCampaignModel.id);
                  },
                  isLiked: myLike,
                  carouselController: carouselController,
                  // controller: controller.videoPlayController,
                  // : reelsCampaignModel,
                  onPressedLike: () {
                    controller.reelsLike(reelsCampaignModel.id ?? '', index);
                  },
                  onPressedComment: () {
                    controller.getReelCommentList(reelsCampaignModel.id ?? '');

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
                            reelsCampaignModel: reelsCampaignModel,
                            onTapViewReactions: () {
                              Get.toNamed(Routes.REELS_REACTIONS,
                                  arguments: reelsCampaignModel.id);
                            },
                            onTapSendReelsComment: () {
                              controller.reelsComments(
                                  reelsCampaignModel.id ?? '',
                                  controller.reelsCommentController.text,
                                  index, reelsCampaignModel.key ?? '');
                              controller.reelsCommentController.clear();
                            },
                            reelsCommentController:
                                controller.reelsCommentController,
                            userModel: controller.loginCredential.getUserData(),
                            onTapReelsReplayComment: ({
                              required commentReplay,
                              required comment_id,
                              required file,
                            }) {
                              controller.reelsCommentsReply(
                                  comment_id: comment_id,
                                  replies_comment_name: commentReplay,
                                  post_id: reelsCampaignModel.id ?? '',
                                  replies_user_id: controller.loginCredential
                                          .getUserData()
                                          .id ??
                                      '', file: file, key: reelsCampaignModel.key ?? '');
                            },
                            onSelectReelsCommentReplayReaction:
                                (String reaction, String commentId,
                                    String commentRepliesId, String userId) {
                              controller.reelsReplyCommentReaction(
                                  reactionType: reaction,
                                  post_id: reelsCampaignModel.id ?? '',
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
                                    'key' : reelsCommentModel.key,
                                  });
                              controller.getReelCommentList(
                                  reelsCommentModel.post_id ?? '');
                            },
                            onReelsCommentDelete: (reelsCommentModel) {
                              controller.reelsCommentDelete(
                                  reelsCommentModel.id ?? '',
                                  reelsCommentModel.post_id ?? '',
                                  index,
                                  reelsCommentModel.key ?? ''
                                  );
                            },
                            onReelsCommentReplayEdit:
                                (reelsCommenReplytModel) async {
                              await Get.toNamed(Routes.EDIT_REELS_REPLY_COMMENT,
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
                                    'key' : reelsCommenReplytModel.key,
                                  });
                              controller.getReelCommentList(
                                  reelsCommenReplytModel.post_id ?? '');
                            },
                            onReelsCommentReplayDelete: (replyId, postId, key) {
                              controller.reelsCommentReplyDelete(
                                  replyId, postId, index, key );
                            },
                            onSelectReelsCommentReaction:
                                (reaction, reelsCommentModel) {
                              controller.reelsCommentReaction(
                                  reactionType: reaction,
                                  post_id: reelsCommentModel.post_id ?? '',
                                  comment_id: reelsCommentModel.id ?? '',
                                  userId: reelsCommentModel.user_id?.id ?? '');
                            },
                          ),
                        )));
                  },
                  // onPressedReelsEye: () {
                  //   Get.toNamed(Routes.OTHERS_PROFILE,
                  //   arguments: {
                  //     'username': reelsCampaignModel.reelUser?.username,
                  //     'isFromReels':'true'
                  //   });
                  //  },

                  reelsCampaignModel: reelsCampaignModel,
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
                      reportAction: (String report_type_id, String report_type,
                          String page_id, String description) {
                        controller.reportRepository.reportAPost(
                            id_key: 'post_id',
                            report_type: report_type,
                            description: description,
                            post_id: reelsCampaignModel.id ?? '',
                            report_type_id: report_type_id);
                      },
                    );
                  },
                  onPressedReelsEye: () {
                    ProfileNavigator.navigateToProfile(
                        username: reelsCampaignModel.reelUser?.username ?? '',
                        isFromReels: 'true');
                  },
                );
              },
            )));
  }
}
