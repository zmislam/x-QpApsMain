import 'package:flutter/material.dart';
import '../../../../config/constants/marketplace_design_tokens.dart';

/// A stat/metric card for dashboards.
/// Displays an icon, value, and label in a compact card.
///
/// Design per plan section 6.7:
/// ┌──────┐
/// │  12  │
/// │Orders│
/// └──────┘
class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor ?? MarketplaceDesignTokens.pricePrimary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: MarketplaceDesignTokens.statValue(context),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: MarketplaceDesignTokens.statLabel(context),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
