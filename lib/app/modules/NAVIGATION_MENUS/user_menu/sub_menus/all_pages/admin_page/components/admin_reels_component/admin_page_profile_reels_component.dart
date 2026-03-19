import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../config/constants/color.dart';
import 'admin_page_personal_reel_component.dart';
import 'admin_page_shared_reels_component.dart';
import '../../controller/admin_page_controller.dart';

/// Admin page Reels tab with text-based sub-tabs
class AdminPageProfileReelsComponent extends StatelessWidget {
  const AdminPageProfileReelsComponent({super.key, required this.controller});

  final AdminPageController controller;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [
      AdminPagePersonalReelComponent(controller: controller),
      AdminPagePersonalSharedReelComponent(controller: controller),
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
