import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../components/status_badge.dart';
import '../models/seller_dashboard_model.dart';

/// Recent orders list — shows last 5 orders with status and quick actions.
class SellerRecentOrdersCard extends StatelessWidget {
  final List<SellerRecentOrder> orders;

  const SellerRecentOrdersCard({super.key, required this.orders});

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
              Icon(Icons.receipt_long_outlined,
                  size: 18, color: MarketplaceDesignTokens.pricePrimary),
              const SizedBox(width: 6),
              Text(
                'Recent Orders',
                style: MarketplaceDesignTokens.bodyText(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No recent orders',
                  style: MarketplaceDesignTokens.statLabel(context),
                ),
              ),
            )
          else
            ...orders.map((order) => _OrderRow(order: order)),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final SellerRecentOrder order;
  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.invoiceNumber.isNotEmpty
                      ? '#${order.invoiceNumber}'
                      : '#${order.orderId.substring(0, 8)}',
                  style: MarketplaceDesignTokens.bodyTextSmall(context)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  order.buyerName,
                  style: MarketplaceDesignTokens.statLabel(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusBadge(
            status: order.status,
          ),
          const SizedBox(width: 8),
          Text(
            CurrencyHelper.formatPrice(order.amount),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: MarketplaceDesignTokens.pricePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
