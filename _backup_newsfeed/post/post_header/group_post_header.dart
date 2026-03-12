import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alert_dialogs/delete_alert_dialogs.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/controllers/group_profile_controller.dart';

import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../models/user_id.dart';
import '../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/post_utlis.dart';
import '../../image.dart';

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

  RxString character = 'spam'.obs;

  TextEditingController reportDescription = TextEditingController();

  HomeController homeController = Get.find();

  // GroupProfileController groupController = Get.put(GroupProfileController());
  //
  @override
  Widget build(BuildContext context) {
    UserIdModel userModel = model.user_id!;
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

                  String groupId = model.groupId?.id ?? '';
                  if (model.post_type == 'Shared') {
                    debugPrint(
                        ':::::::::::::Shared Group Post Header Group Id:$sharedGroupId:::::::::::::');
                    Get.toNamed(Routes.GROUP_PROFILE,
                        arguments: {'id': sharedGroupId, 'group_type': ''});
                  } else {
                    debugPrint(
                        '::::::::::::: Group Post Header Only Id:${model.groupId?.id}:::::::::::::');

                    Get.toNamed(Routes.GROUP_PROFILE,
                        arguments: {'id': groupId, 'group_type': ''});
                  }
                },
                child: Stack(
                  children: [
                    RoundCornerNetworkImage(
                      imageUrl: (model.groupId?.groupCoverPic ?? '')
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
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.GROUP_PROFILE, arguments: {
                          'id': model.groupId?.id,
                          'group_type': ''
                        });
                      },
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: model.post_type == 'Shared'
                              ? '${model.share_post_id?.groupId?.groupName?.capitalizeFirst}'
                              : '${model.groupId?.groupName?.capitalizeFirst}',
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
              // =========================================================== Three Dot Icon ===========================================================
              model.isBookMarked == true
                  ? const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Icon(
                  Icons.bookmark,
                ),
              )
                  : const SizedBox(),

              model.user_id?.id == LoginCredential().getUserData().id &&
                  model.post_type != 'Shared'
                  ? IconButton(
                  onPressed: () {
                    Get.bottomSheet(Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      height: viewType == 'bookmark' ? 340 : 345,
                      color: Theme.of(context).cardTheme.color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          //=================Edit post =================

                          InkWell(
                            onTap: onTapEditPost,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Edit Post'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //=================Hide post =================
                          InkWell(
                            onTap: onTapHidePost ?? () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.hide_image,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Hide Post'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // ========================Bookmark =================

                          model.isBookMarked == false
                              ? InkWell(
                            onTap: onTapBookMarkPost ?? () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.bookmark,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Book Mark'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          // ========================Remove BookMark =================

                              : InkWell(
                            onTap: onTapRemoveBookMarkPost ?? () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.bookmark,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Remove Book Mark'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // ========================Edit History =================
                          InkWell(
                            onTap: onTapViewPostHistory ?? () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.edit_note,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Edit History'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // ========================Turn Off Notification =================

                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.notification_add,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Turn off notification'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          // ========================Copy Link =================

                          InkWell(
                            onTap: onTapCopyPost,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.link_off,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Copy link'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // ========================Delete Post =================

                          InkWell(
                            onTap: () async {
                              showDeleteAlertDialogs(
                                context: context,
                                onDelete: () {
                                  ProfileController controller =
                                  Get.put(ProfileController());
                                  HomeController homeController =
                                  Get.put(HomeController());

                                  //! ADDED FOR HANDLING GROUP POSTS
                                  GroupProfileController
                                  groupProfileController = Get.isRegistered<GroupProfileController>() ?
                                  Get.find<GroupProfileController>() : Get.put(GroupProfileController());
                                  groupProfileController
                                      .isLoadingNewsFeed.value = true;
                                  controller
                                      .deletePost(model.id.toString())
                                      .then(
                                        (value) {
                                      groupProfileController.postList.value
                                          .removeWhere(
                                            (element) =>
                                        element.id.toString().compareTo(
                                            model.id.toString()) ==
                                            0,
                                      );
                                      groupProfileController
                                          .isLoadingNewsFeed.value = false;
                                    },
                                  );

                                  // USING TO HANDEL GROUP POST

                                  // groupProfileController.postList.value.clear();
                                  // groupProfileController.getGroupPosts();

                                  Get.close(1);
                                  Navigator.of(context).pop(false);
                                  controller.postList.value.removeWhere(
                                          (element) =>
                                      element.id ==
                                          model.id.toString());
                                  homeController.postList.value.removeWhere(
                                          (element) =>
                                      element.id ==
                                          model.id.toString());
                                  controller.postList.refresh();
                                  homeController.postList.refresh();
                                },
                                onCancel: () {
                                  Navigator.of(context).pop(false);
                                  Get.back();
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Delete'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
                  },
                  icon: const Icon(Icons.more_vert))
              //************************************* */ When post type shared and user is not me *******************//
                  : model.post_type != 'Shared'
                  ? IconButton(
                  onPressed: () {
                    Get.bottomSheet(Container(
                      margin: EdgeInsets.only(
                          bottom:
                          MediaQuery.of(context).padding.bottom),
                      height: 300,
                      color: Theme.of(context).cardTheme.color,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),

                          // ========================Hide Post =================

                          InkWell(
                            onTap: onTapHidePost ?? () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.hide_image,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Hide Post'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // ========================BookMark Post =================

                          model.isBookMarked == false
                              ? InkWell(
                            onTap: onTapBookMarkPost ?? () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.bookmark,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 8),
                                    child: Text('Book Mark'.tr,
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          // ========================Remove Bookmark Post =================

                              : InkWell(
                            onTap:
                            onTapRemoveBookMarkPost ?? () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.bookmark,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.only(left: 8),
                                    child: Text('Remove Book Mark'.tr,
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // ========================Block User =================

                          InkWell(
                            onTap: onTapBlockUser,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.app_blocking,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Block User'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          // ========================Turn off notifications=================

                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.notification_add,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Turn off notification'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // ========================Copy Link Post =================

                          InkWell(
                            onTap: onTapCopyPost,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.link_off,
                                      size: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text('Copy link'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          InkWell(
                            onTap: () async {
                              await homeController.getReports();
                              CustomReportBottomSheet.showReportOptions(
                                context: context,
                                pageReportList:
                                homeController.pageReportList.value,
                                selectedReportType:
                                homeController.selectedReportType,
                                selectedReportId:
                                homeController.selectedReportId,
                                reportDescription:
                                homeController.reportDescription,
                                onCancel: () {
                                  Get.back();
                                },
                                reportAction: (String report_type_id,
                                    String report_type,
                                    String page_id,
                                    String description) {
                                  homeController.reportAPost(
                                      report_type: report_type,
                                      description: description,
                                      post_id: model.id ?? '',
                                      report_type_id: report_type_id);
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding:
                                    EdgeInsets.only(left: 10.0),
                                    child: Icon(Icons.report_outlined),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 8),
                                    child: GestureDetector(
                                      onTap: () async {},
                                      child: Text('Report'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
                  },
                  icon: const Icon(Icons.more_vert))
                  : const SizedBox(),


            ],
          ),
        ),
      ),
    );
  }

  Widget ReactionIcon(String reactionPath) {
    return Image(
        height: 17, image: NetworkImage((reactionPath).formatedFeelingUrl));
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
