import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../routes/profile_navigator.dart';
import '../controllers/group_settings_controller.dart';
import '../models/group_all_group_admin_model.dart';
import '../models/group_all_group_moderators_model.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../config/constants/color.dart';

class GroupAdminModeratorListView extends GetView<GroupSettingsController> {
  const GroupAdminModeratorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,

        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Admin & Moderator'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.ADD_GROUP_ADMIN_MODERATOR,
                        arguments: controller.allGroupModel);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 15, top: 10, bottom: 10),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: PRIMARY_COLOR,
                      border: Border.all(),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text('Add'.tr,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            RefreshIndicator(
              onRefresh: () async {
                await controller.getGroupAdminList();
                controller.getGroupModeratorList();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Group Admin'.tr,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Obx(
                        () => ListView.builder(
                          itemCount: controller.allAdminsList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _buildAdminTile(controller.adminDetails =
                                controller.allAdminsList[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => (controller.moderatorCount.value != 0)
                            ? Text('Group Moderator'.tr,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            : SizedBox(
                                child: Center(
                                    child: Text('No Group Moderator'.tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: PRIMARY_COLOR),
                                )),
                              ),
                      ),
                      Obx(
                        () => ListView.builder(
                          itemCount: controller.allModeratorsList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _buildModeratorTile(
                                controller.moderatorDetails =
                                    controller.allModeratorsList[index]);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminTile(GroupAdminModel admin) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            (admin.groupMemberUserId.profilePic).formatedProfileUrl),
      ),
      title: InkWell(
        onTap: () {
          ProfileNavigator.navigateToProfile(
              username: admin.groupMemberUserId.username, isFromReels: 'false');
        },
        child: Text('${admin.groupMemberUserId.firstName} ${admin.groupMemberUserId.lastName}'.tr),
      ),
      // subtitle: Text(admin.groupMemberUserId.joined),
      trailing: (controller.adminCount.value ) > 1
          ? PopupMenuButton(
              color: Colors.white,
              // offset: const Offset(-50, 00),
              iconColor: Colors.red,
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (context) {
                List<PopupMenuEntry<int>> menuItems = [];
                //====================================================== Remove Admin =======================================//

                menuItems.add(
                  PopupMenuItem(
                    onTap: () {
                      controller.removeAdminOrModerator(
                          groupMemberId: admin.id,
                          groupMemberUserId: admin.groupMemberUserId.id,
                          role: 'member');
                    },
                    value: 1,
                    child: Text('Remove Admin'.tr,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );

                return menuItems;
              },
            )
          : const SizedBox(),
    );
  }

  Widget _buildModeratorTile(GroupModeratorDetails moderator) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage((
              moderator.groupMemberUserId.profilePic ?? '').formatedProfileUrl),
        ),
        title: InkWell(
          onTap: () {
            ProfileNavigator.navigateToProfile(
                username: moderator.groupMemberUserId.username ?? '',
                isFromReels: 'false');
          },
          child: Text('${moderator.groupMemberUserId.firstName} ${moderator.groupMemberUserId.lastName}'.tr),
        ),
        // subtitle: Text(admin.groupMemberUserId.joined),
        trailing: PopupMenuButton(
          color: Colors.white,
          // offset: const Offset(-50, 00),
          iconColor: Colors.red,
          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          itemBuilder: (context) {
            List<PopupMenuEntry<int>> menuItems = [];
            //====================================================== Remove Moderator =======================================//

            menuItems.add(
              PopupMenuItem(
                onTap: () {
                  controller.removeAdminOrModerator(
                      groupMemberId: moderator.id,
                      groupMemberUserId: moderator.groupMemberUserId.id,
                      role: 'member');
                },
                value: 1,
                child: Text('Remove Moderator'.tr,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );

            return menuItems;
          },
        )

        // IconButton(
        //   icon: const Icon(Icons.more_vert),
        //   onPressed: () {
        //     // Handle more options
        //   },
        // ),
        );
  }
}
