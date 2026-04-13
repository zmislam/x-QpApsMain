import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../../components/custom_cached_image_view.dart';
import '../../../../../components/button.dart';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../utils/currency_helper.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../config/constants/color.dart';
import '../../components/wishlist_icon_button.dart';
import '../controllers/marketplace_controller.dart';
import '../models/all_product_model.dart';

class ProductGridItem extends StatelessWidget {
  final AllProducts productItem;
  final void Function() onPressedAddToCart;
  final void Function() onPressedAddToWishList;
  final bool isWishListed;
  const ProductGridItem({
    super.key,
    required this.productItem,
    required this.onPressedAddToCart,
    required this.isWishListed,
    required this.onPressedAddToWishList,
  });

  MarketplaceController get _mc => Get.find<MarketplaceController>();

  @override
  Widget build(BuildContext context) {
    final mainPrice = productItem.productVariant?.first.mainPrice;
    final sellPrice = productItem.productVariant?.first.sellPrice;
    final hasDiscount = mainPrice != null && sellPrice != null && mainPrice > sellPrice;
    final discountPercent = hasDiscount ? ((mainPrice - sellPrice) / mainPrice * 100).round() : 0;

    return Semantics(
      button: true,
      label: '${productItem.productName ?? 'Product'}, '
          '${sellPrice != null ? CurrencyHelper.formatPrice(sellPrice) : ''}, '
          '${(productItem.totalStock ?? 0) == 0 ? 'Out of stock' : 'In stock'}',
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.PRODUCT_DETAILS, arguments: productItem.id);
        },
        child: Container(
          decoration: MarketplaceDesignTokens.cardDecoration(context),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Product Image with badges ───────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(MarketplaceDesignTokens.cardRadius),
                    topLeft: Radius.circular(MarketplaceDesignTokens.cardRadius),
                  ),
                  child: CustomCachedNetworkImage(
                    height: MarketplaceDesignTokens.productImageH,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    imageUrl:
                        '${ApiConstant.SERVER_IP_PORT}/uploads/product/${productItem.media?.first}',
                    errorWidget: Image.asset(
                      AppAssets.DEFAULT_IMAGE,
                      fit: BoxFit.cover,
                    ),
                    placeholderImage: AppAssets.DEFAULT_IMAGE,
                  ),
                ),
                // Discount badge
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: MarketplaceDesignTokens.priceDiscount,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Stock badge
                if (productItem.totalStock == 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: MarketplaceDesignTokens.outOfStock,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Out of Stock'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Wishlist icon
                Positioned(
                  top: 4,
                  right: 4,
                  child: Obx(() {
                    final isTogglingThis = _mc.isTogglingWishlist.value &&
                        _mc.togglingWishlistProductId.value == productItem.id;
                    if (isTogglingThis) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: PRIMARY_COLOR, width: 1),
                          borderRadius: BorderRadius.circular(20),
                          color: PRIMARY_COLOR_LIGHT,
                        ),
                        child: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: PRIMARY_COLOR),
                        ),
                      );
                    }
                    return WishlistIconButton(
                      isWishListed: isWishListed,
                      onPressed: onPressedAddToWishList,
                    );
                  }),
                ),
              ],
            ),

            // ─── Product Info ────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store name
                    if (productItem.store?.name != null)
                      Text(
                        productItem.store!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MarketplaceDesignTokens.cardSubtext(context),
                      ),

                    const SizedBox(height: 4),

                    // Product name
                    Text(
                      productItem.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: MarketplaceDesignTokens.productName(context),
                    ),

                    const SizedBox(height: 6),

                    // Rating
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: productItem.productReview?.rating ?? 0.0,
                          ignoreGestures: true,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 12,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: MarketplaceDesignTokens.ratingStarFill,
                          ),
                          onRatingUpdate: (_) {},
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${productItem.productReview?.totalReview ?? 0})',
                          style: TextStyle(
                            fontSize: 11,
                            color: MarketplaceDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price row
                    if (productItem.productVariant?.isNotEmpty ?? false)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            CurrencyHelper.formatPrice(sellPrice),
                            style: MarketplaceDesignTokens.productPrice,
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 6),
                            Text(
                              CurrencyHelper.formatPrice(mainPrice),
                              style: TextStyle(
                                fontSize: 12,
                                color: MarketplaceDesignTokens.priceOriginal,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: MarketplaceDesignTokens.priceOriginal,
                              ),
                            ),
                          ],
                        ],
                      ),

                    const SizedBox(height: 8),

                    // Add to Cart button
                    SizedBox(
                      width: double.infinity,
                      child: (productItem.totalStock != 0)
                          ? Obx(() {
                              final isLoading = _mc.isAddingToCart.value &&
                                  _mc.addingToCartProductId.value == productItem.id;
                              return PrimaryIconButton(
                                backgroundColor: PRIMARY_COLOR,
                                text: isLoading ? '' : 'Add to Cart'.tr,
                                horizontalPadding: 10,
                                verticalPadding: 8,
                                onPressed: isLoading ? () {} : onPressedAddToCart,
                                textColor: Colors.white,
                                iconWidget: isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Image(
                                        height: 18,
                                        color: Colors.white,
                                        image: AssetImage(AppAssets.CART_NAVBAR_ICON),
                                      ),
                              );
                            })
                          : TextButton(
                              onPressed: null,
                              style: TextButton.styleFrom(
                                backgroundColor: MarketplaceDesignTokens.outOfStock.withValues(alpha: 0.1),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Out of Stock'.tr,
                                style: TextStyle(
                                  color: MarketplaceDesignTokens.outOfStock,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
