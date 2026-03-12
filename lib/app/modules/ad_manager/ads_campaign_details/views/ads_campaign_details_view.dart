import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../components/file_picker_widget.dart';
import '../../../../config/constants/data_const.dart';

import '../controllers/ads_campaign_details_controller.dart';

class AdsCampaignDetailsView extends GetView<AdsCampaignDetailsController> {
    AdsCampaignDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text('Campaign Details'.tr),
      ),
      body: ListView(
        padding:   EdgeInsets.all(15),
        children: [
          // *---------------------------------------------------------------------------
          // * CAMPAIGN DETAILS
          // *---------------------------------------------------------------------------
          Text('Campaign'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),
          FilePickerWidget(
            controller: controller.filePickerController,
            viewOnly: true,
            height: Get.size.height * 0.5,
          ),
            SizedBox(height: 15),

          dataPreviewSubWidget(
            context: context,
            title: 'Campaign Name'.tr,
            subTitle: controller.campaignModel.value.campaignName,
          ),
          dataPreviewSubWidget(
            context: context,
            title: 'Campaign Category'.tr,
            subTitle: controller.campaignModel.value.campaignCategory,
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
                subTitle: '\$ ${emptyAndNullCheck(controller.campaignModel.value.totalBudget.toString())}',
                setHalfWidth: true,
              ),
              dataPreviewSubWidget(
                context: context,
                title: 'Daily Budget'.tr,
                subTitle: '\$ ${emptyAndNullCheck(controller.campaignModel.value.dailyBudget.toString())}',
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
                subTitle: controller.campaignModel.value.gender,
                setHalfWidth: true,
              ),
              dataPreviewSubWidget(
                context: context,
                title: 'Age Group'.tr,
                subTitle: !controller.campaignModel.value.ageGroup.toString().contains(ageSelection.first) ? '${emptyAndNullCheck(controller.campaignModel.value.fromAge.toString())} - ${emptyAndNullCheck(controller.campaignModel.value.toAge.toString())}' : 'All Age Group',
                setHalfWidth: true,
              ),
            ],
          ),

          // *---------------------------------------------------------------------------
          // * LOCATION
          // *---------------------------------------------------------------------------
            SizedBox(height: 15),
          Text('Location'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
            SizedBox(height: 15),

          if (controller.campaignModel.value.locations!.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: controller.campaignModel.value.locations!.map((item) {
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
          if (controller.campaignModel.value.locations == null || controller.campaignModel.value.locations!.isEmpty)   Text("Don't have any selected"),

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
                  emptyAndNullCheck(controller.campaignModel.value.adsPlacement),
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
                subTitle: DateFormat().add_MMMEd().format(controller.campaignModel.value.startDate!),
                setHalfWidth: true,
              ),
              dataPreviewSubWidget(
                context: context,
                title: 'End Date'.tr,
                subTitle: DateFormat().add_MMMEd().format(controller.campaignModel.value.endDate!),
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
                  emptyAndNullCheck(controller.campaignModel.value.destination),
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
                  emptyAndNullCheck(controller.campaignModel.value.callToAction),
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
            children: controller.campaignModel.value.keywords!.map((item) {
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
}
