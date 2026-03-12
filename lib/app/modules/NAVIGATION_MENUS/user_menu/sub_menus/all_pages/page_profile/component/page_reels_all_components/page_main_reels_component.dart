import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../config/constants/color.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_profile/component/page_reels_all_components/page_shared_reels_components.dart'
    show PagePersonalSharedReelComponent;

import '../../../../../../../../components/simmar_loader.dart';
import '../../controllers/page_profile_controller.dart';
import 'page_personal_reels_component.dart';

class PageProfileReelsComponent extends StatelessWidget {
  const PageProfileReelsComponent({super.key, required this.controller});

  final PageProfileController controller;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      PagePersonalReelComponent(controller: controller),
      PagePersonalSharedReelComponent(controller: controller)
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
                        '${controller.pageProfileModel.value?.pageDetails?.pageName ?? 'User'}\'s Reels'
                            .tr,
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
                  controller.getOtherRepostVideo(
                      pageUserName: controller.pageProfileModel.value
                              ?.pageDetails?.pageUserName ??
                          '');
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // '${controller.profileModel.value?.first_name} ${controller.profileModel.value?.last_name}\'s Reposted Reels',
                      '${controller.pageProfileModel.value?.pageDetails?.pageName ?? '' 'User'}\'s Repost Reels',
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
