import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../alert_dialogs/delete_alert_dialogs.dart';
import '../../../extension/string/string_image_path.dart';
import '../../../data/login_creadential.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../modules/NAVIGATION_MENUS/home/controllers/home_controller.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_groups/group_profile/components/custom_report_bottomsheet.dart';
import '../../../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/admin_page/controller/admin_page_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/profile_navigator.dart';
import '../../../utils/post_utlis.dart';
import '../../image.dart';
import '../../post_tag_list.dart';

class PagePostHeader extends StatelessWidget {
  final PostModel model;
  final VoidCallback? onTapEditPost;

  final VoidCallback? onTapBookMarkPost;
  final VoidCallback? onTapRemoveBookMarkPost;
  final VoidCallback? onTapCopyPost;
  final VoidCallback? onTapViewPostHistory;
  final VoidCallback? onTapPinPost;
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
        this.onTapRemoveBookMarkPost});

  RxString character = 'spam'.obs;

  TextEditingController reportDescription = TextEditingController();

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    UserModel currentUserModel = LoginCredential().getUserData();
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
                username: model.page_id?.pageUserName ?? '',
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
              imageUrl: (model.page_id?.profilePic ?? '')
                  .formatedProfileUrl,
            )
                : RoundCornerNetworkImage(
              imageUrl: (model.page_id?.profilePic ?? '')
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
                          text: '${model.page_id?.pageName}'.tr,
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
                          text: '${model.page_id?.pageName}'.tr,
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
                        text: '${model.page_id?.pageName}'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                            fontWeight:
                            FontWeight.bold),
                      )
                          : (model.post_type == 'timeline_post')
                          ? TextSpan(
                        text: '${model.page_id?.pageName}'.tr,
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
                            text: '${model.page_id?.pageName}'.tr,
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
                  Get.bottomSheet(
                      isScrollControlled: true,
                      Container(
                        margin: EdgeInsets.only(
                            bottom:
                            MediaQuery.of(context).padding.bottom),
                        height: viewType == 'profile' ||
                            viewType == 'PagePost'
                            ? MediaQuery.of(context).size.height *
                            (330 / 812)
                            : viewType == 'bookmark'
                            ? MediaQuery.of(context).size.height *
                            (325 / 812)
                            : MediaQuery.of(context).size.height *
                            (360 / 812),
                        color: Theme.of(context).cardTheme.color,
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context)
                                    .viewPadding
                                    .bottom +
                                    16,
                                left: 16,
                                right: 16,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: [
                                  viewType == 'profile' ||
                                      viewType == 'PagePost'
                                      ? InkWell(
                                    onTap: onTapPinPost,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          top: 10),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding:
                                            EdgeInsets.only(
                                                left: 14),
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize:
                                                  15),
                                            )
                                                : Text('UnPin Post'.tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize:
                                                  15),
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
                                    child:    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 14),
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8),
                                            child: Text('Edit Post'.tr,
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
                                  viewType == 'bookmark'
                                      ? Container()
                                      :    SizedBox(
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      Get.toNamed(Routes.EDIT_HISTORY,
                                          arguments: model.id);
                                    },
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
                                  SizedBox(
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
                                  SizedBox(
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      showDeleteAlertDialogs(
                                        context: context,
                                        onDelete: () {
                                          AdminPageController
                                          controller = Get.put(
                                              AdminPageController());
                                          HomeController
                                          homeController =
                                          Get.put(HomeController());
                                          controller.deletePost(
                                              model.id.toString(), model.key.toString());
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
                                        onCancel: () {
                                          Navigator.of(context)
                                              .pop(false);
                                          Get.back();
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                },
                icon:    Icon(Icons.more_vert))

            //  :
                : IconButton(
                onPressed: () {
                  Get.bottomSheet(Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    height: MediaQuery.of(context).size.height *
                        (250 / 812),
                    color: Theme.of(context).cardTheme.color,
                    child: SingleChildScrollView(
                      physics:    ClampingScrollPhysics(),
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            viewType == 'bookmark'
                                ? Container()
                                :    SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            model.isBookMarked == false
                                ? InkWell(
                              onTap: onTapBookMarkPost ?? () {},
                              child:    Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8),
                                      child: Icon(
                                        Icons.bookmark,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8),
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
                                : InkWell(
                              onTap: onTapRemoveBookMarkPost ??
                                      () {},
                              child:    Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8),
                                      child: Icon(
                                        Icons.bookmark,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8),
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
                            SizedBox(
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
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: onTapCopyPost,
                              child:    Padding(
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
                            SizedBox(
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
                                padding:    EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsets.only(left: 10.0),
                                      child:
                                      Icon(Icons.report_outlined),
                                    ),
                                    Padding(
                                      padding:    EdgeInsets.only(
                                          left: 8),
                                      child: GestureDetector(
                                        onTap: () async {
                                          ////////////////////report/////////////////////////////////////////////////

                                          ////////////////report///////////////////////////////////////////////////
                                        },
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
                      ),
                    ),
                  ));
                },
                icon:    Icon(Icons.more_vert)),
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
