import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/custom_cached_image_view.dart';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../utils/currency_helper.dart';
import '../../../../../routes/app_pages.dart';
import '../controllers/marketplace_controller.dart';
import '../models/all_product_model.dart';

/// Horizontal scrollable category chips
class CategoryChipsSection extends StatelessWidget {
  final MarketplaceController controller;

  const CategoryChipsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categoryList;
      if (categories.isEmpty) return const SizedBox.shrink();

      final chips = ['All', ...categories.map((c) => (c is Map ? c['name'] ?? '' : c.toString()).toString()).where((n) => n.isNotEmpty)];

      return SizedBox(
        height: MarketplaceDesignTokens.chipHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final label = chips[index];
            return Obx(() {
              final isSelected = controller.selectedChip.value == label;
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                selectedColor: MarketplaceDesignTokens.pricePrimary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : MarketplaceDesignTokens.textPrimary(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                backgroundColor: MarketplaceDesignTokens.cardBg(context),
                side: BorderSide(color: MarketplaceDesignTokens.cardBorder(context)),
                onSelected: (_) {
                  controller.selectedChip.value = label;
                  if (label == 'All') {
                    controller.categoryName.value = '';
                  } else {
                    controller.categoryName.value = label;
                  }
                  controller.getMarketPlaceProduct(categoryOnly: label != 'All');
                },
              );
            });
          },
        ),
      );
    });
  }
}

/// Section header with title and optional "See All" button
class SectionHeader extends StatelessWidget {
  final String title;
  final String? icon;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${icon ?? ''} $title'.trim(),
            style: MarketplaceDesignTokens.sectionTitle(context),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All'.tr,
                style: TextStyle(
                  color: MarketplaceDesignTokens.pricePrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Horizontal product carousel (used for New For You, Flash Deals)
class ProductCarouselSection extends StatelessWidget {
  final String title;
  final String? icon;
  final List<AllProducts> products;
  final MarketplaceController controller;

  const ProductCarouselSection({
    super.key,
    required this.title,
    this.icon,
    required this.products,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, icon: icon),
        SizedBox(
          height: MarketplaceDesignTokens.carouselHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: MarketplaceDesignTokens.gridSpacing),
            itemBuilder: (context, index) {
              final product = products[index];
              return _CarouselProductCard(product: product, controller: controller);
            },
          ),
        ),
      ],
    );
  }
}

class _CarouselProductCard extends StatelessWidget {
  final AllProducts product;
  final MarketplaceController controller;

  const _CarouselProductCard({required this.product, required this.controller});

