import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alert_dialogs/delete_alert_dialogs.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/controllers/group_profile_controller.dart';

import '../../../config/constants/feed_design_tokens.dart';
import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../models/user_id.dart';
import '../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/post_utlis.dart';
import '../../../services/api_communication.dart';
import '../../image.dart';
import '../post_icons/connection_status_icons.dart';
import '../report_post_modal.dart';

class GroupPostHeader extends StatelessWidget {
  final PostModel model;
  final VoidCallback? onTapEditPost;
  final VoidCallback? onTapViewPostHistory;
  final VoidCallback? onTapRemoveBookMarkPost;
  final VoidCallback? onTapHidePost;
  final VoidCallback? onTapBookMarkPost;
  final VoidCallback? onTapCopyPost;
  final VoidCallback onTapBlockUser;
  final String? viewType;

  GroupPostHeader(
      {super.key,
      required this.model,
      this.onTapEditPost,
      this.onTapViewPostHistory,
      this.onTapHidePost,
      this.onTapBookMarkPost,
      this.viewType,
      this.onTapCopyPost,
      required this.onTapBlockUser,
      this.onTapRemoveBookMarkPost});

  HomeController homeController = Get.find();

  final RxBool _isJoined = false.obs;

  /// Toggle join/leave group and call API. Icon updates immediately.
  void _handleJoinGroup() async {
    final groupId = model.groupId.id ?? model.share_post_id?.groupId?.id ?? '';
    if (groupId.isEmpty) return;

    final wasJoined = _isJoined.value;
    _isJoined.value = !wasJoined; // Optimistic update

    try {
      final api = ApiCommunication();
      if (!wasJoined) {
        // Join group
        await api.doPostRequest(
          apiEndPoint: 'groups/send-group-invitation-join-request',
          requestData: {
            'group_id': groupId,
            'type': 'join',
            'user_id_arr': [LoginCredential().getUserData().id ?? ''],
          },
        );
        model.isGroupMember = true;
      } else {
        // Leave group
        final userId = LoginCredential().getUserData().id ?? '';
        await api.doPatchRequest(
          apiEndPoint: 'group-member-status-change?group_id=$groupId&user_id=$userId&status=left',
        );
        model.isGroupMember = false;
      }
    } catch (e) {
      _isJoined.value = wasJoined; // Revert on error
    }
  }

