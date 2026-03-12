import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/api_constant.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/copy_to_clipboard_utils.dart';
import '../../share/share_sheet_widget.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../config/constants/app_assets.dart';
import '../../../models/post.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import '../../../modules/shared/modules/multiple_image/views/multiple_image_view.dart';
import '../../../routes/app_pages.dart';
import '../../../config/constants/color.dart';
import '../../comment/comment_component.dart';
import '../post.dart';
import '../post_shimer_loader.dart';

class PinPostCard extends StatelessWidget {
  const PinPostCard({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 10,
          color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                AppAssets.POST_PIN_ICON,
                height: 18,
                width: 18,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Pinned Post'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 10,
          color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha: 0.3),
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.pinnedPostList.value.length,
            itemBuilder: (BuildContext context, int postIndex) {
              PostModel model = controller.pinnedPostList.value[postIndex];
              return controller.isLoadingNewsFeed.value == true
                  ? const PostShimerLoader()
                  : PostCard(
                      onTapBlockUser: () {},
                      onSixSeconds: () {},
                      index: postIndex,
                      model: model,
                      viewType: 'profile',
                      onTapPinPost: () {
                        controller.pinAndUnpinPost(
                            model.pinPost == true ? 0 : 1,
                            model.id.toString(),
                            postIndex);
                      },
                      onSelectReaction: (reaction) {
                        controller.reactOnPost(
                          postModel: model,
                          reaction: reaction,
                          index: postIndex,
                        );
                      },
                      onTapViewOtherProfile: model.event_type == 'relationship'
                          ? () {
                              ProfileNavigator.navigateToProfile(
                                  username:
                                      model.lifeEventId?.toUserId?.username ??
                                          '',
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
                              onCommentReplayEdit: (commentReplayModel) {},
                              onCommentEdit: (commentModel) {},
                              onCommentDelete: (commentModel) {
                                controller.commentDelete(commentModel.id ?? '',
                                    commentModel.post_id ?? '', postIndex);
                              },
                              onCommentReplayDelete: (replyId, postId) {
                                controller.replyDelete(
                                    replyId, postId, postIndex);
                              },
                              commentController: controller.commentController,
                              postModel: controller.postList.value[postIndex],
                              userModel: controller.userModel,
                              onTapSendComment: () {
                                controller.commentOnPost(postIndex, model);
                              },
                              onTapReplayComment: (
                                  {required commentReplay,
                                  required comment_id, required String file}) {
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
                                controller.commentReplyReaction(
                                    postIndex,
                                    reaction,
                                    model.id ?? '',
                                    commentId,
                                    commentRepliesId);
                              },
                              onTapViewReactions: () {
                                Get.toNamed(Routes.REACTIONS,
                                    arguments: model.id);
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
                                userId: model.user_id?.id ?? '',
                                postId: model.id));
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
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Others Post'.tr,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        Obx(() => controller.isLoadingNewsFeed.value == true
            ? const PostShimerLoader()
            : Container())
      ],
    );
  }
}
