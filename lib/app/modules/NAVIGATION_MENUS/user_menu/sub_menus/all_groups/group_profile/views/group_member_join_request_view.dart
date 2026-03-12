import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../components/simmar_loader.dart';
import '../../group_admin/models/group_member_join_list_model.dart';
import '../controllers/group_profile_controller.dart';
import '../custom_widgets/custom_member_request_card.dart';

class GroupMemberJoinRequestView extends GetView<GroupProfileController> {
  const GroupMemberJoinRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getGroupMemberJoinRequest();
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Memeber Request'.tr,
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.white,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color.fromARGB(255, 94, 92, 92),
            thickness: 1.0,
            height: 1.0,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getGroupMemberJoinRequest();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Obx(
                    () => RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Member Request'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: controller.memberRequestList.value.isEmpty
                            ? ' (${controller.friendList.value.length.toString()})'
                            : ' (${controller.memberRequestList.value.length.toString()})',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ])),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() => controller.isLoadingMemberRequest.value == true
                  ? ShimmarLoadingView()
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.memberRequestList.value.isEmpty
                          ? controller.memberRequestList.value.length
                          : controller.memberRequestList.value.length,
                      itemBuilder: (context, index) {
                        GroupMemberRequestListModel memberRequestModel =
                            controller.memberRequestList.value.isEmpty
                                ? controller.memberRequestList.value[index]
                                : controller.memberRequestList.value[index];
                        return InkWell(
                          onTap: () {
                            // Get.toNamed(Routes.OTHERS_PROFILE,
                            //     arguments: friendModel.friend?.username);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: CustomMemberRequestCard(
                              model: memberRequestModel,
                              onTapAccept: () {
                                controller.groupMemberAcceptDeclinePost(
                                    invitationId: memberRequestModel.id,
                                    status: 'accept');
                                // Get.back();
                              },
                              onTapDecline: () async {
                                controller.groupMemberAcceptDeclinePost(
                                    invitationId: memberRequestModel.id,
                                    status: 'decline');
                                // Get.back();
                              },
                            ),
                          ),
                        );
                      },
                    )),
            ),
          ],
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
                        image: AssetImage(
                            'assets/image/default_profile_image.png'),
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
          }),
    );
  }
}