  @override
  Widget build(BuildContext context) {
    final sellPrice = product.productVariant?.first.sellPrice;
    final mainPrice = product.productVariant?.first.mainPrice;
    final hasDiscount = mainPrice != null && sellPrice != null && mainPrice > sellPrice;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product.id),
      child: Container(
        width: 150,
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MarketplaceDesignTokens.cardRadius),
                topRight: Radius.circular(MarketplaceDesignTokens.cardRadius),
              ),
              child: CustomCachedNetworkImage(
                height: 120,
                width: 150,
                fit: BoxFit.contain,
                imageUrl: '${ApiConstant.SERVER_IP_PORT}/uploads/product/${product.media?.first}',
                errorWidget: Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.cover),
                placeholderImage: AppAssets.DEFAULT_IMAGE,
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    if (sellPrice != null)
                      Row(
                        children: [
                          Text(
                            CurrencyHelper.formatPrice(sellPrice),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: MarketplaceDesignTokens.pricePrimary,
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 4),
                            Text(
                              CurrencyHelper.formatPrice(mainPrice),
                              style: const TextStyle(
                                fontSize: 10,
                                color: MarketplaceDesignTokens.priceOriginal,
                                decoration: TextDecoration.lineThrough,
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

/// Featured stores horizontal carousel
class FeaturedStoresSection extends StatelessWidget {
  final List<dynamic> stores;

  const FeaturedStoresSection({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Featured Stores', icon: '🏬'),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: stores.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final store = stores[index];
              final name = store is Map ? store['name'] ?? '' : '';
              final image = store is Map ? store['image_path'] ?? '' : '';

              return Container(
                width: 80,
                decoration: MarketplaceDesignTokens.cardDecoration(context),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: image.isNotEmpty
                          ? CustomCachedNetworkImage(
                              imageUrl: '${ApiConstant.SERVER_IP_PORT}/uploads/store/$image',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorWidget: CircleAvatar(
                                radius: 28,
                                backgroundColor: MarketplaceDesignTokens.cardBorder(context),
                                child: const Icon(Icons.store, size: 24),
                              ),
                              placeholderImage: AppAssets.DEFAULT_IMAGE,
                            )
                          : CircleAvatar(
                              radius: 28,
                              backgroundColor: MarketplaceDesignTokens.cardBorder(context),
                              child: const Icon(Icons.store, size: 24),
                            ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        name.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
                            color: MarketplaceDesignTokens.textPrimary(context)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Sponsored products carousel with "Sponsored" badge and beacon tracking.
class SponsoredCarouselSection extends StatelessWidget {
  final List<AllProducts> products;
  final MarketplaceController controller;

  const SponsoredCarouselSection({
    super.key,
    required this.products,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Sponsored', icon: '🏷️'),
        SizedBox(
          height: MarketplaceDesignTokens.carouselHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: MarketplaceDesignTokens.gridSpacing),
            itemBuilder: (context, index) {
              final product = products[index];
              // Fire impression beacon when card is built (visible)
              controller.trackImpression(product);
              return _SponsoredCard(
                  product: product, controller: controller);
            },
          ),
        ),
      ],
    );
  }
}

class _SponsoredCard extends StatelessWidget {
  final AllProducts product;
  final MarketplaceController controller;

  const _SponsoredCard({required this.product, required this.controller});

  @override
  Widget build(BuildContext context) {
    final sellPrice = product.productVariant?.first.sellPrice;
    final mainPrice = product.productVariant?.first.mainPrice;
    final hasDiscount =
        mainPrice != null && sellPrice != null && mainPrice > sellPrice;

    return GestureDetector(
      onTap: () {
        controller.trackClick(product);
        Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product.id);
      },
      child: Container(
        width: 150,
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with "Sponsored" badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(MarketplaceDesignTokens.cardRadius),
                    topRight:
                        Radius.circular(MarketplaceDesignTokens.cardRadius),
                  ),
                  child: CustomCachedNetworkImage(
                    height: 120,
                    width: 150,
                    fit: BoxFit.contain,
                    imageUrl:
                        '${ApiConstant.SERVER_IP_PORT}/uploads/product/${product.media?.first}',
                    errorWidget:
                        Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.cover),
                    placeholderImage: AppAssets.DEFAULT_IMAGE,
                  ),
                ),
                // Sponsored badge
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: MarketplaceDesignTokens.sellerBadge,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.promotionBadge ?? 'Sponsored',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    if (sellPrice != null)
                      Row(
                        children: [
                          Text(
                            '\$${(sellPrice / 100).toStringAsFixed(2)}',
                            style: MarketplaceDesignTokens.productPrice
                                .copyWith(fontSize: 13),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 4),
                            Text(
                              '\$${(mainPrice / 100).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: MarketplaceDesignTokens.priceOriginal,
                                decoration: TextDecoration.lineThrough,
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

// ─── Recently Visited Section ──────────────────────────────────────────────

class RecentlyVisitedSection extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final MarketplaceController controller;

  const RecentlyVisitedSection({
    super.key,
    required this.items,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Recently Visited', icon: '🕐'),
        SizedBox(
          height: MarketplaceDesignTokens.carouselHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: MarketplaceDesignTokens.gridSpacing),
            itemBuilder: (context, index) {
              final item = items[index];
              return _RecentlyVisitedCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _RecentlyVisitedCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _RecentlyVisitedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final price = item['price'];
    final priceDisplay = price != null
        ? '\$${(price / 100).toStringAsFixed(2)}'
        : '';

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.PRODUCT_DETAILS, arguments: item['id']);
      },
      child: Container(
        width: 150,
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(MarketplaceDesignTokens.cardRadius),
                topRight: Radius.circular(MarketplaceDesignTokens.cardRadius),
              ),
              child: CustomCachedNetworkImage(
                height: 120,
                width: 150,
                fit: BoxFit.contain,
                imageUrl:
                    '${ApiConstant.SERVER_IP_PORT}/uploads/product/${item['image'] ?? ''}',
                errorWidget:
                    Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.cover),
                placeholderImage: AppAssets.DEFAULT_IMAGE,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    if (priceDisplay.isNotEmpty)
                      Text(
                        priceDisplay,
                        style: MarketplaceDesignTokens.productPrice
                            .copyWith(fontSize: 13),
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