  // GroupProfileController groupController = Get.put(GroupProfileController());
  //
  @override
  Widget build(BuildContext context) {
    UserIdModel userModel = model.user_id!;
    // Initialize join state from model data
    _isJoined.value = model.isGroupMember == true;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          ProfileNavigator.navigateToProfile(
              username: userModel.username ?? '', isFromReels: 'false');
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  String sharedGroupId = model.share_post_id?.groupId?.id ?? '';
                  debugPrint(
                      ':::::::::::::Shared Group Post Header Group Id:$sharedGroupId:::::::::::::');

                  String groupId = model.groupId.id ?? '';
                  if (model.post_type == 'Shared') {
                    debugPrint(
                        ':::::::::::::Shared Group Post Header Group Id:$sharedGroupId:::::::::::::');
                    Get.toNamed(Routes.GROUP_PROFILE,
                        arguments: {'id': sharedGroupId, 'group_type': ''});
                  } else {
                    debugPrint(
                        '::::::::::::: Group Post Header Only Id:${model.groupId.id}:::::::::::::');

                    Get.toNamed(Routes.GROUP_PROFILE,
                        arguments: {'id': groupId, 'group_type': ''});
                  }
                },
                child: Stack(
                  children: [
                    RoundCornerNetworkImage(
                      imageUrl: (model.groupId.groupCoverPic ?? '')
                          .formatedGroupProfileUrl,
                    ),
                    Positioned(
                      bottom: 0,
                      right: -5,
                      child: NetworkCircleAvatar(
                        imageUrl: (model.user_id?.profile_pic ?? '')
                            .formatedProfileUrl,
                        radius: 14,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Group name row (with connection icon inline, matching user post pattern)
                    Row(
                      children: [
                        Flexible(
                          child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.GROUP_PROFILE, arguments: {
                          'id': model.groupId.id,
                          'group_type': ''
                        });
                      },
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: model.post_type == 'Shared'
                              ? '${model.share_post_id?.groupId?.groupName?.capitalizeFirst}'
                              : '${model.groupId.groupName?.capitalizeFirst}',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                            text: ' ${getHeaderTextAsPostType(model)}'.tr,
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 16)),
                        (model.feeling_id != null)
                            ? TextSpan(children: [
                                TextSpan(
                                    children: [
                                      TextSpan(
                                          text: ' is feeling'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      WidgetSpan(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: ReactionIcon(
                                            model.feeling_id!.logo.toString()),
                                      )),
                                      TextSpan(
                                          text: ' ${model.feeling_id!.feelingName}'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                              ])
                            : TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 16)),
                      ])),
                    ),
                        ),
                        // ─── Connection Status Icon (reactive join/joined) ───
                        if (model.user_id?.id != LoginCredential().getUserData().id)
                          Obx(() {
                            final status = _isJoined.value
                                ? ConnectionStatus.groupMember
                                : ConnectionStatus.notGroupMember;
                            final icon = getConnectionStatusIcon(
                              status,
                              size: 16,
                              onJoinGroup: () => _handleJoinGroup(),
                            );
                            if (icon == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: icon,
                            );
                          }),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // ================== username section =================
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ProfileNavigator.navigateToProfile(
                                  username: userModel.username ?? '',
                                  isFromReels: 'false');
                            },
                            child: model.post_type == 'Shared'
                                ? Text('${model.share_post_id?.user_id?.first_name} ${model.share_post_id?.user_id?.last_name} '.tr,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold))
                                : Text('${userModel.first_name} ${userModel.last_name} '.tr,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        // =================== privacy and post date time section =============
                        Row(
                          children: [
                            Text(
                              model.post_type == 'Shared'
                                  ? getDynamicFormatedTime(
                                      model.share_post_id?.createdAt ?? '')
                                  : getDynamicFormatedTime(
                                      model.createdAt ?? ''),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              getTextAsPostType(model.post_type ?? ''),
                              style:
                                  TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              model.post_type == 'Shared'
                                  ? getIconAsPrivacy(
                                      model.share_post_id?.post_privacy ?? '')
                                  : getIconAsPrivacy(model.post_privacy ?? ''),
                              size: 17,
                            )
                          ],
                        )
                      ],
                    )
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
              if (model.post_type != 'Shared')
                _buildThreeDotMenu(context),

              // ─── Close / Hide button ───
              if (onTapHidePost != null)
                SizedBox(
                  width: 36,
                  height: 36,
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
      ),
    );
  }

  Widget _buildThreeDotMenu(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showPostActionsSheet(context),
        icon: Icon(
          Icons.more_horiz,
          color: FeedDesignTokens.textSecondary(context),
          size: 24,
        ),
      ),
    );
  }

  void _showPostActionsSheet(BuildContext context) {
    final bool isOwner =
        model.user_id?.id == LoginCredential().getUserData().id;

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
                color:
                    FeedDesignTokens.textSecondary(context).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            if (isOwner) ...[
              _menuItem(context,
                  icon: Icons.edit_outlined,
                  label: 'Edit Post'.tr,
                  subtitle: 'Make changes to this post'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapEditPost?.call();
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
                    onTapViewPostHistory?.call();
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
                  height: 1, color: FeedDesignTokens.divider(context)),
              _menuItem(context,
                  icon: Icons.delete_outline,
                  label: 'Delete'.tr,
                  subtitle: 'Move this post to trash'.tr,
                  isDestructive: true,
                  onTap: () {
                Navigator.pop(context);
                showDeleteAlertDialogs(
                  context: context,
                  onDelete: () {
                    ProfileController controller =
                        Get.put(ProfileController());
                    HomeController hc = Get.put(HomeController());
                    GroupProfileController groupProfileController =
                        Get.isRegistered<GroupProfileController>()
                            ? Get.find<GroupProfileController>()
                            : Get.put(GroupProfileController());
                    groupProfileController.isLoadingNewsFeed.value = true;
                    controller.deletePost(model.id.toString()).then((_) {
                      groupProfileController.postList.value.removeWhere(
                          (element) =>
                              element.id.toString() ==
                              model.id.toString());
                      groupProfileController.isLoadingNewsFeed.value =
                          false;
                    });
                    Navigator.of(context).pop(false);
                    controller.postList.value.removeWhere(
                        (element) => element.id == model.id.toString());
                    hc.postList.value.removeWhere(
                        (element) => element.id == model.id.toString());
                    controller.postList.refresh();
                    hc.postList.refresh();
                  },
                  onCancel: () {
                    Navigator.of(context).pop(false);
                  },
                );
              }),
            ] else ...[
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
                    onTapBlockUser.call();
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
                  height: 1, color: FeedDesignTokens.divider(context)),
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
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color),
      ),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(
                  fontSize: 12,
                  color: isDestructive
                      ? Colors.red.shade300
                      : FeedDesignTokens.textSecondary(context)))
          : null,
      onTap: onTap,
    );
  }

  Widget ReactionIcon(String reactionPath) {
    return Image(
        height: 17, image: NetworkImage((reactionPath).formatedFeelingUrl));
  }

  IconData getIconAsPrivacy(String postPrivacy) {
    switch (postPrivacy) {
      case 'public':
        return Icons.public;
      case 'private':
        return Icons.lock;
      case 'friends':
        return Icons.group;
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
      case 'timeline_post':
        return '';
      case 'page_post':
        return '';
      case 'profile_picture':
        return 'updated a new profile picture';
      case 'cover_picture':
        return 'updated a new cover photo';
      case 'event':
        return '';
      case 'shared_reels':
        return '';
      case 'birthday':
        return '';
      case 'campaign':
        return '';
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
    return (model.location_id?.locationName != null)
        ? ' at ${model.location_id?.locationName}'
        : '';
  }

  String geSharedLocationText(PostModel postModel) {
    return (postModel.share_post_id!.locationName.toString().contains('null'))
        ? ''
        : ' at ${model.share_post_id?.locationName}';
  }

  String getTagText(PostModel postModel) {
    if (postModel.taggedUserList != null) {
      if (postModel.taggedUserList!.length == 1) {
        return ' with ${postModel.taggedUserList![0].user?.firstName ?? ''}';
      } else if (postModel.taggedUserList!.length > 1) {
        return ' with ${postModel.taggedUserList![0].user?.firstName ?? ''} and ${postModel.taggedUserList!.length - 1} others';
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  String getSharedHeaderTextAsPostType(PostModel postModel) {
    switch (model.share_post_id!.post_type) {
      case 'timeline_post':
        return '';
      case 'page_post':
        return '';
      case 'profile_picture':
        return 'updated his profile picture';
      case 'cover_picture':
        return 'updated his cover photo';
      case 'event':
        return '';
      case 'shared_reels':
        return '';
      case 'birthday':
        return '';
      case 'campaign':
        return '';
      default:
        return '';
    }
  }
}
