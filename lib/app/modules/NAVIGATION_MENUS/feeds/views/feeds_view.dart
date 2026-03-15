// =============================================================================
// Feeds View — Dedicated Feeds page with 6 tabbed feeds
// =============================================================================
// Design: Facebook-style Feeds page (accessible from hamburger menu)
// Tabs: All | Favourites | Friends | Groups | Pages | Explore
//
// Created: 2026-03-14
// =============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/comment/comment_component.dart';
import '../../../../components/custom_alert_dialog.dart';
import '../../../../components/post/post.dart';
import '../../../../components/post/post_shimer_loader.dart';
import '../../../../components/share/share_sheet_widget.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../config/constants/feed_design_tokens.dart';
import '../../../../models/post.dart';
import '../../../../routes/app_pages.dart';
import '../../../../routes/profile_navigator.dart';
import '../../../../utils/bottom_sheet.dart';
import '../../../../utils/copy_to_clipboard_utils.dart';
import '../../../shared/modules/multiple_image/views/multiple_image_view.dart';
import '../controllers/feeds_controller.dart';

class FeedsView extends GetView<FeedsController> {
  const FeedsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: FeedDesignTokens.surfaceBg(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Feeds',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: FeedDesignTokens.textPrimary(context),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: FeedDesignTokens.cardBg(context),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              size: 26,
              color: FeedDesignTokens.textPrimary(context),
            ),
            onPressed: () => Get.toNamed(Routes.ADVANCE_SEARCH),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildTabBar(context, isDark),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: FeedsController.tabOrder.map((tab) {
          return _FeedTabContent(tab: tab);
        }).toList(),
      ),
    );
  }

  /// Horizontal scrollable pill-style tab bar
  Widget _buildTabBar(BuildContext context, bool isDark) {
    return Container(
      color: FeedDesignTokens.cardBg(context),
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: FeedDesignTokens.brand(context),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: FeedDesignTokens.textSecondary(context),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dividerHeight: 0,
        splashFactory: NoSplash.splashFactory,
        tabs: FeedsController.tabOrder.map((tab) {
          return Tab(
            height: 36,
            child: Obx(() {
              final isActive = controller.activeTab.value == tab;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: isActive
                    ? null
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.grey.shade200,
                      ),
                child: Text(FeedsController.tabLabel(tab)),
              );
            }),
          );
        }).toList(),
      ),
    );
  }
}

// =============================================================================
// Individual Tab Content — Lazy-loaded, scrollable feed with pagination
// =============================================================================

class _FeedTabContent extends StatelessWidget {
  final FeedsTab tab;
  const _FeedTabContent({required this.tab});

