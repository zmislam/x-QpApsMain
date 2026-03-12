import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../extension/num.dart';
import 'package:reown_appkit/modal/widgets/buttons/primary_button.dart';

import '../../../../components/dropdown.dart';
import '../../../../components/field_title.dart';
import '../../../../components/text_form_field.dart';
import '../../../../config/constants/data_const.dart';
import '../../../../models/location_model.dart';
import '../../../../utils/validator.dart';
import '../../widgets/age_group_selection.dart';
import '../../widgets/selection_chip_group_widget.dart';
import '../controllers/ads_campaign_extend_page_controller.dart';

class AdsCampaignExtendPageView
    extends GetView<AdsCampaignExtendPageController> {
    const AdsCampaignExtendPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text('Extend AD Subscription'.tr),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding:   EdgeInsets.symmetric(horizontal: 15),
          children: [
            // *---------------------------------------------------------------------------
            // * DATE TIME SECTION
            // *---------------------------------------------------------------------------

              SizedBox(height: 15),
            Text('Date & Time'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
              SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      // $ ----------------------------------------------------------------------------------

                        FieldTitle(title: 'Start Date'.tr, isRequired: true),
                      PrimaryTextFormField(
                        controller: controller.startDateController,
                        onTap: () async {
                          await selectDate(context, controller.startDateValue,
                                  controller.startDateController)
                              .then(
                            (value) {
                              controller.calculateDailyBudget();
                            },
                          );
                        },
                        hinText: 'Start Date',
                        prefixIcon:   Icon(Icons.calendar_today_outlined),
                        prefixIconColor: Colors.grey,
                        onChanged: (value) {
                          controller.calculateDailyBudget();
                          return null;
                        },
                        validator: ValidatorClass().validateDateTime,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                  SizedBox(width: 10),

                // $ ----------------------------------------------------------------------------------

                Flexible(
                  child: Column(
                    children: [
                        FieldTitle(title: 'End Date'.tr, isRequired: true),
                      PrimaryTextFormField(
                        controller: controller.endDateController,
                        onTap: () async {
                          await selectDate(context, controller.endDateValue,
                                  controller.endDateController)
                              .then(
                            (value) {
                              controller.calculateDailyBudget();
                            },
                          );
                        },
                        hinText: 'End Date',
                        prefixIcon:   Icon(Icons.calendar_today_outlined),
                        prefixIconColor: Colors.grey,
                        validator: ValidatorClass().validateDateTime,
                        onChanged: (value) {
                          controller.calculateDailyBudget();
                          return null;
                        },
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // $ ----------------------------------------------------------------------------------

              SizedBox(height: 10),
              FieldTitle(title: 'User Destination'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.userDestinationController,
              hinText: 'www.example.qp.com',
              prefixIcon:   Icon(Icons.link),
              keyboardInputType: TextInputType.url,
              validator: ValidatorClass().validateUrl,
            ),
              SizedBox(height: 15),

            // $ ----------------------------------------------------------------------------------

            // *---------------------------------------------------------------------------
            // * BUDGET SELECTION
            // *---------------------------------------------------------------------------

            Text('Budget'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
              SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // $ ----------------------------------------------------------------------------------

                Flexible(
                  child: Column(
                    children: [
                        FieldTitle(title: 'Total Budget'.tr, isRequired: true),
                      PrimaryTextFormField(
                        controller: controller.totalBudgetController,
                        hinText: 'Total Budget',
                        keyboardInputType: TextInputType.number,
                        validator: ValidatorClass().validateMoney,
                        prefixIcon:   Icon(Icons.attach_money),
                        prefixIconColor: Colors.grey,
                        onChanged: (value) {
                          controller.calculateDailyBudget();
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                  SizedBox(width: 10),

                // $ ----------------------------------------------------------------------------------

                Flexible(
                  child: Column(
                    children: [
                        FieldTitle(title: 'Daily Budget'.tr, isRequired: true),
                      PrimaryTextFormField(
                        controller: controller.dailyBudgetController,
                        hinText: 'Daily Budget',
                        validator: ValidatorClass().validateMoney,
                        prefixIcon:   Icon(Icons.attach_money),
                        prefixIconColor: Colors.grey,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // *---------------------------------------------------------------------------
            // * BUDGET SELECTION
            // *---------------------------------------------------------------------------

              SizedBox(height: 15),
            Text('Location & Placement'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),

              SizedBox(height: 10),
              FieldTitle(title: 'Search For Location'.tr, isRequired: false),
            BottomSheetDropdownMultiSelect<String>(
              list: controller.locationList.value
                  .map(
                    (e) => e.locationName.toString(),
                  )
                  .toList(),
              //  [],
              onChanged: (object) {
                controller.selectedLocations.value = object;
              },
              selectedItems: controller.selectedLocations.value,
              minLengthForSearch: 1,
              hint: 'Search Location',
              onSearch: (String searchText) async {
                controller.locationList.value.clear();
                debugPrint('Searching: $searchText');
                List<AllLocation> locations =
                    await controller.getLocation(searchText);
                List<String> locationNames = locations
                    .map((location) => location.locationName)
                    .whereType<String>()
                    .toList();
                return locationNames;
              },
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Ads Placement'.tr, isRequired: true),
            PrimaryDropDownField(
              hint: 'Select ad placement location',
              list: adsPlacementOptions,
              validationText: 'Please select a location',
              onChanged: (value) {
                controller.adPlacementController.text = value ?? '';
              },
              value: controller.adPlacementController.text.isEmpty
                  ? null
                  : controller.adPlacementController.text,
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Keyword'.tr, isRequired: true),
            MultiInputChipField(
              label: 'Keywords'.tr,
              hintText: 'Add a keyword and press done'.tr,
              validator: ValidatorClass().validateListNotEmpty,
              itemsRx: controller
                  .enteredKeywords, // Pass the RxList to maintain state
            ),
              SizedBox(height: 10),

            // *---------------------------------------------------------------------------
            // * TARGET PEOPLE
            // *---------------------------------------------------------------------------

              SizedBox(height: 15),
            Text('Target people'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
              SizedBox(height: 15),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Gender'.tr),
            SelectionChipGroup(
              options:   ['Any', 'Male', 'Female'],
              controller: controller.genderController,
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Age Group'.tr),
              AgeGroupSelectorExtended(),

            // $ ----------------------------------------------------------------------------------
              SizedBox(height: 20),
            PrimaryButton(
              title: 'Run Ads'.tr,
              color: Theme.of(context).primaryColor,
              onTap: () {
                controller
                    .resubscribeToCampaignAndRunAds()
                    .whenComplete(() => Navigator.pop(context));
              },
            ),
            MediaQuery.of(context).padding.bottom > 0 ? 50.h : 20.h,
          ],
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context, RxString dateValue,
      TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate;
      dateValue.value = pickedDate.toIso8601String();
      debugPrint('Updated Date: $formattedDate');
    }
  }
}
