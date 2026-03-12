import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/all_campaign_controller.dart';

class AllCampaignView extends GetView<AllCampaignController> {
    AllCampaignView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text('AllCampaignView'.tr),
        centerTitle: true,
      ),
      body:   Center(
        child: Text('AllCampaignView is working'.tr,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
