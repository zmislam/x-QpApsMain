import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alert_dialogs/delete_alert_dialogs.dart';
import '../../../extension/string/string_image_path.dart';

import '../../../config/constants/feed_design_tokens.dart';
import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../models/user_id.dart';
import '../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/post_utlis.dart';
import '../../image.dart';
import '../../post_tag_list.dart';
import '../post_icons/connection_status_icons.dart';
import '../../../repository/user_relationships_repository.dart';

import '../feed_controls_bottomsheet.dart';
import '../report_post_modal.dart';

class PostHeader extends StatelessWidget {
  final PostModel model;
  final VoidCallback onTapEditPost;
  final VoidCallback? onTapHidePost;
  final VoidCallback? onTapBookMarkPost;
  final VoidCallback? onTapBlockUser;
  final VoidCallback? onTapRemoveBookMarkPost;
  final VoidCallback? onTapCopyPost;
  final VoidCallback? onTapViewPostHistory;
  final VoidCallback? onTapPinPost;
  final String? viewType;
  final bool hideActionIcons;

  PostHeader(
      {super.key,
      required this.model,
      required this.onTapEditPost,
      required this.onTapBlockUser,
      this.onTapHidePost,
      this.onTapBookMarkPost,
      this.onTapCopyPost,
      this.onTapViewPostHistory,
      this.viewType,
      this.onTapPinPost,
      this.onTapRemoveBookMarkPost,
      this.hideActionIcons = false});
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    UserIdModel? userModel = model.user_id;
    final UserModel currentUserModel = LoginCredential().getUserData();

    // ─── Campaign post header ───
    if (model.post_type == 'campaign') {
      return _buildCampaignHeader(context);
    }

    // ─── Shared post header ───
    if (model.post_type == 'Shared') {
      return _buildSharedHeader(context, currentUserModel);
    }

