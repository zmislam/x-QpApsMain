import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dropdown.dart';
import '../text_form_field.dart';

import '../../modules/shared/modules/create_post/controller/create_post_controller.dart';
import '../../config/constants/color.dart';
import '../button.dart';

class EducationSubTypeBody extends StatelessWidget {
  const EducationSubTypeBody(
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
              width: 100,
              height: 100,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 17),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          child: Divider(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
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
              BorderlessTextFormField(
                controller: controller.orgController,
                label: 'Institute Name'.tr,
              ),
              const SizedBox(height: 10),
              PrimaryDropDownField(
                  hint: 'Privacy',
                  list: items,
                  onChanged: (changedValue) {
                    controller.postPrivacy.value = changedValue ?? '';
                  }),
              const SizedBox(height: 10),
              ClickableTextFormField(
                label: 'Start Date'.tr,
                suffixIcon: Icons.calendar_month_outlined,
                controller: controller.startDateController,
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
                      controller.startDate.value = value;
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: title == 'New School' ? false : true,
                child: ClickableTextFormField(
                  suffixIcon: Icons.calendar_month_outlined,
                  label: 'End Date'.tr,
                  controller: controller.endDateController,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: controller.startDate.value,
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
        Visibility(
          visible: title == 'New School' ? true : false,
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
                child: Text('Currently Studying'.tr,
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
          horizontalPadding: 150,
          verticalPadding: 12,
        )
      ],
    );
  }
}
