import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../routes/app_pages.dart';
import '../controllers/seller_dashboard_controller.dart';
import '../widgets/seller_metrics_cards.dart';
import '../widgets/seller_quick_actions.dart';
import '../widgets/seller_performance_card.dart';
import '../widgets/seller_listings_card.dart';
import '../widgets/seller_recent_orders.dart';
import '../widgets/seller_commission_card.dart';

/// Seller Dashboard tab — metrics, quick actions, performance, listings, orders, commission.
/// Plan wireframe section 6.8.
class SellerDashboardView extends GetView<SellerDashboardController> {
  const SellerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: MarketplaceDesignTokens.pricePrimary,
          ),
        );
      }

      final data = controller.dashboard.value;
      if (data == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.storefront_outlined,
                  size: 48,
                  color: MarketplaceDesignTokens.textSecondary(context)),
              const SizedBox(height: 12),
              Text(
                'No seller data available',
                style: MarketplaceDesignTokens.bodyText(context),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: controller.fetchDashboard,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchDashboard,
        color: MarketplaceDesignTokens.pricePrimary,
        child: ListView(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
          children: [
            // Metrics grid
            SellerMetricsCards(
              metrics: data.metrics,
              listings: data.listings,
              sellerRating: data.sellerRating,
            ),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Quick actions
            SellerQuickActions(
              onAddProduct: () => Get.toNamed(Routes.MARKETPLACE_ADD_PRODUCT),
              onOrders: () => _switchTab(context, 2),
              onPayments: () => _switchTab(context, 3),
              onStore: () => _switchTab(context, 4),
            ),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Performance score
            SellerPerformanceCard(
              conversionRate: data.metrics.conversionRate,
              totalViews: data.metrics.totalViews,
            ),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Listings overview
            SellerListingsCard(listings: data.listings),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Commission & payouts
            SellerCommissionCard(commission: data.commission),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Recent orders
            SellerRecentOrdersCard(orders: data.recentOrders),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),
          ],
        ),
      );
    });
  }

  /// Switch tab in parent SellerPanelView by finding ancestor TabController.
  void _switchTab(BuildContext context, int index) {
    // The SellerPanelView uses its own TabController, not DefaultTabController.
    // Navigate by re-opening the panel with the tab argument instead.
    Get.offNamed('/marketplace-seller-panel', arguments: {'tab': index});
  }
}
