import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ads_campaign_extend_page/controllers/ads_campaign_extend_page_controller.dart';

import '../../../components/field_title.dart';
import '../../../components/text_form_field.dart';
import '../../../config/constants/data_const.dart';
import '../../../utils/validator.dart';
import '../ads_campaign_creation/controllers/ads_campaign_creation_controller.dart';

class AgeGroupSelector extends StatelessWidget {
  AgeGroupSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdsCampaignCreationController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Age Group:'.tr, style: TextStyle(fontSize: 16)),
          RadioListTile<String>(
            title: Text('All Age Groups'.tr),
            value: ageSelection.first,
            groupValue: controller.selectedOption.value,
            onChanged: (value) {
              controller.selectOption(value!);
            },
          ),
          RadioListTile<String>(
            title: Text('Age Range'.tr),
            value: ageSelection.last,
            groupValue: controller.selectedOption.value,
            onChanged: (value) {
              controller.selectOption(value!);
            },
          ),
          if (controller.isAgeRange)
            Container(
              margin: EdgeInsets.only(left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        FieldTitle(title: 'Min Age'.tr, isRequired: true),
                        PrimaryTextFormField(
                          controller: controller.minAgeController,
                          hinText: 'From',
                          keyboardInputType: TextInputType.number,
                          validator: ValidatorClass().validateAge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      children: [
                        FieldTitle(title: 'Max Age'.tr, isRequired: true),
                        PrimaryTextFormField(
                          controller: controller.maxAgeController,
                          hinText: 'To',
                          keyboardInputType: TextInputType.number,
                          validator: ValidatorClass().validateAge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AgeGroupSelectorExtended extends StatelessWidget {
  AgeGroupSelectorExtended({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdsCampaignExtendPageController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Age Group:'.tr, style: TextStyle(fontSize: 16)),
          RadioListTile<String>(
            title: Text('All Age Groups'.tr),
            value: ageSelection.first,
            groupValue: controller.selectedOption.value,
            onChanged: (value) {
              controller.selectOption(value!);
            },
          ),
          RadioListTile<String>(
            title: Text('Age Range'.tr),
            value: ageSelection.last,
            groupValue: controller.selectedOption.value,
            onChanged: (value) {
              controller.selectOption(value!);
            },
          ),
          if (controller.isAgeRange)
            Container(
              margin: EdgeInsets.only(left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        FieldTitle(title: 'Min Age'.tr, isRequired: true),
                        PrimaryTextFormField(
                          controller: controller.minAgeController,
                          hinText: 'From',
                          keyboardInputType: TextInputType.number,
                          validator: ValidatorClass().validateAge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      children: [
                        FieldTitle(title: 'Max Age'.tr, isRequired: true),
                        PrimaryTextFormField(
                          controller: controller.maxAgeController,
                          hinText: 'To',
                          keyboardInputType: TextInputType.number,
                          validator: ValidatorClass().validateAge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
