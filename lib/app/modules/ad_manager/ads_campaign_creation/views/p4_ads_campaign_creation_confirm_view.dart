import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/file_picker_widget.dart';
import '../../widgets/ads_creation_navigation_widget.dart';
import '../controllers/ads_campaign_creation_controller.dart';

class AdsCampaignCreationConfirmView extends GetView<AdsCampaignCreationController> {
    AdsCampaignCreationConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKeyConfirm,
      appBar: AppBar(
        title:   Text('Campaign Details'.tr),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding:   EdgeInsets.all(15),
        children: [
          // *---------------------------------------------------------------------------
          // * ASSETS FILE PREVIEW
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Campaign Asset'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              editChipButton(
                  context: context,
                  onClick: () {
                    controller.editCampaignAssetPage();
                  }),
            ],
          ),
            SizedBox(height: 15),
          FilePickerWidget(
            controller: controller.filePickerController,
            viewOnly: true,
            height: Get.size.height * 0.5,
          ),
            SizedBox(height: 15),

          // *---------------------------------------------------------------------------
          // * CAMPAIGN DETAILS
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Campaign'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              editChipButton(
                  context: context,
                  onClick: () {
                    controller.editCampaignDetailsPage();
                  }),
            ],
          ),
            SizedBox(height: 15),

          dataPreviewSubWidget(
            context: context,
            title: 'Campaign Name'.tr,
            subTitle: controller.campaignNameController.text.trim(),
          ),
          dataPreviewSubWidget(
            context: context,
            title: 'Campaign Category'.tr,
            subTitle: controller.campaignCategoryController.text.trim(),
          ),

          // *---------------------------------------------------------------------------
          // * BUDGET
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Text('Budget'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),

          Row(
            children: [
              dataPreviewSubWidget(
                context: context,
                title: 'Total Budget'.tr,
                subTitle: '\$ ${emptyAndNullCheck(controller.totalBudgetController.text.trim())}',
                setHalfWidth: true,
              ),
              dataPreviewSubWidget(
                context: context,
                title: 'Daily Budget'.tr,
                subTitle: '\$ ${emptyAndNullCheck(controller.dailyBudgetController.text.trim())}',
                setHalfWidth: true,
              ),
            ],
          ),

          // *---------------------------------------------------------------------------
          // * TARGET PEOPLE
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Text('Target People'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),

          Row(
            children: [
              dataPreviewSubWidget(
                context: context,
                title: 'Target People'.tr,
                subTitle: controller.genderController.text.trim(),
                setHalfWidth: true,
              ),
              dataPreviewSubWidget(
                context: context,
                title: 'Age Group'.tr,
                subTitle: controller.isAgeRange ? '${emptyAndNullCheck(controller.minAgeController.text)} - ${emptyAndNullCheck(controller.maxAgeController.text)}' : 'All Age Group',
                setHalfWidth: true,
              ),
            ],
          ),

          // *---------------------------------------------------------------------------
          // * LOCATION
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Location'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              editChipButton(
                  context: context,
                  onClick: () {
                    controller.editCampaignLocationPage();
                  }),
            ],
          ),
            SizedBox(height: 15),

          if (controller.selectedLocations.value.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: controller.selectedLocations.value.map((item) {
                return Chip(
                  label: Text(
                    item.toString(),
                    style:   TextStyle(fontSize: 12),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          if (controller.selectedLocations.value.isEmpty)   Text('Please select target locations'.tr),

          // *---------------------------------------------------------------------------
          // * ADs Placement
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Text('Ads Placement'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),
          Row(
            children: [
              Chip(
                label: Text(
                  emptyAndNullCheck(controller.adPlacementController.text.trim()),
                  style:   TextStyle(fontSize: 12),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

            SizedBox(height: 15),

          // *---------------------------------------------------------------------------
          // * DATE & TIME
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Text('Date & Time'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),

          Row(
            children: [
              dataPreviewSubWidget(
                context: context,
                title: 'Start Date'.tr,
                subTitle: controller.startDateController.text,
                setHalfWidth: true,
              ),
              dataPreviewSubWidget(
                context: context,
                title: 'End Date'.tr,
                subTitle: controller.endDateController.text,
                setHalfWidth: true,
              ),
            ],
          ),

          // *---------------------------------------------------------------------------
          // * USER DESTINATION
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Text('User Destination'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),

          Row(
            children: [
              Chip(
                label: Text(
                  emptyAndNullCheck(controller.userDestinationController.text.trim()),
                  style:   TextStyle(fontSize: 12),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          // *---------------------------------------------------------------------------
          // * CALL TO ACTION
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Text('Call To Action'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),

          Row(
            children: [
              Chip(
                label: Text(
                  emptyAndNullCheck(controller.callToActionController.text.trim()),
                  style:   TextStyle(fontSize: 12),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),

          // *---------------------------------------------------------------------------
          // * Keywords
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Text('Keywords'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: controller.enteredKeywords!.map((item) {
              return Chip(
                label: Text(
                  item.toString(),
                  style:   TextStyle(fontSize: 12),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),

          // *---------------------------------------------------------------------------
          // * PAGE TO PAGE NAVIGATION
          // *---------------------------------------------------------------------------

            SizedBox(height: 20),
          AdsCreationNavigationWidget(
            actionTitleOne: 'Save Draft',
            actionTitleTwo: 'Pay & Lunch',
            actionOneOnClick: () {
              controller.createCampaign(status: 'draft');
            },
            actionTwoOnClick: () {
              controller.createCampaign(status: 'active');
            },
          ),

            SizedBox(height: 70),
        ],
      ),
    );
  }

  String emptyAndNullCheck(String? data) {
    if (data == null || data.isEmpty) {
      return 'Not Provided';
    }
    return data;
  }

  Widget dataPreviewSubWidget({required BuildContext context, required String? title, required String? subTitle, bool? setHalfWidth}) {
    return Padding(
      padding:   EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: (setHalfWidth ?? false) ? (MediaQuery.sizeOf(context).width * 0.5) - 30 : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emptyAndNullCheck(title),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w200, color: Colors.grey),
            ),
            Text(
              emptyAndNullCheck(subTitle),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget editChipButton({required Function onClick, required BuildContext context}) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).colorScheme.onSecondary,
            border: Border.all(
              width: .5,
              color: Theme.of(context).colorScheme.secondary,
            )),
        padding:   EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Text('Edit'.tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
