import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../services/versionCheckerService.dart';
import '../widget/all_suggested_pages_widget.dart';
import '../../../../utils/url_utils.dart';

import '../../../../components/comment/comment_component.dart';
import '../../../../components/custom_alert_dialog.dart';
import '../../../../components/image.dart';
import '../../../../components/post/post.dart';
import '../../../../components/post/post_shimer_loader.dart';
import '../../../../components/share/share_sheet_widget.dart';
import '../../../../components/story.dart';
import '../../../../components/story/add_story_widget.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../config/constants/app_assets.dart';
import '../../../../models/merge_story.dart';
import '../../../../models/post.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/bottom_sheet.dart';
import '../../../../utils/copy_to_clipboard_utils.dart';
import '../../../../utils/snackbar.dart';
import '../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../components/story_shimer_loader.dart';
import '../controllers/home_controller.dart';
import '../widget/people_you_may_know_view.dart';
import 'story_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VersionCheckerService().checkAppVersion();
    });
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        controller.pageNo = 1;
        controller.postList.value.clear();
        controller.postList.refresh();
        // controller.totalPageCount =0;
        // Future.wait([
        controller.getPosts(forceRecallAPI: true);
        controller.generateRandomIndicesForPosts();
        controller.getPeopleMayYouKnow();
        controller.getSuggestedPages();
        // ]);
        await controller.getAllStory(forceRecallAPI: true);
        // controller.peopleMayYouKnowList.value.clear();
        // await Future.wait([
        //   controller.getPeopleMayYouKnow(),
        // ]);
      },
      child: CustomScrollView(
        controller: controller.postScrollController,
        slivers: [
          // ===================== Do Post Section =========================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                  top: 20, start: 16, end: 16, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundCornerNetworkImage(
                    imageUrl: (controller.userModel.profile_pic ?? '')
                        .formatedProfileUrl,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: controller.onTapCreatePost,
                      child: Container(
                        height: 48,
                        width: Get.width - 140,
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          maxLines: 1,
                          "${'What\'s on your mind'.tr}, ${controller.userModel.first_name}?",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          // style: TextStyle(
                          //   fontSize: 16,
                          // ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.1),
                    ),
                    child: IconButton(
                        onPressed: () {
                          controller.pickMediaFiles();
                        },
                        icon: const Image(
                            height: 25,
                            image: AssetImage(AppAssets.Gallery_ICON))),
                  )
                ],
              ),
            ),
          ),
          // ===================== Stories Section =========================
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: SizedBox(
                          height: 150,
                          child: AddStoryWidget(
                            userModel: controller.userModel,
                            onTapCreateStory: controller.onTapCreateStory,
                          ),
                        ),
                      ),
                      Obx(() => controller.isLoadingStory.value == true
                          ? const StoryShimerLoader()
                          : Expanded(
                              child: ListView.builder(
                                  itemCount:
                                      controller.storyMergeList.value.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    StoryMergeModel storyMergeModel =
                                        controller.storyMergeList.value[index];
                                    return MyDayCard(
                                      onTapStoryCard: () {
                                        Get.to(
                                            () => StoryView(
                                                  storyMergeList: controller
                                                      .storyMergeList.value,
                                                  onStoryViewed: (
                                                      {required storyId}) {
                                                    controller
                                                        .storyViewed(storyId);
                                                  },
                                                  onTapReaction: (
                                                      {required reactionType,
                                                      required storyId}) {
                                                    controller
                                                        .doReactionOnStory(
                                                            storyId,
                                                            reactionType);
                                                  },
                                                  onTapSendMessage: (
                                                      {required comment,
                                                      required storyId}) {},
                                                  onTapDeleteStory: (
                                                      {required storyId}) {
                                                    controller
                                                        .deleteStory(storyId);
                                                  },
                                                ),
                                            arguments: index);
                                      },
                                      storyMergeModel: storyMergeModel,
                                    );
                                  }),
                            )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Divider(
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
          Obx(() => SliverList.builder(
                itemCount: controller.postList.value.length +
                    controller.randomIndices.length,
                itemBuilder: (context, postIndex) {
                  if (postIndex != 0 &&
                      controller.randomIndices.contains(postIndex) &&
                      controller.showPeople.value) {
                    controller.showPeople.value = false;
                    return const PeopleYouMayKnowView();
                  }

                  if (postIndex != 0 &&
                      controller.randomIndicesForSuggestedPages
                          .contains(postIndex) &&
                      !controller.showPeople.value) {
                    controller.showPeople.value = true;
                    return const AllSuggestedPagesWidget();
                  } else {
                    int actualPostIndex = postIndex -
                        controller.randomIndices
                            .where((i) => i < postIndex)
                            .length;
                    if (actualPostIndex >= 0 &&
                        actualPostIndex < controller.postList.value.length) {
                      // debugPrint('Video Screen triggered:::::::::::: ${controller.videoAdList.value.first.campaignCoverPic?[0]}');
                      PostModel postModel =
                          controller.postList.value[actualPostIndex];

                      int adIndex = 0;
                      // debugPrint(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
                      // debugPrint(actualPostIndex.toString());
                      // debugPrint(controller.videoAdList.value.length.toString());
                      if (controller.videoAdList.value.isNotEmpty) {
                        adIndex = actualPostIndex %
                            controller.videoAdList.value.length;
                      }

                      return PostCard(
                          onTapBlockUser: () {
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
                                  controller.blockFriends(
                                      postModel.user_id?.id ?? '');
                                },
                              ),
                            );
                          },
                          onSixSeconds: () {
                            debugPrint(
                                'Video Screen triggered:::::::::::: ${controller.videoAdList.value.first.campaignCoverPic?.first ?? ''}');
                            // Get.to(()=> VideoAdScreen(videoLink: controller.videoAdList.value.first.campaignCoverPic?.first??''));
                          },
                          adVideoLink:
                              controller.videoAdList.value.elementAtOrNull(adIndex) != null
                                  ? (controller.videoAdList.value[adIndex]
                                              .campaignCoverPic?[0] ??
                                          '')
                                      .formatedAdsUrl
                                  : null,
                          campaignWebUrl:
                              controller.videoAdList.value.elementAtOrNull(adIndex) != null
                                  ? controller.videoAdList.value[adIndex].websiteUrl ??
                                      ''
                                  : null,
                          campaignName:
                              controller.videoAdList.value.elementAtOrNull(adIndex) != null
                                  ? controller.videoAdList.value[adIndex]
                                          .campaignName?.capitalizeFirst ??
                                      ''
                                  : null,
                          campaignDescription:
                              controller.videoAdList.value.elementAtOrNull(adIndex) != null
                                  ? controller.videoAdList.value[adIndex].description ?? ''
                                  : null,
                          campaignCallToAction: () async {
                            if (controller.videoAdList.value
                                    .elementAtOrNull(adIndex) !=
                                null) {
                              UriUtils.launchUrlInBrowser(
                                (controller.videoAdList.value[adIndex]
                                        .websiteUrl ??
                                    ''),
                              );
                            }
                          },
                          model: postModel,
                          onSelectReaction: (reaction) {
                            controller.reactOnPost(
                              postModel: postModel,
                              reaction: reaction,
                              index: actualPostIndex,
                              key: postModel.key ?? '',
                            );
                            debugPrint(reaction);
                          },
                          onPressedComment: () {
                            Get.bottomSheet(
                              backgroundColor:
                                  Theme.of(context).cardTheme.color,
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
                                      await Get.toNamed(
                                          Routes.EDIT_POST_COMMENT,
                                          arguments: {
                                            'post_comment':
                                                commentModel.comment_name,
                                            'post_id': commentModel.post_id,
                                            'comment_id': commentModel.id,
                                            'comment_type':
                                                commentModel.comment_type,
                                            'image_video':
                                                commentModel.image_or_video,
                                            'key' : commentModel.key,
                                          });
                                      controller.updatePostList(
                                          commentModel.post_id ?? '',
                                          actualPostIndex);
                                    },
                                    onCommentReplayEdit:
                                        (commentReplayModel) async {
                                      await Get.toNamed(
                                          Routes.EDIT_REPLY_POST_COMMENT,
                                          arguments: {
                                            'reply_comment': commentReplayModel
                                                .replies_comment_name,
                                            'replay_post_id':
                                                commentReplayModel.post_id,
                                            'comment_replay_id':
                                                commentReplayModel.id,
                                            'comment_type':
                                                commentReplayModel.comment_type,
                                            'image_video': commentReplayModel
                                                .image_or_video,
                                            'key' : commentReplayModel.key,
                                          });
                                      controller.updatePostList(
                                          commentReplayModel.post_id ?? '',
                                          actualPostIndex);
                                    },
                                    onCommentDelete: (commentModel) {
                                      controller.commentDelete(
                                          commentModel.id ?? '',
                                          commentModel.post_id ?? '',
                                          actualPostIndex);
                                    },
                                    onCommentReplayDelete: (replyId, postId) {
                                      controller.replyDelete(
                                          replyId, postId, actualPostIndex);
                                    },
                                    commentController:
                                        controller.commentController,
                                    postModel: controller
                                        .postList.value[actualPostIndex],
                                    userModel: controller.userModel,
                                    onTapSendComment: () {
                                      controller.commentOnPost(
                                          actualPostIndex, postModel);
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
                                        postIndex: actualPostIndex,
                                        file: controller.processedCommentFileData.value
                                      );
                                    },
                                    onSelectCommentReaction: (
                                      reaction,
                                      commentId,
                                    ) {
                                      controller.commentReaction(
                                        postIndex: actualPostIndex,
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
                                      controller.commentReplyReaction(
                                          actualPostIndex,
                                          reaction,
                                          postModel.id ?? '',
                                          commentId,
                                          commentRepliesId);
                                    },
                                    onTapViewReactions: () {
                                      Get.toNamed(Routes.REACTIONS,
                                          arguments: postModel.id);
                                    },
                                  ),
                                ),
                              ),
                              // backgroundColor: Colors.white,
                              isScrollControlled: true,
                              persistent: false,
                              isDismissible: true,
                            );
                          },
                          onTapBodyViewMoreMedia: () {
                            Get.to(MultipleImageView(postModel: postModel));
                          },
                          onTapViewReactions: () {
                            Get.toNamed(Routes.REACTIONS,
                                arguments: postModel.id);
                          },
                          onTapViewPostHistory: () {
                            Get.back();
                            Get.toNamed(Routes.EDIT_HISTORY,
                                arguments: postModel.id);
                          },
                          onTapEditPost: () {
                            Get.back();
                            controller.onTapEditPost(postModel);
                          },
                          onTapHidePost: () {
                            controller.hidePost(
                                1, postModel.id.toString(), actualPostIndex);
                          },
                          onTapBookMardPost: () {
                            controller.bookmarkPost(
                                postModel.id.toString(),
                                postModel.post_privacy.toString(),
                                actualPostIndex);
                          },
                          onTapRemoveBookMardPost: () {
                            controller.removeBookmarkPost(postModel.id ?? '',
                                postModel.bookmark?.id ?? '', actualPostIndex);
                          },
                          onTapCopyPost: () async {
                            CopyToClipboardUtils.copyToClipboard(
                                '$baseUrl${postModel.id}', 'Post');
                            Get.back();
                            showSuccessSnackkbar(
                                message: 'Your link copied to clipboard');
                          },
                          onTapViewOtherProfile: postModel.event_type == 'relationship'
                              ? () {
                                  final username =
                                      postModel.lifeEventId?.toUserId?.username;

                                  ProfileNavigator.navigateToProfile(
                                      isFromPageReels: 'false',
                                      username: username ?? '',
                                      isFromReels: 'false');
                                }
                              : null,
                          onTapShareViewOtherProfile: postModel.post_type == 'Shared'
                              ? () {
                                  final username = postModel.share_post_id
                                      ?.lifeEventId?.toUserId?.username;

                                  ProfileNavigator.navigateToProfile(
                                      isFromPageReels: 'false',
                                      username: username ?? '',
                                      isFromReels: 'false');
                                }
                              : null,

                          /* ============Share Post BottoSheet ==========*/
                          onPressedShare: () {
                            String sharePostId = '';
                            if (postModel.post_type == 'Shared') {
                              sharePostId = postModel.id ?? '';
                            }
                            if (postModel.share_post_id?.id == null) {
                              sharePostId = postModel.id ?? '';
                            } else {
                              sharePostId = postModel.share_post_id?.id ?? '';
                            }
                            showDraggableScrollableBottomSheet(context,
                                child: ShareSheetWidget(
                                  campaignId: postModel.campaign_id?.id ?? '',
                                  userId: postModel.user_id?.id ?? '',
                                  postId: sharePostId,
                                  report_id_key: 'post_id',
                                ));
                          });
                    } else {
                      debugPrint(
                          'Invalid actualPostIndex: $actualPostIndex, postIndex: $actualPostIndex');
                      return Container(); // Or return an empty widget or error widget
                    }
                  }
                },
              )),
          Obx(() => controller.isLoadingNewsFeed.value
              ? const PostShimerLoader()
              : const SliverToBoxAdapter(child: SizedBox()))
        ],
      ),
    ));
  }
}
