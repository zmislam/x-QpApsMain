import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

                //  model.post_type == 'Shared' && model.share_post_id?.post_type =='campaign' ? const SizedBox():

                model.user_id?.id == currentUserModel.id
                    ? IconButton(
                        onPressed: () {
                          Get.bottomSheet(Container(
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            height: 340,
                            color: Theme.of(context).cardTheme.color,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: onTapEditPost,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 14),
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Edit'.tr,
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
                                          child: Text(
                                            'Hide Post'.tr,
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
                                          child: Text(
                                            'Book Mark'.tr,
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
                                          child: Text(
                                            'Edit History'.tr,
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
                                          child: Text(
                                            'Turn off notification'.tr,
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
                                  onTap: onTapCopyPost ?? () {},
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
                                          child: Text(
                                            'Copy link'.tr,
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
                                    showDeleteAlertDialogs(
                                      context: context,
                                      onDelete: () {
                                        ProfileController controller =
                                            Get.put(ProfileController());
                                        HomeController homeController =
                                            Get.put(HomeController());
                                        controller
                                            .deletePost(model.id.toString());
                                        Get.back();
                                        Navigator.of(context).pop(false);
                                        controller.postList.value.removeWhere(
                                            (element) =>
                                                element.id ==
                                                model.id.toString());
                                        homeController.postList.value
                                            .removeWhere((element) =>
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
                                          child: Text(
                                            'Delete'.tr,
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
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 25,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          Get.bottomSheet(Container(
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            height: 280,
                            color: Theme.of(context).cardTheme.color,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
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
                                          child: Text(
                                            'Hide Post'.tr,
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
                                          child: Text(
                                            'Book Mark'.tr,
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
                                          child: Text(
                                            'Turn off notification'.tr,
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
                                  onTap: onTapCopyPost ?? () {},
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
                                          child: Text(
                                            'Copy link'.tr,
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
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Icon(Icons.report_outlined),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: GestureDetector(
                                            onTap: () async {
                                              ////////////////////report/////////////////////////////////////////////////

                                              ////////////////report///////////////////////////////////////////////////
                                            },
                                            child: Text(
                                              'Report'.tr,
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
                        icon: const Icon(Icons.more_vert)),
              ],
            ),
            Container(
              // =================================================== No Meida Post ===================================================
              height: (model.post_background_color != null &&
                      model.post_background_color!.isNotEmpty &&
                      model.post_background_color! != '')
                  ? 256
                  : null,
              // not having background color will make height dynamic
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: (model.post_background_color != null &&
                          model.post_background_color!.isNotEmpty)
                      ? Color(int.parse('0xff${model.post_background_color}'))
                      : null),
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: (model.post_background_color != null &&
                      model.post_background_color != '')
                  ? Center(
                      child: Text(
                        '${model.description}'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
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
}
