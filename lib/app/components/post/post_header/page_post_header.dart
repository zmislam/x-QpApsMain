import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alert_dialogs/delete_alert_dialogs.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../config/constants/feed_design_tokens.dart';
import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/admin_page/controller/admin_page_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/post_utlis.dart';
import '../../../repository/page_repository.dart';
import '../../image.dart';
import '../../post_tag_list.dart';
import '../post_icons/connection_status_icons.dart';
import '../report_post_modal.dart';

class PagePostHeader extends StatelessWidget {
  final PostModel model;
  final VoidCallback? onTapEditPost;

  final VoidCallback? onTapBookMarkPost;
  final VoidCallback? onTapRemoveBookMarkPost;
  final VoidCallback? onTapCopyPost;
  final VoidCallback? onTapViewPostHistory;
  final VoidCallback? onTapPinPost;
  final VoidCallback? onTapHidePost;
  final String? viewType;

  PagePostHeader(
      {super.key,
        required this.model,
        this.onTapEditPost,
        this.onTapBookMarkPost,
        this.onTapCopyPost,
        this.onTapViewPostHistory,
        this.viewType = 'PagePost',
        this.onTapPinPost,
        this.onTapHidePost,
        this.onTapRemoveBookMarkPost});

  HomeController homeController = Get.find();

  final RxBool _isFollowing = false.obs;

  /// Toggle follow/unfollow and call API. Icon updates immediately.
  void _handleFollowPage() async {
    final pageId = model.page_id.id ?? model.share_post_id?.page_id?.id ?? '';
    if (pageId.isEmpty) return;

    final wasFollowing = _isFollowing.value;
    _isFollowing.value = !wasFollowing; // Optimistic update

    try {
      if (wasFollowing) {
        await PageRepository().unfollowPage(pageId: pageId);
        model.isFollowingPage = false;
      } else {
        await PageRepository().followPage(pageId);
        model.isFollowingPage = true;
      }
    } catch (e) {
      _isFollowing.value = wasFollowing; // Revert on error
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUserModel = LoginCredential().getUserData();
    // Initialize follow state from model data
    _isFollowing.value = model.isFollowingPage == true;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          if (model.post_type == 'Shared' &&
              model.share_post_id?.post_type == 'campaign') {
            ProfileNavigator.navigateToProfile(
                username:
                model.share_post_id?.adProduct?.pageInfo?.pageUserName ??
                    '',
                isFromReels: 'false');
          } else if (model.post_type == 'Shared' &&
              model.share_post_id?.post_type != 'campaign') {
            ProfileNavigator.navigateToProfile(
                username: model.share_post_id?.page_id?.pageUserName ?? '',
                isFromReels: 'false');
          } else {
            ProfileNavigator.navigateToProfile(
                username: model.page_id.pageUserName ?? '',
                isFromReels: 'false');
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            (model.post_type == 'Shared' &&
                model.share_post_id?.post_type == 'campaign' &&
                model.share_post_id?.adProduct?.pageInfo != null)
                ? RoundCornerNetworkImage(
              imageUrl:
              (model.share_post_id?.adProduct?.pageInfo?.profilePic ??
                  '')
                  .formatedProfileUrl,
            )
                : (model.post_type == 'Shared' &&
                model.share_post_id?.post_type == 'campaign' &&
                model.share_post_id?.campaignModel != null)
                ? RoundCornerNetworkImage(
              imageUrl:
              (model.share_post_id?.page_id?.profilePic ?? '')
                  .formatedProfileUrl,
            )
                : (model.post_type == 'Shared' &&
                model.share_post_id?.post_type == 'page_post')
                ? RoundCornerNetworkImage(
              imageUrl:
              (model.share_post_id?.page_id?.profilePic ?? '')
                  .formatedProfileUrl,
            )
                : model.post_type == 'profile_picture'
                ? RoundCornerNetworkImage(
              imageUrl: (model.page_id.profilePic ?? '')
                  .formatedProfileUrl,
            )
                : RoundCornerNetworkImage(
              imageUrl: (model.page_id.profilePic ?? '')
                  .formatedProfileUrl,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name row (with connection icon inline, matching user post pattern)
                  Row(
                    children: [
                      Flexible(
                        child: RichText(
                    text: TextSpan(children: [
                      (model.post_type == 'Shared' &&
                          model.share_post_id?.post_type == 'campaign' &&
                          model.share_post_id?.adProduct?.pageInfo != null)
                          ? TextSpan(
                        text: '${model.share_post_id?.adProduct?.pageInfo?.pageName}'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                          : (model.post_type == 'Shared' &&
                          model.share_post_id?.post_type ==
                              'campaign' &&
                          model.share_post_id?.campaignModel != null)
                          ? TextSpan(
                        text: '${model.share_post_id?.page_id?.pageName}'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                          : (model.post_type == 'profile_picture')
                          ? TextSpan(children: [
                        TextSpan(
                          text: '${model.page_id.pageName}'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${getHeaderTextAsPostType(model)}'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                              fontWeight: FontWeight.w700),
                        )
                      ])
                          : (model.post_type == 'cover_picture')
                          ? TextSpan(children: [
                        TextSpan(
                          text: '${model.page_id.pageName}'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                              fontWeight:
                              FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${getHeaderTextAsPostType(model)}'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                              fontWeight:
                              FontWeight.w700),
                        )
                      ])
                          : (model.post_type == 'page_post')
                          ? TextSpan(
                        text: '${model.page_id.pageName}'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                            fontWeight:
                            FontWeight.bold),
                      )
                          : (model.post_type == 'timeline_post')
                          ? TextSpan(
                        text: '${model.page_id.pageName}'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                            fontWeight:
                            FontWeight.bold),
                      )
                          : TextSpan(
                        children: [
                          (model.share_post_id !=
                              null)
                              ? TextSpan(
                            text: '${model.share_post_id?.page_id?.pageName}'.tr,
                            style: Theme.of(
                                context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                fontWeight:
                                FontWeight
                                    .bold),
                          )
                              : TextSpan(
                            text: '${model.page_id.pageName}'.tr,
                            style: Theme.of(
                                context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                fontWeight:
                                FontWeight
                                    .bold),
                          ),
                          TextSpan(
                            text: ' ${getHeaderTextAsPostType(model)}'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                fontWeight:
                                FontWeight
                                    .w700),
                          )
                        ],
                      ),
                      TextSpan(children: [
                        // model.share_post_id?.feeling_id != null
                        // model.post_type == "Shared"
                        model.feeling_id != null
                            ? TextSpan(children: [
                          TextSpan(children: [
                            TextSpan(
                                text: ' is feeling'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge),
                            WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: ReactionIcon(
                                      model.feeling_id!.logo.toString()),
                                )),
                            TextSpan(
                                text: ' ${model.feeling_id!.feelingName}'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge),
                          ], style: TextStyle(fontSize: 16)),
                        ])
                            : TextSpan(
                            text: '',
                            style: Theme.of(context).textTheme.bodyLarge),
                        TextSpan(
                            text: getLocationText(model),
                            style: Theme.of(context).textTheme.bodyLarge),
                        TextSpan(
                          text: getTagText(model),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => PostTagList(
                                postModel: model,
                              ));
                            },
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        )
                      ]),
                    ]),
                  ),
                      ),
                      // ─── Connection Status Icon (reactive follow/following) ───
                      if (model.user_id?.id != currentUserModel.id)
                        Obx(() {
                          final status = _isFollowing.value
                              ? ConnectionStatus.followingPage
                              : ConnectionStatus.notFollowingPage;
                          final icon = getConnectionStatusIcon(
                            status,
                            size: 16,
                            onFollowPage: () => _handleFollowPage(),
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
                  model.post_type == 'Shared'
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          '${getDynamicFormatedTime(model.share_post_id?.createdAt ?? '')} '),
                      Text(
                        getTextAsPostType(
                            model.share_post_id?.post_type ?? ''),
                        style:
                        TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        getIconAsPrivacy(
                            model.share_post_id?.post_privacy ?? ''),
                        size: 17,
                      )
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          '${getDynamicFormatedTime(model.createdAt ?? '')} '),
                      Text(
                        getTextAsPostType(model.post_type ?? ''),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
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
            _buildThreeDotMenu(context, currentUserModel),

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
    );
  }

