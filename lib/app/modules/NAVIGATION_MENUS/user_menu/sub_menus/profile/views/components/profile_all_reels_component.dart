import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'personal_reels_component.dart';
import 'personal_repost_reels_compoent.dart';
import 'personal_saved_reels_component.dart';
import '../../../../../../../config/constants/color.dart';

import '../../controllers/profile_controller.dart';

class ProfileReelsComponent extends StatelessWidget {
  const ProfileReelsComponent({super.key, required this.controller});

  final ProfileController controller;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      PersonalReelComponent(controller: controller),
      PersonalRepostReelComponent(controller: controller),
      PersonalSavedReelComponent(controller: controller),
    ];
    return SliverList(
      delegate: SliverChildListDelegate([
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
                  child: Obx(() => Text('My Reels'.tr,
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
                  controller.getRepostVideo();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => Text('My Repost Reels'.tr,
                      style: TextStyle(
                        color: controller.viewReelsTabNumber.value == 1
                            ? PRIMARY_COLOR
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  controller.viewReelsTabNumber.value = 2;
                  controller.getSavedReels();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Obx(
                    () => Text('Saved Reels'.tr,
                      style: TextStyle(
                        color: controller.viewReelsTabNumber.value == 2
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
        Obx(() => widgetList[controller.viewReelsTabNumber.value]),
      ]),
    );
  }
}
