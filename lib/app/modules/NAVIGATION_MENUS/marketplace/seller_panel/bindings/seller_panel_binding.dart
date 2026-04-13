import 'package:get/get.dart';
import '../seller_dashboard/controllers/seller_dashboard_controller.dart';
import '../seller_insights/controllers/seller_insights_controller.dart';
import '../seller_products/controllers/seller_products_controller.dart';
import '../seller_orders/controllers/seller_orders_controller.dart';
import '../seller_payments/controllers/seller_payments_controller.dart';
import '../seller_stores/controllers/seller_stores_controller.dart';
import '../stock_management/controllers/stock_management_controller.dart';
import '../seller_returns/controllers/seller_returns_controller.dart';
import '../seller_coupons/controllers/seller_coupons_controller.dart';
import '../seller_verification/controllers/seller_verification_controller.dart';
import '../seller_promotions/controllers/seller_promotions_controller.dart';
import '../flash_sales/controllers/flash_sales_controller.dart';
import '../seller_performance/controllers/seller_performance_controller.dart';
import '../inventory_alerts/controllers/inventory_alerts_controller.dart';
import '../commission_summary/controllers/commission_summary_controller.dart';
import '../review_reply/controllers/review_reply_controller.dart';
import '../product_settings/controllers/product_settings_controller.dart';

class SellerPanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerDashboardController>(() => SellerDashboardController());
    Get.lazyPut<SellerInsightsController>(() => SellerInsightsController());
    Get.lazyPut<SellerProductsController>(() => SellerProductsController());
    Get.lazyPut<SellerOrdersController>(() => SellerOrdersController());
    Get.lazyPut<SellerPaymentsController>(() => SellerPaymentsController());
    Get.lazyPut<CommissionSummaryController>(() => CommissionSummaryController());
    Get.lazyPut<SellerStoresController>(() => SellerStoresController());
    Get.lazyPut<StockManagementController>(() => StockManagementController());
    Get.lazyPut<SellerReturnsController>(() => SellerReturnsController());
    Get.lazyPut<SellerCouponsController>(() => SellerCouponsController());
    Get.lazyPut<SellerPromotionsController>(() => SellerPromotionsController());
    Get.lazyPut<FlashSalesController>(() => FlashSalesController());
    Get.lazyPut<SellerPerformanceController>(() => SellerPerformanceController());
    Get.lazyPut<InventoryAlertsController>(() => InventoryAlertsController());
    Get.lazyPut<ReviewReplyController>(() => ReviewReplyController());
    Get.lazyPut<ProductSettingsController>(() => ProductSettingsController());
    Get.lazyPut<SellerVerificationController>(() => SellerVerificationController());
  }
}
