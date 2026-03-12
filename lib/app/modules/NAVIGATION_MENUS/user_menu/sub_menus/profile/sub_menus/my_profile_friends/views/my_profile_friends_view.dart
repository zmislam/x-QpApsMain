import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../components/custom_friend_card.dart';
import '../../../../../../../../components/simmar_loader.dart';
import '../../../../../../../../routes/profile_navigator.dart';
import '../controllers/my_profile_friends_controller.dart';
import '../../../../../../../../models/friend.dart';

class MyProfileFriendsView extends GetView<MyProfileFriendsController> {
  const MyProfileFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend List'.tr,
        ),
      ),
      body: Column(
        children: [
          // =========================== search section ========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: TextField(
                decoration: InputDecoration(
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
                      ),
                    ),
                    TextSpan(
                      text: controller.searchKey.value.isEmpty
                          ? ' (${controller.friendList.value.length.toString()})'
                          : ' (${controller.searchedFriendList.value.length.toString()})',
                      style: TextStyle(
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
                      FriendModel friendModel =
                          controller.searchKey.value.isEmpty
                              ? controller.friendList.value[index]
                              : controller.searchedFriendList.value[index];

                      return InkWell(
                        onTap: () {
                          ProfileNavigator.navigateToProfile(
                              username: friendModel.friend?.username ?? '',
                              isFromReels: 'false');
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
