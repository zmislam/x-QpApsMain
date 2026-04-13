import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../components/empty_state.dart';
import '../controllers/buyer_dashboard_controller.dart';
import '../widgets/buyer_metrics_cards.dart';
import '../widgets/buyer_financial_cards.dart';
import '../widgets/buyer_quick_actions.dart';
import '../widgets/buyer_spending_chart.dart';
import '../widgets/buyer_recent_orders.dart';
import '../widgets/buyer_access_status_card.dart';

/// Buyer Dashboard — Plan section 6.7 wireframe:
///
/// ┌──────────────────────────┐
/// │ 👋 Hi, {Name}            │
/// │ Your Marketplace Overview │
/// ├──────────────────────────┤
/// │ [12 Orders] [3 Pending]  │  ← 2x2 metric grid
/// │ [8 Delivd]  [1 Return]   │
/// ├──────────────────────────┤
/// │ Total Spent | Escrow | Refunds │ ← Financial row
/// ├──────────────────────────┤
/// │ Quick Actions            │
/// │ [Orders][Reviews][Returns][Stores] │
/// ├──────────────────────────┤
/// │ Spending Overview        │  ← Bar chart
/// ├──────────────────────────┤
/// │ Recent Orders            │
/// └──────────────────────────┘
class BuyerDashboardView extends StatelessWidget {
  const BuyerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerDashboardController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: MarketplaceDesignTokens.pricePrimary,
          ),
        );
      }

      if (controller.hasError.value) {
        return MarketplaceEmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load dashboard',
          subtitle: 'Please check your connection and try again.',
          actionLabel: 'Retry',
          onAction: controller.refreshDashboard,
        );
      }

      final dashboard = controller.dashboard.value;
      if (dashboard == null) {
        return MarketplaceEmptyState(
          icon: Icons.dashboard_outlined,
          title: 'No Data',
          subtitle: 'Your dashboard data will appear here.',
          actionLabel: 'Refresh',
          onAction: controller.refreshDashboard,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        color: MarketplaceDesignTokens.pricePrimary,
        child: ListView(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
          children: [
            // Greeting
            Text(
              'Your Marketplace Overview',
              style: MarketplaceDesignTokens.heading(context),
            ),
            const SizedBox(height: 4),
            Text(
              '${dashboard.metrics.ordersThisMonth} orders this month',
              style: MarketplaceDesignTokens.cardSubtext(context),
            ),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Access Status Card
            if (controller.accessStatus.value != null)
              BuyerAccessStatusCard(
                  status: controller.accessStatus.value!),
            if (controller.accessStatus.value != null)
              const SizedBox(
                  height: MarketplaceDesignTokens.sectionSpacing),

            // Metric cards (2x2)
            BuyerMetricsCards(
              metrics: dashboard.metrics,
              onTapMetric: (filter) {
                // Switch to Orders tab with filter
                final tabController =
                    DefaultTabController.of(context);
                if (tabController.length > 1) {
                  tabController.animateTo(1);
                }
              },
            ),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Financial cards
            BuyerFinancialCards(metrics: dashboard.metrics),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Quick Actions
            BuyerQuickActions(
              onSwitchTab: (index) {
                // Find the ancestor TabController from BuyerPanelView
                final state = context.findAncestorStateOfType<State>();
                // Navigate via parent tab if possible
                if (state != null) {
                  // Try to find the TabController
                  try {
                    final tabCtrl = DefaultTabController.of(context);
                    if (index < tabCtrl.length) {
                      tabCtrl.animateTo(index);
                    }
                  } catch (_) {
                    // Fallback — use route navigation
                  }
                }
              },
            ),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Spending chart
            BuyerSpendingChart(data: dashboard.spendingChart),
            const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

            // Recent Orders
            BuyerRecentOrders(
              orders: dashboard.recentOrders,
              onViewAll: () {
                try {
                  final tabCtrl = DefaultTabController.of(context);
                  if (tabCtrl.length > 1) {
                    tabCtrl.animateTo(1);
                  }
                } catch (_) {}
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
