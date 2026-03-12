import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../components/button.dart';
import '../../../../../../components/dropdown.dart';
import '../../../../../../components/text_form_field.dart';
import '../../../../../../data/post_local_data.dart';
import '../../../../../../config/constants/color.dart';
import '../../controller/create_post_controller.dart';

class CustomTypeBody extends StatelessWidget {
  const CustomTypeBody({
    super.key,
    required this.imageLink,
    required this.title,
    required this.onPressed,
    required this.controller,
  });
  final String imageLink;
  final String title;
  final VoidCallback onPressed;
  final CreatePostController controller;

  @override
  Widget build(BuildContext context) {
    controller.orgController.clear();
    controller.startDateController.clear();
    controller.endDateController.clear();
    controller.titleTEController.clear();

    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.dialog(AlertDialog(
                      contentPadding: const EdgeInsets.all(0),
                      content: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 220,
                          width: Get.width,
                          child: Obx(() => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, top: 10.0),
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: const Icon(
                                              Icons.cancel_outlined,
                                              size: 30,
                                              color: PRIMARY_COLOR,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    GridView.builder(
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: controller.eventIconList.value
                                          .length, //controller.photoModel.value?.posts?.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 6,
                                              childAspectRatio: 0.7),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.back();
                                            controller.iconIndex.value = index;
                                            controller
                                                    .customEventIconName.value =
                                                controller
                                                    .eventIconList
                                                    .value[controller
                                                        .iconIndex.value]
                                                    .iconName
                                                    .toString();
                                          },
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0,
                                                  bottom: 5.0,
                                                  left: 5.0,
                                                  right: 5.0),
                                              child: Image.asset(
                                                width: 35,
                                                height: 35,
                                                controller.eventIconList
                                                    .value[index].imagePath
                                                    .toString(),
                                              )),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ))),
                    ));
                  },
                  child: Obx(() => Image.asset(
                        controller.eventIconList
                            .value[controller.iconIndex.value].imagePath
                            .toString(),
                        width: 60,
                        height: 60,
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tap to change icon'.tr,
                  style: TextStyle(fontSize: 12, color: PRIMARY_COLOR),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 17),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  BorderlessTextFormField(
                    controller: controller.orgController,
                    label: 'Title'.tr,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PrimaryDropDownField(
                      hint: 'Privacy',
                      list: privacyList,
                      onChanged: (changedValue) {
                        controller.dropdownValue.value = changedValue ?? '';
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  ClickableTextFormField(
                    label: 'Date'.tr,
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
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(
              onPressed: onPressed,
              text: 'Create'.tr,
              horizontalPadding: 150,
              verticalPadding: 12,
            ),
          ],
        ),
      ),
    );
  }
}
