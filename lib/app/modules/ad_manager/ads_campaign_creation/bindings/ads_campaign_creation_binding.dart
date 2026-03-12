import 'package:get/get.dart';

import '../controllers/ads_campaign_creation_controller.dart';

class AdsCampaignCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdsCampaignCreationController>(
      () => AdsCampaignCreationController(),
    );
  }
}
