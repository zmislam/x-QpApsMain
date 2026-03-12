import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/post_local_data.dart';
import '../../extension/date_time_extension.dart';
import '../../models/post.dart';
import '../../modules/edit_post/controllers/edit_post_controller.dart';
import '../../config/constants/color.dart';
import '../button.dart';
import '../dropdown.dart';
import '../post/post_body/post_body.dart';
import '../text_form_field.dart';

class EditCustomBody extends StatelessWidget {
  const EditCustomBody(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.controller,
      required this.postModel});
  final String title;
  final VoidCallback onPressed;
  final EditPostController controller;
  final PostModel? postModel;

  @override
  Widget build(BuildContext context) {
    controller.eventType.value = 'customevent';
    controller.eventSubType.value = postModel?.event_sub_type ?? '';
    controller.descriptionController.text = postModel?.description ?? '';
    controller.startDateController.text =
        postModel?.lifeEventId?.date.toString().substring(0, 10) ?? '';
    controller.startDate.value =
        postModel?.lifeEventId?.date.toString().substring(0, 10) ?? '';
    controller.titleController.text = postModel?.lifeEventId?.title ?? '';
    controller.iconName.value = postModel?.lifeEventId?.iconName ?? '';

    if (postModel?.post_privacy == 'only_me') {
      controller.dropdownValue.value = 'Only Me';
      controller.postPrivacy.value = 'only_me';
    } else if (postModel?.post_privacy == 'public') {
      controller.dropdownValue.value = 'Public';
      controller.postPrivacy.value = 'public';
    } else {
      controller.dropdownValue.value = 'Friends';
      controller.postPrivacy.value = 'friends';
    }

    return SingleChildScrollView(
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

                                          controller.iconName.value = controller
                                              .eventIconList
                                              .value[index]
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
                      getCustomLifeEventIconName(controller.iconName.value),
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
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Divider(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: TextFormField(
              controller: controller.descriptionController,
              textAlign: TextAlign.center,
              maxLines: 2,
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
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                BorderlessTextFormField(
                  controller: controller.titleController,
                  label: 'Title'.tr,
                ),
                const SizedBox(
                  height: 10,
                ),
                PrimaryDropDownField(
                    hint: 'Privacy',
                    value: controller.dropdownValue.value,
                    list: privacyList,
                    onChanged: (changedValue) {
                      if (changedValue == 'Only Me') {
                        controller.postPrivacy.value = 'only_me';
                      } else {
                        controller.postPrivacy.value =
                            changedValue?.toLowerCase() ?? '';
                      }
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
                        controller.startDate.value =
                            controller.startDateController.text;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          PrimaryButton(
            onPressed: onPressed,
            text: 'update'.tr,
            horizontalPadding: 150,
            verticalPadding: 12,
          )
        ],
      ),
    );
  }

  String getDynamicFormatedTime(String time) {
    DateTime postDateTime;
    if (time.toString() == 'null' || time.isEmpty || time.toString() == '') {
      postDateTime = DateTime.now().toLocal();
    } else {
      postDateTime = DateTime.parse(time).toLocal();
    }
    return productDateTimeFormat.format(postDateTime);
  }
}
