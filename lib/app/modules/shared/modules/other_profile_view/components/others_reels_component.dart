import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/simmar_loader.dart';
import 'other_personal_reels_compoent.dart';
import 'other_personal_shared_reels_compoent.dart';
import '../controller/other_profile_controller.dart';
import '../../../../../config/constants/color.dart';

class OthersProfileReelsComponent extends StatelessWidget {
  const OthersProfileReelsComponent({super.key, required this.controller});

  final OthersProfileController controller;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      OtherPersonalReelComponent(controller: controller),
      OtherPersonalSharedReelComponent(controller: controller)
    ];
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // width: Get.width/3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  controller.viewReelsTabNumber.value = 0;
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Obx(() => Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        '${controller.profileModel.value?.first_name ?? 'User'}\'s Reels',
                        style: TextStyle(
                          color: controller.viewReelsTabNumber.value == 0
                              ? PRIMARY_COLOR
                              : Colors.black,
                        ),
                      )),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  controller.viewReelsTabNumber.value = 1;
                  controller.getOtherRepostVideo();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // '${controller.profileModel.value?.first_name} ${controller.profileModel.value?.last_name}\'s Reposted Reels',
                      '${controller.profileModel.value?.first_name.toString().split(' ')[0] ?? 'User'}\'s Repost Reels',
                      style: TextStyle(
                        color: controller.viewReelsTabNumber.value == 1
                            ? PRIMARY_COLOR
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() => widgetList[controller.viewReelsTabNumber.value]),
        ],
      ),
    );
  }

  Widget ShimmarLoadingView() {
    return SizedBox(
      height: Get.height,
      child: GridView.builder(
          physics: const ScrollPhysics(),
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.7),
          itemBuilder: (BuildContext context, index) {
            return ShimmerLoader(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width / 3,
                    height: 157,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withValues(alpha: 0.9)),
                  )),
            );
          }),
    );
  }
}
