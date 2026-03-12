import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../extension/date_time_extension.dart';
import '../../models/post.dart';
import '../../modules/edit_post/controllers/edit_post_controller.dart';
import '../../config/constants/color.dart';
import '../button.dart';

class EditWorkEventBody extends StatelessWidget {
  const EditWorkEventBody(
      {super.key,
      required this.imageLink,
      required this.title,
      required this.onPressed,
      required this.controller,
      required this.postModel});
  final String imageLink;
  final String title;
  final VoidCallback onPressed;
  final EditPostController controller;
  final PostModel? postModel;

  @override
  Widget build(BuildContext context) {
    controller.eventType.value = 'work';
    controller.eventSubType.value = title;
    controller.eventSubType.value = postModel!.event_sub_type ?? '';
    controller.orgName.value = postModel!.workplace_id!.orgName ?? '';
    controller.designation.value =
        postModel!.workplace_id!.designation ?? 'position';
    controller.startDate.value =
        getDynamicFormatedTime(postModel!.workplace_id!.fromDate.toString());
    controller.endDate.value =
        getDynamicFormatedTime(postModel!.workplace_id!.toDate.toString());

    return SingleChildScrollView(
      child: Column(
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
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
            child: Divider(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              height: 50,
              width: double.maxFinite,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextFormField(
                  initialValue: title,
                  readOnly: true,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              height: 50,
              width: double.maxFinite,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextFormField(
                  initialValue: controller.designation.value,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'position'.tr),
                  onChanged: (value) {
                    controller.designation.value = value;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
              height: 50,
              width: double.maxFinite,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextFormField(
                  initialValue: controller.orgName.value,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'work place'.tr),
                  onChanged: (value) {
                    controller.orgName.value = value;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Visibility(
              visible:
                  title == 'Left Job' || title == 'Retirement' ? false : true,
              child: Container(
                height: 50,
                width: double.maxFinite,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950, 1, 1),
                      lastDate: DateTime(2050, 1, 1),
                    ).then((value) {
                      if (value != null) {
                        controller.startDate.value =
                            '${value.year}-${value.month}-${value.day}';
                      }
                    });
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Text(
                          controller.startDate.value,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950, 1, 1),
                  lastDate: DateTime(2050, 1, 1),
                ).then((value) {
                  if (value != null) {
                    controller.endDate.value =
                        '${value.year}-${value.month}-${value.day}';
                  }
                });
              },
              child: Visibility(
                visible:
                    title == 'New Job' || title == 'Promotion' ? false : true,
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Text(
                          controller.endDate.value,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            text: 'update'.tr,
            horizontalPadding: 150,
            verticalPadding: 12,
          )
        ],
      ),
    );
  }

  String getDynamicFormatedTime(String time) {
    // print("time of date ........."+time);

    DateTime postDateTime;
    if (time.toString() == 'null' || time.isEmpty || time.toString() == '') {
      postDateTime = DateTime.now().toLocal();
    } else {
      postDateTime = DateTime.parse(time).toLocal();
    }
    return productDateTimeFormat.format(postDateTime);
  }
}
