import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/search_people_card.dart';
import '../../../components/simmar_loader.dart';
import '../../../config/constants/color.dart';
import '../controllers/global_search_controller.dart';

class PeopleSearch extends GetView<GlobalSearchController> {
  const PeopleSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? ShimmarLoadingView()
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.peopleList.value.length.clamp(0, 5),
              itemBuilder: (context, index) {
                final peopleModel = controller.peopleList.value[index];
                return SearchPeopleCard(
                  peopleMayYouKnowModel: peopleModel,
                  onPressedAddFriend: () {
                    controller.sendFriendRequest(
                      index: index,
                      userId: peopleModel.id ?? '',
                    );
                  },
                  onPressedRemove: () {
                    controller.cancelFriendRequest(
                      index: index,
                      userId: peopleModel.id ?? '',
                    );
                  },
                );
              },
            ),
    );
  }

  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height,
      child: ListView.builder(
          itemCount: 12,
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
