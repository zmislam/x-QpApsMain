import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/post_background.dart';
import '../../alert_dialogs/delete_alert_dialogs.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';

import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../models/user_id.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/post_utlis.dart';
import '../../image.dart';

class SharedReelHeader extends StatelessWidget {
  final PostModel model;
  final VoidCallback onTapEditPost;

  const SharedReelHeader(
      {super.key, required this.model, required this.onTapEditPost});

  @override
  Widget build(BuildContext context) {
    UserIdModel userModel = model.share_reels_id?.userId ?? UserIdModel();
    UserModel currentUserModel = LoginCredential().getUserData();
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
            'username': userModel.username,
            'isFromReels': 'false'
          });
        },
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                RoundCornerNetworkImage(
                  imageUrl: (userModel.profile_pic ?? '').formatedProfileUrl,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: '${userModel.first_name} ${userModel.last_name}'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color),
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
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: ReactionIcon(
                                          model.feeling_id!.logo.toString()),
                                    )),
                                    TextSpan(
                                        text: ' ${model.feeling_id!.feelingName}'.tr,
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
                                  fontWeight: FontWeight.w500, fontSize: 16)),
                          TextSpan(
                              text: getTagText(model),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16))
                        ]),
                      ])),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              '${getDynamicFormatedTime(model.share_reels_id?.createdAt.toString() ?? '')} '),
                          Text(
                            getTextAsPostType(
                                model.share_reels_id?.reelsPrivacy ?? ''),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            getIconAsPrivacy(
                                model.share_reels_id?.reelsPrivacy ?? ''),
                            size: 17,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // =========================================================== Three Dot Icon ===========================================================
                userModel.id == currentUserModel.id
                    ? IconButton(
                        onPressed: () {
                          Get.bottomSheet(Container(
                            height: 160,
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
                                          child: Text('Edit'.tr,
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
                                            Icons.lock,
                                            size: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text('Privacy'.tr,
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
                    : Container()
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
                      child: Text('${model.share_reels_id?.description}'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: PostBackground.textColorFromStoredValue(model.post_background_color)),
                      ),
                    )
                  : ExpandableText('${model.share_reels_id?.description}'.tr,
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
