import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../components/dropdown.dart';
import '../../../../components/field_title.dart';
import '../../../../components/shimmer_loaders/single_component_shimmer.dart';
import '../../../../config/constants/data_const.dart';
import '../../../NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/mypage_model.dart';
import '../../widgets/ads_creation_navigation_widget.dart';
import '../../widgets/selection_chip_group_widget.dart';
import '../../../../utils/validator.dart';

import '../../../../components/text_form_field.dart';
import '../../widgets/age_group_selection.dart';
import '../controllers/ads_campaign_creation_controller.dart';

class AdsCampaignCreationView extends GetView<AdsCampaignCreationController> {
    AdsCampaignCreationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        title:  Text('New Campaign Create'.tr),
      ),

      // ┃ TODO:  IMPLEMENT END DRAWER WHEN DESIGN IS LAVALIERE ┃
      // endDrawer:   Drawer(),

      body: Form(
        key: controller.campaignDetailsFormKey,
        child: ListView(
          padding:   EdgeInsets.all(15),
          children: [
            // *---------------------------------------------------------------------------
            // * INITIAL SECTION
            // *---------------------------------------------------------------------------

              FieldTitle(title: 'Campaign Name'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.campaignNameController,
              hinText: 'Campaign Name',
              validator: ValidatorClass().validateName,
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Campaign Category'.tr, isRequired: true),
            PrimaryDropDownField(
              hint: 'Select Category',
              list: campaignCategory,
              validationText: 'Please select a category',
              onChanged: (value) {
                controller.campaignCategoryController.text = value ?? '';
              },
              value: controller.campaignCategoryController.text.isEmpty
                  ? null
                  : controller.campaignCategoryController.text,
            ),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Page Name'.tr, isRequired: true),

            Obx(
              () {
                if (!controller.loadingMyPages.value) {
                  return PrimaryDropDownFieldExtended<MyPagesModel>(
                    hint: 'Select Page',
                    items: controller.myPages.value,
                    onChanged: (value) {
                      controller.selectedMyPageModel.value = value;
                    },
                    selectedItem: controller.selectedMyPageModel.value,
                    validationText: 'Please select a page',
                    displayField: (MyPagesModel item) {
                      return item.pageName.toString();
                    },
                    valueField: (MyPagesModel item) {
                      return item;
                    },
                  );
                } else {
                  return   SingleComponentShimmer();
                }
              },
            ),

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

            // *---------------------------------------------------------------------------
            // * BUDGET SELECTION
            // *---------------------------------------------------------------------------

              SizedBox(height: 15),
            Text('Budget'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
              SizedBox(height: 15),

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
              AgeGroupSelector(),

            // *---------------------------------------------------------------------------
            // * PAGE TO PAGE NAVIGATION
            // *---------------------------------------------------------------------------

              SizedBox(height: 20),
            AdsCreationNavigationWidget(
              actionTitleOne: 'Back',
              actionOneOnClick: () {
                controller.returnToPrevious(pageNumber: 1);
              },
              actionTwoOnClick: () {
                controller.validateCampaignDetailsAndGoToLocation();
              },
            ),
              SizedBox(height: 60),
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
