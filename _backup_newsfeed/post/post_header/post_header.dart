import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/models/profile_model.dart';
import 'package:quantum_possibilities_flutter/app/utils/logger/logger.dart';
import '../../alert_dialogs/delete_alert_dialogs.dart';
import '../../../extension/string/string_image_path.dart';

import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../models/user_id.dart';
import '../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/profile/controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/post_utlis.dart';
import '../../image.dart';
import '../../post_tag_list.dart';

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
      this.onTapRemoveBookMarkPost});

  RxString character = 'spam'.obs;

  TextEditingController reportDescription = TextEditingController();

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    UserIdModel? userModel = model.user_id;
    UserModel currentUserModel = LoginCredential().getUserData();
    return model.post_type == 'Shared'
        ? Container(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () {
                ProfileNavigator.navigateToProfile(
                    username: model.share_post_id?.user_id?.username ?? '',
                    isFromReels: 'false');

                // ! PREVIOUS CODE
                // homeController.getPageDetails(pageUserName: model.share_post_id?.user_id?.username ?? '');
                // if (model.share_post_id?.user_id?.username == LoginCredential().getUserData().username && LoginCredential().getProfileSwitch() == false) {
                //   Get.toNamed(Routes.PROFILE);
                // } else if (homeController.pageProfileModel.value?.role == 'admin') {
                //   Get.toNamed(Routes.ADMIN_PAGE, arguments: model.share_post_id?.user_id?.username);
                // } else if ((userModel.page_id != null)) {
                //   Get.toNamed(Routes.PAGE_PROFILE, arguments: model.share_post_id?.user_id?.username);
                // } else {
                //   Get.toNamed(Routes.OTHERS_PROFILE, arguments: {'username': model.share_post_id?.user_id?.username, 'isFromReels': 'false'});
                // }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  RoundCornerNetworkImage(
                    imageUrl: (model.share_post_id?.user_id?.profile_pic ?? '')
                        .formatedProfileUrl,
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
                            text: '${model.share_post_id?.user_id?.first_name} ${model.share_post_id?.user_id?.last_name}'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(children: [
                            model.share_post_id?.feeling_id != null
                                ? TextSpan(
                                    children: [
                                      TextSpan(
                                          children: [
                                            TextSpan(
                                                text: ' is feeling'.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16)),
                                            WidgetSpan(
                                              child: Padding(
                                                padding:    EdgeInsets.only(
                                                    left: 3.0),
                                                child: ReactionIcon(model
                                                        .feeling_id?.logo
                                                        .toString() ??
                                                    ''),
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ${model.feeling_id?.feelingName}'.tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ],
                                  )
                                : TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16)),
                            TextSpan(
                              text: getSharedLocationText(model),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            TextSpan(
                                text: getTagText(model),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => PostTagList(
                                          postModel: model,
                                        ));
                                  },
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16))
                          ]),
                        ])),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                '${getDynamicFormatedTime(model.share_post_id?.createdAt ?? '')} '),
                            Text(
                              getTextAsPostType(
                                  model.share_post_id?.post_type ?? ''),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              getIconAsPrivacy(
                                  model.share_post_id?.post_privacy ?? ''),
                              size: 17,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : (model.post_type == 'campaign')
            ? Container(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.PAGE_PROFILE,
                        arguments: model.campaign_id?.id);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      RoundCornerNetworkImage(
                        imageUrl: (model.adProduct?.pageInfo?.profilePic ?? '')
                            .formatedProfileUrl,
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
                                text: '${model.adProduct?.pageInfo?.pageName}'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(children: []),
                            ])),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  getTextAsPostType(model.post_type ?? ''),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
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
                    ],
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.only(top: 10),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: InkWell(
                  onTap: () {
                    final username = userModel?.username;

                    ProfileNavigator.navigateToProfile(
                        username: username ?? '', isFromReels: 'false');
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10),
                          RoundCornerNetworkImage(
                            imageUrl: (userModel?.profile_pic ?? '')
                                .formatedProfileUrl,
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
                                          text: '${userModel?.first_name} ${userModel?.last_name}'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      TextSpan(children: [
                                        (model.post_type == 'timeline_post' &&
                                                model.is_live == true)
                                            ? TextSpan(
                                                text: ' was live'.tr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall)
                                            : (model.post_type == 'live' &&
                                                    model.is_live == true)
                                                ? TextSpan(
                                                    text: ' is live now'.tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall)
                                                : model.feeling_id != null
                                                    ? TextSpan(children: [
                                                        TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text: ' is feeling'.tr,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall),
                                                              WidgetSpan(
                                                                  child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 3.0),
                                                                child: ReactionIcon(
                                                                    model
                                                                        .feeling_id!
                                                                        .logo
                                                                        .toString()),
                                                              )),
                                                              TextSpan(
                                                                  text: ' ${model.feeling_id!.feelingName}'.tr,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall),
                                                            ],
                                                            style: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 16)),
                                                      ])
                                                    : TextSpan(
                                                        text: '',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade700,
                                                            fontSize: 16)),
                                        TextSpan(
                                            text: getLocationText(model),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
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
                                                .bodySmall)
                                      ]),
                                    ])),
                                    const SizedBox(width: 4),
                                        userModel?.isProfileVerified == true
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      getIconAsPrivacy(
                                          model.post_privacy ?? ''),
                                      size: 17,
                                    )
                                  ],
                                ),
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
                              : Container(),

                          model.user_id?.id == currentUserModel.id
                              ? IconButton(
                                  onPressed: () {
                                    Get.bottomSheet(Container(
                                      margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                      height: viewType == 'profile'
                                          ? 385
                                          : viewType == 'bookmark'
                                              ? 340
                                              : 355,
                                      color: Theme.of(context).cardTheme.color,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          viewType == 'profile'
                                              ? InkWell(
                                                  onTap: onTapPinPost,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 20,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Icon(
                                                            Icons.push_pin,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8),
                                                          child:
                                                              model.pinPost ==
                                                                      false
                                                                  ? Text('Pin Post'.tr,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge
                                                                          ?.copyWith(
                                                                              fontWeight: FontWeight.bold),
                                                                    )
                                                                  : Text('UnPin Post'.tr,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyLarge
                                                                          ?.copyWith(
                                                                              fontWeight: FontWeight.bold),
                                                                    ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: onTapEditPost,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text('Edit Post'.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                            child:    Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.hide_image,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Hide Post'.tr,
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
                                          model.isBookMarked == false
                                              ? InkWell(
                                                  onTap: onTapBookMarkPost ??
                                                      () {},
                                                  child:    Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Icon(
                                                            Icons.bookmark,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Text('Book Mark'.tr,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap:
                                                      onTapRemoveBookMarkPost ??
                                                          () {},
                                                  child:    Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Icon(
                                                            Icons.bookmark,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Text('Remove Book Mark'.tr,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                            onTap:
                                                onTapViewPostHistory ?? () {},
                                            child:    Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.edit_note,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Edit History'.tr,
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
                                             InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.notification_add,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Turn off notification'.tr,
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
                                          InkWell(
                                            onTap: onTapCopyPost,
                                            child:    Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.link_off,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Copy link'.tr,
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
                                          InkWell(
                                            onTap: () async {
                                              showDeleteAlertDialogs(
                                                context: context,
                                                onCancel: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                  Get.back();
                                                },
                                                onDelete: () {
                                                  ProfileController controller =
                                                      Get.put(
                                                          ProfileController());
                                                  HomeController
                                                      homeController =
                                                      Get.put(HomeController());
                                                  controller.deletePost(
                                                      model.id.toString());
                                                  Get.back();
                                                  Navigator.of(context)
                                                      .pop(false);
                                                  controller.postList.value
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          model.id.toString());
                                                  homeController.postList.value
                                                      .removeWhere((element) =>
                                                          element.id ==
                                                          model.id.toString());
                                                  controller.postList.refresh();
                                                  homeController.postList
                                                      .refresh();
                                                },
                                              );
                                            },
                                            child:    Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Delete'.tr,
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
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ));
                                  },
                                  icon: const Icon(Icons.more_vert))
                              : IconButton(
                                  onPressed: () {
                                    Get.bottomSheet(Container(
                                      margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                      height: 300,
                                      color: Theme.of(context).cardTheme.color,
                                      child: Column(
                                        children: [
                                             SizedBox(
                                            height: 15,
                                          ),
                                          InkWell(
                                            onTap: onTapHidePost ?? () {},
                                            child:    Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.hide_image,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Hide Post'.tr,
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
                                          model.isBookMarked == false
                                              ? InkWell(
                                                  onTap: onTapBookMarkPost ??
                                                      () {},
                                                  child:    Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Icon(
                                                            Icons.bookmark,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Text('Book Mark'.tr,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap:
                                                      onTapRemoveBookMarkPost ??
                                                          () {},
                                                  child:    Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Icon(
                                                            Icons.bookmark,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8),
                                                          child: Text('Remove Book Mark'.tr,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                            child:    Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.app_blocking,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Block User'.tr,
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
                                             InkWell(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.notification_add,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Turn off notification'.tr,
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
                                          InkWell(
                                            onTap: onTapCopyPost,
                                            child:    Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Icon(
                                                      Icons.link_off,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Copy link'.tr,
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
                                          InkWell(
                                            onTap: () async {
                                              await homeController.getReports();
                                              CustomReportBottomSheet
                                                  .showReportOptions(
                                                context: context,
                                                pageReportList: homeController
                                                    .pageReportList.value,
                                                selectedReportType:
                                                    homeController
                                                        .selectedReportType,
                                                selectedReportId: homeController
                                                    .selectedReportId,
                                                reportDescription:
                                                    homeController
                                                        .reportDescription,
                                                onCancel: () {
                                                  Get.back();
                                                },
                                                reportAction:
                                                    (String report_type_id,
                                                        String report_type,
                                                        String page_id,
                                                        String description) {
                                                  homeController.reportAPost(
                                                      report_type: report_type,
                                                      description: description,
                                                      post_id: model.id ?? '',
                                                      report_type_id:
                                                          report_type_id);
                                                },
                                              );
                                            },
                                            child:    Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Icon(
                                                        Icons.report_outlined),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8),
                                                    child: Text('Report'.tr,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
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
                                  icon: Icon(
                                    Icons.more_vert,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: 25,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
  }

  getIconAsPrivacy(String postPrivacy) {
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
