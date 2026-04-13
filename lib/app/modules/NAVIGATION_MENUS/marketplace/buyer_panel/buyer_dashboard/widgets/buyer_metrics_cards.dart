import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../models/buyer_dashboard_model.dart';

/// 4 metric cards in a 2x2 grid: Orders, Pending, Delivered, Returns.
/// Plan section 6.7 wireframe.
class BuyerMetricsCards extends StatelessWidget {
  final DashboardMetrics metrics;
  final Function(String filter)? onTapMetric;

  const BuyerMetricsCards({
    super.key,
    required this.metrics,
    this.onTapMetric,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        _MetricTile(
          icon: Icons.shopping_bag_outlined,
          value: '${metrics.totalOrders}',
          label: 'Orders',
          color: MarketplaceDesignTokens.pricePrimary,
          onTap: () => onTapMetric?.call(''),
        ),
        _MetricTile(
          icon: Icons.hourglass_top_rounded,
          value: '${metrics.pending}',
          label: 'Pending',
          color: MarketplaceDesignTokens.orderPending,
          onTap: () => onTapMetric?.call('pending'),
        ),
        _MetricTile(
          icon: Icons.check_circle_outline,
          value: '${metrics.delivered}',
          label: 'Delivered',
          color: MarketplaceDesignTokens.orderDelivered,
          onTap: () => onTapMetric?.call('delivered'),
        ),
        _MetricTile(
          icon: Icons.replay_rounded,
          value: '${metrics.refunded}',
          label: 'Returns',
          color: MarketplaceDesignTokens.orderRefund,
          onTap: () => onTapMetric?.call('refund'),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _MetricTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: MarketplaceDesignTokens.statValue(context)
                      .copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: MarketplaceDesignTokens.statLabel(context),
            ),
          ],
        ),
      ),
    );
  }
}
