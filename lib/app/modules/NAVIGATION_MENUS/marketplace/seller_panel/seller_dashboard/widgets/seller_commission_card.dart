import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../models/seller_dashboard_model.dart';

/// Commission & payout summary card.
class SellerCommissionCard extends StatelessWidget {
  final SellerCommission commission;

  const SellerCommissionCard({super.key, required this.commission});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 18, color: MarketplaceDesignTokens.pricePrimary),
              const SizedBox(width: 6),
              Text(
                'Commission & Payouts',
                style: MarketplaceDesignTokens.bodyText(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Commission Rate',
                  value: '${(commission.rate * 100).toStringAsFixed(1)}%',
                  context: context,
                ),
              ),
              Expanded(
                child: _InfoTile(
                  label: 'This Month',
                  value: CurrencyHelper.formatPrice(commission.thisMonthTotal),
                  context: context,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Pending Payout',
                  value: CurrencyHelper.formatPrice(commission.pendingPayout),
                  context: context,
                  valueColor: MarketplaceDesignTokens.pricePrimary,
                ),
              ),
              if (commission.nextPayoutDate != null)
                Expanded(
                  child: _InfoTile(
                    label: 'Next Payout',
                    value: _formatDate(commission.nextPayoutDate!),
                    context: context,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return isoDate;
    }
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;
  final Color? valueColor;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.context,
    this.valueColor,
  });

  @override
  Widget build(BuildContext _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: MarketplaceDesignTokens.statLabel(context),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor ??
                MarketplaceDesignTokens.textPrimary(context),
          ),
        ),
      ],
    );
  }
}
