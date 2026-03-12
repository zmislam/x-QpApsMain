import 'package:flutter/material.dart';

import '../../../components/dropdown.dart';
import '../../../components/text_form_field.dart';
import '../../NAVIGATION_MENUS/reels/sub_menu/boost_reels/components/age_range_selector.dart';
import '../controllers/boost_post_controller.dart';
import 'package:get/get.dart';

class CampaignFormSectionTwo extends StatelessWidget {
  final BoostPostController controller;
    CampaignFormSectionTwo({super.key, required this.controller});

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
            Text('Total Budget'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          PrimaryTextFormField(
            controller: controller.totalBudgetController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a total budget';
              }
              final total = double.tryParse(value);
              final daily =
                  double.tryParse(controller.dailyBudgetController.text);
              if (total == null) return 'Please enter a valid number';
              if (daily != null && total < daily) {
                return 'Total budget cannot be less than the daily budget';
              }
              return null;
            },
            onChanged: (value) {
              controller.totalBudget.value =
                  double.tryParse(value ?? '') ?? 0.0;
              return null;
            },
            hinText: '\$ Total Budget',
          ),
            SizedBox(height: 10),
            Text('Daily Budget'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          PrimaryTextFormField(
            controller: controller.dailyBudgetController,
            hinText: '\$ Daily Budget',
            readOnly: true,
          ),
            SizedBox(height: 10),
            Text('User Destination'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          PrimaryTextFormField(
            controller: controller.destinationController,
            hinText: 'Destination',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a destination link';
              }
              if (!controller.isValidURL(value)) {
                return 'Please enter a valid URL';
              }
              return null;
            },
          ),
            SizedBox(height: 10),
            Text('Search For Location'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          BottomSheetDropdownSearch<String>(
            list:   [],
            onChanged: (data) => controller.onCLocationChanged = data ?? '',
            hint: 'Search Location',
            onSearch: (searchText) async {
              final locations = await controller.getLocation(searchText);
              return locations
                  .map((e) => e.locationName)
                  .whereType<String>()
                  .toList();
            },
          ),
            SizedBox(height: 10),
            Text('Keywords'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          BottomSheetDropdownSearch<String>(
            list: controller.keywordsList,
            onChanged: (data) => controller.onKeyWordsChanged = data ?? '',
          ),
            SizedBox(height: 10),
            Text('Select Gender'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          BottomSheetDropdownSearch<String>(
            list: controller.genderList,
            onChanged: (data) => controller.onGenderChanged = data ?? '',
          ),
            SizedBox(height: 10),
            Text('Select Age Range'.tr,
              style: TextStyle(fontSize: 16, color: Color(0xff344054))),
            SizedBox(height: 10),
          AgeRangeSelector(
            onRangeSelected: (range) => controller.rangeValues = range,
            onAgeSelected: (age) => controller.ageGroup = age,
          ),
            SizedBox(height: 20),
        ],
      ),
    );
  }
}
