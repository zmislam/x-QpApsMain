import 'package:get/get.dart';

import '../controllers/ads_campaign_extend_page_controller.dart';

class AdsCampaignExtendPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdsCampaignExtendPageController>(
      () => AdsCampaignExtendPageController(),
    );
  }
}
