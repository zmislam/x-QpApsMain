import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_search.dart';
import '../../../components/comment/comment_component.dart';
import '../../../components/custom_alert_dialog.dart';
import '../../../components/post/post.dart';
import '../../../components/share/share_sheet_widget.dart';
import '../../../config/constants/api_constant.dart';
import '../../../models/post.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../utils/copy_to_clipboard_utils.dart';
import '../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../controllers/global_search_controller.dart';

class PostSearch extends GetWidget<GlobalSearchController> {
  const PostSearch({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';
    return Obx(
      () => controller.isLoadingFeed.value
          ? const AllSearchPostShimmerLoader()
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.postList.value.length,
              itemBuilder: (context, postIndex) {
                PostModel model = controller.postList.value[postIndex];
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
                          Get.back();
                          Get.back();
                          // Call the method to block the user
                          controller.blockFriends(model.user_id?.id ?? '');
                        },
                      ),
                    );
                  },
                  onSixSeconds: () {},
                  index: postIndex,
                  model: model,
                  viewType: 'home',
                  onTapPinPost: () {},
                  onSelectReaction: (reaction) {
                    controller.reactOnPost(
                      postModel: model,
                      reaction: reaction,
                      index: postIndex,
                      key: model.key ?? '',
                    );
                  },
                  onTapViewOtherProfile: model.event_type == 'relationship'
                      ? () {
                          ProfileNavigator.navigateToProfile(
                              username:
                                  model.lifeEventId?.toUserId?.username ?? '',
                              isFromReels: 'false');
                        }
                      : null,
                  onTapShareViewOtherProfile: model.post_type == 'Shared'
                      ? () {
                          ProfileNavigator.navigateToProfile(
                              username: model.share_post_id?.lifeEventId
                                      ?.toUserId?.username ??
                                  '',
                              isFromReels: 'false');
                        }
                      : null,
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
                                  'comment_type':
                                      commentReplayModel.comment_type,
                                  'image_video':
                                      commentReplayModel.image_or_video,
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
                            controller.commentOnPost(postIndex, model);
                          },
                          onTapReplayComment: (
                              {required commentReplay, required comment_id, required String file}) {
                            controller.commentReply(
                              comment_id: comment_id,
                              replies_comment_name: commentReplay,
                              post_id: model.id ?? '',
                              postIndex: postIndex,
                              file: file,
                            );
                          },
                          onSelectCommentReaction: (reaction, commentId) {
                            controller.commentReaction(
                              postIndex: postIndex,
                              reaction_type: reaction,
                              post_id: model.id ?? '',
                              comment_id: commentId,
                            );
                          },
                          onSelectCommentReplayReaction: (
                            reaction,
                            commentId,
                            commentRepliesId,
                          ) {
                            controller.commentReplyReaction(postIndex, reaction,
                                model.id ?? '', commentId, commentRepliesId);
                          },
                          onTapViewReactions: () {
                            Get.toNamed(Routes.REACTIONS, arguments: model.id);
                          },
                        ),
                      ),
                      // backgroundColor: Colors.white,
                      isScrollControlled: true,
                    );
                  },
                  onTapBodyViewMoreMedia: () {
                    Get.to(MultipleImageView(postModel: model));
                  },
                  onTapViewReactions: () {
                    Get.toNamed(Routes.REACTIONS, arguments: model.id);
                  },
                  onTapEditPost: () {
                    Get.back();
                    controller.onTapEditPost(model);
                  },
                  onPressedShare: () {
                    showDraggableScrollableBottomSheet(context,
                        child: ShareSheetWidget(
                            report_id_key: 'post_id',
                            userId:
                                controller.loginCredential.getUserData().id ??
                                    '',
                            postId: model.id ?? ''));
                  },
                  onTapHidePost: () {
                    controller.hidePost(1, model.id.toString(), postIndex);
                  },
                  onTapBookMardPost: () {
                    controller.bookmarkPost(
                        model.id.toString(), model.post_privacy.toString());
                  },
                  onTapCopyPost: () async {
                    Get.back();

                    CopyToClipboardUtils.copyToClipboard(
                        '$baseUrl${model.id}', 'Link');
                  },
                );
              },
            ),
    );
  }
}
