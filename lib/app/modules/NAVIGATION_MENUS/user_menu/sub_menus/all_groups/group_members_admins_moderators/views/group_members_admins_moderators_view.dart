import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../components/simmar_loader.dart';
import '../components/group_member_card.dart';
import '../controllers/group_members_admins_moderators_controller.dart';

class GroupMembersAdminsModeratorsView
    extends GetView<GroupMembersAdminsModeratorsController> {
  const GroupMembersAdminsModeratorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Group Admins & Members'.tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Admins & Moderators'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoadingGroupMembers.value) {
                  return ShimmarLoadingView();
                } else {
                  final adminsAndModerators = controller.groupMemberList.value
                      .where((member) => member.role != 'member')
                      .toList();
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: adminsAndModerators.length,
                    itemBuilder: (context, index) {
                      final groupMemberListModel = adminsAndModerators[index];
                      return InkWell(
                        onTap: () {
                          // Handle on tap
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GroupMemberCard(
                            controller: controller,
                            model: groupMemberListModel,
                            onTapUnfriend: () {
                              // Handle unfriend
                            },
                            onPressBlockFriend: () async {
                              // Handle block friend
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
              const SizedBox(height: 10),
              Obx(() {
                final hasMembers = controller.groupMemberList.value
                    .any((member) => member.role == 'member');
                if (!hasMembers) {
                  return const SizedBox
                      .shrink(); // Return an empty widget if no members
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('All Members'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        if (controller.isLoadingGroupMembers.value) {
                          return ShimmarLoadingView();
                        } else {
                          final membersOnly = controller.groupMemberList.value
                              .where((member) => member.role == 'member')
                              .toList();
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: membersOnly.length,
                            itemBuilder: (context, index) {
                              final groupMemberListModel = membersOnly[index];
                              return InkWell(
                                onTap: () {
                                  // Handle on tap
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: GroupMemberCard(
                                    controller: controller,
                                    model: groupMemberListModel,
                                    onTapUnfriend: () {
                                      // Handle unfriend
                                    },
                                    onPressBlockFriend: () async {
                                      // Handle block friend
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height,
      child: ListView.builder(
        itemCount: 15,
        itemBuilder: (BuildContext context, index) {
          return ShimmerLoader(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                leading: Container(
                  height: Get.width * 0.40,
                  width: Get.width * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          AssetImage('assets/image/default_profile_image.png'),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.white, width: 0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      width: Get.width - 120,
                    ),
                    const SizedBox(height: 7),
                    Container(
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.white, width: 0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      width: Get.width / 2 - 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
