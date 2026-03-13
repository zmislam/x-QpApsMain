import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/comment/comment_sort_bottom_sheet.dart';
import '../../../../../components/post/post_body/post_body.dart' hide getDynamicFormatedTime;
import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../config/constants/feed_design_tokens.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../models/comment_model.dart';
import '../../../../../models/post.dart';
import '../../../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import '../../../../../routes/profile_navigator.dart';
import '../../../../../components/alert_dialogs/delete_alert_dialogs.dart';
import '../../../../../utils/copy_to_clipboard_utils.dart';
import '../../../../../utils/post_utlis.dart';
import '../../../../../components/custom_cached_image_view.dart';
import '../../../../../components/single_image.dart';
import '../../../../../components/smart_text.dart';
import '../../../../../components/video_player/post/newsfeed_post_video_player.dart';
import '../../../../../components/video_player/post/post_details_video_screen.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../repository/page_repository.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../services/emoji_sticker_picker_service.dart';
import '../../../../../components/reaction_button/comment_reaction_button.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../shared/components/post_reactions/views/post_reactions_view.dart';

/// Full-page Facebook-style comment view.
///
/// Opens when user taps the comment icon on a post card.
/// Shows the original post at top, then all comments below,
/// with a sticky input bar at the bottom.
class PostCommentPageView extends StatefulWidget {
  const PostCommentPageView({
    super.key,
    required this.postIndex,
  });

  final int postIndex;

  @override
  State<PostCommentPageView> createState() => _PostCommentPageViewState();
}

class _PostCommentPageViewState extends State<PostCommentPageView> {
  final HomeController controller = Get.find<HomeController>();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  CommentSortMode _sortMode = CommentSortMode.mostRelevant;

  // ── Send button visibility ──
  final RxBool _hasText = false.obs;

  // ── Reactive state for follow/join buttons ──
  final RxBool _isFollowingPage = false.obs;
  final RxBool _isGroupMember = false.obs;
  final RxBool _isFriendRequestSent = false.obs;

  PostModel get postModel => controller.edgeRankPosts[widget.postIndex];

  @override
  void initState() {
    super.initState();
    // Load comments if not already loaded
    if (postModel.id != null) {
      controller.getSinglePostsComments(postModel.id!);
    }
    // Initialize follow/join state from model
    _isFollowingPage.value = postModel.isFollowingPage == true;
    _isGroupMember.value = postModel.isGroupMember == true;
    _isFriendRequestSent.value = postModel.isFriendRequestSended == true;
    // Listen for text changes to toggle send button
    controller.commentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _hasText.value = controller.commentController.text.trim().isNotEmpty;
  }

  // ── Follow/Unfollow Page ──
  void _handleFollowPage(PostModel post) async {
    final pageId = post.page_id.id ?? post.share_post_id?.page_id?.id ?? '';
    if (pageId.isEmpty) return;
    final wasFollowing = _isFollowingPage.value;
    _isFollowingPage.value = !wasFollowing;
    try {
      if (wasFollowing) {
        await PageRepository().unfollowPage(pageId: pageId);
        post.isFollowingPage = false;
      } else {
        await PageRepository().followPage(pageId);
        post.isFollowingPage = true;
      }
    } catch (e) {
      _isFollowingPage.value = wasFollowing;
    }
  }

  // ── Join/Leave Group ──
  void _handleJoinGroup(PostModel post) async {
    final groupId = post.groupId.id ?? post.share_post_id?.groupId?.id ?? '';
    if (groupId.isEmpty) return;
    final wasJoined = _isGroupMember.value;
    _isGroupMember.value = !wasJoined;
    try {
      final api = ApiCommunication();
      if (!wasJoined) {
        await api.doPostRequest(
          apiEndPoint: 'groups/send-group-invitation-join-request',
          requestData: {
            'group_id': groupId,
            'type': 'join',
            'user_id_arr': [LoginCredential().getUserData().id ?? ''],
          },
        );
        post.isGroupMember = true;
      } else {
        final userId = LoginCredential().getUserData().id ?? '';
        await api.doPatchRequest(
          apiEndPoint: 'group-member-status-change?group_id=$groupId&user_id=$userId&status=left',
        );
        post.isGroupMember = false;
      }
    } catch (e) {
      _isGroupMember.value = wasJoined;
    }
  }

  @override
  void dispose() {
    controller.commentController.removeListener(_onTextChanged);
    _focusNode.dispose();
    _scrollController.dispose();
    controller.isReply.value = false;
    controller.isReplyOfReply.value = false;
    controller.xfiles.value.clear();
    controller.commentController.clear();
    super.dispose();
  }

