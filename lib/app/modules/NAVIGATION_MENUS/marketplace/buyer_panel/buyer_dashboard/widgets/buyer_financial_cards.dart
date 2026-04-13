import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../models/buyer_dashboard_model.dart';

/// Financial overview cards: Total Spent, In Escrow, Refunds.
class BuyerFinancialCards extends StatelessWidget {
  final DashboardMetrics metrics;

  const BuyerFinancialCards({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        children: [
          _FinancialItem(
            label: 'Total Spent',
            value: CurrencyHelper.formatPrice(metrics.totalSpent),
            color: MarketplaceDesignTokens.pricePrimary,
          ),
          _divider(context),
          _FinancialItem(
            label: 'In Escrow',
            value: CurrencyHelper.formatPrice(metrics.inEscrow),
            color: MarketplaceDesignTokens.orderPending,
          ),
          _divider(context),
          _FinancialItem(
            label: 'Refunds',
            value: CurrencyHelper.formatPrice(metrics.refundAmount),
            color: MarketplaceDesignTokens.orderRefund,
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: MarketplaceDesignTokens.divider(context),
    );
  }
}

class _FinancialItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _FinancialItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: MarketplaceDesignTokens.cardSubtext(context),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
