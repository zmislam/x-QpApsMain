import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../controllers/product_details_controller.dart';

class ProductHeaderSection extends GetView<ProductDetailsController> {
  const ProductHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final p = controller.product.value;
      if (p == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: MarketplaceDesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Badges Row ─────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (controller.isInStock)
                  _badge('IN STOCK', MarketplaceDesignTokens.inStock)
                else
                  _badge('OUT OF STOCK', MarketplaceDesignTokens.outOfStock),
                if (p.productCondition != null &&
                    p.productCondition!.isNotEmpty)
                  _badge(p.productCondition!.toUpperCase(),
                      MarketplaceDesignTokens.sellerBadge),
                if (p.trustedSeller?.id != null)
                  _badge('TRUSTED SELLER', MarketplaceDesignTokens.buyerBadge),
              ],
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingSm),

            // ─── Product Name ───────────────────────
            Text(
              p.productName ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MarketplaceDesignTokens.textPrimary(context),
              ),
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingSm),

            // ─── Price Section ──────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyHelper.formatPrice(controller.currentPrice.value),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: MarketplaceDesignTokens.pricePrimary,
                  ),
                ),
                if (controller.hasDiscount) ...[
                  const SizedBox(width: 10),
                  Text(
                    CurrencyHelper.formatPrice(controller.originalPrice.value),
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2,
                      color: MarketplaceDesignTokens.priceOriginal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: MarketplaceDesignTokens.priceDiscount
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${controller.discountPercent}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MarketplaceDesignTokens.priceDiscount,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // ─── VAT Info ───────────────────────────
            if (p.vat != null && p.vat! > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${'Price including'.tr} ${p.vat}% ${'VAT:'.tr} ${CurrencyHelper.formatPrice(controller.vatInclusivePrice)}',
                style: TextStyle(
                  fontSize: 13,
                  color: MarketplaceDesignTokens.textSecondary(context),
                ),
              ),
            ],

            // ─── Stock + Sold Info ──────────────────
            const SizedBox(height: 4),
            Row(
              children: [
                if (controller.stock.value > 0 &&
                    controller.stock.value <= 5)
                  Text(
                    'Only ${controller.stock.value} left!',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: MarketplaceDesignTokens.lowStock,
                    ),
                  ),
                if (p.sold != null && p.sold! > 0) ...[
                  if (controller.stock.value > 0 &&
                      controller.stock.value <= 5)
                    const SizedBox(width: 12),
                  Text(
                    '${p.sold} sold',
                    style: TextStyle(
                      fontSize: 13,
                      color: MarketplaceDesignTokens.textSecondary(context),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
