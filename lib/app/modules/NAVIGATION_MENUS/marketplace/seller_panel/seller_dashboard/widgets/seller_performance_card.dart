import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';

/// Performance score card with progress bar and tier.
class SellerPerformanceCard extends StatelessWidget {
  final double conversionRate;
  final int totalViews;

  const SellerPerformanceCard({
    super.key,
    required this.conversionRate,
    required this.totalViews,
  });

  String get _tier {
    if (conversionRate >= 4) return 'Gold';
    if (conversionRate >= 2) return 'Silver';
    return 'Bronze';
  }

  IconData get _tierIcon {
    if (conversionRate >= 4) return Icons.workspace_premium;
    if (conversionRate >= 2) return Icons.military_tech;
    return Icons.stars;
  }

  Color get _tierColor {
    if (conversionRate >= 4) return const Color(0xFFFFD700);
    if (conversionRate >= 2) return const Color(0xFFC0C0C0);
    return const Color(0xFFCD7F32);
  }

  @override
  Widget build(BuildContext context) {
    // Normalize conversion rate to 0-100 for the progress bar (cap at 10%)
    final normalized = (conversionRate / 10.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights,
                  size: 18, color: MarketplaceDesignTokens.pricePrimary),
              const SizedBox(width: 6),
              Text(
                'Performance',
                style: MarketplaceDesignTokens.bodyText(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Icon(_tierIcon, size: 20, color: _tierColor),
              const SizedBox(width: 4),
              Text(
                _tier,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _tierColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${conversionRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    ),
                  ),
                  Text(
                    'Conversion Rate',
                    style: MarketplaceDesignTokens.statLabel(context),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalViews',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    ),
                  ),
                  Text(
                    'Total Views',
                    style: MarketplaceDesignTokens.statLabel(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            child: LinearProgressIndicator(
              value: normalized,
              minHeight: 6,
              backgroundColor:
                  MarketplaceDesignTokens.pricePrimary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(
                  MarketplaceDesignTokens.pricePrimary),
            ),
          ),
        ],
      ),
    );
  }
}
