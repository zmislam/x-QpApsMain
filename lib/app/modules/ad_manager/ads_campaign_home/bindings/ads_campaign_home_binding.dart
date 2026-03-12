import 'package:get/get.dart';

import '../controllers/ads_campaign_home_controller.dart';

class AdsCampaignHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdsCampaignHomeController>(
      () => AdsCampaignHomeController(),
    );
  }
}
