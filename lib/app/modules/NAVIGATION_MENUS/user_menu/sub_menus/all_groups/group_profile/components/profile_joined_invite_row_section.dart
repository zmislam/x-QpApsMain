import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../config/constants/app_assets.dart';
import '../../../../../../../utils/copy_to_clipboard_utils.dart';
import '../../create_group/models/friend_list_model.dart';
import '../controllers/group_profile_controller.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';

class GroupProfileJoinedInviteRowButtons extends StatelessWidget {
  final GroupProfileController controller;
  const GroupProfileJoinedInviteRowButtons(
      {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isGroupMember.value == false &&
            controller.allGroupModel.value?.groupPrivacy == 'private'
        ? Container(
            height: Get.height,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // controller.groupsController
                    controller
                        .joinGroupRequestPost(
                          groupId: controller.allGroupModel.value?.id,
                          userIdArray:
                              controller.loginCredential.getUserData().id,
                        )
                        .whenComplete(() => controller
                            .fetchGroupDetails()
                            .whenComplete(() => controller.update()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.transparent)),
                    child: Text(
                      // controller.groupsController.isJoinRequestSent.value ==
                      controller.isJoinRequestSent.value == true
                          ? 'Requested'
                          : 'Join Group',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('About'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          controller.allGroupModel.value?.groupDescription ??
                              '',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 15,
                          style: TextStyle(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock,
                              size: 30,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              controller.allGroupModel.value?.groupPrivacy
                                      ?.capitalizeFirst ??
                                  '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          'Only member can see who\'s in the group and what they post',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 30,
                            ),
                            SizedBox(width: 5),
                            Text('Visible'.tr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text('Anyone can find this group'.tr,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Text('History'.tr,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text('Group created on September 23, 2024'.tr,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ============= manage group, join, and joined button =========
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 40,
                      decoration: BoxDecoration(
                          color: controller.isGroupMember.value == true &&
                                  (controller.groupRole.value == 'admin' ||
                                      controller.groupRole.value == 'moderator')
                              ? const Color(0xFFE4E6EB)
                              : PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () async {
                          if (controller.isGroupMember.value == false) {
                            await controller
                                .joinGroupRequestPost(
                                  groupId: controller.allGroupModel.value?.id,
                                  userIdArray: controller.loginCredential
                                      .getUserData()
                                      .id,
                                )
                                .whenComplete(() => controller
                                    .fetchGroupDetails()
                                    .whenComplete(() => controller.update()));
                          } else if (controller.isGroupMember.value == true &&
                              (controller.groupRole.value == 'admin' ||
                                  controller.groupRole.value == 'moderator')) {
                            Get.toNamed(Routes.GROUP_SETTING, arguments: {
                              'group_model': controller.allGroupModel,
                              'group_role': ''
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: controller.isGroupMember.value
                              ? (controller.groupRole.value == 'admin' ||
                                      controller.groupRole.value == 'moderator'
                                  ? PRIMARY_COLOR
                                  : Colors.white)
                              : PRIMARY_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: controller.isGroupMember.value &&
                                    (controller.groupRole.value != 'admin' &&
                                        controller.groupRole.value !=
                                            'moderator')
                                ? const BorderSide(
                                    // color: Colors.none,
                                    // width: 2.0
                                    )
                                : BorderSide.none,
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            controller.isGroupMember.value
                                ? (controller.groupRole.value == 'admin' ||
                                        controller.groupRole.value ==
                                            'moderator'
                                    ? Image.asset(
                                        AppAssets.SETTINGS_ICON,
                                        color: controller.isGroupMember.value
                                            ? (controller.groupRole.value ==
                                                        'admin' ||
                                                    controller
                                                            .groupRole.value ==
                                                        'moderator'
                                                ? Colors.white
                                                : Colors.black)
                                            : Colors.white,
                                      )
                                    : Image.asset(
                                        'assets/icon/group_profile/joined.png',
                                        color: controller.isGroupMember.value
                                            ? (controller.groupRole.value ==
                                                        'admin' ||
                                                    controller
                                                            .groupRole.value ==
                                                        'moderator'
                                                ? Colors.white
                                                : Colors.black)
                                            : Colors.white,
                                      ))
                                : Image.asset(
                                    'assets/icon/group_profile/joined.png',
                                    color: controller.isGroupMember.value
                                        ? (controller.groupRole.value ==
                                                    'admin' ||
                                                controller.groupRole.value ==
                                                    'moderator'
                                            ? Colors.white
                                            : Colors.black)
                                        : Colors.white,
                                  ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                controller.isGroupMember.value == true
                                    ? (controller.groupRole.value == 'admin' ||
                                            controller.groupRole.value ==
                                                'moderator'
                                        ? 'Manage Group'
                                        : 'Joined')
                                    : 'Join',
                                style: TextStyle(
                                  color: controller.isGroupMember.value
                                      ? (controller.groupRole.value ==
                                                  'admin' ||
                                              controller.groupRole.value ==
                                                  'moderator'
                                          ? Colors.white
                                          : Colors.black)
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                const SizedBox(width: 8),
                // ======================== invite button ======================
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                        onPressed: () {
                          controller.inviteFriendList();
                          Get.bottomSheet(
                            Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Invite Your friends to this Group'.tr,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: const Icon(Icons.close))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Obx(() {
                                      List<FriendResultModel>
                                          filteredFriendList = controller
                                              .friendList.value
                                              .where((invitefreindList) =>
                                                  invitefreindList.friend?.id !=
                                                  controller.loginCredential
                                                      .getUserData()
                                                      .id)
                                              .toList();

                                      return ListView.builder(
                                        itemCount: filteredFriendList.length,
                                        itemBuilder: (context, index) {
                                          FriendResultModel invitefreindList =
                                              filteredFriendList[index];

                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 60,
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 20,
                                                        child: ClipOval(
                                                          child: Image(
                                                            image: NetworkImage(
                                                              (
                                                                  invitefreindList
                                                                          .friend
                                                                          ?.profilePic ??
                                                                      '').formatedProfileUrl,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        (invitefreindList.friend
                                                                    ?.firstName ??
                                                                '') +
                                                            (' ') +
                                                            (invitefreindList
                                                                    .friend
                                                                    ?.lastName ??
                                                                ''),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Obx(
                                                  () => Checkbox(
                                                    activeColor: PRIMARY_COLOR,
                                                    value: controller
                                                        .selectedFriendList
                                                        .value
                                                        .contains(
                                                            invitefreindList),
                                                    onChanged: (bool? changed) {
                                                      if (changed == true) {
                                                        if (!controller
                                                            .selectedFriendList
                                                            .value
                                                            .contains(
                                                                invitefreindList)) {
                                                          controller
                                                              .selectedFriendList
                                                              .value
                                                              .add(
                                                                  invitefreindList);
                                                        }
                                                      } else {
                                                        controller
                                                            .selectedFriendList
                                                            .value
                                                            .remove(
                                                                invitefreindList);
                                                      }

                                                      controller
                                                          .selectedFriendList
                                                          .refresh();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ),
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: PRIMARY_COLOR,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextButton(
                                      onPressed: () {
                                        controller.sendFriendInvitation();
                                      },
                                      child: Text('Send'.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icon/group_profile/invite.png'),
                            const SizedBox(width: 8),
                            Text('Invite'.tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFE4E6EB),
                  ),
                  child: PopupMenuButton(
                    color: Colors.white,
                    // offset: const Offset(-50, 00),
                    iconColor: Colors.red,
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                    ),
                    itemBuilder: (context) {
                      List<PopupMenuEntry<int>> menuItems = [];
                      //====================================================== Leave Group =======================================//

                      if (controller.isGroupMember.value == true) {
                        menuItems.add(
                          PopupMenuItem(
                            onTap: () {
                              controller.getGroupAdminList().whenComplete(() {
                                if (controller.groupRole.value == 'admin' &&
                                    controller.adminCount.value == 1 &&
                                    (controller.allGroupModel.value
                                                ?.joinedGroupsCount ??
                                            0) ==
                                        2) {
                                  Get.dialog(
                                    AlertDialog(
                                      contentPadding: const EdgeInsets.all(20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: SizedBox(
                                        height: 180,
                                        width: Get.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header section
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.remove_circle_rounded,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 10),
                                                Text('Leave from group!'.tr,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Are you sure you want to remove from ${controller.allGroupModel.value?.groupName?.capitalizeFirst ?? ''} group? Please assign at least one group admin first.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      side: const BorderSide(
                                                          color: GREY_COLOR),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12),
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child:
                                                        Text('Disagree'.tr),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12),
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      Get.toNamed(
                                                        Routes
                                                            .GROUP_TRANSFER_OWNERSHIP,
                                                        arguments: {
                                                          'group_model':
                                                              controller
                                                                  .allGroupModel,
                                                          'group_role': 'admin',
                                                        },
                                                      );
                                                      debugPrint(
                                                          'Admin Count::::::::::::::::::::::::${controller.adminCount.value}');
                                                    },
                                                    child: Text('Agree'.tr),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                  return; // Prevent further execution of the else block
                                }

                                if (controller.groupRole.value == 'admin' &&
                                    (controller.allGroupModel.value
                                                ?.joinedGroupsCount ??
                                            0) ==
                                        1) {
                                  Get.dialog(
                                    AlertDialog(
                                      contentPadding: const EdgeInsets.all(20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: SizedBox(
                                        height: 200,
                                        width: Get.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header section
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // Icon(
                                                //   Icons.delete,
                                                //   color: Colors.red,
                                                // ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Text('Confirm Leave and Delete the group'.tr,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text('Are you sure you want to delete all group info? This action will also remove all related post activities and cannot be undone'.tr,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      side: const BorderSide(
                                                          color: GREY_COLOR),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12),
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text('Cancel'.tr),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12),
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      controller.deleteGroup();
                                                    },
                                                    child: Text('Delete'.tr),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // If no dialog is shown, proceed with leaveFromGroupPatch
                                controller
                                    .leaveFromGroupPatch()
                                    .whenComplete(() => controller.update());
                              });
                            },
                            value: 1,
                            child: Text('Leave Group'.tr,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }
                      menuItems.add(PopupMenuItem(
                          onTap: () async {
                            CopyToClipboardUtils.copyToClipboard(
                                '${ApiConstant.SERVER_IP}/groups/groups-single-page/${controller.allGroupModel.value?.id}',
                                'Link');
                          },
                          value: 2,
                          child: Text('Share'.tr,
                            style: TextStyle(color: Colors.black),
                          )));
                      //====================================================== Member Request =======================================//
                      if (controller.allGroupModel.value?.groupPrivacy ==
                              'private' &&
                          controller.groupRole.value == 'admin') {
                        menuItems.add(
                          PopupMenuItem(
                            onTap: () {
                              Get.toNamed(Routes.GROUP_MEMBER_LIST);
                            },
                            value: 3,
                            child: Text('Member Request'.tr,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }

                      return menuItems;
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ));
  }
}
