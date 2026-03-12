import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/share/share_sheet_widget.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../config/constants/feed_design_tokens.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/bottom_sheet.dart';
import '../../../../utils/copy_to_clipboard_utils.dart';
import '../controller/explore_controller.dart';
import '../../../../components/comment/comment_component.dart';
import '../../../../components/post/post.dart';
import '../../../../components/post/post_shimer_loader.dart';
import '../../../../models/post.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/snackbar.dart';
import '../../../shared/modules/multiple_image/views/multiple_image_view.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = '${ApiConstant.SERVER_IP}/notification/';

    // ============================ refresh indicator section ==================
    return Scaffold(
      backgroundColor: FeedDesignTokens.surfaceBg(context),
      // ======================= appbar section ==============================
      appBar: AppBar(
        title: Text('Explore...'.tr,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(),
      ),
      // ======================= body section ================================
      body: RefreshIndicator(
        color: Theme.of(context).indicatorColor,
        backgroundColor: Theme.of(context).cardTheme.color,
        onRefresh: () => controller.refreshExplore(),
        child: CustomScrollView(
          cacheExtent: 800,
          controller: controller.postScrollController,
          slivers: [
            Obx(
              () => SliverList.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
                itemCount: controller.postList.length,
                itemBuilder: (context, postIndex) {
                  if (postIndex < 0 || postIndex >= controller.postList.length) {
                    return const SizedBox.shrink();
                  }
                  final PostModel postModel = controller.postList[postIndex];

                    return Column(
                      key: ValueKey(postModel.id),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PostCard(
                      onTapBlockUser: () {},
                      onSixSeconds: () {},
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
                          backgroundColor: Theme.of(context).cardTheme.color,
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
                                    postIndex);
                              },
                              onCommentDelete: (commentModel) {
                                controller.commentDelete(commentModel.id ?? '',
                                    commentModel.post_id ?? '', postIndex);
                              },
                              onCommentReplayDelete: (replyId, postId) {
                                controller.replyDelete(
                                    replyId, postId, postIndex);
                              },
                              commentController: controller.commentController,
                              postModel: controller.postList[postIndex],
                              userModel: controller.userModel,
                              onTapSendComment: () {
                                controller.commentOnPost(postIndex, postModel);
                              },
                              onTapReplayComment: ({
                                required commentReplay,
                                required comment_id,
                                required file
                              }) {
                                controller.commentReply(
                                  comment_id: comment_id,
                                  replies_comment_name: commentReplay,
                                  post_id: postModel.id ?? '',
                                  postIndex: postIndex,
                                  processedFileData: file,
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
                                controller.commentReplyReaction(
                                    postIndex,
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
                        Get.toNamed(Routes.EDIT_HISTORY,
                            arguments: postModel.id);
                      },
                      // onTapEditPost: () {
                      //   Get.back();
                      //   controller.onTapEditPost(postModel);
                      // },
                      onTapHidePost: () {
                        controller.hidePost(
                            1, postModel.id.toString(), postIndex);
                      },
                      // onTapBookMardPost: () {
                      //   controller.bookmarkPost(postModel.id.toString(),
                      //       postModel.post_privacy.toString(), postIndex);
                      // },
                      // onTapRemoveBookMardPost: () {
                      //   controller.removeBookmarkPost(postModel.id ?? '',
                      //       postModel.bookmark?.id ?? '', postIndex);
                      // },
                      onTapCopyPost: () async {
                        CopyToClipboardUtils.copyToClipboard(
                            '$baseUrl${postModel.id}', 'Post');

                        Get.back();
                        showSuccessSnackkbar(
                            message: 'Your link copied to clipboard');
                      },
                      onTapViewOtherProfile:
                          postModel.event_type == 'relationship'
                              ? () {
                                  ProfileNavigator.navigateToProfile(
                                      username: postModel.lifeEventId?.toUserId
                                              ?.username ??
                                          '',
                                      isFromReels: 'false');
                                }
                              : null,
                      onTapShareViewOtherProfile:
                          postModel.post_type == 'Shared'
                              ? () {
                                  ProfileNavigator.navigateToProfile(
                                      username: postModel
                                              .share_post_id
                                              ?.lifeEventId
                                              ?.toUserId
                                              ?.username ??
                                          '',
                                      isFromReels: 'false');
                                }
                              : null,

                      /* ============Share Post BottoSheet ==========*/
                      onPressedShare: controller
                                  .postList[postIndex].post_privacy ==
                              'public'
                          ? () {
                              String sharePostId = '';
                              if (postModel.share_post_id?.id == null) {
                                sharePostId = postModel.id ?? '';
                              } else {
                                sharePostId = postModel.share_post_id?.id ?? '';
                              }
                              showDraggableScrollableBottomSheet(context,
                                  child: ShareSheetWidget(
                                      report_id_key: 'post_id',
                                      campaignId:
                                          postModel.campaign_id?.id ?? '',
                                      userId: postModel.user_id?.id ?? '',
                                      postId: sharePostId));
                            }
                          : () {},
                    ),
                    const SizedBox(height: 2),
                  ],
                );
                  },
                ),
              ),
              // Initial loading shimmer
              Obx(() => controller.isLoadingNewsFeed.value
                  ? const PostShimerLoader()
                  : const SliverToBoxAdapter(child: SizedBox())),
              // Pagination loading indicator
              Obx(() {
                if (controller.isLoadingMore.value) {
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
                if (controller.feedExhausted.value && controller.postList.isNotEmpty) {
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
                            'You\'ve explored it all!',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Check back later for new content',
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
              }),
            ],
          ),
        ),
      );
  }
}
