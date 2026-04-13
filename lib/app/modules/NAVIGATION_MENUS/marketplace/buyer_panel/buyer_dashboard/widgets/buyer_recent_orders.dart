import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../components/status_badge.dart';
import '../models/buyer_dashboard_model.dart';

/// Recent orders list per plan section 6.7.
class BuyerRecentOrders extends StatelessWidget {
  final List<RecentOrder> orders;
  final VoidCallback? onViewAll;

  const BuyerRecentOrders({
    super.key,
    required this.orders,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: MarketplaceDesignTokens.sectionTitle(context),
            ),
            if (onViewAll != null)
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MarketplaceDesignTokens.pricePrimary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...orders
            .take(5)
            .map((order) => _RecentOrderTile(order: order)),
      ],
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  final RecentOrder order;

  const _RecentOrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (order.id.isNotEmpty && order.storeId != null) {
          Get.toNamed(Routes.MARKETPLACE_ORDER_DETAIL, arguments: {
            'order_id': order.id,
            'store_id': order.storeId,
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.invoiceNumber ?? 'Order #${order.id.substring(order.id.length - 6)}',
                          style: MarketplaceDesignTokens.productName(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StatusBadge(status: order.status ?? 'pending'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${CurrencyHelper.formatPrice(order.totalAmount)}  •  ${order.itemCount} item${order.itemCount != 1 ? 's' : ''}',
                    style: MarketplaceDesignTokens.cardSubtext(context),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: MarketplaceDesignTokens.textSecondary(context),
            ),
          ],
        ),
      ),
    );
  }
}
