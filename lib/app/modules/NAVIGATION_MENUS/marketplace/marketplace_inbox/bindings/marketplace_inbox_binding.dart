import 'package:get/get.dart';
import '../controllers/marketplace_inbox_controller.dart';

class MarketplaceInboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketplaceInboxController>(
      () => MarketplaceInboxController(),
    );
  }
}
