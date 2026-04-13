import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/custom_cached_image_view.dart';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../utils/currency_helper.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../routes/app_pages.dart';
import '../models/wishlist_model.dart';

class WishlistItemTile extends StatelessWidget {
  final WishlistItem wishedProductItem;
  final VoidCallback onDelete;
  final VoidCallback onAddToCart;

  const WishlistItemTile({
    super.key,
    required this.wishedProductItem,
    required this.onDelete,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final product = wishedProductItem.product;
    final variant = wishedProductItem.productVariant;
    final store = wishedProductItem.store;
    final inStock = variant?.stockStatus == 'In Stock';
    final alreadyInCart = wishedProductItem.isInCart == true;

    final imageUrl = (product?.media?.isNotEmpty ?? false)
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/products/${product!.media!.first}'
        : null;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: () => Get.toNamed(Routes.PRODUCT_DETAILS,
            arguments: product?.id ?? ''),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        child: Padding(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Product Image ──
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusSm),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: imageUrl != null
                      ? CustomCachedNetworkImage(imageUrl: imageUrl)
                      : Container(
                          color: MarketplaceDesignTokens.primary
                              .withOpacity(0.1),
                          child: const Icon(Icons.image_outlined,
                              color: MarketplaceDesignTokens.primary,
                              size: 32),
                        ),
                ),
              ),
              const SizedBox(width: MarketplaceDesignTokens.spacingMd),

              // ── Product Info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product?.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: MarketplaceDesignTokens.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Store Name
                    if (store?.name != null)
                      Text(
                        store!.name!,
                        style: TextStyle(
                          fontSize: 13,
                          color: MarketplaceDesignTokens.textSecondary(
                              context),
                        ),
                      ),
                    const SizedBox(height: 6),

                    // Price + Stock Row
                    Row(
                      children: [
                        Text(
                          CurrencyHelper.formatPrice(variant?.sellPrice),
                          style: MarketplaceDesignTokens.productPrice,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: inStock
                                ? MarketplaceDesignTokens.primary
                                    .withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            variant?.stockStatus ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: inStock
                                  ? MarketplaceDesignTokens.primary
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Date + Actions
                    Row(
                      children: [
                        Text(
                          'Saved ${(wishedProductItem.createdAt ?? '').toFormatDateOfBirth()}',
                          style: TextStyle(
                            fontSize: 11,
                            color: MarketplaceDesignTokens.textSecondary(
                                context),
                          ),
                        ),
                        const Spacer(),
                        // Delete
                        _ActionButton(
                          icon: Icons.delete_outline,
                          color: Colors.red,
                          onTap: onDelete,
                        ),
                        const SizedBox(width: 8),
                        // Add to cart
                        if (inStock && !alreadyInCart)
                          _ActionButton(
                            icon: Icons.add_shopping_cart,
                            color: MarketplaceDesignTokens.primary,
                            onTap: onAddToCart,
                          )
                        else if (alreadyInCart)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'In Cart',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color:
                                    MarketplaceDesignTokens.textSecondary(
                                        context),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: icon == Icons.delete_outline
          ? 'Remove from wishlist'
          : 'Add to cart',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
