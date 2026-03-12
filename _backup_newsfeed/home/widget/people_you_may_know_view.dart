import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/login_creadential.dart';

import '../../../../components/simmar_loader.dart';
import '../../../../config/constants/color.dart';
import '../../../tab_view/controllers/tab_view_controller.dart';
import '../../friend/model/people_may_you_khnow.dart';
import '../components/custom_people_may_you_know_card.dart';
import '../controllers/home_controller.dart';

class PeopleYouMayKnowView extends GetView<HomeController> {
  const PeopleYouMayKnowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: PeopleMayYouKnowView(context),
    );
  }

  Widget PeopleMayYouKnowView(BuildContext context) {
    return Obx(() => Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10),
                child: Text('People You May Know'.tr,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 330,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.peopleMayYouKnowList.value.length,
                itemBuilder: (context, index) {
                  PeopleMayYouKnowModel peopleMayYouKnowModel =
                      controller.peopleMayYouKnowList.value[index];
                  return CustomPeopleMayYouKnowCard(
                    peopleMayYouKnowModel: peopleMayYouKnowModel,
                    onPressedAddFriend: () {
                      controller.sendFriendRequest(
                          index: index, userId: peopleMayYouKnowModel.id ?? '');
                    },
                    onPressedRemove: () async {
                      controller.peopleMayYouKnowList.value.removeAt(index);
                      await controller.getPeopleMayYouKnow();
                    },
                  );
                },
              ),
            ),
            const Divider(),
            InkWell(
              child: Text('See all'.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary),
                // style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              onTap: () {
                TabViewController tabViewController =
                    Get.find<TabViewController>();
                LoginCredential loginCredential = LoginCredential();
                if (loginCredential.getProfileSwitch()) {
                  // ! JUST RETURN IF ON PAGE PROFILE
                  return;
                } else {
                  // * GOING TO SUGGESTED FRIENDS TAB IF ON GENERAL PROFILE
                  tabViewController.tabController.animateTo(2);
                }
                // Get.toNamed(Routes.FRIEND_SUGGESTION);
              },
            ),
            const Divider()
          ],
        ));
  }

  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height,
      child: ListView.builder(
          itemCount: 10,
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
