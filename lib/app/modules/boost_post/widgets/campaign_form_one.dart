import 'package:flutter/material.dart';

import '../../../components/dropdown.dart';
import '../../../components/text_form_field.dart';
import '../controllers/boost_post_controller.dart';
import 'package:get/get.dart';

class CampaignFormSectionOne extends StatelessWidget {
  final BoostPostController controller;
    CampaignFormSectionOne({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:   EdgeInsets.symmetric(horizontal: 20),
      margin:   EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            SizedBox(height: 10),
            Text('Campaign Name'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          PrimaryTextFormField(
            controller: controller.campaignNameController,
            hinText: 'Campaign Name',
            validator: (value) => value == null || value.isEmpty
                ? 'Campaign Name is required'
                : null,
          ),
            SizedBox(height: 10),
            Text('Campaign Category'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          BottomSheetDropdownSearch<String>(
            hint: 'Select Category',
            list: controller.campaignCategoryList,
            onChanged: (data) =>
                controller.selectedCampaignCategory = data ?? '',
          ),
            SizedBox(height: 10),
            Text('Start Date'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          PrimaryTextFormField(
            controller: controller.fromDateController,
            onTap: () => controller.selectDate(
                context, controller.fromDate, controller.fromDateController),
            hinText: 'Start Date',
            suffixIcon:   Icon(Icons.calendar_today_outlined),
            suffixIconColor: Colors.grey,
            readOnly: true,
          ),
            SizedBox(height: 10),
            Text('End Date'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          PrimaryTextFormField(
            controller: controller.endDateController,
            onTap: () => controller.selectDate(
                context, controller.endDate, controller.endDateController),
            hinText: 'End Date',
            suffixIcon:   Icon(Icons.calendar_today_outlined),
            suffixIconColor: Colors.grey,
            readOnly: true,
          ),
            SizedBox(height: 20),
        ],
      ),
    );
  }
}
