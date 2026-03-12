import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/friend_request.dart';
import '../../../../components/people_may_you_know_card.dart';
import '../../../../components/simmar_loader.dart';
import '../../../../config/constants/color.dart';
import '../../../../models/firend_request.dart';
import '../controllers/friend_controller.dart';
import '../model/people_may_you_khnow.dart';
import 'search_friends_view.dart';

class FriendView extends GetView<FriendController> {
  const FriendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).cardTheme.color,
          color: PRIMARY_COLOR,
          onRefresh: () async {
            controller.peopleMayYouKnowList.value.clear();
            controller.friendRequestList.value.clear();
            controller.friendList.value.clear();

            Future.wait([
              controller.getFriendRequestes(),
              controller.getPeopleMayYouKnow(skip: 0),
              controller.getFriends()
            ]);
          },
          child:ListView(
            controller: controller.friendsScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Connections'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(() => const SearchFriendsView());
                    },
                    icon: const Icon(Icons.search, size: 30),
                  )
                ],
              ),
              const SizedBox(height: 5),
              RequestView(context),
              const SizedBox(height: 20),

              // People You May Know Section
              Obx(() {
                if (controller.isLoadingPeopleYouMayKnow.value &&
                    controller.peopleMayYouKnowList.value.isEmpty) {
                  return ShimmarLoadingView();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'People May You Know'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    ...controller.peopleMayYouKnowList.value
                        .map(
                          (people) => PeopleMayYouKnowCard(
                        peopleMayYouKnowModel: people,
                        onPressedAddFriend: () {
                          final index = controller.peopleMayYouKnowList.value.indexOf(people);
                          controller.sendFriendRequest(
                            index: index,
                            userId: people.id ?? '',
                          );
                        },
                        onPressedRemove: () async {
                          final index = controller.peopleMayYouKnowList.value.indexOf(people);
                          controller.peopleMayYouKnowList.value.removeAt(index);
                          await controller.getPeopleMayYouKnow(skip: 0);
                        },
                      ),
                    )
                        ,
                    if (controller.isLoadingPeopleYouMayKnow.value)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(child: ShimmarLoadingView(itemCount: 3)),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget RequestView(BuildContext context) {
    return Obx(
      () => controller.isFriendRequestLoading.value == true
          ? ShimmarLoadingView(itemCount: 3)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Connections request'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: ' ${controller.friendRequestList.value.length.toString()}'.tr,
                            style: TextStyle(
                              color: ACCENT_COLOR,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                      ),
                      // ! NEED TO FIX THIS ASAP TOMORROW OR ELSE ANIK VI MARBE !!!!
                      // TextButton(
                      //     onPressed: () {
                      //       controller.friendRequestList.value.length.toString();
                      //     },
                      //     child: Text(
                      //       'See All',
                      //       style: TextStyle(fontSize: 16, color: PRIMARY_COLOR, fontWeight: FontWeight.bold),
                      //     )),
                    ],
                  ),
                ),

                // : const SizedBox(),,

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.friendRequestList.value.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    FriendRequestModel friendRequestModel =
                        controller.friendRequestList.value[index];
                    return FriendRequestCard(
                      friendRequestModel: friendRequestModel,
                      onPressedAccept: () {
                        controller.actionOnFriendRequest(
                            action: 1, requestId: friendRequestModel.id!);
                      },
                      onPressedReject: () {
                        controller.actionOnFriendRequest(
                            action: 0, requestId: friendRequestModel.id!);
                      },
                    );
                  },
                ),
                const Divider(),
              ],
            ),
    );
  }

  Widget PeopleMayYouKnowView(BuildContext context) {
    return Obx(() => controller.isLoadingPeopleYouMayKnow.value == true
        ? ShimmarLoadingView()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('People May You Know'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.peopleMayYouKnowList.value.length,
                itemBuilder: (context, index) {
                  PeopleMayYouKnowModel peopleMayYouKnowModel =
                      controller.peopleMayYouKnowList.value[index];
                  return PeopleMayYouKnowCard(
                    peopleMayYouKnowModel: peopleMayYouKnowModel,
                    onPressedAddFriend: () {
                      controller.sendFriendRequest(
                          index: index, userId: peopleMayYouKnowModel.id ?? '');
                    },
                    onPressedRemove: () async {
                      controller.peopleMayYouKnowList.value.removeAt(index);
                      await controller.getPeopleMayYouKnow(skip: 0);
                    },
                  );
                },
              ),
            ],
          ));
  }

  Widget ShimmarLoadingView({int? itemCount}) {
    return SizedBox(
      height: itemCount != null ? ((Get.width * 0.30) * itemCount) : Get.height,
      child: ListView.builder(
          itemCount: itemCount ?? 10,
          itemBuilder: (BuildContext context, index) {
            return ShimmerLoader(
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 35,
                          width: Get.width * 0.24,
                          decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {},
                            child: Text('Accept'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 35,
                          width: Get.width * 0.24,
                          decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {},
                            style: const ButtonStyle(),
                            child: Text('Decline'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
