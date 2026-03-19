import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../config/constants/color.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/page_profile/component/page_reels_all_components/page_shared_reels_components.dart'
    show PagePersonalSharedReelComponent;

import '../../controllers/page_profile_controller.dart';
import 'page_personal_reels_component.dart';

/// Page profile Reels tab with text-based sub-tabs
class PageProfileReelsComponent extends StatelessWidget {
  const PageProfileReelsComponent({super.key, required this.controller});

  final PageProfileController controller;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [
      PagePersonalReelComponent(controller: controller),
      PagePersonalSharedReelComponent(controller: controller),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Text-based sub-tabs ──────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  controller.viewReelsTabNumber.value = 0;
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => Text(
                      'Personal Reels'.tr,
                      style: TextStyle(
                        color: controller.viewReelsTabNumber.value == 0
                            ? PRIMARY_COLOR
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  controller.viewReelsTabNumber.value = 1;
                  controller.getOtherRepostVideo(
                    pageUserName: controller.pageProfileModel.value
                            ?.pageDetails?.pageUserName ??
                        '',
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => Text(
                      'Repost Reels'.tr,
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
        ),

        // ─── Content ──────────────────────────────────
        Obx(() => widgetList[controller.viewReelsTabNumber.value]),
      ],
    );
  }
}