  // ─── Sort comments ───
  List<CommentModel> _sortedComments(List<CommentModel> comments) {
    if (comments.isEmpty) return comments;
    final sorted = List<CommentModel>.from(comments);
    switch (_sortMode) {
      case CommentSortMode.newest:
        sorted.sort((a, b) {
          final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
          final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });
        break;
      case CommentSortMode.mostRelevant:
        sorted.sort((a, b) {
          final scoreA = (a.comment_reactions?.length ?? 0) * 2 +
              (a.replies?.length ?? 0);
          final scoreB = (b.comment_reactions?.length ?? 0) * 2 +
              (b.replies?.length ?? 0);
          if (scoreB != scoreA) return scoreB.compareTo(scoreA);
          final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
          final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });
        break;
      case CommentSortMode.allComments:
        sorted.sort((a, b) {
          final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(2000);
          final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(2000);
          return dateA.compareTo(dateB);
        });
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FeedDesignTokens.cardBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Scrollable content: Post + Comments ───
            Expanded(
              child: Obx(() {
                final post = controller.edgeRankPosts[widget.postIndex];
                final comments = _sortedComments(post.comments ?? []);

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // ── Post Header (back + user info) ──
                    SliverToBoxAdapter(child: _buildPostHeader(context, post)),

                    // ── Post Body ──
                    SliverToBoxAdapter(child: _buildPostBody(post)),

                    // ── Reaction / Comment / Share counts ──
                    SliverToBoxAdapter(
                        child: _buildCountsRow(context, post)),

                    // ── Sort dropdown ──
                    SliverToBoxAdapter(child: _buildSortRow(context)),

                    // ── Comments list ──
                    if (comments.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyComments(context),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _FbCommentTile(
                            comment: comments[index],
                            controller: controller,
                            postIndex: widget.postIndex,
                            focusNode: _focusNode,
                          ),
                          childCount: comments.length,
                        ),
                      ),

                    // Bottom padding
                    const SliverToBoxAdapter(
                        child: SizedBox(height: 16)),
                  ],
                );
              }),
            ),

            // ─── Sticky input bar ───
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ACTION BUTTON — Follow page / Join group / Add friend
  // ═══════════════════════════════════════════════════════════
  Widget _buildActionButton(PostModel post) {
    final isPagePost = (post.page_id.pageName?.length ?? 0) > 1;
    final isGroupPost = (post.groupId.groupName?.length ?? 0) > 1;

    if (isPagePost) {
      // ── Page Follow / Following ──
      return Obx(() => GestureDetector(
            onTap: () => _handleFollowPage(post),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                _isFollowingPage.value
                    ? '· ${'Following'.tr}'
                    : '· ${'Follow'.tr}',
                style: TextStyle(
                  color: _isFollowingPage.value ? Colors.grey : PRIMARY_COLOR,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ));
    } else if (isGroupPost) {
      // ── Group Join / Joined ──
      return Obx(() => GestureDetector(
            onTap: () => _handleJoinGroup(post),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                _isGroupMember.value
                    ? '· ${'Joined'.tr}'
                    : '· ${'Join'.tr}',
                style: TextStyle(
                  color: _isGroupMember.value ? Colors.grey : PRIMARY_COLOR,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ));
    } else {
      // ── User post: show Follow (acts as friend request) ──
      if (post.isFriend == true || _isFriendRequestSent.value) {
        return const SizedBox.shrink();
      }
      return GestureDetector(
        onTap: () async {
          final targetUserId = post.user_id?.id ?? '';
          if (targetUserId.isEmpty) return;
          _isFriendRequestSent.value = true;
          try {
            final api = ApiCommunication();
            await api.doPostRequest(
              apiEndPoint: 'send-friend-request',
              requestData: {'user_id': targetUserId},
            );
            Get.snackbar('Success'.tr, 'Friend request sent'.tr,
                snackPosition: SnackPosition.BOTTOM);
          } catch (e) {
            _isFriendRequestSent.value = false;
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '· ${'Follow'.tr}',
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  POST HEADER — Back button + user avatar + name + time
  // ═══════════════════════════════════════════════════════════
  Widget _buildPostHeader(BuildContext context, PostModel post) {
    final userId = post.user_id;
    final pageId = post.page_id;
    final groupId = post.groupId;

    String name = '';
    String avatarUrl = '';
    String subtitle = '';
    bool isVerified = false;

    // Determine name & avatar based on post type
    if ((groupId.groupName?.length ?? 0) > 1) {
      name = groupId.groupName ?? '';
      avatarUrl = (groupId.groupCoverPic ?? '').formatedProfileUrl;
      subtitle = '${userId?.first_name ?? ''} ${userId?.last_name ?? ''} · ${getDynamicFormatedTime(post.createdAt ?? '')}';
    } else if ((pageId.pageName?.length ?? 0) > 1) {
      name = pageId.pageName ?? '';
      avatarUrl = (pageId.profilePic ?? '').formatedProfileUrl;
      subtitle = getDynamicFormatedTime(post.createdAt ?? '');
    } else {
      name = '${userId?.first_name ?? ''} ${userId?.last_name ?? ''}';
      avatarUrl = (userId?.profile_pic ?? '').formatedProfileUrl;
      subtitle = getDynamicFormatedTime(post.createdAt ?? '');
      isVerified = userId?.isProfileVerified == true;
    }

    // ── Profile navigation handler ──
    void navigateToProfile() {
      if ((groupId.groupName?.length ?? 0) > 1) {
        final gId = post.post_type == 'Shared'
            ? (post.share_post_id?.groupId?.id ?? groupId.id ?? '')
            : (groupId.id ?? '');
        Get.toNamed(Routes.GROUP_PROFILE, arguments: {'id': gId, 'group_type': ''});
      } else if ((pageId.pageName?.length ?? 0) > 1) {
        ProfileNavigator.navigateToProfile(
          username: pageId.pageUserName ?? pageId.pageName ?? '',
          isFromReels: 'false',
        );
      } else {
        ProfileNavigator.navigateToProfile(
          username: userId?.username ?? '',
          isFromReels: 'false',
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          // Avatar — tap to open profile
          GestureDetector(
            onTap: navigateToProfile,
            child: ClipOval(
              child: CustomCachedNetworkImage(
                imageUrl: avatarUrl,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Name + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: navigateToProfile,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.verified, color: PRIMARY_COLOR, size: 16),
                    ],
                    // ── Follow / Join button (reactive) ──
                    if (post.post_type != 'Shared' &&
                        userId?.id != controller.userModel.id)
                      _buildActionButton(post),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          // Three-dot menu
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showPostActionsSheet(context, post),
              icon: Icon(
                Icons.more_horiz,
                color: FeedDesignTokens.textSecondary(context),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  POST BODY — text + media (reuse existing PostBodyView)
  // ═══════════════════════════════════════════════════════════
  Widget _buildPostBody(PostModel post) {
    return PostBodyView(
      model: post,
      onTapBodyViewMoreMedia: () {},
      onSixSeconds: () {},
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  COUNTS ROW — Like 44.4K | Comment 3K | Share 2K
  // ═══════════════════════════════════════════════════════════
  Widget _buildCountsRow(BuildContext context, PostModel post) {
    final int reactionCount = post.reactionCount ?? 0;
    final int commentCount = post.totalComments ?? 0;
    final int shareCount = post.postShareCount ?? 0;
    final reactionAssets = getReactionAssets(post, maxCount: 3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // ── Reaction icons + count (tap opens reaction modal) ──
          if (reactionCount > 0)
            GestureDetector(
              onTap: () => ReactionsBottomSheet.show(context, post.id ?? ''),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
            // Stacked reaction icons
            if (reactionAssets.isNotEmpty)
              SizedBox(
                width: reactionAssets.length * 14.0 + 6,
                height: 20,
                child: Stack(
                  children: [
                    for (int i = 0; i < reactionAssets.length; i++)
                      Positioned(
                        left: i * 14.0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: FeedDesignTokens.cardBg(context),
                                width: 1.5),
                          ),
                          child: Image.asset(reactionAssets[i],
                              width: 18, height: 18),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(width: 4),
            Text(
              _formatCount(reactionCount),
              style: FeedDesignTokens.countStyle(context),
            ),
                ],
              ),
            ),
          const Spacer(),
          // ── Comment count ──
          if (commentCount > 0) ...[
            Icon(Icons.chat_bubble_outline,
                size: 14, color: FeedDesignTokens.textSecondary(context)),
            const SizedBox(width: 4),
            Text(_formatCount(commentCount),
                style: FeedDesignTokens.countStyle(context)),
          ],
          if (commentCount > 0 && shareCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('·',
                  style: FeedDesignTokens.countStyle(context)
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
          // ── Share count ──
          if (shareCount > 0) ...[
            Icon(Icons.reply,
                size: 16, color: FeedDesignTokens.textSecondary(context)),
            const SizedBox(width: 4),
            Text(_formatCount(shareCount),
                style: FeedDesignTokens.countStyle(context)),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  SORT ROW — "Most relevant ▾"
  // ═══════════════════════════════════════════════════════════
  Widget _buildSortRow(BuildContext context) {
    return Column(
      children: [
        Divider(
            height: 1,
            thickness: 0.5,
            color: FeedDesignTokens.divider(context)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: GestureDetector(
            onTap: () async {
              final result =
                  await CommentSortBottomSheet.show(context, _sortMode);
              if (result != null && result != _sortMode) {
                setState(() {
                  _sortMode = result;
                });
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  commentSortLabel(_sortMode),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: FeedDesignTokens.textSecondary(context),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down,
                    size: 20,
                    color: FeedDesignTokens.textSecondary(context)),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  EMPTY STATE
  // ═══════════════════════════════════════════════════════════
  Widget _buildEmptyComments(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 56,
              color: FeedDesignTokens.textSecondary(context)
                  .withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text('No comments yet',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: FeedDesignTokens.textPrimary(context))),
          const SizedBox(height: 4),
          Text('Be the first to comment.',
              style: TextStyle(
                  fontSize: 13,
                  color: FeedDesignTokens.textSecondary(context))),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  THREE-DOT POST ACTIONS
  // ═══════════════════════════════════════════════════════════
  void _showPostActionsSheet(BuildContext context, PostModel post) {
    final isOwner = post.user_id?.id == controller.userModel.id;
    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: FeedDesignTokens.textSecondary(context)
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (isOwner) ...[
              _actionMenuItem(context,
                  icon: Icons.edit_outlined,
                  label: 'Edit Post'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    controller.onTapEditPost(post);
                  }),
              _actionMenuItem(context,
                  icon: post.isBookMarked == false
                      ? Icons.bookmark_border_outlined
                      : Icons.bookmark_outlined,
                  label: post.isBookMarked == false
                      ? 'Save Post'.tr
                      : 'Remove Save'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    if (post.isBookMarked == false) {
                      controller.bookmarkPost(post.id ?? '',
                          post.post_privacy.toString(), widget.postIndex);
                    } else {
                      controller.removeBookmarkPost(
                          post.id ?? '', post.bookmark?.id ?? '', widget.postIndex);
                    }
                  }),
              _actionMenuItem(context,
                  icon: Icons.link_outlined,
                  label: 'Copy link'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    CopyToClipboardUtils.copyToClipboard(
                        '${ApiConstant.SERVER_IP}/notification/${post.id}', 'Post');
                  }),
              Divider(
                  height: 1,
                  color: FeedDesignTokens.divider(context)),
              _actionMenuItem(context,
                  icon: Icons.delete_outline,
                  label: 'Delete'.tr,
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    showDeleteAlertDialogs(
                      context: context,
                      onCancel: () => Navigator.of(context).pop(false),
                      onDelete: () {
                        final pc = Get.put(ProfileController());
                        controller.removePostFromFeed(post.id ?? '');
                        pc.deletePost(post.id ?? '');
                        Navigator.of(context).pop(false);
                        Get.back(); // close comment page
                      },
                    );
                  }),
            ] else ...[
              _actionMenuItem(context,
                  icon: post.isBookMarked == false
                      ? Icons.bookmark_border_outlined
                      : Icons.bookmark_outlined,
                  label: post.isBookMarked == false
                      ? 'Save Post'.tr
                      : 'Remove Save'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    if (post.isBookMarked == false) {
                      controller.bookmarkPost(post.id ?? '',
                          post.post_privacy.toString(), widget.postIndex);
                    } else {
                      controller.removeBookmarkPost(
                          post.id ?? '', post.bookmark?.id ?? '', widget.postIndex);
                    }
                  }),
              _actionMenuItem(context,
                  icon: Icons.link_outlined,
                  label: 'Copy link'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    CopyToClipboardUtils.copyToClipboard(
                        '${ApiConstant.SERVER_IP}/notification/${post.id}', 'Post');
                  }),
              _actionMenuItem(context,
                  icon: Icons.visibility_off_outlined,
                  label: 'Hide Post'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    controller.hidePost(1, post.id ?? '', widget.postIndex);
                    Get.back(); // close comment page
                  }),
              _actionMenuItem(context,
                  icon: Icons.flag_outlined,
                  label: 'Report Post'.tr,
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _actionMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: isDestructive
              ? Colors.red
              : FeedDesignTokens.textPrimary(context),
          size: 24),
      title: Text(label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDestructive
                ? Colors.red
                : FeedDesignTokens.textPrimary(context),
          )),
      onTap: onTap,
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  INPUT BAR — Camera | "Comment as [Name]" | icons / send
  //  Facebook exact style — send button appears when typing
  // ═══════════════════════════════════════════════════════════
  Widget _buildInputBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? const Color(0xFFB0B3B8) : const Color(0xFF65676B);

    return Container(
      decoration: BoxDecoration(
        color: FeedDesignTokens.cardBg(context),
        border: Border(
          top: BorderSide(
            color: FeedDesignTokens.divider(context),
            width: 0.5,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Reply indicator ──
          Obx(
            () => (controller.isReply.value || controller.isReplyOfReply.value)
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: FeedDesignTokens.inputBg(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.reply,
                            size: 16,
                            color: FeedDesignTokens.textSecondary(context)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            controller.isReply.value
                                ? 'Replying to ${controller.commentModel.value.user_id?.first_name ?? "User"}'
                                : 'Replying to ${controller.commentReplyModel.value.replies_user_id?.first_name ?? "User"}',
                            style: TextStyle(
                              fontSize: 13,
                              color: FeedDesignTokens.textSecondary(context),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.isReply.value = false;
                            controller.isReplyOfReply.value = false;
                          },
                          child: Icon(Icons.close,
                              size: 16,
                              color: FeedDesignTokens.textSecondary(context)),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Media preview ──
          Obx(() => controller.xfiles.value.isNotEmpty
              ? Container(
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.xfiles.value.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final file = controller.xfiles.value[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(file.path),
                                width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: InkWell(
                              onTap: () {
                                controller.xfiles.value.removeAt(index);
                                controller.xfiles.refresh();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : const SizedBox.shrink()),

          // ── Facebook-style comment input ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Camera icon — standalone, left of pill
              GestureDetector(
                onTap: () => controller.pickFiles(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 24,
                    color: iconColor,
                  ),
                ),
              ),
              // Single rounded pill: text + icons inside
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF3A3B3C)
                        : const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Text input
                      Expanded(
                        child: Obx(
                          () => TextField(
                            focusNode: _focusNode,
                            controller: controller.commentController,
                            cursorColor: PRIMARY_COLOR,
                            minLines: 1,
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: FeedDesignTokens.textPrimary(context),
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              isDense: true,
                              filled: false,
                              hintText: controller.isReply.value
                                  ? 'Reply to ${controller.commentModel.value.user_id?.first_name}...'
                                  : controller.isReplyOfReply.value
                                      ? 'Reply to ${controller.commentReplyModel.value.replies_user_id?.first_name}...'
                                      : 'Comment as ${controller.userModel.first_name ?? ""}',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: iconColor,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendComment(),
                          ),
                        ),
                      ),
                      // Right-side icons OR send button
                      Obx(() => _hasText.value
                          ? const SizedBox.shrink()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // AI / Sparkle icon
                                GestureDetector(
                                  onTap: () {
                                    Get.snackbar(
                                      'AI Suggestions'.tr,
                                      'Coming soon'.tr,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                  child: Icon(
                                    Icons.auto_awesome_outlined,
                                    size: 22,
                                    color: iconColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // GIF icon
                                GestureDetector(
                                  onTap: () {
                                    Get.snackbar(
                                      'GIF'.tr,
                                      'GIF picker coming soon'.tr,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: iconColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'GIF',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: iconColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Emoji / Sticker picker
                                GestureDetector(
                                  onTap: () async {
                                    final result = await EmojiStickerPickerService()
                                        .showEmojiStrickerBottomSheet();
                                    if (result != null && result.name != null) {
                                      // Insert emoji/sticker text at cursor
                                      final text = controller.commentController.text;
                                      final selection = controller.commentController.selection;
                                      final cursorPos = selection.baseOffset >= 0
                                          ? selection.baseOffset
                                          : text.length;
                                      final newText = text.substring(0, cursorPos) +
                                          (result.name ?? '') +
                                          text.substring(cursorPos);
                                      controller.commentController.text = newText;
                                      controller.commentController.selection =
                                          TextSelection.collapsed(
                                              offset: cursorPos + (result.name?.length ?? 0));
                                    }
                                  },
                                  child: Icon(
                                    Icons.sentiment_satisfied_alt_outlined,
                                    size: 22,
                                    color: iconColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            )),
                    ],
                  ),
                ),
              ),
              // ── Send button (appears when typing) ──
              Obx(() => _hasText.value
                  ? GestureDetector(
                      onTap: _sendComment,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0084FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }

  void _sendComment() {
    if (controller.isReply.value) {
      if (controller.commentController.text.trim().isNotEmpty ||
          controller.processedCommentFileData.value.isNotEmpty) {
        controller.commentReply(
          comment_id: controller.commentsID.value,
          replies_comment_name: controller.commentController.text,
          post_id: postModel.id ?? '',
          postIndex: widget.postIndex,
          file: controller.processedCommentFileData.value,
        );
        controller.isReply.value = false;
        controller.commentController.clear();
      }
    } else if (controller.isReplyOfReply.value) {
      if (controller.commentController.text.trim().isNotEmpty ||
          controller.processedCommentFileData.value.isNotEmpty) {
        controller.commentReply(
          comment_id: controller.commentsID.value,
          replies_comment_name: controller.commentController.text,
          post_id: postModel.id ?? '',
          postIndex: widget.postIndex,
          file: controller.processedCommentFileData.value,
        );
        controller.isReplyOfReply.value = false;
        controller.commentController.clear();
      }
    } else {
      if (controller.commentController.text.trim().isNotEmpty ||
          controller.xfiles.value.isNotEmpty) {
        controller.commentOnPost(widget.postIndex, postModel);
      }
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  FACEBOOK-STYLE COMMENT TILE — No bubble, plain text
//  Long-press shows reaction emoji popup (like Facebook)
//  Own comments get edit / delete via three-dot menu
// ═══════════════════════════════════════════════════════════════════════
class _FbCommentTile extends StatelessWidget {
  const _FbCommentTile({
    required this.comment,
    required this.controller,
    required this.postIndex,
    required this.focusNode,
  });

  final CommentModel comment;
  final HomeController controller;
  final int postIndex;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final user = comment.user_id;
    final currentUserId = controller.userModel.id ?? '';
    final isOwner = user?.id == currentUserId;
    final mediaPath = comment.image_or_video ?? '';
    final isVideo = _isVideoFile(mediaPath);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar ──
              GestureDetector(
                onTap: () => ProfileNavigator.navigateToProfile(
                    username: user?.username ?? '', isFromReels: 'false'),
                child: ClipOval(
                  child: CustomCachedNetworkImage(
                    imageUrl: (user?.profile_pic ?? '').formatedProfileUrl,
                    height: 36,
                    width: 36,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // ── Content ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name · time
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => ProfileNavigator.navigateToProfile(
                              username: user?.username ?? '',
                              isFromReels: 'false'),
                          child: Text(
                            '${user?.first_name ?? ''} ${user?.last_name ?? ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (user?.isProfileVerified == true) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.verified,
                              color: PRIMARY_COLOR, size: 14),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text('·',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: FeedDesignTokens.textSecondary(
                                      context))),
                        ),
                        Text(
                          getDynamicFormatedCommentTime(
                              comment.createdAt ?? ''),
                          style: TextStyle(
                            fontSize: 12,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                    // Comment text (no bubble)
                    if (comment.comment_name != null &&
                        comment.comment_name != '' &&
                        comment.comment_name != 'null')
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: SmartText(comment.comment_name ?? ''),
                      ),

                    // Media (image or video)
                    if (mediaPath.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: isVideo
                            ? NewsFeedPostVideoPlayer(
                                onNavigate: () => Get.to(
                                    PostDetailsVideoScreen(
                                        videoSrc:
                                            '${ApiConstant.SERVER_IP_PORT}/$mediaPath')),
                                postId: '',
                                videoSrc:
                                    '${ApiConstant.SERVER_IP_PORT}/$mediaPath',
                              )
                            : GestureDetector(
                                onTap: () => Get.to(() => SingleImage(
                                    imgURL:
                                        '${ApiConstant.SERVER_IP_PORT}/$mediaPath')),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CustomCachedNetworkImage(
                                    imageUrl:
                                        '${ApiConstant.SERVER_IP_PORT}/$mediaPath',
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),

                    // Action row: time | CommentReactionButton | Reply | ⋯ own menu
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          // Reaction button (long-press shows emoji popup)
                          CommentReactionButton(
                            selectedReaction: getSelectedCommentReaction(
                                comment, currentUserId),
                            onChangedReaction: (reaction) {
                              controller.commentReaction(
                                postIndex: postIndex,
                                reaction_type: reaction.value,
                                post_id: comment.post_id ?? '',
                                comment_id: comment.id ?? '',
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          // Reply
                          InkWell(
                            onTap: () {
                              controller.commentsID.value =
                                  '${comment.id}';
                              controller.postID.value =
                                  '${comment.post_id}';
                              controller.isReply.value = true;
                              controller.isReplyOfReply.value = false;
                              controller.commentModel.value = comment;
                              FocusScope.of(context)
                                  .requestFocus(focusNode);
                            },
                            child: Text(
                              'Reply'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: FeedDesignTokens.textSecondary(
                                    context),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Thumbs up (quick tap)
                          InkWell(
                            onTap: () {
                              controller.commentReaction(
                                postIndex: postIndex,
                                reaction_type: 'like',
                                post_id: comment.post_id ?? '',
                                comment_id: comment.id ?? '',
                              );
                            },
                            child: Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 16,
                              color: _hasUserReacted(comment, currentUserId)
                                  ? PRIMARY_COLOR
                                  : FeedDesignTokens.textSecondary(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Thumbs down (quick tap)
                          InkWell(
                            onTap: () {
                              controller.commentReaction(
                                postIndex: postIndex,
                                reaction_type: 'dislike',
                                post_id: comment.post_id ?? '',
                                comment_id: comment.id ?? '',
                              );
                            },
                            child: Icon(
                              Icons.thumb_down_alt_outlined,
                              size: 16,
                              color: FeedDesignTokens.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ── Edit / Delete menu (own comments only) ──
              if (isOwner)
                SizedBox(
                  width: 28,
                  height: 28,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    icon: Icon(Icons.more_horiz,
                        size: 18,
                        color: FeedDesignTokens.textSecondary(context)),
                    color: FeedDesignTokens.cardBg(context),
                    offset: const Offset(-40, 0),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editComment(comment);
                      } else if (value == 'delete') {
                        _deleteComment(context, comment);
                      }
                    },
                    itemBuilder: (_) {
                      final items = <PopupMenuEntry<String>>[];
                      // Only show edit if there's text to edit
                      if (comment.image_or_video == null ||
                          (comment.comment_name?.isNotEmpty ?? false)) {
                        items.add(PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit_outlined, size: 18),
                              const SizedBox(width: 8),
                              Text('Edit'.tr),
                            ],
                          ),
                        ));
                      }
                      items.add(PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            const SizedBox(width: 8),
                            Text('Delete'.tr,
                                style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ));
                      return items;
                    },
                  ),
                ),
            ],
          ),

          // ── Replies ──
          if ((comment.replies?.length ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.only(left: 46, top: 4),
              child: Column(
                children: List.generate(
                  comment.replies!.length,
                  (i) => _FbReplyTile(
                    reply: comment.replies![i],
                    parentComment: comment,
                    controller: controller,
                    postIndex: postIndex,
                    focusNode: focusNode,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _editComment(CommentModel cm) async {
    await Get.toNamed(Routes.EDIT_POST_COMMENT, arguments: {
      'post_comment': cm.comment_name,
      'post_id': cm.post_id,
      'comment_id': cm.id,
      'comment_type': cm.comment_type,
      'image_video': cm.image_or_video,
    });
    controller.updatePostList(cm.post_id ?? '', postIndex);
  }

  void _deleteComment(BuildContext context, CommentModel cm) {
    showDeleteAlertDialogs(
      context: context,
      onCancel: () => Navigator.of(context).pop(false),
      onDelete: () {
        controller.commentDelete(
            cm.id ?? '', cm.post_id ?? '', postIndex);
        Navigator.of(context).pop(false);
      },
    );
  }

  bool _hasUserReacted(CommentModel comment, String userId) {
    return comment.comment_reactions?.any((r) => r.user_id == userId) ?? false;
  }

  bool _isVideoFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') ||
        ext.endsWith('.mov') ||
        ext.endsWith('.mkv') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.webm');
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  REPLY TILE — Same style, indented
//  Includes reaction popup + edit/delete for own replies
// ═══════════════════════════════════════════════════════════════════════
class _FbReplyTile extends StatelessWidget {
  const _FbReplyTile({
    required this.reply,
    required this.parentComment,
    required this.controller,
    required this.postIndex,
    required this.focusNode,
  });

  final CommentReplay reply;
  final CommentModel parentComment;
  final HomeController controller;
  final int postIndex;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final user = reply.replies_user_id;
    final currentUserId = controller.userModel.id ?? '';
    final isOwner = user?.id == currentUserId;
    final replyMedia = reply.image_or_video ?? '';
    final isVideo = replyMedia.toLowerCase().endsWith('.mp4') ||
        replyMedia.toLowerCase().endsWith('.mov') ||
        replyMedia.toLowerCase().endsWith('.mkv') ||
        replyMedia.toLowerCase().endsWith('.avi') ||
        replyMedia.toLowerCase().endsWith('.webm');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => ProfileNavigator.navigateToProfile(
                username: user?.username ?? '', isFromReels: 'false'),
            child: ClipOval(
              child: CustomCachedNetworkImage(
                imageUrl: (user?.profile_pic ?? '').formatedProfileUrl,
                height: 28,
                width: 28,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name · time
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => ProfileNavigator.navigateToProfile(
                          username: user?.username ?? '',
                          isFromReels: 'false'),
                      child: Text(
                        '${user?.first_name ?? ''} ${user?.last_name ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text('·',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  FeedDesignTokens.textSecondary(context))),
                    ),
                    Text(
                      getDynamicFormatedCommentTime(reply.createdAt ?? ''),
                      style: TextStyle(
                        fontSize: 11,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ),
                  ],
                ),
                // Reply text
                if (reply.replies_comment_name != null &&
                    reply.replies_comment_name != '' &&
                    reply.replies_comment_name != 'null')
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SmartText(reply.replies_comment_name ?? ''),
                  ),

                // Media
                if (replyMedia.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: isVideo
                        ? NewsFeedPostVideoPlayer(
                            onNavigate: () => Get.to(PostDetailsVideoScreen(
                                videoSrc:
                                    '${ApiConstant.SERVER_IP_PORT}/$replyMedia')),
                            postId: '',
                            videoSrc:
                                '${ApiConstant.SERVER_IP_PORT}/$replyMedia',
                          )
                        : GestureDetector(
                            onTap: () => Get.to(() => SingleImage(
                                imgURL:
                                    '${ApiConstant.SERVER_IP_PORT}/$replyMedia')),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CustomCachedNetworkImage(
                                imageUrl:
                                    '${ApiConstant.SERVER_IP_PORT}/$replyMedia',
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),

                // Action row
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      // Reaction button (long-press shows emoji popup)
                      CommentReactionButton(
                        selectedReaction: getSelectedCommentReplayReaction(
                            reply, currentUserId),
                        onChangedReaction: (reaction) {
                          controller.commentReplyReaction(
                            postIndex,
                            reaction.value,
                            parentComment.post_id ?? '',
                            parentComment.id ?? '',
                            reply.id ?? '',
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          controller.commentsID.value =
                              '${parentComment.id}';
                          controller.postID.value =
                              '${parentComment.post_id}';
                          controller.isReply.value = false;
                          controller.isReplyOfReply.value = true;
                          controller.commentReplyModel.value = reply;
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                        child: Text(
                          'Reply'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          controller.commentReplyReaction(
                            postIndex,
                            'like',
                            parentComment.post_id ?? '',
                            parentComment.id ?? '',
                            reply.id ?? '',
                          );
                        },
                        child: Icon(Icons.thumb_up_alt_outlined,
                            size: 14,
                            color: FeedDesignTokens.textSecondary(context)),
                      ),
                      const SizedBox(width: 14),
                      InkWell(
                        onTap: () {
                          controller.commentReplyReaction(
                            postIndex,
                            'dislike',
                            parentComment.post_id ?? '',
                            parentComment.id ?? '',
                            reply.id ?? '',
                          );
                        },
                        child: Icon(Icons.thumb_down_alt_outlined,
                            size: 14,
                            color: FeedDesignTokens.textSecondary(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── Edit / Delete menu (own replies only) ──
          if (isOwner)
            SizedBox(
              width: 24,
              height: 24,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                iconSize: 16,
                icon: Icon(Icons.more_horiz,
                    size: 16,
                    color: FeedDesignTokens.textSecondary(context)),
                color: FeedDesignTokens.cardBg(context),
                offset: const Offset(-40, 0),
                onSelected: (value) {
                  if (value == 'edit') {
                    _editReply(reply);
                  } else if (value == 'delete') {
                    _deleteReply(context, reply);
                  }
                },
                itemBuilder: (_) {
                  final items = <PopupMenuEntry<String>>[];
                  if (reply.image_or_video == null ||
                      (reply.replies_comment_name?.isNotEmpty ?? false)) {
                    items.add(PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 16),
                          const SizedBox(width: 8),
                          Text('Edit'.tr, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ));
                  }
                  items.add(PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline,
                            size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Delete'.tr,
                            style:
                                const TextStyle(fontSize: 14, color: Colors.red)),
                      ],
                    ),
                  ));
                  return items;
                },
              ),
            ),
        ],
      ),
    );
  }

  void _editReply(CommentReplay r) async {
    await Get.toNamed(Routes.EDIT_REPLY_POST_COMMENT, arguments: {
      'reply_comment': r.replies_comment_name,
      'replay_post_id': r.post_id,
      'comment_replay_id': r.id,
      'comment_type': r.comment_type,
      'image_video': r.image_or_video,
    });
    controller.updatePostList(r.post_id ?? '', postIndex);
  }

  void _deleteReply(BuildContext context, CommentReplay r) {
    showDeleteAlertDialogs(
      context: context,
      onCancel: () => Navigator.of(context).pop(false),
      onDelete: () {
        controller.replyDelete(
            r.id ?? '', r.post_id ?? '', postIndex);
        Navigator.of(context).pop(false);
      },
    );
  }
}
