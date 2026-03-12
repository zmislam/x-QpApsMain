import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/button.dart';
import '../../../../components/text_form_field.dart';
import '../../../../extension/num.dart';
import '../../widgets/campaign_preview_widget.dart';

import '../controllers/ads_campaign_home_controller.dart';
import '../widget/ads_campaign_filter_drawer.dart';

class AdsCampaignHomeView extends GetView<AdsCampaignHomeController> {
    AdsCampaignHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // @ FOR CLEARING THE FOCUS FROM THE SEARCH TEXT FIELD
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          title:   Text('Ads Manager'.tr),
          actions: [
            IconButton(
              onPressed: () {
                controller.scaffoldKey.currentState!.openEndDrawer();
              },
              icon:   Icon(Icons.filter_alt_outlined),
            ),
          ],
        ),

        // ┃ TODO:  IMPLEMENT END DRAWER WHEN DESIGN IS LAVALIERE ┃
        endDrawer:   AdsCampaignFilterDrawer(),

        body: Padding(
          padding:   EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            onRefresh: () async {
              controller.searchController.clear();
              await controller.getAllCampaigns(forceFetch: true);
            },
            child: Column(
              children: [
                Obx(() {
                  return PrimaryTextFormField(
                    controller: controller.searchController,
                    prefixIcon:   Icon(Icons.search),
                    suffixIcon: controller.searchText.value.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              controller.getAllCampaigns(
                                  campaignName:
                                      controller.searchController.text);
                            },
                            icon:   Icon(Icons.search),
                          )
                        : null,
                    hinText: 'Search Campaigns',
                    onChanged: (value) {
                      controller.searchText.value = value ?? '';
                      return null;
                    },
                  );
                }),
                  SizedBox(height: 10),
                PrimaryIconButton(
                  onPressed: controller.goToCreateCampaignPage,
                  iconWidget:   Icon(
                    Icons.add,
                    size: 22,
                  ),
                  verticalPadding: 15,
                  text: 'Create Campaigns'.tr,
                ),
                  SizedBox(height: 10),

                // *---------------------------------------------------------------------------
                // * TAB BAR FUNCTIONALITY
                // *---------------------------------------------------------------------------

                Container(
                  height: 60,
                  padding:   EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.5, color: Colors.grey.shade300),
                  ),
                  child: TabBar(
                    controller: controller.tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                    padding:   EdgeInsets.all(4),
                    tabs:   [
                      Tab(
                        text: 'All'.tr,
                      ),
                      Tab(
                        text: 'Active'.tr,
                      ),
                      Tab(
                        text: 'Paused'.tr,
                      ),
                    ],
                  ),
                ),

                // *---------------------------------------------------------------------------
                // * TAB VIEW BUILDER
                // * AS DATA CHANGES BY STATUS ONLY LIST VIEW BUILDER IS ENOUGH
                // *---------------------------------------------------------------------------

                  SizedBox(height: 10),
                Obx(() {
                  if (!controller.campaignsLoading.value) {
                    return Expanded(
                      child: controller.userCampaigns.isNotEmpty
                          ? ListView.builder(
                              // shrinkWrap: true,
                              itemCount: controller.userCampaigns.length,
                              padding:   EdgeInsets.only(bottom: 10),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    CampaignPreviewWidget(
                                      campaignModel:
                                          controller.userCampaigns[index],
                                      viewDetailsClicked: () {
                                        controller.goToCampaignDetailsPage(
                                            dataModel: controller
                                                .userCampaigns[index]);
                                      },
                                    ),
                                    MediaQuery.of(context).padding.bottom > 0
                                        ? 30.h
                                        : 0.h,
                                  ],
                                );
                              },
                            )
                          :   Center(
                              child: Text(
                                  "You don't have any campaigns on this tab")),
                    );
                  } else {
                    return   Center(child: CircularProgressIndicator());
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
