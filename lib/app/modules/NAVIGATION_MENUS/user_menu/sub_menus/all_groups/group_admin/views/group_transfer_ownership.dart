import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../extension/string/string_image_path.dart';
import '../../../../../../../components/dropdown.dart';
import '../controllers/group_settings_controller.dart';
import '../models/group_all_group_members_model.dart';
import '../../../../../../../config/constants/color.dart';

class GroupTransferOwnerShipView extends GetView<GroupSettingsController> {
  const GroupTransferOwnerShipView({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> roles = ['Admin', 'Moderator'];
    controller.selectedGroupMemberList.clear();
    controller.allGroupMemberList.clear();

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text('Add Group Admin & Moderator'.tr,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getGroupAdminList();
          await controller.getGroupModeratorList();
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Role'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Obx(
                () => SecondaryDropDownField(
                  list: roles,
                  selectedItem:
                      controller.selectedUserRole.value.capitalizeFirst ==
                              'Admin'
                          ? roles.first
                          : null,
                  onChanged:
                      controller.selectedUserRole.value.capitalizeFirst ==
                              'Admin'
                          ? null
                          : (changed) {
                              controller.selectedUserRole.value =
                                  changed as String? ?? 'Admin';
                            },
                  hint: 'Select Role',
                  validationText: 'Please select a role',
                ),
              ),
              const SizedBox(height: 20),
              Text('Search Members'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search members...'.tr,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  controller.searchFriends(value);
                },
              ),
              const SizedBox(height: 20),
              Obx(
                () => Visibility(
                  visible: controller.selectedGroupMemberList.isNotEmpty,
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.selectedGroupMemberList
                          .where((member) =>
                              member.groupMemberUserId?.id !=
                              controller.loginCredential.getUserData().id)
                          .toList()
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        List<GroupMembersModel> filteredList = controller
                            .selectedGroupMemberList
                            .where((member) =>
                                member.groupMemberUserId?.id !=
                                controller.loginCredential.getUserData().id)
                            .toList();

                        GroupMembersModel makeAdminfromList =
                            filteredList[index];

                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${makeAdminfromList.groupMemberUserId?.firstName ?? ''} ${makeAdminfromList.groupMemberUserId?.lastName ?? ''}',
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.selectedGroupMemberList
                                        .remove(makeAdminfromList);
                                    controller.selectedGroupMemberList
                                        .refresh();
                                  },
                                  child: const Icon(Icons.close,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('All Members'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.filteredMemberList
                        .where((member) =>
                            member.groupMemberUserId?.id !=
                            controller.loginCredential.getUserData().id)
                        .toList()
                        .length,
                    itemBuilder: (context, index) {
                      List<GroupMembersModel> filteredList = controller
                          .filteredMemberList
                          .where((member) =>
                              member.groupMemberUserId?.id !=
                              controller.loginCredential.getUserData().id)
                          .toList();

                      GroupMembersModel filteredMember = filteredList[index];

                      return InkWell(
                        onTap: () {
                          if (!controller.selectedGroupMemberList
                              .contains(filteredMember)) {
                            controller.selectedGroupMemberList
                                .add(filteredMember);
                          }
                        },
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  (filteredMember
                                              .groupMemberUserId?.profilePic ??
                                          '')
                                      .formatedProfileUrl,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${filteredMember.groupMemberUserId?.firstName ?? ''} ${filteredMember.groupMemberUserId?.lastName ?? ''}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: controller.selectedGroupMemberList.isNotEmpty
                        ? PRIMARY_COLOR
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (controller.selectedUserRole.value.capitalizeFirst ==
                              'Admin' &&
                          controller.selectedGroupMemberList.isNotEmpty) {
                        controller.groupTransferOwnerShip();
                      }
                    },
                    child: Text('Add'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
