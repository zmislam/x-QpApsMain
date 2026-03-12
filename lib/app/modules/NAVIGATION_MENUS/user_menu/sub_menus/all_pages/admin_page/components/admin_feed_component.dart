import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';

import '../../../../../../../components/comment/comment_component.dart';
import '../../../../../../../components/post/post.dart';
import '../../../../../../../components/post/post_shimer_loader.dart';
import '../../../../../../../components/share/share_sheet_widget.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../config/constants/color.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../../../../../../../utils/bottom_sheet.dart';
import '../../../../../../../utils/copy_to_clipboard_utils.dart';
import '../../../../../../../utils/url_utils.dart';
import '../../../../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../controller/admin_page_controller.dart';
import '../view/admin_pin_post_card.dart';

class AdminFeedComponent extends StatelessWidget {
  const AdminFeedComponent({super.key, required this.controller});
  final AdminPageController controller;
  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';

    return SliverList(
        delegate: SliverChildListDelegate([
      // "What's on your mind" Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(
            () => Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 47.86,
              width: 47.86,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  image: NetworkImage((controller.pageProfileModel.value
                                  ?.pageDetails?.profilePic ??
                              '')
                          .formatedProfileUrl
                      // controller.pageProfileModel.value?.pageDetails!
                      //             .profilePic !=
                      //         null
                      //     ? getFormatedProfileUrl(controller
                      //         .pageProfileModel.value!.pageDetails!.profilePic
                      //         .toString())
                      //     : 'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                      ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: controller.onTapPageCreatePost,
            child: Container(
              height: 40,
              width: Get.width - 140,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  color: Colors.grey.withValues(
                      alpha: 0.1), //Color.fromARGB(135, 238, 238, 238),
                  borderRadius: BorderRadius.circular(10)),
              child: Obx(
                () => Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "What's on your mind ${controller.pageProfileModel.value?.pageDetails?.pageName}?",
                  style: TextStyle(color: GREY_COLOR),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withValues(alpha: 0.1),
            ),
            child: IconButton(
                onPressed: () {
                  controller.onTapPageCreatePost();
                },
                icon: const Image(
                  image: AssetImage(AppAssets.Gallery_ICON),
                  height: 25,
                )),
          )
        ],
      ),

      const SizedBox(
        height: 10,
      ),
      const Divider(),
      Obx(
        () => controller.pinnedPostList.value.isNotEmpty
            ? AdminPagePinPostCard(
                controller: controller,
              )
            : Container(),
      ),

      //==================================================== Post ListView===========================================//1

      const SizedBox(
        height: 10,
      ),
      // Container(
      //   height: 10,
      //   color: PRIMARY_GREY_DIVIDER_COLOR.withValues(alpha:0.3),
      // ),
      Obx(() {
        if (controller.postList.value.isEmpty &&
            controller.isLoadingNewsFeed.value == false) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text('No Posts Found'.tr,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else if (controller.isLoadingNewsFeed.value) {
          return const PostShimerLoaderGeneral();
        } else {
          return ListView.builder(
            // controller: controller.postScrollController,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.postList.value.length,
            itemBuilder: (BuildContext context, int postIndex) {
              PostModel model = controller.postList.value[postIndex];
              return PostCard(
                onTapBlockUser: () {},
                onSixSeconds: () {},
                index: postIndex,
                model: model,
                viewType: 'PagePost',
                onTapPinPost: () {
                  controller.pinAndUnpinPost(model.pinPost == true ? 0 : 1,
                      model.id.toString(), postIndex);
                },
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
                            username: model.share_post_id?.lifeEventId?.toUserId
                                    ?.username ??
                                '',
                            isFromReels: 'false');
                      }
                    : null,
                onPressedComment: () {
                  Get.bottomSheet(
                    backgroundColor: Theme.of(context).cardTheme.color,
                    Obx(
                      () => PopScope(
                        canPop: true,
                        onPopInvokedWithResult: (didPop, result) {
                          controller.xfiles.value.clear();
                          controller.commentController.clear();
                          controller.xfiles.refresh();
                        },
                        child: CommentComponent(
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
                              {required commentReplay, required comment_id, required file}) {
                            controller.commentReply(
                              comment_id: comment_id,
                              replies_comment_name: commentReplay,
                              post_id: model.id ?? '',
                              postIndex: postIndex,
                              file: file
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
                onTapEditPost: () async {
                  Get.close(1);
                  await Get.toNamed(Routes.EDIT_POST, arguments: model);
                  controller.onTapEditPost(model);
                  Get.back();
                },
                onTapViewPostHistory: () {
                  Get.back();
                  Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
                },
                // onTapViewPostHistory: () {},
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
                  // debugPrint(
                  // 'Campaign Name::::::${(controller.videoAdList.value[controller.currentAdIndex.value].campaignName?.capitalizeFirst ?? '')}');
                  controller.videoAdList.value.elementAtOrNull(postIndex) !=
                          null
                      ? UriUtils.launchUrlInBrowser(controller
                              .videoAdList
                              .value[controller.currentAdIndex.value]
                              .websiteUrl ??
                          '')
                      : null;
                  // await launchUrl(
                  //     Uri.parse(controller
                  //             .videoAdList
                  //             .value[controller.currentAdIndex.value]
                  //             .websiteUrl ??
                  //         ''),
                  //     mode: LaunchMode.externalApplication);
                },
                onPressedShare: () {
                  String sharePostId = '';
                  if (model.share_post_id?.id == null) {
                    sharePostId = model.id ?? '';
                  } else {
                    sharePostId = model.share_post_id?.id ?? '';
                  }
                  showDraggableScrollableBottomSheet(context,
                      child: ShareSheetWidget(
                          report_id_key: 'post_id',
                          campaignId: model.campaign_id?.id ?? '',
                          userId: model.user_id?.id ?? '',
                          postId: sharePostId));
                },
                onTapRemoveBookMardPost: () {
                  controller.removeBookmarkPost(model.id ?? '', postIndex);
                },
                onTapBookMardPost: () {
                  controller.bookmarkPost(
                      model.id.toString(), model.post_privacy.toString());
                },
                onTapCopyPost: () async {
                  CopyToClipboardUtils.copyToClipboard(
                      '$baseUrl${model.id}', 'Link');
                  Get.back();
                },
              );
            },
          );
        }
      }),
    ]));
  }
}
