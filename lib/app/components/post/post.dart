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
                if (model.whyShown != null && model.whyShown!.isNotEmpty)
                  WhyShownWidget(text: model.whyShown!, model: model),

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
}


