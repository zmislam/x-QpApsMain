import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../../../../components/custom_cached_image_view.dart';
import '../models/buyer_order_detail_model.dart';

/// List of order items with product image, name, variant, price, quantity.
class OrderItemsList extends StatelessWidget {
  final List<StoreListItem> items;
  final Function(StoreListItem item)? onReviewTap;

  const OrderItemsList({
    super.key,
    required this.items,
    this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items (${items.length})',
          style: MarketplaceDesignTokens.sectionTitle(context),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _OrderItemTile(
              item: item,
              onReviewTap: onReviewTap != null ? () => onReviewTap!(item) : null,
            )),
      ],
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final StoreListItem item;
  final VoidCallback? onReviewTap;

  const _OrderItemTile({required this.item, this.onReviewTap});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final variant = item.variant;
    final imageUrl = (product?.media.isNotEmpty ?? false)
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/products/${product!.media.first}'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: MarketplaceDesignTokens.thumbnailSize,
              height: MarketplaceDesignTokens.thumbnailSize,
              child: imageUrl != null
                  ? CustomCachedNetworkImage(imageUrl: imageUrl)
                  : Container(
                      color: MarketplaceDesignTokens.cardBorder(context),
                      child: Icon(
                        Icons.image_outlined,
                        color:
                            MarketplaceDesignTokens.textSecondary(context),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.productName ?? 'Product',
                  style: MarketplaceDesignTokens.productName(context),
                  maxLines: 2,
                ),
                if (variant != null && variant.displayText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    variant.displayText,
                    style: MarketplaceDesignTokens.cardSubtext(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      CurrencyHelper.formatPrice(item.sellPrice),
                      style: MarketplaceDesignTokens.productPrice,
                    ),
                    if (item.sellMainPrice > item.sellPrice) ...[
                      const SizedBox(width: 6),
                      Text(
                        CurrencyHelper.formatPrice(item.sellMainPrice),
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: MarketplaceDesignTokens.priceOriginal,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      'x${item.quantity}',
                      style: MarketplaceDesignTokens.bodyText(context),
                    ),
                  ],
                ),
                if (onReviewTap != null && !item.hasReview) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onReviewTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: MarketplaceDesignTokens.pricePrimary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '⭐ Write Review',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: MarketplaceDesignTokens.pricePrimary,
                        ),
                      ),
                    ),
                  ),
                ],
                if (item.hasReview) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: MarketplaceDesignTokens.inStock,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Reviewed',
                        style: TextStyle(
                          fontSize: 12,
                          color: MarketplaceDesignTokens.inStock,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
