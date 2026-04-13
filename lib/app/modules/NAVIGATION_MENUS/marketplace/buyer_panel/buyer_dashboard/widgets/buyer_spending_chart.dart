import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../models/buyer_dashboard_model.dart';

/// Spending bar chart per plan section 6.7 (last 6 months).
class BuyerSpendingChart extends StatelessWidget {
  final List<SpendingMonth> data;

  const BuyerSpendingChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxAmount =
        data.fold<double>(0, (max, e) => e.amount > max ? e.amount : max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spending Overview',
          style: MarketplaceDesignTokens.sectionTitle(context),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          decoration: MarketplaceDesignTokens.cardDecoration(context),
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((month) {
              final barHeight = maxAmount > 0
                  ? (month.amount / maxAmount) * 120
                  : 0.0;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyHelper.formatPrice(month.amount),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: MarketplaceDesignTokens.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: barHeight.clamp(4.0, 120.0),
                        decoration: BoxDecoration(
                          color: MarketplaceDesignTokens.pricePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        month.month,
                        style: MarketplaceDesignTokens.cardSubtext(context)
                            .copyWith(fontSize: 10),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
