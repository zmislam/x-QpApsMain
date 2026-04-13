import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../routes/app_pages.dart';
import '../buyer_dashboard/views/buyer_dashboard_view.dart';
import '../buyer_orders/views/buyer_orders_view.dart';
import '../buyer_reviews/views/buyer_reviews_view.dart';
import '../buyer_refunds/views/buyer_refunds_view.dart';
import '../buyer_addresses/views/address_management_view.dart';
import '../following_stores/views/following_stores_view.dart';
import '../buyer_complaints/views/buyer_complaints_view.dart';
import '../buyer_alerts/views/buyer_alerts_view.dart';
import '../buyer_recent_activity/views/buyer_recent_activity_view.dart';

/// Main Buyer Panel view with tab-based navigation.
///
/// Plan section 6.7 navigation:
/// [Dashboard] [Orders] [Saved] [Reviews] [Returns] [More ▼]
class BuyerPanelView extends StatefulWidget {
  const BuyerPanelView({super.key});

  @override
  State<BuyerPanelView> createState() => _BuyerPanelViewState();
}

class _BuyerPanelViewState extends State<BuyerPanelView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    Tab(text: 'Dashboard'),
    Tab(text: 'Orders'),
    Tab(text: 'Reviews'),
    Tab(text: 'Returns'),
    Tab(text: 'Addresses'),
    Tab(text: 'Following'),
    Tab(text: 'Complaints'),
    Tab(text: 'Alerts'),
    Tab(text: 'Activity'),
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
          'Buyer Panel',
          style: MarketplaceDesignTokens.heading(context),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
        actions: [
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
          BuyerDashboardView(),
          BuyerOrdersView(),
          BuyerReviewsView(),
          BuyerRefundsView(),
          AddressManagementView(),
          FollowingStoresView(),
          BuyerComplaintsView(),
          BuyerAlertsView(),
          BuyerRecentActivityView(),
        ],
      ),
    );
  }
}
