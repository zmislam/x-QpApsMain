import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/custom_cached_image_view.dart';
import '../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../routes/app_pages.dart';
import '../models/store_products_model.dart';
import '../controllers/store_products_controller.dart';
import '../widgets/store_details_main_view_widgets/store_product_image_section.dart';
import '../widgets/store_details_main_view_widgets/store_product_price_section.dart';
import '../widgets/store_details_main_view_widgets/store_product_rating.dart';

class StoreProductsView extends GetView<StoreProductsController> {
  const StoreProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getStoreBaseProduct(storeId: controller.pId.value);
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.storeDetails.value?.name?.capitalizeFirst ?? 'Store',
            style: MarketplaceDesignTokens.heading(context),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
      ),
      body: Obx(() {
        if (controller.storeDetails.value == null) {
          return const Center(child: GroupShimmerLoader());
        }
        final store = controller.storeDetails.value!;
        return CustomScrollView(
          slivers: [
            // ── Store Header ──
            SliverToBoxAdapter(child: _StoreHeader(store: store)),

            // ── Store Policies ──
            if (_hasPolicies(store))
              SliverToBoxAdapter(
                child: _StorePoliciesSection(store: store),
              ),

            // ── Product Count Bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    MarketplaceDesignTokens.cardPadding,
                    MarketplaceDesignTokens.spacingSm,
                    MarketplaceDesignTokens.cardPadding,
                    MarketplaceDesignTokens.spacingSm),
                child: Text(
                  '${store.totalProductCount ?? store.products?.length ?? 0} Products',
                  style: MarketplaceDesignTokens.sectionTitle(context),
                ),
              ),
            ),

            // ── Product Grid ──
            (store.products?.isEmpty ?? true)
                ? SliverFillRemaining(
                    child: Center(
                      child: Text('No products yet',
                          style: MarketplaceDesignTokens.cardSubtext(context)),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MarketplaceDesignTokens.cardPadding),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 290,
                        crossAxisSpacing: MarketplaceDesignTokens.gridSpacing,
                        mainAxisSpacing: MarketplaceDesignTokens.gridSpacing,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = store.products![index];
                          return _ProductCard(
                            product: product,
                            controller: controller,
                          );
                        },
                        childCount: store.products!.length,
                      ),
                    ),
                  ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: MarketplaceDesignTokens.spacingLg),
            ),
          ],
        );
      }),
    );
  }

  bool _hasPolicies(StoreDetailsModel? store) {
    if (store == null) return false;
    return (store.shipping?.isNotEmpty ?? false) ||
        (store.delivery?.isNotEmpty ?? false) ||
        (store.returns?.isNotEmpty ?? false);
  }
}

// ━━━━━━━━━━━━━━━━━━ Store Header ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
class _StoreHeader extends GetView<StoreProductsController> {
  final StoreDetailsModel store;
  const _StoreHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    final imageUrl = store.imagePath != null && store.imagePath!.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/${store.imagePath}'
        : null;

    return Container(
      margin: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Image
          ClipRRect(
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
            child: SizedBox(
              width: 72,
              height: 72,
              child: imageUrl != null
                  ? CustomCachedNetworkImage(imageUrl: imageUrl)
                  : Container(
                      color:
                          MarketplaceDesignTokens.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.storefront,
                          color: MarketplaceDesignTokens.primary, size: 32),
                    ),
            ),
          ),
          const SizedBox(width: MarketplaceDesignTokens.spacingMd),

          // Store Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name?.capitalizeFirst ?? 'Store',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  ),
                ),
                if (store.categoryName?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 2),
                  Text(
                    store.categoryName!,
                    style: TextStyle(
                      fontSize: 13,
                      color: MarketplaceDesignTokens.textSecondary(context),
                    ),
                  ),
                ],
                if (store.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 6),
                  Text(
                    store.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: MarketplaceDesignTokens.bodyTextSmall(context),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Follow Button
                    Obx(() => _FollowButton(
                          isFollowing: controller.isFollowingStore.value,
                          onTap: controller.toggleFollowStore,
                        )),
                    const SizedBox(width: 10),
                    // Reviews Link
                    InkWell(
                      onTap: () => Get.toNamed(Routes.STORE_REVIEWS,
                          arguments: store.id),
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(
                              MarketplaceDesignTokens.radiusSm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_outline,
                                size: 16,
                                color: MarketplaceDesignTokens.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: MarketplaceDesignTokens.textPrimary(
                                    context),
                              ),
                            ),
                          ],
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
    );
  }
}

class _FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onTap;
  const _FollowButton({required this.isFollowing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isFollowing
              ? MarketplaceDesignTokens.primary.withValues(alpha: 0.1)
              : MarketplaceDesignTokens.primary,
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isFollowing
                ? MarketplaceDesignTokens.primary
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━━━ Product Card ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
class _ProductCard extends StatelessWidget {
  final StoreProductsDetails product;
  final StoreProductsController controller;
  const _ProductCard({required this.product, required this.controller});

  @override
  Widget build(BuildContext context) {
    final inStock = (product.totalStock ?? 0) > 0;

    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product.id),
      child: Container(
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(MarketplaceDesignTokens.cardRadius)),
              child: SizedBox(
                height: 130,
                width: double.infinity,
                child: Stack(
                  children: [
                    StoreProductImageSection(
                      controller: controller,
                      storeProductsDetails: product,
                    ),
                    if (!inStock)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: MarketplaceDesignTokens.outOfStock,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Out of Stock',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(
                    MarketplaceDesignTokens.spacingSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      product.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: MarketplaceDesignTokens.productName(context),
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    StoreProductRatingWidget(
                        storeProductsDetails: product),
                    const SizedBox(height: 4),

                    const Spacer(),

                    // Price
                    if (product.productVariants != null &&
                        product.productVariants!.isNotEmpty)
                      StoreProductPriceWidget(
                          storeProductsDetails: product),
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

/// Collapsible section showing store shipping, delivery, & return policies.
class _StorePoliciesSection extends StatelessWidget {
  final StoreDetailsModel store;
  const _StorePoliciesSection({required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          MarketplaceDesignTokens.cardPadding, 0,
          MarketplaceDesignTokens.cardPadding, 4),
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
          side: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
          side: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
        ),
        title: Row(
          children: [
            Icon(Icons.policy_outlined,
                size: 18,
                color: MarketplaceDesignTokens.textSecondary(context)),
            const SizedBox(width: 8),
            Text('Store Policies',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: MarketplaceDesignTokens.textPrimary(context))),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (store.shipping?.isNotEmpty ?? false)
                  _PolicyItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Shipping Policy',
                    text: store.shipping!,
                  ),
                if (store.delivery?.isNotEmpty ?? false)
                  _PolicyItem(
                    icon: Icons.delivery_dining_outlined,
                    title: 'Delivery Policy',
                    text: store.delivery!,
                  ),
                if (store.returns?.isNotEmpty ?? false)
                  _PolicyItem(
                    icon: Icons.assignment_return_outlined,
                    title: 'Return Policy',
                    text: store.returns!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _PolicyItem({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16,
              color: MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            MarketplaceDesignTokens.textPrimary(context))),
                const SizedBox(height: 2),
                Text(text,
                    style: MarketplaceDesignTokens.bodyTextSmall(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