  Widget _buildThreeDotMenu(BuildContext context, UserModel currentUserModel) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showPostActionsSheet(context, currentUserModel),
        icon: Icon(
          Icons.more_horiz,
          color: FeedDesignTokens.textSecondary(context),
          size: 24,
        ),
      ),
    );
  }

  void _showPostActionsSheet(BuildContext context, UserModel currentUserModel) {
    final bool isOwner = model.user_id?.id == currentUserModel.id;

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
              if (viewType == 'profile' || viewType == 'PagePost')
                _menuItem(context,
                    icon: Icons.push_pin_outlined,
                    label: model.pinPost == false ? 'Pin Post'.tr : 'UnPin Post'.tr,
                    subtitle: model.pinPost == false
                        ? 'Pin this post to your page'.tr
                        : 'Remove pin from this post'.tr,
                    onTap: () {
                      Navigator.pop(context);
                      onTapPinPost?.call();
                    }),
              _menuItem(context,
                  icon: Icons.edit_outlined,
                  label: 'Edit Post'.tr,
                  subtitle: 'Make changes to this post'.tr,
                  onTap: () {
                    Navigator.pop(context);
                    onTapEditPost?.call();
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
              Divider(height: 1, color: FeedDesignTokens.divider(context)),
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
                    AdminPageController controller =
                        Get.put(AdminPageController());
                    HomeController hc = Get.put(HomeController());
                    controller.deletePost(model.id.toString(), model.key.toString());
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
              Divider(height: 1, color: FeedDesignTokens.divider(context)),
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

  IconData getIconAsPrivacy(String postPrivacy) {
    switch (postPrivacy) {
      case 'public':
        return Icons.public;
      case 'only_me':
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
    return (postModel.locationName.toString().contains('null') ||
        postModel.locationName.toString() == '')
        ? ''
        : ' at ${postModel.locationName}';
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

  Widget ReactionIcon(String reactionPath) {
    return Image(
        height: 17, image: NetworkImage((reactionPath).formatedFeelingUrl));
  }
}
