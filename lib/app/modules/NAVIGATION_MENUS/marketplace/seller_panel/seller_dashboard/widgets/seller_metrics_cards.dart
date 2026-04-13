import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../models/seller_dashboard_model.dart';

/// 2x2 grid of metric cards: Sales, Orders, Products, Rating
class SellerMetricsCards extends StatelessWidget {
  final SellerMetrics metrics;
  final SellerListings listings;
  final double sellerRating;

  const SellerMetricsCards({
    super.key,
    required this.metrics,
    required this.listings,
    required this.sellerRating,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.8,
      mainAxisSpacing: MarketplaceDesignTokens.gridSpacing,
      crossAxisSpacing: MarketplaceDesignTokens.gridSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _MetricTile(
          icon: Icons.attach_money,
          value: CurrencyHelper.formatPrice(metrics.totalRevenue),
          label: 'Sales',
          change: metrics.revenueChange,
          color: MarketplaceDesignTokens.inStock,
        ),
        _MetricTile(
          icon: Icons.shopping_bag_outlined,
          value: '${metrics.totalOrders}',
          label: 'Orders',
          change: metrics.ordersChange,
          color: MarketplaceDesignTokens.orderProcessing,
        ),
        _MetricTile(
          icon: Icons.inventory_2_outlined,
          value: '${listings.total}',
          label: 'Products',
          color: MarketplaceDesignTokens.pricePrimary,
        ),
        _MetricTile(
          icon: Icons.star_rounded,
          value: sellerRating.toStringAsFixed(1),
          label: 'Rating',
          color: MarketplaceDesignTokens.ratingStarFill,
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final double? change;
  final Color color;

  const _MetricTile({
    required this.icon,
    required this.value,
    required this.label,
    this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              if (change != null) ...[
                const Spacer(),
                _ChangeIndicator(change: change!),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: MarketplaceDesignTokens.textPrimary(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: MarketplaceDesignTokens.statLabel(context),
          ),
        ],
      ),
    );
  }
}

class _ChangeIndicator extends StatelessWidget {
  final double change;
  const _ChangeIndicator({required this.change});

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 12,
          color: isPositive
              ? MarketplaceDesignTokens.inStock
              : MarketplaceDesignTokens.outOfStock,
        ),
        Text(
          '${change.abs().toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isPositive
                ? MarketplaceDesignTokens.inStock
                : MarketplaceDesignTokens.outOfStock,
          ),
        ),
      ],
    );
  }
}
