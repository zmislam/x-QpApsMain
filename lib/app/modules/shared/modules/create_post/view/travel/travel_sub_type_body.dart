import 'package:flutter/material.dart';
import '../../../../../../components/dropdown.dart';
import '../../../../../../components/text_form_field.dart';
import '../../../../../../models/location_model.dart';

import '../../../../../../components/button.dart';
import '../../controller/create_post_controller.dart';
import 'package:get/get.dart';

class TravelSubTypeBody extends StatelessWidget {
  const TravelSubTypeBody({
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
    List<String> lists = ['Public', 'Friends', 'Only me'];

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
                width: 60,
                height: 60,
              ),
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
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BorderlessTextFormField(
                  controller: controller.orgController,
                  label: 'Title'.tr,
                ),
                const SizedBox(height: 10),

                // PrimaryDropDownField(
                //     hint: 'Location',
                //     list: positions,
                //     onChanged: (changedValue) {
                //       controller.postPrivacy.value = changedValue ?? '';
                //     }),
                const SizedBox(height: 10),

                PrimaryDropDownSearch<AllLocation>(
                  padding: const EdgeInsets.all(17),
                  hintText: 'Select Location'.tr,
                  items: controller.locationList.value,
                  itemBuilder: (context, item, isSelected) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                      child: Row(
                        children: [
                          Text(
                            item.locationName ?? '',
                            style: TextStyle(fontSize: 17),
                          )
                        ],
                      ),
                    );
                  },
                  onChanged: (locationModel) {
                    controller.travelLocation.value =
                        locationModel!.locationName.toString();
                  },
                  asyncItems: controller.getLocation,
                ),

                const SizedBox(
                  height: 10,
                ),

                PrimaryDropDownField(
                    hint: 'Privacy',
                    list: lists,
                    onChanged: (changedValue) {
                      controller.dropdownValue.value = changedValue ?? '';
                    }),
                const SizedBox(
                  height: 10,
                ),
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
    );
  }
}
