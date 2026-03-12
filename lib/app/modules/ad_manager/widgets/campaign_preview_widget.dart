import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../ads_campaign_home/controllers/ads_campaign_home_controller.dart';
import '../../../routes/app_pages.dart';

import '../../../models/ads_management_models/campaign_model.dart';

class CampaignPreviewWidget extends StatelessWidget {
  final CampaignModel campaignModel;
  final Function viewDetailsClicked;

    CampaignPreviewWidget(
      {super.key,
      required this.campaignModel,
      required this.viewDetailsClicked});

  @override
  Widget build(BuildContext context) {
    final GlobalKey moreOptionsMenuKey = GlobalKey();
    final hasExpired = campaignModel.endDate!.isBefore(DateTime.now());
    final showFromSubscription = campaignModel.subscriptions!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: .5,
          color: Colors.grey.shade300,
        ),
      ),
      margin:   EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:   EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    campaignModel.campaignName ?? 'N/A',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                    key: moreOptionsMenuKey,
                    onPressed: () {
                      showPopUpMenu(
                          context: context, moreOptionKey: moreOptionsMenuKey);
                    },
                    icon:   Icon(Icons.more_vert))
              ],
            ),
          ),
          Padding(
            padding:   EdgeInsets.only(left: 15),
            child: Chip(
              color: WidgetStatePropertyAll(hasExpired && !showFromSubscription
                  ? Theme.of(context).colorScheme.tertiaryFixedDim
                  : Theme.of(context).colorScheme.primaryFixedDim),
              label: Text(
                  "${campaignModel.status} ${(hasExpired && !showFromSubscription) ? "- Expired" : ""}"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side:   BorderSide(color: Colors.transparent)),
            ),
          ),
            SizedBox(height: 6),
          Padding(
            padding:   EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                dataPreviewSubWidget(
                  context: context,
                  subTitle: showFromSubscription
                      ? "\$${campaignModel.subscriptions?[0].totalBudget ?? 'N/A'}"
                      : '\$${campaignModel.totalBudget ?? 'N/A'}',
                  title: 'Total Budget'.tr,
                ),
                dataPreviewSubWidget(
                  context: context,
                  subTitle: showFromSubscription
                      ? "\$${campaignModel.subscriptions?[0].dailyBudget ?? 'N/A'}"
                      : '\$${campaignModel.dailyBudget ?? 'N/A'}',
                  title: 'Daily budget'.tr,
                ),
                dataPreviewSubWidget(
                  context: context,
                  subTitle: showFromSubscription
                      ? (campaignModel.subscriptions?[0].startDate != null
                          ? DateFormat()
                              .add_MMMd()
                              .addPattern(', ')
                              .add_y()
                              .format(
                                  campaignModel.subscriptions![0].startDate!)
                          : 'N/A')
                      : (campaignModel.startDate != null
                          ? DateFormat()
                              .add_MMMd()
                              .addPattern(', ')
                              .add_y()
                              .format(campaignModel.startDate!)
                          : 'N/A'),
                  title: 'Start Date'.tr,
                ),
                dataPreviewSubWidget(
                  context: context,
                  subTitle: showFromSubscription
                      ? (campaignModel.subscriptions?[0].endDate != null
                          ? DateFormat()
                              .add_MMMd()
                              .addPattern(', ')
                              .add_y()
                              .format(campaignModel.subscriptions![0].endDate!)
                          : 'N/A')
                      : (campaignModel.endDate != null
                          ? DateFormat()
                              .add_MMMd()
                              .addPattern(', ')
                              .add_y()
                              .format(campaignModel.endDate!)
                          : 'N/A'),
                  title: 'End Date'.tr,
                ),
              ],
            ),
          ),
            SizedBox(height: 10),
          InkWell(
            onTap: () {
              viewDetailsClicked();
            },
            child: Material(
              borderRadius: BorderRadius.only(
                bottomLeft: (!hasExpired || showFromSubscription)
                    ?   Radius.circular(10)
                    :   Radius.circular(0),
                bottomRight: (!hasExpired || showFromSubscription)
                    ?   Radius.circular(10)
                    :   Radius.circular(0),
              ),
              color: Colors.grey.shade300,
              child:   Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('View Details'.tr),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            ),
          ),
          if (hasExpired && !showFromSubscription)
            InkWell(
              onTap: () {
                Get.toNamed(Routes.ADS_CAMPAIGN_EXTEND_PAGE,
                    arguments: campaignModel);
              },
              child: Material(
                borderRadius:   BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding:   EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Extend'.tr,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                        SizedBox(width: 10),
                      Icon(
                        Icons.add_alarm_sharp,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  void showPopUpMenu(
      {required BuildContext context, required GlobalKey moreOptionKey}) {
    final controller = Get.find<AdsCampaignHomeController>();
    final RenderBox button =
        moreOptionKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset offset = button.localToGlobal(Offset.zero);
    showMenu(
      context: context,
      color: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          (offset.dx - 30),
          offset.dy,
          button.size.width,
          button.size.height,
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child:   Row(
            children: [Icon(Icons.edit), Text('Edit'.tr)],
          ),
          onTap: () {
            controller.editTheSelectedCampaign(campaignModel: campaignModel);
          },
        ),
        PopupMenuItem(
          child:   Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              Text('Delete'.tr)
            ],
          ),
          onTap: () {
            if (campaignModel.id == null) return;
            controller.deleteCampaignWithID(id: campaignModel.id ?? '');
          },
        ),
      ],
    );
  }
}

Widget dataPreviewSubWidget(
    {required BuildContext context,
    required String? title,
    required String? subTitle}) {
  return SizedBox(
    width: (MediaQuery.sizeOf(context).width * 0.5) - 60,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'N/A',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
        ),
        Text(
          subTitle ?? 'N/A',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}
