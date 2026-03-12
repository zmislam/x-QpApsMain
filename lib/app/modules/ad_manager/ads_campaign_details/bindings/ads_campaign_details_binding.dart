import 'package:get/get.dart';

import '../controllers/ads_campaign_details_controller.dart';

class AdsCampaignDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdsCampaignDetailsController>(
      () => AdsCampaignDetailsController(),
    );
  }
}
