import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants/feed_design_tokens.dart';
import '../../models/post.dart';
import '../../routes/app_pages.dart';
import 'post_body/post_body.dart';
import 'post_footer/post_footer.dart';
import 'post_header/group_post_header.dart';
import 'post_header/page_post_header.dart';
import 'post_header/post_header.dart';
import 'post_header/share_reel_header.dart';
import 'post_header/shared_post_header.dart';
import 'why_shown.dart';
import '../../data/login_creadential.dart';
import '../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import '../alert_dialogs/delete_alert_dialogs.dart';
import 'feed_controls_bottomsheet.dart';
import 'report_post_modal.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.model,
      required this.onSelectReaction,
      required this.onPressedComment,
      required this.onPressedShare,
      required this.onTapBodyViewMoreMedia,
      this.onTapEditPost,
      this.onTapCopyPost,
      this.onTapBookMardPost,
      this.onTapRemoveBookMardPost,
      this.onTapHidePost,
      this.onTapViewOtherProfile,
      this.onTapShareViewOtherProfile,
      this.viewType,
      this.onTapPinPost,
      this.adVideoLink,
      required this.onTapBlockUser,
      this.onTapViewPostHistory,
      required this.onTapViewReactions,
      required this.onSixSeconds,
      this.campaignWebUrl,
      this.campaignName,
      this.actionButtonText,
      this.campaignDescription,
      this.campaignCallToAction,
      this.index});

  final PostModel model;
  final Function(String reaction) onSelectReaction;
  final VoidCallback onPressedComment;
  final VoidCallback onPressedShare;
  final VoidCallback onTapBodyViewMoreMedia;
  final VoidCallback onTapViewReactions;
  final VoidCallback? onTapEditPost;
  final VoidCallback onTapBlockUser;
  final VoidCallback? onTapHidePost;
  final VoidCallback? onTapBookMardPost;
  final VoidCallback? onTapRemoveBookMardPost;
  final VoidCallback? onTapViewOtherProfile;
  final VoidCallback? onTapShareViewOtherProfile;
  final VoidCallback? onTapCopyPost;
  final VoidCallback? onTapViewPostHistory;
  final VoidCallback? onTapPinPost;
  final VoidCallback onSixSeconds;
  final String? viewType;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? actionButtonText;
  final String? campaignName;
  final String? campaignDescription;
  final VoidCallback? campaignCallToAction;

  // ignore: prefer_typing_uninitialized_variables
  final index;

  bool get _hasWhyShown => model.whyShown != null && model.whyShown!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (model.user_id == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: FeedDesignTokens.cardBg(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ─── WhyShown badge (EdgeRank context) ───
                if (_hasWhyShown)
                  WhyShownWidget(
                    text: model.whyShown!,
                    model: model,
                    onTapMenu: () => _showPostActionsSheet(context),
                    onTapClose: onTapHidePost,
                  ),

                // ─── Header (varies by post type) ───
                _buildHeader(context),

                // ─── Body ───
                _buildBody(),

                // ─── Footer ───
                PostFooter(
                  model: model,
                  onSelectReaction: onSelectReaction,
                  onPressedComment: onPressedComment,
                  onPressedShare: onPressedShare,
                  onTapViewReactions: onTapViewReactions,
                ),
              ],
            ),
            // X button moved into individual header widgets
          ],
        ),
      ),
    );
  }

  /// Build the appropriate header widget based on post_type.
  Widget _buildHeader(BuildContext context) {
    if (model.post_type == 'shared_reels') {
      return Column(
        children: [
          SharedPostHeader(
            model: model,
            onTapEditPost: onTapEditPost ?? () {},
            onTapCopyPost: onTapCopyPost ?? () {},
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: FeedDesignTokens.divider(context), width: 0.5),
              ),
            ),
            child: SharedReelHeader(
              model: model,
              onTapEditPost: onTapEditPost ?? () {},
            ),
          ),
        ],
      );
    }

    if (model.post_type == 'Shared') {
      return Column(
        children: [
          SharedPostHeader(
            model: model,
            onTapEditPost: onTapEditPost ?? () {},
            onTapHidePost: onTapHidePost ?? () {},
            onTapBookMarkPost: onTapBookMardPost ?? () {},
            onTapCopyPost: onTapCopyPost ?? () {},
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: FeedDesignTokens.divider(context),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildSharedInnerHeader(context),
              ],
            ),
          ),
        ],
      );
    }

    // Default / normal post
    return _buildNormalHeader(context);
  }

  /// Inner header for shared posts
  Widget _buildSharedInnerHeader(BuildContext context) {
    if ((model.share_post_id?.groupId?.groupName?.length ?? 0) > 1) {
      return GroupPostHeader(
        onTapBlockUser: onTapBlockUser,
        model: model,
        onTapEditPost: onTapEditPost ?? () {},
        onTapViewPostHistory: onTapViewPostHistory ?? () {},
        onTapBookMarkPost: onTapBookMardPost ?? () {},
        onTapHidePost: onTapHidePost ?? () {},
        onTapCopyPost: onTapCopyPost ?? () {},
        viewType: viewType ?? '',
      );
    }
    if (model.share_post_id?.post_type == 'campaign' ||
        (model.share_post_id?.page_id?.pageName?.length ?? 0) > 1) {
      return PagePostHeader(
        model: model,
        onTapEditPost: onTapEditPost ?? () {},
        onTapBookMarkPost: onTapBookMardPost ?? () {},
        onTapCopyPost: onTapCopyPost ?? () {},
        onTapViewPostHistory: () {
          Get.back();
          Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
        },
        onTapPinPost: onTapPinPost ?? () {},
        onTapHidePost: onTapHidePost,
        onTapRemoveBookMarkPost: () {
          onTapRemoveBookMardPost!();
        },
        viewType: viewType ?? '',
      );
    }
    return PostHeader(
      onTapBlockUser: onTapBlockUser,
      model: model,
      onTapEditPost: onTapEditPost ?? () {},
      onTapHidePost: onTapHidePost ?? () {},
      onTapBookMarkPost: onTapBookMardPost ?? () {},
      onTapCopyPost: onTapCopyPost ?? () {},
      onTapViewPostHistory: onTapViewPostHistory ?? () {},
      onTapPinPost: onTapPinPost ?? () {},
      onTapRemoveBookMarkPost: onTapRemoveBookMardPost ?? () {},
      viewType: viewType ?? '',
    );
  }

  /// Normal post header
  Widget _buildNormalHeader(BuildContext context) {
    if (model.groupId!.groupName!.length > 1) {
      return GroupPostHeader(
        onTapBlockUser: onTapBlockUser,
        model: model,
        onTapEditPost: onTapEditPost ?? () {},
        onTapViewPostHistory: onTapViewPostHistory ?? () {},
        onTapBookMarkPost: onTapBookMardPost ?? () {},
        onTapHidePost: onTapHidePost ?? () {},
        onTapCopyPost: onTapCopyPost ?? () {},
        viewType: viewType ?? '',
        hideActionIcons: _hasWhyShown,
      );
    }
    if (model.page_id!.pageName!.length > 1) {
      return PagePostHeader(
        model: model,
        onTapEditPost: onTapEditPost ?? () {},
        onTapBookMarkPost: onTapBookMardPost ?? () {},
        onTapCopyPost: onTapCopyPost ?? () {},
        onTapViewPostHistory: () {
          Get.back();
          Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
        },
        onTapPinPost: onTapPinPost ?? () {},
        onTapHidePost: onTapHidePost,
        onTapRemoveBookMarkPost: () {
          onTapRemoveBookMardPost!();
        },
        viewType: viewType ?? '',
        hideActionIcons: _hasWhyShown,
      );
    }
    return PostHeader(
      onTapBlockUser: onTapBlockUser,
      model: model,
      onTapEditPost: onTapEditPost ?? () {},
      onTapHidePost: onTapHidePost ?? () {},
      onTapBookMarkPost: onTapBookMardPost ?? () {},
      onTapCopyPost: onTapCopyPost ?? () {},
      onTapViewPostHistory: onTapViewPostHistory ?? () {},
      onTapPinPost: onTapPinPost ?? () {},
      onTapRemoveBookMarkPost: onTapRemoveBookMardPost ?? () {},
      viewType: viewType ?? '',
      hideActionIcons: _hasWhyShown,
    );
  }

  /// Build the post body view
  Widget _buildBody() {
    if (model.post_type == 'Shared') {
      return PostBodyView(
        adVideoLink: adVideoLink,
        actionButtonText: actionButtonText,
        onSixSeconds: onSixSeconds,
        campaignWebUrl: campaignWebUrl,
        campaignName: campaignName,
        campaignDescription: campaignDescription,
        campaignCallToAction: campaignCallToAction,
        model: model,
        onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
        onTapShareViewOtherProfile: onTapShareViewOtherProfile,
      );
    }
    if (model.post_type == 'shared_reels') {
      return PostBodyView(
        adVideoLink: adVideoLink,
        actionButtonText: actionButtonText,
        campaignWebUrl: campaignWebUrl,
        campaignName: campaignName,
        campaignDescription: campaignDescription,
        campaignCallToAction: campaignCallToAction,
        onSixSeconds: onSixSeconds,
        model: model,
        onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
      );
    }
    return PostBodyView(
      adVideoLink: adVideoLink,
      actionButtonText: actionButtonText,
      campaignWebUrl: campaignWebUrl,
      campaignName: campaignName,
      campaignDescription: campaignDescription,
      campaignCallToAction: campaignCallToAction,
      onSixSeconds: onSixSeconds,
      model: model,
      onTapBodyViewMoreMedia: onTapBodyViewMoreMedia,
      onTapViewOtherProfile: onTapViewOtherProfile ?? () {},
    );
  }

  Widget ReactionIcon(String assetName) {
    return Image(height: 32, image: AssetImage(assetName));
  }

  // ═════════════════════════════════════════════════════════════
  // Generic Post Actions Sheet (used from WhyShown row)
  // ═════════════════════════════════════════════════════════════
  void _showPostActionsSheet(BuildContext context) {
    final isOwner = model.user_id?.id == LoginCredential().getUserData().id;

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
            // ─── Handle bar ───
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
              _postMenuItem(context,
                  icon: Icons.edit_outlined,
                  label: 'Edit Post',
                  subtitle: 'Make changes to this post',
                  onTap: () {
                    Navigator.pop(context);
                    onTapEditPost?.call();
                  }),
              _postMenuItem(context,
                  icon: Icons.visibility_off_outlined,
                  label: 'Hide Post',
                  subtitle: 'See fewer posts like this',
                  onTap: () {
                    Navigator.pop(context);
                    onTapHidePost?.call();
                  }),
              model.isBookMarked == false
                  ? _postMenuItem(context,
                      icon: Icons.bookmark_border_outlined,
                      label: 'Save Post',
                      subtitle: 'Add this to your saved items',
                      onTap: () {
                        Navigator.pop(context);
                        onTapBookMardPost?.call();
                      })
                  : _postMenuItem(context,
                      icon: Icons.bookmark_outlined,
                      label: 'Remove Save',
                      subtitle: 'Remove from your saved items',
                      onTap: () {
                        Navigator.pop(context);
                        onTapRemoveBookMardPost?.call();
                      }),
              _postMenuItem(context,
                  icon: Icons.history_outlined,
                  label: 'Edit History',
                  subtitle: 'See all edits made to this post',
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
                  }),
              _postMenuItem(context,
                  icon: Icons.link_outlined,
                  label: 'Copy link',
                  subtitle: 'Copy post link to clipboard',
                  onTap: () {
                    Navigator.pop(context);
                    onTapCopyPost?.call();
                  }),
              Divider(
                height: 1,
                color: FeedDesignTokens.divider(context),
              ),
              _postMenuItem(context,
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  subtitle: 'Move this post to trash',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    showDeleteAlertDialogs(
                      context: context,
                      onCancel: () {
                        Navigator.of(context).pop(false);
                      },
                      onDelete: () {
                        final ProfileController controller =
                            Get.put(ProfileController());
                        final HomeController hc = Get.put(HomeController());
                        controller.deletePost(model.id.toString());
                        Navigator.of(context).pop(false);
                        controller.postList.value.removeWhere(
                            (element) => element.id == model.id.toString());
                        hc.removePostFromFeed(model.id.toString());
                        controller.postList.refresh();
                      },
                    );
                  }),
            ] else ...[
              _postMenuItem(context,
                  icon: Icons.tune,
                  label: 'Manage Feed',
                  subtitle: 'Control what you see in your feed',
                  onTap: () {
                    Navigator.pop(context);
                    Get.bottomSheet(
                      FeedControlsBottomsheet(
                        post: model,
                        onHide: onTapHidePost,
                      ),
                      isScrollControlled: true,
                    );
                  }),
              _postMenuItem(context,
                  icon: Icons.visibility_off_outlined,
                  label: 'Hide Post',
                  subtitle: 'See fewer posts like this',
                  onTap: () {
                    Navigator.pop(context);
                    onTapHidePost?.call();
                  }),
              model.isBookMarked == false
                  ? _postMenuItem(context,
                      icon: Icons.bookmark_border_outlined,
                      label: 'Save Post',
                      subtitle: 'Add this to your saved items',
                      onTap: () {
                        Navigator.pop(context);
                        onTapBookMardPost?.call();
                      })
                  : _postMenuItem(context,
                      icon: Icons.bookmark_outlined,
                      label: 'Remove Save',
                      subtitle: 'Remove from your saved items',
                      onTap: () {
                        Navigator.pop(context);
                        onTapRemoveBookMardPost?.call();
                      }),
              _postMenuItem(context,
                  icon: Icons.block_outlined,
                  label: 'Block User',
                  subtitle: 'Stop seeing content from this user',
                  onTap: () {
                    Navigator.pop(context);
                    onTapBlockUser.call();
                  }),
              _postMenuItem(context,
                  icon: Icons.link_outlined,
                  label: 'Copy link',
                  subtitle: 'Copy post link to clipboard',
                  onTap: () {
                    Navigator.pop(context);
                    onTapCopyPost?.call();
                  }),
              Divider(
                height: 1,
                color: FeedDesignTokens.divider(context),
              ),
              _postMenuItem(context,
                  icon: Icons.flag_outlined,
                  label: 'Report',
                  subtitle: 'Report a problem with this post',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    Get.bottomSheet(
                      ReportPostModal(postId: model.id ?? ''),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  }),
            ],

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _postMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? Colors.red.shade400
        : FeedDesignTokens.textPrimary(context);

    return ListTile(
      leading: Icon(icon, size: 22, color: color),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isDestructive
                    ? Colors.red.shade300
                    : FeedDesignTokens.textSecondary(context),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}


