import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../components/custom_cached_image_view.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../controllers/product_details_controller.dart';
import '../../models/related_product_model.dart';

class RelatedProductsSection extends GetView<ProductDetailsController> {
  const RelatedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRelatedProduct.value) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final products = controller.relatedProductList.value;
      if (products.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MarketplaceDesignTokens.spacingMd),
            child: Text(
              'Related Products'.tr,
              style: MarketplaceDesignTokens.sectionTitle(context),
            ),
          ),
          const SizedBox(height: MarketplaceDesignTokens.spacingSm),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.spacingMd),
              itemCount: products.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: MarketplaceDesignTokens.gridSpacing),
              itemBuilder: (context, index) =>
                  _RelatedProductCard(product: products[index]),
            ),
          ),
        ],
      );
    });
  }
}

class _RelatedProductCard extends GetView<ProductDetailsController> {
  final AllRelatedProducts product;
  const _RelatedProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.navigateToProduct(product.id ?? ''),
      child: Container(
        width: 165,
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Image ─────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(MarketplaceDesignTokens.cardRadius)),
              child: CustomCachedNetworkImage(
                imageUrl: product.media != null && product.media!.isNotEmpty
                    ? product.media!.first.formatedProductUrlLive
                    : '',
                height: 130,
                width: 165,
                fit: BoxFit.contain,
                errorWidget: Image.asset(
                  AppAssets.DEFAULT_IMAGE,
                  height: 130,
                  width: 165,
                  fit: BoxFit.cover,
                ),
                placeholderImage: AppAssets.DEFAULT_IMAGE,
              ),
            ),

            // ─── Details ───────────────────────
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.all(MarketplaceDesignTokens.spacingSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: MarketplaceDesignTokens.productName(context),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating:
                              product.productReview?.rating ?? 0.0,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: 12,
                          itemBuilder: (_, __) => const Icon(
                              Icons.star_rounded,
                              color: MarketplaceDesignTokens.ratingStarFill),
                          onRatingUpdate: (_) {},
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.productReview?.totalReview ?? 0})',
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                MarketplaceDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (product.productVariant != null &&
                        product.productVariant!.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            CurrencyHelper.formatPrice(product.productVariant!.first.sellPrice),
                            style: MarketplaceDesignTokens.productPrice,
                          ),
                          if (product.productVariant!.first.mainPrice !=
                                  null &&
                              product.productVariant!.first.mainPrice! >
                                  (product.productVariant!.first.sellPrice ??
                                      0)) ...[
                            const SizedBox(width: 6),
                            Text(
                              CurrencyHelper.formatPrice(product.productVariant!.first.mainPrice),
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color:
                                    MarketplaceDesignTokens.priceOriginal,
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