    // ─── Default / Normal post header ───
    return _buildNormalHeader(context, userModel, currentUserModel);
  }

  // ═══════════════════════════════════════════════════════════
  // Campaign Header
  // ═══════════════════════════════════════════════════════════
  Widget _buildCampaignHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: FeedDesignTokens.cardPaddingV,
        left: FeedDesignTokens.cardPaddingH,
        right: FeedDesignTokens.cardPaddingH,
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.PAGE_PROFILE, arguments: model.campaign_id?.id);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(FeedDesignTokens.avatarSize / 2),
              child: RoundCornerNetworkImage(
                imageUrl: (model.adProduct?.pageInfo?.profilePic ?? '')
                    .formatedProfileUrl,
              ),
            ),
            const SizedBox(width: FeedDesignTokens.avatarSize * 0.25),
            // Name + Meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.adProduct?.pageInfo?.pageName}'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: FeedDesignTokens.nameSize,
                      color: FeedDesignTokens.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Sponsored'.tr,
                        style: TextStyle(
                          fontSize: FeedDesignTokens.timeSize,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.public,
                        size: 14,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // Shared Post Header
  // ═══════════════════════════════════════════════════════════
  Widget _buildSharedHeader(BuildContext context, UserModel currentUserModel) {
    return Padding(
      padding: const EdgeInsets.only(
        top: FeedDesignTokens.cardPaddingV,
        left: FeedDesignTokens.cardPaddingH,
        right: 4,
      ),
      child: InkWell(
        onTap: () {
          ProfileNavigator.navigateToProfile(
              username: model.share_post_id?.user_id?.username ?? '',
              isFromReels: 'false');
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(FeedDesignTokens.avatarSize / 2),
              child: RoundCornerNetworkImage(
                imageUrl: (model.share_post_id?.user_id?.profile_pic ?? '')
                    .formatedProfileUrl,
              ),
            ),
            const SizedBox(width: FeedDesignTokens.avatarSize * 0.25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with feeling/location/tags
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            '${model.share_post_id?.user_id?.first_name} ${model.share_post_id?.user_id?.last_name}'
                                .tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: FeedDesignTokens.nameSize,
                          color: FeedDesignTokens.textPrimary(context),
                        ),
                      ),
                      if (model.share_post_id?.feeling_id != null) ...[
                        TextSpan(
                          text: ' is feeling'.tr,
                          style: TextStyle(
                            fontSize: FeedDesignTokens.nameSize - 1,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: ReactionIcon(
                                model.feeling_id?.logo.toString() ?? ''),
                          ),
                        ),
                        TextSpan(
                          text: ' ${model.feeling_id?.feelingName}'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: FeedDesignTokens.nameSize - 1,
                            color: FeedDesignTokens.textPrimary(context),
                          ),
                        ),
                      ],
                      TextSpan(
                        text: getSharedLocationText(model),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: FeedDesignTokens.nameSize - 1,
                          color: FeedDesignTokens.textPrimary(context),
                        ),
                      ),
                      TextSpan(
                        text: getTagText(model),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => PostTagList(postModel: model));
                          },
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: FeedDesignTokens.nameSize - 1,
                          color: FeedDesignTokens.textPrimary(context),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 2),
                  // Timestamp + privacy
                  Row(
                    children: [
                      Text(
                        getDynamicFormatedTime(
                            model.share_post_id?.createdAt ?? ''),
                        style: TextStyle(
                          fontSize: FeedDesignTokens.timeSize,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        getTextAsPostType(
                            model.share_post_id?.post_type ?? ''),
                        style: TextStyle(
                          fontSize: FeedDesignTokens.timeSize,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                      Icon(
                        getIconAsPrivacy(
                            model.share_post_id?.post_privacy ?? ''),
                        size: 14,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Add Friend Action ───
  void _handleAddFriend(String userId) async {
    if (userId.isEmpty) return;
    try {
      await UserRelationshipRepository().sendFriendRequestToUser(userId: userId);
      model.isFriendRequestSended = true;
      Get.snackbar(
        'Friend Request Sent'.tr,
        'Your friend request has been sent.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to send friend request.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // Normal Post Header (Facebook-style)
  // ═══════════════════════════════════════════════════════════
  Widget _buildNormalHeader(
      BuildContext context, UserIdModel? userModel, UserModel currentUserModel) {
    final bool isOwner = model.user_id?.id == currentUserModel.id;
    final connectionStatus = getUserPostConnectionStatus(model, currentUserModel.id ?? '');
    final connectionIcon = getConnectionStatusIcon(
      connectionStatus,
      size: 16,
      onAddFriend: connectionStatus == ConnectionStatus.notConnected
          ? () => _handleAddFriend(model.user_id?.id ?? '')
          : null,
    );

    return Padding(
      padding: const EdgeInsets.only(
        top: FeedDesignTokens.cardPaddingV,
        left: FeedDesignTokens.cardPaddingH,
        right: 4,
      ),
      child: InkWell(
        onTap: () {
          ProfileNavigator.navigateToProfile(
              username: userModel?.username ?? '', isFromReels: 'false');
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ─── Avatar ───
            ClipRRect(
              borderRadius: BorderRadius.circular(FeedDesignTokens.avatarSize / 2),
              child: RoundCornerNetworkImage(
                imageUrl: (userModel?.profile_pic ?? '').formatedProfileUrl,
              ),
            ),
            const SizedBox(width: FeedDesignTokens.avatarSize * 0.25),

            // ─── Name + Meta ───
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row
                  Row(
                    children: [
                      Flexible(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(children: [
                            TextSpan(
                              text: '${userModel?.first_name} ${userModel?.last_name}'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: FeedDesignTokens.nameSize,
                                color: FeedDesignTokens.textPrimary(context),
                              ),
                            ),
                            // Live indicators
                            if (model.post_type == 'timeline_post' &&
                                model.is_live == true)
                              TextSpan(
                                text: ' was live'.tr,
                                style: TextStyle(
                                  fontSize: FeedDesignTokens.timeSize,
                                  color: FeedDesignTokens.textSecondary(context),
                                ),
                              )
                            else if (model.post_type == 'live' &&
                                model.is_live == true)
                              TextSpan(
                                text: ' is live now'.tr,
                                style: TextStyle(
                                  fontSize: FeedDesignTokens.timeSize,
                                  color: Colors.red,
                                ),
                              )
                            else if (model.feeling_id != null) ...[
                              TextSpan(
                                text: ' is feeling'.tr,
                                style: TextStyle(
                                  fontSize: FeedDesignTokens.timeSize,
                                  color: FeedDesignTokens.textSecondary(context),
                                ),
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: ReactionIcon(
                                      model.feeling_id!.logo.toString()),
                                ),
                              ),
                              TextSpan(
                                text: ' ${model.feeling_id!.feelingName}'.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: FeedDesignTokens.nameSize - 1,
                                  color: FeedDesignTokens.textPrimary(context),
                                ),
                              ),
                            ],
                            // Location
                            TextSpan(
                              text: getLocationText(model),
                              style: TextStyle(
                                fontSize: FeedDesignTokens.timeSize,
                                color: FeedDesignTokens.textSecondary(context),
                              ),
                            ),
                            // Tags
                            TextSpan(
                              text: getTagText(model),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => PostTagList(postModel: model));
                                },
                              style: TextStyle(
                                fontSize: FeedDesignTokens.timeSize,
                                color: FeedDesignTokens.textSecondary(context),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (userModel?.isProfileVerified == true)
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF0D7377),
                          size: 16,
                        ),
                      // Connection status icon (non-owner only)
                      if (!isOwner && connectionIcon != null) ...[
                        const SizedBox(width: 6),
                        connectionIcon,
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Timestamp + privacy row
                  Row(
                    children: [
                      Text(
                        getDynamicFormatedTime(model.createdAt ?? ''),
                        style: TextStyle(
                          fontSize: FeedDesignTokens.timeSize,
                          color: FeedDesignTokens.textSecondary(context),
                        ),
                      ),
                      if (getTextAsPostType(model.post_type ?? '').isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          getTextAsPostType(model.post_type ?? ''),
                          style: TextStyle(
                            fontSize: FeedDesignTokens.timeSize,
                            color: FeedDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                      const SizedBox(width: 4),
                      Icon(
                        getIconAsPrivacy(model.post_privacy ?? ''),
                        size: 14,
                        color: FeedDesignTokens.textSecondary(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Bookmark indicator ───
            if (model.isBookMarked == true)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(
                  Icons.bookmark,
                  size: 18,
                  color: FeedDesignTokens.textSecondary(context),
                ),
              ),

            // ─── Three-dot menu ───
            if (!hideActionIcons)
              _buildThreeDotMenu(context, isOwner),

            // ─── Close / Hide button ───
            if (!hideActionIcons && onTapHidePost != null)
              SizedBox(
                width: FeedDesignTokens.threeDotButtonSize,
                height: FeedDesignTokens.threeDotButtonSize,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onTapHidePost,
                  icon: Icon(
                    Icons.close,
                    color: FeedDesignTokens.textSecondary(context),
                    size: 22,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // Three-dot Menu (FB-style bottom sheet)
  // ═══════════════════════════════════════════════════════════
  Widget _buildThreeDotMenu(BuildContext context, bool isOwner) {
    return SizedBox(
      width: FeedDesignTokens.threeDotButtonSize,
      height: FeedDesignTokens.threeDotButtonSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showPostActionsSheet(context, isOwner),
        icon: Icon(
          Icons.more_horiz,
          color: FeedDesignTokens.textSecondary(context),
          size: 24,
        ),
      ),
    );
  }

  void _showPostActionsSheet(BuildContext context, bool isOwner) {
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
                color: FeedDesignTokens.textSecondary(context).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            if (isOwner) ...[
              // Owner actions
              if (viewType == 'profile')
                _menuItem(
                  context,
                  icon: Icons.push_pin_outlined,
                  label: model.pinPost == false ? 'Pin Post'.tr : 'UnPin Post'.tr,
                  subtitle: model.pinPost == false
                      ? 'Pin this post to your profile'.tr
                      : 'Remove pin from this post'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapPinPost?.call();
                  },
                ),
              _menuItem(context,
                  icon: Icons.edit_outlined,
                  label: 'Edit Post'.tr,
                  subtitle: 'Make changes to this post'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapEditPost.call();
                  }),
              _menuItem(context,
                  icon: Icons.visibility_off_outlined,
                  label: 'Hide Post'.tr,
                  subtitle: 'See fewer posts like this'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapHidePost?.call();
                  }),
              model.isBookMarked == false
                  ? _menuItem(context,
                      icon: Icons.bookmark_border_outlined,
                      label: 'Save Post'.tr,
                      subtitle: 'Add this to your saved items'.tr,
                      onTap: () {
                        Navigator.pop(context);
                        onTapBookMarkPost?.call();
                      })
                  : _menuItem(context,
                      icon: Icons.bookmark_outlined,
                      label: 'Remove Save'.tr,
                      subtitle: 'Remove from your saved items'.tr,
                      onTap: () {
                        Navigator.pop(context);
                        onTapRemoveBookMarkPost?.call();
                      }),
              _menuItem(context,
                  icon: Icons.history_outlined,
                  label: 'Edit History'.tr,
                  subtitle: 'See all edits made to this post'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(Routes.EDIT_HISTORY, arguments: model.id);
                  }),
              _menuItem(context,
                  icon: Icons.notifications_off_outlined,
                  label: 'Turn off notification'.tr,
                  subtitle: 'Stop getting notifications for this'.tr,
                  onTap: null),
              _menuItem(context,
                  icon: Icons.link_outlined,
                  label: 'Copy link'.tr,
                  subtitle: 'Copy post link to clipboard'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapCopyPost?.call();
                  }),
              Divider(
                height: 1,
                color: FeedDesignTokens.divider(context),
              ),
              _menuItem(context,
                  icon: Icons.delete_outline,
                  label: 'Delete'.tr,
                  subtitle: 'Move this post to trash'.tr,
                  isDestructive: true,
                  onTap: () {
                Navigator.pop(context);
                showDeleteAlertDialogs(
                  context: context,
                  onCancel: () {
                    Navigator.of(context).pop(false);
                  },
                  onDelete: () {
                    ProfileController controller =
                        Get.put(ProfileController());
                    HomeController hc = Get.put(HomeController());
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
              // Non-owner actions
              _menuItem(context,
                  icon: Icons.tune,
                  label: 'Manage Feed'.tr,
                  subtitle: 'Control what you see in your feed'.tr,
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
              _menuItem(context,
                  icon: Icons.visibility_off_outlined,
                  label: 'Hide Post'.tr,
                  subtitle: 'See fewer posts like this'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapHidePost?.call();
                  }),
              model.isBookMarked == false
                  ? _menuItem(context,
                      icon: Icons.bookmark_border_outlined,
                      label: 'Save Post'.tr,
                      subtitle: 'Add this to your saved items'.tr,
                      onTap: () {
                        Navigator.pop(context);
                        onTapBookMarkPost?.call();
                      })
                  : _menuItem(context,
                      icon: Icons.bookmark_outlined,
                      label: 'Remove Save'.tr,
                      subtitle: 'Remove from your saved items'.tr,
                      onTap: () {
                        Navigator.pop(context);
                        onTapRemoveBookMarkPost?.call();
                      }),
              _menuItem(context,
                  icon: Icons.block_outlined,
                  label: 'Block User'.tr,
                  subtitle: 'Stop seeing content from this user'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapBlockUser?.call();
                  }),
              _menuItem(context,
                  icon: Icons.notifications_off_outlined,
                  label: 'Turn off notification'.tr,
                  subtitle: 'Stop getting notifications for this'.tr,
                  onTap: null),
              _menuItem(context,
                  icon: Icons.link_outlined,
                  label: 'Copy link'.tr,
                  subtitle: 'Copy post link to clipboard'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapCopyPost?.call();
                  }),
              Divider(
                height: 1,
                color: FeedDesignTokens.divider(context),
              ),
              _menuItem(context,
                  icon: Icons.flag_outlined,
                  label: 'Report'.tr,
                  subtitle: 'Report a problem with this post'.tr,
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

  /// Facebook-style menu item using ListTile for consistent design
  Widget _menuItem(
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

  // ═══════════════════════════════════════════════════════════
  // Utility Methods (preserved from original)
  // ═══════════════════════════════════════════════════════════

  IconData getIconAsPrivacy(String postPrivacy) {
    switch (postPrivacy) {
      case 'public':
        return Icons.public;
      case 'only_me':
        return Icons.lock;
      case 'friends':
        return Icons.people;
      default:
        return Icons.public;
    }
  }

  String getTextAsPostType(String postType) {
    switch (postType) {
      case 'campaign':
        return 'Sponsored ';
      default:
        return '';
    }
  }

  String getHeaderTextAsPostType(PostModel postModel) {
    switch (model.post_type) {
      case 'profile_picture':
        return 'updated his profile picture';
      case 'cover_picture':
        return 'updated his cover photo';
      default:
        return '';
    }
  }

  String getFeelingText(PostModel postModel) {
    return (model.feeling_id?.feelingName != null)
        ? ' is feeling ${model.feeling_id?.feelingName}'
        : '';
  }

  String getLocationText(PostModel postModel) {
    return (postModel.locationName.toString().contains('null') ||
            postModel.locationName.toString() == '')
        ? ''
        : ' at ${postModel.locationName}';
  }

  String getSharedLocationText(PostModel postModel) {
    if (postModel.share_post_id?.locationName == null ||
        postModel.share_post_id?.locationName == '') {
      return '';
    }
    return ((postModel.share_post_id?.locationName ?? '').contains('null'))
        ? ''
        : ' at ${model.share_post_id?.locationName}';
  }

  String getTagText(PostModel postModel) {
    if (postModel.taggedUserList != null) {
      if (postModel.taggedUserList!.length == 1) {
        return ' with ${postModel.taggedUserList![0].user?.firstName ?? ''} ${postModel.taggedUserList![0].user?.lastName ?? ''}';
      } else if (postModel.taggedUserList!.length > 1) {
        return ' with ${postModel.taggedUserList![0].user?.firstName ?? ''} and ${postModel.taggedUserList!.length - 1} others';
      }
    }
    return '';
  }

  String getSharedHeaderTextAsPostType(PostModel postModel) {
    switch (model.share_post_id!.post_type) {
      case 'profile_picture':
        return 'updated his profile picture';
      case 'cover_picture':
        return 'updated his cover photo';
      default:
        return '';
    }
  }

  Widget ReactionIcon(String reactionPath) {
    return Image(
        height: 17, image: NetworkImage((reactionPath).formatedFeelingUrl));
  }
}
