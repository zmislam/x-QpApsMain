import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants/color.dart';
import '../../modules/shared/modules/create_post/controller/create_post_controller.dart';
import '../button.dart';
import '../dropdown.dart';
import '../text_form_field.dart';

class EventSubTypeBody extends StatelessWidget {
  const EventSubTypeBody(
      {super.key,
      required this.imageLink,
      required this.title,
      required this.onPressed,
      required this.controller});
  final String imageLink;
  final String title;
  final VoidCallback onPressed;
  final CreatePostController controller;

  @override
  Widget build(BuildContext context) {
    List<String> items = ['Public', 'Friends', 'Only me'];
    controller.orgController.clear();
    controller.positionController.clear();
    controller.startDateController.clear();
    controller.endDateController.clear();
    controller.titleTEController.clear();
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageLink,
              width: 60,
              height: 60,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          child: Divider(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: controller.titleTEController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: 'Say something about this...'.tr,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // PrimaryTextFormField(
              //   controller: controller.orgController,

              //   label: 'Title'.tr,

              //   // decoration: const InputDecoration(border: InputBorder.none),
              //   // decoration: const InputDecoration(border: InputBorder.none),
              // ),
              const SizedBox(
                height: 10,
              ),
              BorderlessTextFormField(
                controller: controller.positionController,
                label: 'Position'.tr,
              ),
              const SizedBox(
                height: 10,
              ),
              BorderlessTextFormField(
                controller: controller.orgController,

                // controller: controller.workController,
                label: 'Work Place'.tr,
              ),
              const SizedBox(
                height: 10,
              ),
              PrimaryDropDownField(
                  hint: 'Privacy',
                  list: items,
                  onChanged: (changedValue) {
                    controller.dropdownValue.value = changedValue ?? '';
                  }),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible:
                    title == 'Left Job' || title == 'Retirement' ? false : true,
                child: ClickableTextFormField(
                  controller: controller.startDateController,
                  label: 'Start Date'.tr,
                  suffixIcon: Icons.calendar_month_outlined,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950, 1, 1),
                      lastDate: DateTime.now(),
                    ).then((value) {
                      if (value != null) {
                        controller.startDateController.text =
                            '${value.year}-${value.month}-${value.day}';
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible:
                    title == 'New Job' || title == 'Promotion' ? false : true,
                child: ClickableTextFormField(
                  label: 'End Date'.tr,
                  suffixIcon: Icons.calendar_month_outlined,
                  controller: controller.endDateController,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2050, 1, 1),
                    ).then((value) {
                      if (value != null) {
                        controller.endDateController.text =
                            '${value.year}-${value.month}-${value.day}';
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: title == 'New Job' ? true : false,
          child: Row(
            children: [
              Obx(
                () => Checkbox(
                  checkColor: Colors.white,
                  activeColor: PRIMARY_COLOR,
                  value: controller.is_current_working.value,
                  onChanged: (bool? value) {
                    controller.is_current_working.value = value!;
                  },
                ),
              ),
              SizedBox(
                width: Get.width - 50,
                child: Text('Currenly Working'.tr,
                  style: TextStyle(fontSize: 15),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        PrimaryButton(
          onPressed: onPressed,
          text: 'Create'.tr,
          horizontalPadding: 140,
          verticalPadding: 12,
        )
      ],
    );
  }
}
