import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../models/ads_management_models/campaign_status_model.dart';
import '../controllers/ads_campaign_home_controller.dart';

import '../../../../components/dropdown.dart';
import '../../../../components/field_title.dart';
import '../../../../components/shimmer_loaders/single_component_shimmer.dart';
import '../../../../components/text_form_field.dart';
import '../../widgets/ads_creation_navigation_widget.dart';

class AdsCampaignFilterDrawer extends StatefulWidget {
    AdsCampaignFilterDrawer({super.key});

  @override
  State<AdsCampaignFilterDrawer> createState() =>
      _AdsCampaignFilterDrawerState();
}

class _AdsCampaignFilterDrawerState extends State<AdsCampaignFilterDrawer> {
  final controller = Get.find<AdsCampaignHomeController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding:   EdgeInsets.symmetric(vertical: 50, horizontal: 15),
        child: Column(
          children: [
            Text('Campaign Filters'.tr,
                style: Theme.of(context).appBarTheme.titleTextStyle),
              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Campaign Status'.tr, isRequired: false),
            Obx(
              () {
                if (!controller.isCampaignStatusLoading.value) {
                  return PrimaryDropDownFieldExtended<CampaignStatusModel>(
                    hint: 'Select status',
                    items: controller.campaignStatusList.value,
                    onChanged: (value) {
                      controller.selectedCampaignStatusModel.value = value;
                    },
                    selectedItem: controller.selectedCampaignStatusModel.value,
                    displayField: (CampaignStatusModel item) {
                      return item.label.toString();
                    },
                    valueField: (CampaignStatusModel item) {
                      return item;
                    },
                  );
                } else {
                  return   SingleComponentShimmer();
                }
              },
            ),

              SizedBox(
              height: 10,
            ),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'Start Date'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.startDateController,
              onTap: () async {
                await selectDate(context, controller.startDateValue,
                    controller.startDateController);
              },
              hinText: 'Start Date',
              prefixIcon:   Icon(Icons.calendar_today_outlined),
              prefixIconColor: Colors.grey,
              onChanged: (value) {
                return null;
              },
              readOnly: true,
            ),

            // $ ----------------------------------------------------------------------------------

              SizedBox(height: 10),

            // $ ----------------------------------------------------------------------------------

              FieldTitle(title: 'End Date'.tr, isRequired: true),
            PrimaryTextFormField(
              controller: controller.endDateController,
              onTap: () async {
                await selectDate(context, controller.endDateValue,
                    controller.endDateController);
              },
              hinText: 'End Date',
              prefixIcon:   Icon(Icons.calendar_today_outlined),
              prefixIconColor: Colors.grey,
              onChanged: (value) {
                return null;
              },
              readOnly: true,
            ),

              SizedBox(height: 20),

            AdsCreationNavigationWidget(
              actionTitleOne: 'Clear',
              actionTitleTwo: 'Apply',
              actionOneBGColor:
                  Theme.of(context).colorScheme.error.withValues(alpha: 0.6),
              actionOneOnClick: () {
                controller.clearFilter();
              },
              actionTwoOnClick: () {
                controller.applyFilterOnCampaignList();
              },
            ),
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
    }
  }
}
