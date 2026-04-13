import 'package:get/get.dart';
import '../controllers/marketplace_notifications_controller.dart';

class MarketplaceNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketplaceNotificationsController>(
      () => MarketplaceNotificationsController(),
    );
  }
}
