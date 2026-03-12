import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../components/custom_friend_card.dart';
import '../../../../../components/simmar_loader.dart';
import '../../../../../models/friend.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../routes/app_pages.dart';

class OtherFriendListComponent extends StatelessWidget {
  const OtherFriendListComponent({
    super.key,
    required this.controller,
  });
  final OthersProfileController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withValues(alpha: .3)),
          child: TextField(
              decoration:  InputDecoration(
                  border: InputBorder.none, hintText: 'Search friends'.tr),
              onChanged: (value) {
                controller.filterFriend(value);
              }),
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
                    text: 'Friends'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: controller.searchKey.value.isEmpty
                        ? ' (${controller.friendList.value.length.toString()})'
                        : ' (${controller.searchedFriendList.value.length.toString()})',
                    style: const TextStyle(
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
          child: Obx(() => controller.isLoadingFriendList.value == true
              ? ShimmarLoadingView()
              : ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.searchKey.value.isEmpty
                      ? controller.friendList.value.length
                      : controller.searchedFriendList.value.length,
                  itemBuilder: (context, index) {
                    FriendModel friendModel = controller.searchKey.value.isEmpty
                        ? controller.friendList.value[index]
                        : controller.searchedFriendList.value[index];
                    return InkWell(
                      onTap: () {
                        if (friendModel.friend?.username !=
                            LoginCredential().getUserData().username) {
                          if (Get.isRegistered<OthersProfileController>()) {
                            Get.delete<OthersProfileController>();
                          }
                          Get.toNamed(
                            Routes.OTHERS_PROFILE,
                            arguments: {
                              'username': friendModel.friend?.username,
                              'isFromReels': 'false',
                            },
                          );
                        } else {
                          Get.toNamed(Routes.PROFILE);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomFriendCard(
                          model: friendModel,
                          onTapUnfriend: () {
                            controller.unfriendFriends('${friendModel.id}');
                            Get.back();
                          },
                          onPressBlockFriend: () async {
                            controller
                                .blockFriends('${friendModel.friend?.id}');
                            Get.back();
                          },
                        ),
                      ),
                    );
                  },
                )),
        ),
      ],
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
