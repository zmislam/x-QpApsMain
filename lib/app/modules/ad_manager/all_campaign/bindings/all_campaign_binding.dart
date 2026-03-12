import 'package:get/get.dart';

import '../controllers/all_campaign_controller.dart';

class AllCampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllCampaignController>(
      () => AllCampaignController(),
    );
  }
}
