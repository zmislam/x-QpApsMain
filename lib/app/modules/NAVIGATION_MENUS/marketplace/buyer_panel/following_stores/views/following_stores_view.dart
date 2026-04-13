import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/custom_cached_image_view.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../routes/app_pages.dart';
import '../controllers/following_stores_controller.dart';
import '../models/following_store_model.dart';

class FollowingStoresView extends GetView<FollowingStoresController> {
  const FollowingStoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Search Bar ──
        Padding(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: TextField(
            onChanged: (v) => controller.searchQuery.value = v,
            decoration: InputDecoration(
              hintText: 'Search followed stores...',
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.3)),
              ),
            ),
          ),
        ),

        // ── Store List ──
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredStores.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: controller.fetchFollowingStores,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.filteredStores.length,
                itemBuilder: (context, index) =>
                    _buildStoreCard(context, controller.filteredStores[index]),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_outlined,
              size: 64,
              color: MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(height: 16),
          Text(
            'No followed stores yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MarketplaceDesignTokens.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Follow stores to see them here',
            style: TextStyle(
              fontSize: 14,
              color: MarketplaceDesignTokens.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, FollowingStoreItem item) {
    final store = item.store;
    if (store == null) return const SizedBox.shrink();

    final logoUrl = store.storeLogo != null && store.storeLogo!.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/stores/${store.storeLogo}'
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: MarketplaceDesignTokens.spacingSm),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: () =>
            Get.toNamed(Routes.STORE_PRODUCTS_PAGE, arguments: store.id),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        child: Padding(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: Row(
            children: [
              // ── Store Logo ──
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusSm),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: logoUrl != null
                      ? CustomCachedNetworkImage(imageUrl: logoUrl)
                      : Container(
                          color: MarketplaceDesignTokens.primary
                              .withOpacity(0.1),
                          child: const Icon(Icons.store,
                              color: MarketplaceDesignTokens.primary,
                              size: 28),
                        ),
                ),
              ),
              const SizedBox(width: MarketplaceDesignTokens.spacingMd),

              // ── Store Info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            store.storeName ?? 'Store',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: MarketplaceDesignTokens.textPrimary(
                                  context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (store.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              size: 16,
                              color: MarketplaceDesignTokens.primary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (item.newListingsCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: MarketplaceDesignTokens.primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${item.newListingsCount} new listing${item.newListingsCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: MarketplaceDesignTokens.primary,
                          ),
                        ),
                      )
                    else
                      Text(
                        'No new listings',
                        style: TextStyle(
                          fontSize: 12,
                          color: MarketplaceDesignTokens.textSecondary(
                              context),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Unfollow Button ──
              TextButton(
                onPressed: () => _confirmUnfollow(context, store),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: const Text('Unfollow', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmUnfollow(BuildContext context, StoreInfo store) {
    Get.dialog(
      AlertDialog(
        title: const Text('Unfollow Store'),
        content:
            Text('Stop following ${store.storeName ?? 'this store'}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (store.id != null) {
                controller.unfollowStore(store.id!);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Unfollow'),
          ),
        ],
      ),
    );
  }
}
