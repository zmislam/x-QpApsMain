import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/user_profile/user_followers_card.dart';
import '../../../../../../components/simmar_loader.dart';
import '../../../../../../models/follower_user_model.dart';
import '../../../../../../routes/profile_navigator.dart';
import '../controllers/profile_controller.dart';

class FollowerList extends GetView<ProfileController> {
  const FollowerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Follower List'.tr,
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.white,
        //surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withValues(alpha: .3)),
            child: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Search here'.tr),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  controller.followerController.value = value;
                  controller.searchFollowerList.value.clear();

                  controller.searchFollowerList.value = controller
                      .followerList.value
                      .where((followerModel) =>
                          followerModel.userId!.username
                              .toString()
                              .toUpperCase()
                              .contains(value.toString().toUpperCase()) ||
                          followerModel.userId!.firstName
                              .toString()
                              .toUpperCase()
                              .contains(value.toString().toUpperCase()) ||
                          followerModel.userId!.lastName
                              .toString()
                              .toUpperCase()
                              .contains(value.toString().toUpperCase()))
                      .toList();

                  debugPrint(
                      'friend controller .....${controller.searchFollowerList.value}');
                } else {
                  controller.followerController.value = '';
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: RichText(
                        text: TextSpan(children: [
                  TextSpan(
                    text: 'Follower'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ]))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() => controller.isLoadingFollowerList.value == true
                ? ShimmarLoadingView()
                : controller.followerController.value == ''
                    ? ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.followerList.value.length,
                        itemBuilder: (context, index) {
                          UserId userModel =
                              controller.followerList.value[index].userId!;

                          return InkWell(
                            onTap: () {
                              ProfileNavigator.navigateToProfile(
                                  username: userModel.username ?? '',
                                  isFromReels: 'false');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: FollowerCard(
                                model: userModel,
                                onTapBlock: () {
                                  controller.blockFriends(controller
                                          .followerList
                                          .value[index]
                                          .userId
                                          ?.id ??
                                      '');
                                  controller.followerList.value.removeAt(index);
                                  controller.followerList.refresh();
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.searchFollowerList.value.length,
                        itemBuilder: (context, index) {
                          UserId userModel = controller
                              .searchFollowerList.value[index].userId!;

                          return InkWell(
                            onTap: () {
                              ProfileNavigator.navigateToProfile(
                                  username: userModel.username ?? '',
                                  isFromReels: 'false');
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: FollowerCard(
                                model: userModel,
                                onTapBlock: () {
                                  controller.blockFriends(controller
                                          .searchFollowerList
                                          .value[index]
                                          .userId
                                          ?.id ??
                                      '');
                                  controller.searchFollowerList.value
                                      .removeAt(index);
                                  controller.searchFollowerList.refresh();
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
          itemCount: 10,
          itemBuilder: (BuildContext context, index) {
            return ShimmerLoader(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
