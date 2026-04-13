import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../routes/app_pages.dart';
import '../seller_dashboard/views/seller_dashboard_view.dart';
import '../seller_insights/views/seller_insights_view.dart';
import '../seller_performance/views/seller_performance_view.dart';
import '../inventory_alerts/views/inventory_alerts_view.dart';
import '../seller_products/views/seller_products_view.dart';
import '../seller_orders/views/seller_orders_view.dart';
import '../seller_payments/views/seller_payments_view.dart';
import '../commission_summary/views/commission_summary_view.dart';
import '../seller_stores/views/seller_stores_view.dart';
import '../stock_management/views/stock_management_view.dart';
import '../seller_returns/views/seller_returns_view.dart';
import '../seller_coupons/views/seller_coupons_view.dart';
import '../seller_verification/views/seller_verification_view.dart';
import '../seller_promotions/views/seller_promotions_view.dart';
import '../flash_sales/views/flash_sales_view.dart';
import '../review_reply/views/review_reply_view.dart';
import '../product_settings/views/product_settings_view.dart';

/// Main Seller Panel view with tab-based navigation.
///
/// Plan section 6.8 navigation:
/// [Dashboard] [Products] [Orders] [Payments] [Store] [Stock]
class SellerPanelView extends StatefulWidget {
  const SellerPanelView({super.key});

  @override
  State<SellerPanelView> createState() => _SellerPanelViewState();
}

class _SellerPanelViewState extends State<SellerPanelView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    Tab(text: 'Dashboard'),
    Tab(text: 'Insights'),
    Tab(text: 'Products'),
    Tab(text: 'Orders'),
    Tab(text: 'Payments'),
    Tab(text: 'Comm.'),
    Tab(text: 'Store'),
    Tab(text: 'Stock'),
    Tab(text: 'Alerts'),
    Tab(text: 'Returns'),
    Tab(text: 'Coupons'),
    Tab(text: 'Promos'),
    Tab(text: 'Flash'),
    Tab(text: 'Reviews'),
    Tab(text: 'Settings'),
    Tab(text: 'Perf'),
    Tab(text: 'Verify'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // If navigated with a specific tab index
    final args = Get.arguments;
    if (args is Map && args['tab'] != null) {
      final tabIndex = args['tab'] as int;
      if (tabIndex >= 0 && tabIndex < _tabs.length) {
        _tabController.index = tabIndex;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seller Panel',
          style: MarketplaceDesignTokens.heading(context),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign_outlined),
            tooltip: 'Announcements',
            onPressed: () => Get.toNamed(Routes.SELLER_ANNOUNCEMENTS),
          ),
          IconButton(
            icon: const Icon(Icons.forum_outlined),
            tooltip: 'Marketplace Inbox',
            onPressed: () => Get.toNamed(Routes.MARKETPLACE_INBOX),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Marketplace Notifications',
            onPressed: () => Get.toNamed(Routes.MARKETPLACE_NOTIFICATIONS),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: MarketplaceDesignTokens.pricePrimary,
          unselectedLabelColor:
              MarketplaceDesignTokens.textSecondary(context),
          indicatorColor: MarketplaceDesignTokens.pricePrimary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SellerDashboardView(),
          SellerInsightsView(),
          SellerProductsView(),
          SellerOrdersView(),
          SellerPaymentsView(),
          CommissionSummaryView(),
          SellerStoresView(),
          StockManagementView(),
          InventoryAlertsView(),
          SellerReturnsView(),
          SellerCouponsView(),
          SellerPromotionsView(),
          FlashSalesView(),
          ReviewReplyView(),
          ProductSettingsView(),
          SellerPerformanceView(),
          SellerVerificationView(),
        ],
      ),
    );
  }
}