  static const String _baseUrl = '${ApiConstant.SERVER_IP}/notification/';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedsController>();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => controller.refreshTab(tab),
        color: FeedDesignTokens.brand(context),
        child: CustomScrollView(
          controller: controller.scrollControllers[tab],
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 4)),

            // ── Post list ──
            Obx(() {
              final posts = controller.posts[tab]!;

              if (posts.isEmpty && !controller.isLoading[tab]!.value) {
                return SliverToBoxAdapter(
                  child: _buildEmptyState(context),
                );
              }

              return SliverList.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  if (index < 0 || index >= posts.length) {
                    return const SizedBox.shrink();
                  }

                  final PostModel postModel = posts[index];

                  return Column(
                    key: ValueKey('${tab.name}_${postModel.id}'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPostCard(context, controller, postModel, index, tab),
                      const SizedBox(height: 2),
                    ],
                  );
                },
              );
            }),

            // ── Initial loading shimmer ──
            Obx(() => controller.isLoading[tab]!.value
                ? const PostShimerLoader()
                : const SliverToBoxAdapter(child: SizedBox())),

            // ── Pagination indicator / caught-up message ──
            Obx(() {
              if (controller.isLoadingMore[tab]!.value) {
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

              if (controller.exhausted[tab]!.value &&
                  controller.posts[tab]!.isNotEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 24),
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
            }),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PostCard — replicates the callback wiring from home_view.dart
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildPostCard(
    BuildContext context,
    FeedsController controller,
    PostModel postModel,
    int index,
    FeedsTab tab,
  ) {
    return PostCard(
      model: postModel,
      onTapBlockUser: () {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.app_blocking,
            title: 'Block User'.tr,
            description:
                'Are you sure you want to block this user? The user won\'t be able to interact with you or see your profile',
            cancelButtonText: 'Cancel',
            confirmButtonText: 'Block',
            onCancel: () => Get.back(),
            onConfirm: () {
              Get.back();
              Get.back();
            },
          ),
        );
      },
      onSixSeconds: () {},
      onTapBodyViewMoreMedia: () {
        Get.to(MultipleImageView(postModel: postModel));
      },
      onTapViewReactions: () {
        Get.toNamed(Routes.REACTIONS, arguments: postModel.id);
      },
      onTapHidePost: () {
        controller.hidePost(tab, postModel.id.toString());
      },
      onTapBookMardPost: () {
        controller.bookmarkPost(
          tab,
          postModel.id.toString(),
          postModel.post_privacy.toString(),
          index,
        );
      },
      onTapRemoveBookMardPost: () {
        controller.removeBookmark(
          tab,
          postModel.id ?? '',
          postModel.bookmark?.id ?? '',
          index,
        );
      },
      onTapCopyPost: () async {
        CopyToClipboardUtils.copyToClipboard(
          '$_baseUrl${postModel.id}',
          'Post',
        );
      },
      onTapViewOtherProfile: postModel.event_type == 'relationship'
          ? () {
              ProfileNavigator.navigateToProfile(
                username:
                    postModel.lifeEventId?.toUserId?.username ?? '',
                isFromReels: 'false',
              );
            }
          : null,
      onTapShareViewOtherProfile: postModel.post_type == 'Shared'
          ? () {
              final username =
                  postModel.share_post_id?.lifeEventId?.toUserId?.username;
              ProfileNavigator.navigateToProfile(
                isFromPageReels: 'false',
                username: username ?? '',
                isFromReels: 'false',
              );
            }
          : null,
      onSelectReaction: (reaction) {
        controller.reactOnPost(
          tab: tab,
          postModel: postModel,
          reaction: reaction,
          index: index,
        );
      },
      onPressedComment: () {
        Get.bottomSheet(
          backgroundColor: Theme.of(context).cardTheme.color,
          Obx(
            () => CommentComponent(
              commentController: controller.commentController,
              postModel: controller.posts[tab]![index],
              userModel: controller.userModel,
              onTapSendComment: () {
                controller.commentOnPost(tab, index, postModel);
              },
              onCommentEdit: (commentModel) async {
                await Get.toNamed(Routes.EDIT_POST_COMMENT, arguments: {
                  'post_comment': commentModel.comment_name,
                  'post_id': commentModel.post_id,
                  'comment_id': commentModel.id,
                  'comment_type': commentModel.comment_type,
                  'image_video': commentModel.image_or_video,
                });
                controller.updatePostList(
                    tab, commentModel.post_id ?? '', index);
              },
              onCommentReplayEdit: (commentReplayModel) async {
                await Get.toNamed(Routes.EDIT_REPLY_POST_COMMENT, arguments: {
                  'reply_comment': commentReplayModel.replies_comment_name,
                  'replay_post_id': commentReplayModel.post_id,
                  'comment_replay_id': commentReplayModel.id,
                  'comment_type': commentReplayModel.comment_type,
                  'image_video': commentReplayModel.image_or_video,
                  'key': commentReplayModel.key,
                });
                controller.updatePostList(
                    tab, commentReplayModel.post_id ?? '', index);
              },
              onCommentDelete: (commentModel) {
                controller.commentDelete(
                  tab,
                  commentModel.id ?? '',
                  commentModel.post_id ?? '',
                  index,
                );
              },
              onCommentReplayDelete: (replyId, postId) {
                controller.replyDelete(
                  tab,
                  replyId,
                  postId,
                  index,
                );
              },
              onTapReplayComment: ({
                required commentReplay,
                required comment_id,
                required file,
              }) {
                controller.commentReply(
                  tab: tab,
                  comment_id: comment_id,
                  replies_comment_name: commentReplay,
                  post_id: postModel.id ?? '',
                  postIndex: index,
                  processedFileData: file,
                );
              },
              onSelectCommentReaction: (reaction, commentId) {
                controller.commentReaction(
                  tab: tab,
                  postIndex: index,
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
                  tab: tab,
                  postIndex: index,
                  reaction_type: reaction,
                  post_id: postModel.id ?? '',
                  comment_id: commentId,
                  comment_replies_id: commentRepliesId,
                );
              },
              onTapViewReactions: () {
                Get.toNamed(Routes.REACTIONS, arguments: postModel.id);
              },
            ),
          ),
          isScrollControlled: true,
        );
      },
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
        showDraggableScrollableBottomSheet(
          context,
          child: ShareSheetWidget(
            campaignId: postModel.campaign_id?.id ?? '',
            userId: postModel.user_id?.id ?? '',
            postId: sharePostId,
            report_id_key: 'post_id',
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Empty state — shown when a tab has no posts
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.dynamic_feed_rounded,
            size: 64,
            color: Colors.grey[350],
          ),
          const SizedBox(height: 16),
          Text(
            'No posts yet'.tr,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Posts from this feed will appear here'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
