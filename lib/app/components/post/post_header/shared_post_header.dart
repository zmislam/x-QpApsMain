import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/post_background.dart';
import '../../../extension/string/string_image_path.dart';

import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../models/user_id.dart';
import '../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/post_utlis.dart';
import '../../alert_dialogs/delete_alert_dialogs.dart';
import '../../image.dart';
import '../../../config/constants/feed_design_tokens.dart';
import '../report_post_modal.dart';

class SharedPostHeader extends StatelessWidget {
  final PostModel model;
  final VoidCallback onTapEditPost;
  final VoidCallback? onTapHidePost;
  final VoidCallback? onTapBookMarkPost;
  final VoidCallback? onTapCopyPost;

  SharedPostHeader(
      {super.key,
      required this.model,
      required this.onTapEditPost,
      this.onTapHidePost,
      this.onTapBookMarkPost,
      this.onTapCopyPost});

  RxString character = 'spam'.obs;

  TextEditingController reportDescription = TextEditingController();

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    UserIdModel userModel = model.user_id!;
    UserModel currentUserModel = LoginCredential().getUserData();
    final isVerified =
        LoginCredential().getUserInfoData().isProfileVerified;
    // final isVerified = userModel. ?? false;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          ProfileNavigator.navigateToProfile(
              username: model.user_id?.username ?? '', isFromReels: 'false');
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                RoundCornerNetworkImage(
                  imageUrl: userModel.page_id != null
                      ? (userModel.profile_pic ?? '').formatedProfileUrl
                      : (userModel.profile_pic ?? '').formatedProfileUrl,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text:
                                  '${userModel.first_name} ${userModel.last_name}'
                                      .tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(children: [
                              model.feeling_id != null
                                  ? TextSpan(children: [
                                      TextSpan(children: [
                                        TextSpan(
                                            text: ' is feeling'.tr,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                        WidgetSpan(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: ReactionIcon(model
                                              .feeling_id!.logo
                                              .toString()),
                                        )),
                                        TextSpan(
                                            text:
                                                ' ${model.feeling_id!.feelingName}'
                                                    .tr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            )),
                                      ], style: const TextStyle(fontSize: 16)),
                                    ])
                                  : TextSpan(
                                      text: '',
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16)),
                              TextSpan(
                                  text: getLocationText(model),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                              TextSpan(
                                  text: getTagText(model),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16))
                            ]),
                          ])),
                          const SizedBox(width: 4),
                          isVerified == true
                              ? Icon(
                                  Icons.verified,
                                  color: Color(
                                      0xFF0D7377),
                                  size: 18,
                                )
                              : const SizedBox()
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              '${getDynamicFormatedTime(model.createdAt ?? '')} '),
                          Text(
                            getTextAsPostType(model.post_type ?? ''),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            getIconAsPrivacy(model.post_privacy ?? ''),
                            size: 17,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // =========================================================== Three Dot Icon ===========================================================
                _buildThreeDotMenu(context, currentUserModel),
              ],
            ),
            Container(
              // =================================================== No Media Post ===================================================
              height: PostBackground.hasBackground(model.post_background_color)
                  ? 256
                  : null,
              // not having background color will make height dynamic
              width: double.maxFinite,
              decoration: PostBackground.decorationFromStoredValue(model.post_background_color) ?? const BoxDecoration(),
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: PostBackground.hasBackground(model.post_background_color)
                  ? Center(
                      child: Text(
                        '${model.description}'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: PostBackground.textColorFromStoredValue(model.post_background_color)),
                      ),
                    )
                  : ExpandableText(
                      '${model.description}'.tr,
                      expandText: 'See more',
                      maxLines: 5,
                      collapseText: 'see less',
                    ),
            )
          ],
        ),
      ),
    );
  }

  getIconAsPrivacy(String postPrivacy) {
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

  String getFeelingText(PostModel postModel) {
    return (model.feeling_id?.feelingName != null)
        ? ' is feeling ${model.feeling_id?.feelingName}'
        : '';
  }

  String getLocationText(PostModel postModel) {
    return (postModel.locationName.toString().contains('null') ||
            postModel.locationName.toString().contains(''))
        ? ''
        : ' at ${model.locationName}';
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

  Widget ReactionIcon(String reactionPath) {
    return Image(
        height: 17, image: NetworkImage((reactionPath).formatedFeelingUrl));
  }

  // ─── Three-dot menu (new design) ─────────────────────────────────────
  Widget _buildThreeDotMenu(BuildContext context, UserModel currentUserModel) {
    return IconButton(
      onPressed: () => _showPostActionsSheet(context, currentUserModel),
      icon: Icon(
        Icons.more_horiz,
        color: FeedDesignTokens.textSecondary(context),
        size: FeedDesignTokens.threeDotButtonSize,
      ),
    );
  }

  void _showPostActionsSheet(BuildContext context, UserModel currentUserModel) {
    final bool isOwner = model.user_id?.id == currentUserModel.id;
    final HomeController homeController = Get.put(HomeController());

    showModalBottomSheet(
      context: context,
      backgroundColor: FeedDesignTokens.cardBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: FeedDesignTokens.textSecondary(context)
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                if (isOwner) ...[
                  _menuItem(
                    context: ctx,
                    icon: Icons.edit_outlined,
                    title: 'Edit'.tr,
                    subtitle: 'Make changes to this post',
                    onTap: () {
                      Navigator.pop(ctx);
                      onTapEditPost();
                    },
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.visibility_off_outlined,
                    title: 'Hide Post'.tr,
                    subtitle: 'See fewer posts like this',
                    onTap: () {
                      Navigator.pop(ctx);
                      if (onTapHidePost != null) onTapHidePost!();
                    },
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.bookmark_border,
                    title: 'Save Post'.tr,
                    subtitle: 'Add this to your saved items',
                    onTap: () {
                      Navigator.pop(ctx);
                      if (onTapBookMarkPost != null) onTapBookMarkPost!();
                    },
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.history_outlined,
                    title: 'Edit History'.tr,
                    subtitle: 'View previous versions of this post',
                    onTap: () {
                      Navigator.pop(ctx);
                    },
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.notifications_off_outlined,
                    title: 'Turn off notification'.tr,
                    subtitle: 'Stop receiving updates about this post',
                    onTap: () {
                      Navigator.pop(ctx);
                    },
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.link,
                    title: 'Copy link'.tr,
                    subtitle: 'Share this post link with others',
                    onTap: () {
                      Navigator.pop(ctx);
                      if (onTapCopyPost != null) onTapCopyPost!();
                    },
                  ),
                  Divider(
                    height: 1,
                    color: FeedDesignTokens.divider(context),
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.delete_outline,
                    title: 'Delete'.tr,
                    subtitle: 'Permanently remove this post',
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(ctx);
                      showDeleteAlertDialogs(
                        context: context,
                        onDelete: () {
                          ProfileController controller =
                              Get.put(ProfileController());
                          HomeController hc = Get.put(HomeController());
                          controller.deletePost(model.id.toString());
                          Navigator.of(context).pop(false);
                          controller.postList.value.removeWhere(
                              (element) =>
                                  element.id == model.id.toString());
                          hc.postList.value.removeWhere(
                              (element) =>
                                  element.id == model.id.toString());
                          controller.postList.refresh();
                          hc.postList.refresh();
                        },
                        onCancel: () {
                          Navigator.of(context).pop(false);
                        },
                      );
                    },
                  ),
                ] else ...[
                  _menuItem(
                    context: ctx,
                    icon: Icons.visibility_off_outlined,
                    title: 'Hide Post'.tr,
                    subtitle: 'See fewer posts like this',
                    onTap: () {
                      Navigator.pop(ctx);
                      if (onTapHidePost != null) onTapHidePost!();
                    },
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.bookmark_border,
                    title: 'Save Post'.tr,
                    subtitle: 'Add this to your saved items',
                    onTap: () {
                      Navigator.pop(ctx);
                      if (onTapBookMarkPost != null) onTapBookMarkPost!();
                    },
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.notifications_off_outlined,
                    title: 'Turn off notification'.tr,
                    subtitle: 'Stop receiving updates about this post',
                    onTap: () {
                      Navigator.pop(ctx);
                    },
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.link,
                    title: 'Copy link'.tr,
                    subtitle: 'Share this post link with others',
                    onTap: () {
                      Navigator.pop(ctx);
                      if (onTapCopyPost != null) onTapCopyPost!();
                    },
                  ),
                  Divider(
                    height: 1,
                    color: FeedDesignTokens.divider(context),
                  ),
                  _menuItem(
                    context: ctx,
                    icon: Icons.flag_outlined,
                    title: 'Report'.tr,
                    subtitle: 'Report this post for review',
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(ctx);
                      ReportPostModal.show(
                        context: context,
                        postId: model.id ?? '',
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final Color color = isDestructive
        ? Colors.red
        : FeedDesignTokens.textPrimary(context);
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: isDestructive
                    ? Colors.red.withOpacity(0.7)
                    : FeedDesignTokens.textSecondary(context),
                fontSize: 12,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
