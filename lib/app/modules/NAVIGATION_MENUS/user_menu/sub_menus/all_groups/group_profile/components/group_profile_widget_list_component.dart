import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../controllers/group_profile_controller.dart';
import '../../../../../../../config/constants/color.dart';
import 'package:get/get.dart';

class GroupProfileWidgetList extends StatelessWidget {
  final GroupProfileController controller;
  const GroupProfileWidgetList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            controller.groupProfileWidgetViewNumber.value = 0;
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            child: Obx(
              () => Text('Discussion'.tr,
                style: TextStyle(
                  color: controller.groupProfileWidgetViewNumber.value == 0
                      ? PRIMARY_COLOR
                      : null,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            controller.groupProfileWidgetViewNumber.value = 1;
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            child: Obx(
              () => Text('Media'.tr,
                style: TextStyle(
                  color: controller.groupProfileWidgetViewNumber.value == 1
                      ? PRIMARY_COLOR
                      : null,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            controller.groupProfileWidgetViewNumber.value = 2;
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            child: Obx(
              () => Text('Files'.tr,
                style: TextStyle(
                  color: controller.groupProfileWidgetViewNumber.value == 2
                      ? PRIMARY_COLOR
                      : null,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            controller.groupProfileWidgetViewNumber.value = 3;
            controller.groupProfileWidgetViewNumber.refresh();
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            child: Obx(
              () => Text('About'.tr,
                style: TextStyle(
                  color: controller.groupProfileWidgetViewNumber.value == 3
                      ? PRIMARY_COLOR
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
