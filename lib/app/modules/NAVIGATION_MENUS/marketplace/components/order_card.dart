import 'package:flutter/material.dart';
import '../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../utils/currency_helper.dart';
import '../../../../components/custom_cached_image_view.dart';
import 'status_badge.dart';

/// A compact order card for order lists.
/// Shows first product image, invoice number, store, status, amount, date.
class OrderCard extends StatelessWidget {
  final String? invoiceNumber;
  final String? storeName;
  final String? status;
  final double? totalAmount;
  final int? itemCount;
  final String? firstProductImage;
  final String? createdAt;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    this.invoiceNumber,
    this.storeName,
    this.status,
    this.totalAmount,
    this.itemCount,
    this.firstProductImage,
    this.createdAt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Row(
          children: [
            // Product thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: MarketplaceDesignTokens.thumbnailSize,
                height: MarketplaceDesignTokens.thumbnailSize,
                child: firstProductImage != null && firstProductImage!.isNotEmpty
                    ? CustomCachedNetworkImage(imageUrl: firstProductImage!)
                    : Container(
                        color: MarketplaceDesignTokens.cardBorder(context),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: MarketplaceDesignTokens.textSecondary(context),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Order info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          invoiceNumber ?? 'Order',
                          style: MarketplaceDesignTokens.productName(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (status != null) StatusBadge(status: status!),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (storeName != null)
                    Text(
                      storeName!,
                      style: MarketplaceDesignTokens.cardSubtext(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        CurrencyHelper.formatPrice(totalAmount ?? 0),
                        style: MarketplaceDesignTokens.productPrice,
                      ),
                      if (itemCount != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '$itemCount item${itemCount != 1 ? 's' : ''}',
                          style: MarketplaceDesignTokens.cardSubtext(context),
                        ),
                      ],
                      const Spacer(),
                      if (createdAt != null)
                        Text(
                          _formatDate(createdAt!),
                          style: MarketplaceDesignTokens.cardSubtext(context),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: MarketplaceDesignTokens.textSecondary(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays == 0) return 'Today';
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
