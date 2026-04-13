import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/shimmer_loaders/marketplace_list_shimmer_loader.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../routes/app_pages.dart';
import '../controllers/marketplace_wishlist_controller.dart';
import '../components/wishlist_item_tile.dart';

class MarketplaceWishlistView extends GetView<MarketplaceWishlistController> {
  const MarketplaceWishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'.tr,
            style: MarketplaceDesignTokens.heading(context)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
        actions: [
          Obx(() {
            final count = controller.wishedProductList.value.length;
            if (count == 0) return const SizedBox.shrink();
            return Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: MarketplaceDesignTokens.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: MarketplaceDesignTokens.primary,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ──
          Padding(
            padding:
                const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
            child: TextField(
              onChanged: (v) => controller.searchQuery.value = v,
              decoration: InputDecoration(
                hintText: 'Search wishlist...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusMd),
                  borderSide: BorderSide(
                      color:
                          Theme.of(context).dividerColor.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusMd),
                  borderSide: BorderSide(
                      color:
                          Theme.of(context).dividerColor.withOpacity(0.3)),
                ),
              ),
            ),
          ),

          // ── Count + Sort Row ──
          Obx(() {
            final count = controller.filteredWishlist.length;
            if (controller.isLoadingWishlist.value || count == 0) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.cardPadding),
              child: Row(
                children: [
                  Text(
                    '$count item${count == 1 ? '' : 's'} saved',
                    style: MarketplaceDesignTokens.cardSubtext(context),
                  ),
                  const Spacer(),
                  _SortChip(controller: controller),
                ],
              ),
            );
          }),
          const SizedBox(height: MarketplaceDesignTokens.spacingSm),

          // ── List ──
          Expanded(
            child: Obx(() {
              if (controller.isLoadingWishlist.value) {
                return const MarketplaceListShimmerLoader();
              }

              if (controller.filteredWishlist.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: controller.getWishlistProducts,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: MarketplaceDesignTokens.cardPadding),
                  itemCount: controller.filteredWishlist.length,
                  separatorBuilder: (_, __) => const SizedBox(
                      height: MarketplaceDesignTokens.spacingSm),
                  itemBuilder: (context, index) {
                    final item = controller.filteredWishlist[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(
                              MarketplaceDesignTokens.cardRadius),
                        ),
                        child: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 28),
                      ),
                      confirmDismiss: (_) async {
                        return await Get.dialog<bool>(
                          AlertDialog(
                            title: const Text('Remove Item'),
                            content: Text(
                                'Remove "${item.product?.productName ?? 'this item'}" from wishlist?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Get.back(result: false),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () => Get.back(result: true),
                                  child: const Text('Remove',
                                      style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        ) ?? false;
                      },
                      onDismissed: (_) => controller.deleteWishlistProduct(
                          productId: item.id ?? ''),
                      child: WishlistItemTile(
                        wishedProductItem: item,
                        onDelete: () => controller.deleteWishlistProduct(
                            productId: item.id ?? ''),
                        onAddToCart: () =>
                            controller.addToCartAndRemoveFromWishlist(
                                wishedProductItem: item),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasSearch = controller.searchQuery.value.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.favorite_border,
            size: 64,
            color: MarketplaceDesignTokens.textSecondary(context),
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch ? 'No matching items' : 'Your wishlist is empty',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MarketplaceDesignTokens.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearch
                ? 'Try a different search term'
                : 'Save items you love to find them later',
            style: TextStyle(
              fontSize: 14,
              color: MarketplaceDesignTokens.textSecondary(context),
            ),
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Get.toNamed(Routes.MARKETPLACE),
              icon: const Icon(Icons.storefront, size: 18),
              label: const Text('Browse Products'),
              style: FilledButton.styleFrom(
                backgroundColor: MarketplaceDesignTokens.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusMd),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final MarketplaceWishlistController controller;
  const _SortChip({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopupMenuButton<String>(
          onSelected: (v) => controller.sortBy.value = v,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.3)),
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sort, size: 16,
                    color: MarketplaceDesignTokens.textSecondary(context)),
                const SizedBox(width: 4),
                Text(
                  _sortLabel(controller.sortBy.value),
                  style: TextStyle(
                    fontSize: 12,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          itemBuilder: (_) => [
            _sortItem('newest', 'Newest First'),
            _sortItem('oldest', 'Oldest First'),
            _sortItem('price_low', 'Price: Low to High'),
            _sortItem('price_high', 'Price: High to Low'),
            _sortItem('name', 'Name A-Z'),
          ],
        ));
  }

  String _sortLabel(String key) {
    switch (key) {
      case 'oldest':
        return 'Oldest';
      case 'price_low':
        return 'Price ↑';
      case 'price_high':
        return 'Price ↓';
      case 'name':
        return 'Name';
      default:
        return 'Newest';
    }
  }

  PopupMenuItem<String> _sortItem(String value, String label) {
    return PopupMenuItem(value: value, child: Text(label, style: const TextStyle(fontSize: 14)));
  }
}
