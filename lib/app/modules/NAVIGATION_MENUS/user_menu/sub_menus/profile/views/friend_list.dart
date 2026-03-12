import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/friend.dart';
import '../../../../../../components/simmar_loader.dart';
import '../../../../../../models/friend.dart';
import '../../../../../../routes/profile_navigator.dart';
import '../controllers/profile_controller.dart';

class FriendList extends GetView<ProfileController> {
  const FriendList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Friend List'.tr,
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
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Search friends'.tr),
            ),
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
                      text: ' (${controller.friendList.value.length.toString()})'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ])),
                )),

                // Text(
                //   'Sell All',
                //   style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //       color: PRIMARY_COLOR),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() => ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.friendList.value.length,
                  itemBuilder: (context, index) {
                    FriendModel friendModel =
                        controller.friendList.value[index];
                    return InkWell(
                      onTap: () {
                        ProfileNavigator.navigateToProfile(
                            username: friendModel.friend?.username ?? '',
                            isFromReels: 'false');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FriendCard(
                          model: friendModel,
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
            );
          }),
    );
  }
}
