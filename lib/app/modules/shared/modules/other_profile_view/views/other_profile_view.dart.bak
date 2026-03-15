import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/app_constant.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../utils/applauncher_helper/applauncher_helper.dart';
import '../../../../../components/profile_tile.dart';
import '../../../../../components/profile_view_banner_image.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../routes/app_pages.dart';
import '../components/feed_component.dart';
import '../components/others_reels_component.dart';
import '../components/photos_component.dart';
import '../controller/other_profile_controller.dart';

class OtherProfileView extends GetView<OthersProfileController> {
  const OtherProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Data fetching is handled in OthersProfileController.onInit()
    // DO NOT call API methods here — build() runs on every rebuild

    List<Widget> otherProfileWidgetList = [
      OtherFeedComponent(controller: controller),
      OtherPhotosComponent(controller: controller),
      OthersProfileReelsComponent(controller: controller),
    ];

    return Scaffold(
      // ======================= refresh indicator =============================
      body: RefreshIndicator(
        color: Theme.of(context).indicatorColor,
        backgroundColor: Theme.of(context).cardTheme.color,
        onRefresh: controller.refresh,
        child: SingleChildScrollView(
          controller: controller.postScrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => PrifileViewBannerImage(
                  profileImageUpload: () {},
                  coverImageUpload: () {},
                  banner: controller.profileModel.value?.cover_pic != null
                      ? ('${controller.profileModel.value?.cover_pic}')
                          .formatedProfileUrl
                      : 'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                  profilePic: controller.profileModel.value?.profile_pic != null
                      ? ('${controller.profileModel.value?.profile_pic}')
                          .formatedProfileUrl
                      : 'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
                  enableImageUpload: false,
                  removeCoverPhoto: () {},
                  removeProfilePhoto: () {},
                ),
              ),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${controller.profileModel.value?.first_name ?? ''} ${controller.profileModel.value?.last_name ?? ''}',
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22,),
                      ),
                      const SizedBox(width: 6),
                      controller.profileModel.value?.isProfileVerified == true
                          ? Icon(
                              Icons.verified,
                              color: PRIMARY_COLOR,
                              size: 20,
                            )
                          : const SizedBox(),
                    ],
                  )),
              controller.profileModel.value?.user_bio == null
                  ? const SizedBox()
                  : const SizedBox(height: 10),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 20,
                    alignment: Alignment.center,
                    child: Text(controller.profileModel.value?.user_bio ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16)),
                  ),
                ),
              ),
              controller.profileModel.value?.user_bio == null
                  ? const SizedBox()
                  : const SizedBox(
                      height: 8,
                    ),
              const Divider(),

              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ===================== friend button =======================
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: 35,
                    decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        TextButton(
                          onPressed: () {
                            if (controller.friendStatus.value == '0' ||
                                controller.friendStatus.value == '') {
                              if (controller.hasSentRequest.value == true)
                              //if friend
                              {
                                controller.cancelFriendRequest(
                                    userId: controller.profileModel.value?.id ??
                                        '');
                                controller.friendStatus.value = '';
                              }

                              if (controller.friendStatus.value == '0' ||
                                  controller.friendStatus.value == '' &&
                                      controller.connectedUserID.value ==
                                          controller.currentUserModel.id) {
                                controller.actionOnFriendRequest(
                                    action: 1,
                                    requestId:
                                        controller.respondToUserID.value);
                              }

                              if (controller.hasSentRequest.value == true)
                              //if friend
                              {
                                controller.cancelFriendRequest(
                                    userId: controller.profileModel.value?.id ??
                                        '');
                                controller.friendStatus.value = '';
                              } else {
                                controller.sendFriendRequest(
                                    userId: controller.profileModel.value?.id ??
                                        '');
                                controller.friendStatus.value = '0';
                              }
                            }
                          },
                          child: Obx(() {
                            if (controller.friendStatus.value == '1') {
                              return Text(
                                'Friend'.tr,
                                style: TextStyle(color: Colors.white),
                              );
                            } else if (controller.friendStatus.value == '0' &&
                                controller.connectedUserID.value !=
                                    controller.currentUserModel.id) {
                              return Text(
                                'Cancel  Request'.tr,
                                style: TextStyle(color: Colors.white),
                              );
                            } else if (controller.friendStatus.value == '0' &&
                                controller.connectedUserID.value ==
                                    controller.currentUserModel.id) {
                              return InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              controller.actionOnFriendRequest(
                                                  action: 1,
                                                  requestId: controller
                                                      .respondToUserID.value);

                                              Get.back();
                                            },
                                            child: Row(
                                              children: [
                                                // Icon(
                                                //   Icons.person,
                                                //   color: PRIMARY_COLOR,
                                                // )
                                                Image.asset(
                                                  height: 32,
                                                  'assets/icon/other_profile/accept_request.png',
                                                ),

                                                const SizedBox(
                                                  width: 10,
                                                ),

                                                Text(
                                                  'Confirm Friend'.tr,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              controller.actionOnFriendRequest(
                                                  action: 0,
                                                  requestId: controller
                                                      .respondToUserID.value);
                                              controller.unfriendId.value == '';
                                              Get.back();
                                            },
                                            child: Row(
                                              children: [
                                                // Icon(
                                                //   Icons.cancel_outlined,
                                                //   color: Colors.red,
                                                // ),
                                                Image.asset(
                                                    height: 32,
                                                    'assets/icon/other_profile/cancel.png'),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Delete Request'.tr,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    isScrollControlled:
                                        true, // To make the BottomSheet take full width
                                  );
                                },
                                child: Text(
                                  'Respond'.tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else if (controller.friendStatus.value == '' ||
                                controller.unfriendId.value == '') {
                              return Text(
                                'Add Friend'.tr,
                                style: TextStyle(color: Colors.white),
                              );
                            } else {
                              return Text(
                                'Add Friend'.tr,
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // ============================ message button ========================
                  Container(
                    height: 35,
                    width: Get.width * 0.34,
                    decoration: BoxDecoration(
                        color:
                            PRIMARY_COLOR, //Colors.grey.withValues(alpha:0.5),
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon/other_profile/messanger.png',
                          height: 20,
                          width: 20,
                        ),
                        TextButton(
                          onPressed: () async {
                            Get.snackbar('🎉 Almost Ready!',
                                'Get the messenger app and start amazing conversations with your friends! ✨');
                            // await controller
                            //     .getIndividualChatDetails(
                            //         userId:
                            //             controller.profileModel.value?.userInfo?.id ?? '')
                            //     .then((_) {
                            //   final encodedChat = Uri.encodeComponent(
                            //       jsonEncode(
                            //           controller.individualChatDetails.value));
                            //   debugPrint(
                            //       'Encoded ChatModel::::::::::::::::::: $encodedChat');
                            //   AppLauncherHelper.launchQPApp(
                            //     deepLinkUrl:
                            //         '${AppConstant.QP_MESSENGER_DEEP_MESSAGE_URL}?chat=$encodedChat',
                            //     fallbackUrl:
                            //         AppConstant.QP_MESSENGER_FALL_BACK_URL,
                            //   );
                            // });
                          },
                          child: Text(
                            'Message'.tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // ========================== popup button ===================
                  Container(
                      height: 35,
                      width: Get.width * 0.14,
                      decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(7)),
                      child: PopupMenuButton(
                        color: Theme.of(context).cardTheme.color,
                        offset: const Offset(10, 50),
                        icon: const Icon(
                          Icons.more_horiz,
                        ),
                        itemBuilder: (context) {
                          List<PopupMenuEntry> items = [];

                          if (controller.friendStatus.value != '0' &&
                              controller.friendStatus.value != '') {
                            items.add(
                              PopupMenuItem(
                                onTap: () async {
                                  await controller.unfriendFriends(
                                      controller.profileModel.value?.id ?? '');
                                },
                                child: Row(
                                  children: [
                                    Image(
                                      height: 25,
                                      width: 25,
                                      fit: BoxFit.cover,
                                      color: Theme.of(context).iconTheme.color,
                                      image: const AssetImage(
                                        AppAssets.UNFRIEND_ICON,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Unfriend'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          if (controller.isFollowerResult.value == true) {
                            items.add(
                              PopupMenuItem(
                                onTap: () async {
                                  controller.followUnfollowStatus.value = '0';
                                  await controller.followUnfollowOtherUser();
                                },
                                child: Row(
                                  children: [
                                    Image(
                                      height: 25,
                                      width: 25,
                                      color: Theme.of(context).iconTheme.color,
                                      fit: BoxFit.cover,
                                      image: const AssetImage(
                                        AppAssets.UNFOLLOW_ICON,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Unfollow'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }

                          if (controller.isFollowerResult.value == false) {
                            items.add(
                              PopupMenuItem(
                                onTap: () async {
                                  controller.followUnfollowStatus.value = '1';
                                  await controller.followUnfollowOtherUser();
                                },
                                child: Row(
                                  children: [
                                    Image(
                                      height: 25,
                                      width: 25,
                                      color: Theme.of(context).iconTheme.color,
                                      fit: BoxFit.cover,
                                      image: const AssetImage(
                                        AppAssets.FOLLOW_ICON,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Follow'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          items.addAll([
                            PopupMenuItem(
                              onTap: () async {
                                Get.dialog(AlertDialog(
                                  contentPadding: const EdgeInsets.all(0),
                                  content: Container(
                                    decoration: BoxDecoration(
                                      color: PRIMARY_COLOR,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 200,
                                    width: Get.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Block A Friend'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .cardTheme
                                                    .color),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Are you sure, you want to block?'
                                                          .tr,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            foregroundColor:
                                                                PRIMARY_COLOR,
                                                          ),
                                                          onPressed: () {
                                                            // Get.back();
                                                            Get.toNamed(
                                                                Routes.HOME);
                                                          },
                                                          child: Text(
                                                            'No'.tr,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                PRIMARY_COLOR,
                                                            foregroundColor:
                                                                Colors.white,
                                                          ),
                                                          onPressed: () async {
                                                            await controller
                                                                .blockFriends(controller
                                                                        .profileModel
                                                                        .value
                                                                        ?.id ??
                                                                    '');
                                                            Get.back();
                                                          },
                                                          child: Text('Yes'.tr),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.block,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Block this person'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                          return items;
                        },
                      )),
                ],
              ),
              const SizedBox(
                height: 29,
              ),
              // //====================================================================== Other Profile Info ======================================================================//
              Obx(
                () => (controller
                            .profileModel.value?.userWorkplaces?.isNotEmpty ??
                        false)
                    ? ProfileTile(
                        company: controller.profileModel.value?.userWorkplaces
                                ?.last.org_name ??
                            '',
                        designation:
                            '${controller.profileModel.value?.userWorkplaces?.first.designation ?? 'Works'} at ',
                        icon: const Image(
                          height: 25,
                          width: 25,
                          image: AssetImage(
                            AppAssets.WORK_ICON,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),

              Obx(() => (controller.profileModel.value?.educationWorkplaces
                          ?.isNotEmpty ??
                      false)
                  ? ProfileTile(
                      company: controller.profileModel.value
                              ?.educationWorkplaces?.first.institute_name ??
                          '',
                      designation:
                          '${controller.profileModel.value?.educationWorkplaces?.first.designation ?? 'Studied'} at ',
                      icon: const Image(
                        height: 30,
                        width: 30,
                        image: AssetImage(AppAssets.SCHOOL_ICON),
                      ),
                    )
                  : Container()),

              Obx(
                () => Visibility(
                  visible: controller.profileModel.value?.present_town != null,
                  child: ProfileTile(
                      company: '${controller.profileModel.value?.present_town}',
                      designation: 'Lives in ',
                      icon: const Image(
                        height: 30,
                        width: 30,
                        image: AssetImage(AppAssets.HOME_ICON),
                      )),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.profileModel.value?.home_town != null,
                  child: ProfileTile(
                    company: '${controller.profileModel.value?.home_town}',
                    designation: 'From ',
                    icon: const Image(
                      height: 30,
                      width: 30,
                      image: AssetImage(AppAssets.LOCATION_ICON),
                    ),
                  ),
                ),
              ),
              Obx(
                () => controller.profileModel.value != null
                    ? InkWell(
                        onTap: () {
                          Get.toNamed(Routes.OTHER_PROFILA_DETAIL);
                        },
                        child: ProfileTile(
                          company: '',
                          designation:
                              'See ${controller.profileModel.value?.first_name} ${controller.profileModel.value?.last_name}\'s  about info.',
                          icon: const Icon(Icons.more_horiz),
                        ),
                      )
                    : Container(),
              ),
              const Divider(),
              const SizedBox(height: 7),
              Visibility(
                visible: '${controller.currentUserModel.lock_profile}' != '1',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.otherProfileWidgetViewNumber.value = 0;
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Obx(
                              () => Text(
                                'Feed'.tr,
                                style: controller.otherProfileWidgetViewNumber
                                            .value ==
                                        0
                                    ? TextStyle(color: PRIMARY_COLOR)
                                    : Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.otherProfileWidgetViewNumber.value = 1;
                            controller.getOtherPhotos();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Obx(
                              () => Text(
                                'Photos'.tr,
                                style: controller.otherProfileWidgetViewNumber
                                            .value ==
                                        1
                                    ? TextStyle(color: PRIMARY_COLOR)
                                    : Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.otherProfileWidgetViewNumber.value = 2;
                            controller.getUserReels(controller.username ?? '');
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Obx(
                              () => Text(
                                'Reels'.tr,
                                style: controller.otherProfileWidgetViewNumber
                                            .value ==
                                        2
                                    ? TextStyle(color: PRIMARY_COLOR)
                                    : Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.OTHER_FRIEND_LIST,
                                arguments: controller.username);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Friends'.tr,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Obx(() => otherProfileWidgetList[
                        controller.otherProfileWidgetViewNumber.value]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
