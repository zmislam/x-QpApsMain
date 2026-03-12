import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/feed_design_tokens.dart';
import '../../../../utils/url_utils.dart';

import '../../../../components/comment/comment_component.dart';
import '../../../../components/custom_alert_dialog.dart';
import '../../../../components/feed_mode_tabs.dart';
import '../../../../components/post/post.dart';
import '../../../../components/post/post_shimer_loader.dart';
import '../../../../components/share/share_sheet_widget.dart';
import '../../../../components/story.dart';
import '../../../../components/story/add_story_widget.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../models/merge_story.dart';
import '../../../../models/post.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/bottom_sheet.dart';
import '../../../../utils/copy_to_clipboard_utils.dart';
import '../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../components/story_shimer_loader.dart';
import '../controllers/home_controller.dart';
import 'story_view.dart';
import '../../../../components/feed_insertion/feed_insertion_widget.dart';
import '../../../../components/sponsored_ad/sponsored_ad_widget.dart';
import '../../../../components/post/post_creator_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';
    return Scaffold(
        backgroundColor: FeedDesignTokens.surfaceBg(context),
        body: RefreshIndicator(
      color: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).cardTheme.color,
      strokeWidth: 2.5,
      onRefresh: () async {
        await Future.wait([
          controller.refreshEdgeRankFeed(),
          controller.getAllStory(forceRecallAPI: true),
        ]);
        controller.generateRandomIndicesForPosts();
      },
      child: CustomScrollView(
        cacheExtent: 800, // Pre-build cards 800px beyond viewport for smoother scroll
        controller: controller.postScrollController,
        slivers: [
          // ===================== Do Post Section =========================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PostCreatorBar(
                userModel: controller.userModel,
                onTapCreatePost: controller.onTapCreatePost,
                onTapPhoto: controller.pickMediaFiles,
              ),
            ),
          ),
          // ===================== Stories Section =========================
          SliverToBoxAdapter(
            child: Container(
              color: FeedDesignTokens.cardBg(context),
              margin: const EdgeInsets.only(bottom: 8), 
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                   SizedBox(
                  height: 230,
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: SizedBox(
                          height: 230,
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
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: MyDayCard(
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
                                      ),
                                    );
                                  }),
                            )),
                    ],
                  ),
                ),
                ],
              ),
            ),
          ),
          // ===================== Feed Mode Tabs =========================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Obx(() => FeedModeTabs(
                    currentMode: controller.currentFeedMode.value,
                    onModeChanged: (mode) {
                      // Scroll to top before switching mode
                      if (controller.postScrollController.hasClients) {
                        controller.postScrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                      controller.switchFeedMode(mode);
                    },
                  )),
            ),
          ),
          Obx(() {
                final posts = controller.edgeRankPosts;

                return SliverList.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final int actualPostIndex = index;

                    if (actualPostIndex < 0 || actualPostIndex >= posts.length) {
                      return const SizedBox.shrink();
                    }

                    final PostModel postModel = posts[actualPostIndex];

                      // Pre-compute video ad data outside the widget tree
                      int adIndex = 0;
                      if (controller.videoAdList.value.isNotEmpty) {
                        adIndex = actualPostIndex %
                            controller.videoAdList.value.length;
                      }
                      final videoAd = controller.videoAdList.value.elementAtOrNull(adIndex);

                      return Column(
                        key: ValueKey(postModel.id),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PostCard(
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
                              adVideoLink: videoAd != null
                                      ? (videoAd.campaignCoverPic?[0] ?? '').formatedAdsUrl
                                      : null,
                              campaignWebUrl: videoAd?.websiteUrl,
                              campaignName: videoAd?.campaignName?.capitalizeFirst,
                              campaignDescription: videoAd?.description,
                              campaignCallToAction: () async {
                                if (videoAd != null) {
                                  UriUtils.launchUrlInBrowser(
                                    videoAd.websiteUrl ?? '',
                                  );
                                }
                              },
                              model: postModel,
                              onTapBodyViewMoreMedia: () {
                                Get.to(MultipleImageView(postModel: postModel));
                              },
                              onTapViewReactions: () {
                                 Get.toNamed(Routes.REACTIONS, arguments: postModel.id);
                              },
                              onTapEditPost: () {
                                controller.onTapEditPost(postModel);
                              },
                              onTapHidePost: () {
                                controller.hidePost(
                                    1, postModel.id.toString(), actualPostIndex);
                              },
                              onTapBookMardPost: () {
                                controller.bookmarkPost(postModel.id.toString(),
                                    postModel.post_privacy.toString(), actualPostIndex);
                              },
                              onTapRemoveBookMardPost: () {
                                 controller.removeBookmarkPost(
                                    postModel.id ?? '', postModel.bookmark?.id ?? '', actualPostIndex);
                              },
                              onTapCopyPost: () async {
                                 CopyToClipboardUtils.copyToClipboard(
                                    '$baseUrl${postModel.id}', 'Post');
                              },
                              onTapViewOtherProfile:
                                postModel.event_type == 'relationship'
                                    ? () {
                                        ProfileNavigator.navigateToProfile(
                                            username: postModel.lifeEventId
                                                    ?.toUserId?.username ??
                                                '',
                                            isFromReels: 'false');
                                      }
                                    : null,
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
                                                'post_comment':
                                                    commentModel.comment_name,
                                                'post_id': commentModel.post_id,
                                                'comment_id': commentModel.id,
                                                'comment_type':
                                                    commentModel.comment_type,
                                                'image_video':
                                                    commentModel.image_or_video
                                              });
                                          controller.updatePostList(
                                              commentModel.post_id ?? '', actualPostIndex);
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
                                                    'image_video':
                                                        commentReplayModel.image_or_video,
                                                    'key': commentReplayModel.key,
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
                                        commentController: controller.commentController,
                                        postModel: controller.edgeRankPosts[actualPostIndex],
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
                                            file: file,
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
                                  isScrollControlled: true,
                                );
                              },
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
                              }),
                          if (controller.insertionMap.containsKey(postModel.id))
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                              child: FeedInsertionWidget(
                                insertion: controller.insertionMap[postModel.id]!,
                              ),
                            ),
                          // Sponsored ad anchored after this post
                          if (controller.sponsoredAdsMap.containsKey(postModel.id) &&
                              !controller.sponsoredAdsMap[postModel.id]!.isBoostedPagePost)
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                              child: SponsoredAdWidget(
                                ad: controller.sponsoredAdsMap[postModel.id]!,
                              ),
                            ),
                          // Boosted page posts render as a normal PostCard with "Sponsored" label
                          // (handled by the backend — the post itself comes with campaign metadata)
                          const SizedBox(height: 2),
                        ],
                      );
                  },
                );
              }),
          // Initial feed loading shimmer
          Obx(() => controller.isLoadingNewsFeed.value
              ? const PostShimerLoader()
              : const SliverToBoxAdapter(child: SizedBox())),
          // Pagination loading indicator (when scrolling for more posts)
          Obx(() {
            if (controller.isLoadingFeed.value && !controller.isLoadingNewsFeed.value) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                ),
              );
            }
            if (controller.feedExhausted.value && controller.edgeRankPosts.isNotEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 20),
                      Icon(
                        Icons.check_circle_outline,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You\'re all caught up!'.tr,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You\'ve seen all new posts'.tr,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox());
          })
        ],
      ),
    ));
  }
}
