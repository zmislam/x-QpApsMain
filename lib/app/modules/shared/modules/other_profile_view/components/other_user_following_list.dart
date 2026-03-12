import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/simmar_loader.dart';
import '../../../../../components/user_profile/user_following_card.dart';
import '../../../../../models/following_user_model.dart';
import '../../../../../routes/profile_navigator.dart';
import '../controller/other_profile_controller.dart';

class OtherUserFollowingListComponent extends StatelessWidget {
  final OthersProfileController controller;

  const OtherUserFollowingListComponent({
    super.key,
    required this.controller,
  });
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
          child: TextFormField(
            decoration:  InputDecoration(
                border: InputBorder.none, hintText: 'Search here'.tr),
            onChanged: (value) {
              if (value.isNotEmpty) {
                controller.followingController.value = value;
                controller.searchFollowingList.value.clear();

                controller.searchFollowingList.value = controller
                    .followingList.value
                    .where((followerModel) =>
                        followerModel.followerUserId!.username
                            .toString()
                            .toUpperCase()
                            .contains(value.toString().toUpperCase()) ||
                        followerModel.followerUserId!.firstName
                            .toString()
                            .toUpperCase()
                            .contains(value.toString().toUpperCase()) ||
                        followerModel.followerUserId!.lastName
                            .toString()
                            .toUpperCase()
                            .contains(value.toString().toUpperCase()))
                    .toList();

                debugPrint(
                    'friend controller .....${controller.searchFollowerList.value}');
              } else {
                controller.followingController.value = '';
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
                  text: 'Following'.tr,
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
          child: Obx(() => controller.isLoadingFollowingList.value == true
              ? ShimmarLoadingView()
              : controller.followingController.value == ''
                  ? ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.followingList.value.length,
                      itemBuilder: (context, index) {
                        FollowerUserId model = controller
                            .followingList.value[index].followerUserId!;

                        return InkWell(
                          onTap: () {
                            ProfileNavigator.navigateToProfile(
                                username: model.username ?? '',
                                isFromReels: 'false');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FollowingCard(
                              model: model,
                              onTapBlock: () {
                                controller.blockFriends(controller.followingList
                                        .value[index].followerUserId?.id ??
                                    '');
                                controller.followingList.value.removeAt(index);
                                controller.followingList.refresh();
                              },
                              onTapUnfollow: () {
                                controller.unfollowFriends(controller
                                    .followingList.value[index].id
                                    .toString());
                                controller.followingList.value.removeAt(index);
                                controller.followingList.refresh();
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.searchFollowingList.value.length,
                      itemBuilder: (context, index) {
                        FollowerUserId model = controller
                            .searchFollowingList.value[index].followerUserId!;
                        return InkWell(
                          onTap: () {
                            ProfileNavigator.navigateToProfile(
                                username: model.username ?? '',
                                isFromReels: 'false');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FollowingCard(
                              model: model,
                              onTapBlock: () {
                                controller.blockFriends(controller
                                        .searchFollowingList
                                        .value[index]
                                        .followerUserId
                                        ?.id ??
                                    '');
                                controller.searchFollowingList.value
                                    .removeAt(index);
                                controller.searchFollowingList.refresh();
                              },
                              onTapUnfollow: () {
                                controller.unfollowFriends(controller
                                    .searchFollowingList.value[index].id
                                    .toString());
                                controller.searchFollowingList.value
                                    .removeAt(index);
                                controller.searchFollowingList.refresh();
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
