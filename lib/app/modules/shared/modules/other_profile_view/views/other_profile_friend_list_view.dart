import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../../components/simmar_loader.dart';
import '../../../../../enum/other_user_friend_follower_following.dart';
import '../components/other_friendlist_component.dart';
import '../components/other_user_follower_list.dart';
import '../components/other_user_following_list.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../config/constants/color.dart';

class OtherProfileFriendsView extends GetView<OthersProfileController> {
  const OtherProfileFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      OtherFriendListComponent(controller: controller),
      OtherFriendListComponent(controller: controller),
      OtherUserFollowingListComponent(controller: controller),
      OtherUserFollowerListComponent(controller: controller),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Friend List'.tr,
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: ListView(
              // padding: const EdgeInsets.all(5.0),
              scrollDirection: Axis.horizontal,
              children: FriendCategory.values.map((category) {
                return Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ActionChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      label: Text(
                        category.displayTitle.toString().split('.').last,
                        style: TextStyle(
                            color: controller.selectedCategory.value == category
                                ? Colors.white
                                : Colors.black),
                      ),
                      backgroundColor:
                          controller.selectedCategory.value == category
                              ? PRIMARY_COLOR
                              : Colors.grey.withValues(alpha: .3),
                      onPressed: () {
                        controller.filterByCategory(category);
                      },
                    ),
                  );
                });
              }).toList(),
            ),
          ),
          Expanded(
            child: Obx(() =>
                widgetList[controller.otherProfileFriendsViewNumber.value]),
          )
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
