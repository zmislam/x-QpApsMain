import 'package:get/get.dart';
import '../buyer_dashboard/controllers/buyer_dashboard_controller.dart';
import '../buyer_orders/controllers/buyer_orders_controller.dart';
import '../buyer_reviews/controllers/buyer_reviews_controller.dart';
import '../buyer_refunds/controllers/buyer_refunds_controller.dart';
import '../buyer_addresses/controllers/address_management_controller.dart';
import '../following_stores/controllers/following_stores_controller.dart';
import '../buyer_complaints/controllers/buyer_complaints_controller.dart';
import '../buyer_alerts/controllers/buyer_alerts_controller.dart';
import '../buyer_recent_activity/controllers/buyer_recent_activity_controller.dart';

class BuyerPanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerDashboardController>(() => BuyerDashboardController());
    Get.lazyPut<BuyerOrdersController>(() => BuyerOrdersController());
    Get.lazyPut<BuyerReviewsController>(() => BuyerReviewsController());
    Get.lazyPut<BuyerRefundsController>(() => BuyerRefundsController());
    Get.lazyPut<AddressManagementController>(() => AddressManagementController());
    Get.lazyPut<FollowingStoresController>(() => FollowingStoresController());
    Get.lazyPut<BuyerComplaintsController>(() => BuyerComplaintsController());
    Get.lazyPut<BuyerAlertsController>(() => BuyerAlertsController());
    Get.lazyPut<BuyerRecentActivityController>(() => BuyerRecentActivityController());
  }
}
