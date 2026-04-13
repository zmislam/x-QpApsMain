import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/custom_cached_image_view.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../../../../../routes/app_pages.dart';
import '../../controllers/product_details_controller.dart';

class StoreInfoCard extends GetView<ProductDetailsController> {
  const StoreInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final store = controller.product.value?.store;
      if (store == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: MarketplaceDesignTokens.spacingMd),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          children: [
            Row(
              children: [
                // ─── Store Avatar ──────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.avatarSize / 2),
                  child: CustomCachedNetworkImage(
                    imageUrl: (store.imagePath ?? '').formatedStoreUrlLive,
                    width: MarketplaceDesignTokens.avatarSize,
                    height: MarketplaceDesignTokens.avatarSize,
                    fit: BoxFit.cover,
                    placeholderImage: AppAssets.DEFAULT_IMAGE,
                  ),
                ),
                const SizedBox(width: 12),

                // ─── Store Name + Badge ────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              store.name?.capitalizeFirst ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: MarketplaceDesignTokens.textPrimary(
                                    context),
                              ),
                            ),
                          ),
                          if (controller.product.value?.trustedSeller?.id !=
                              null) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.verified,
                              size: 18,
                              color: MarketplaceDesignTokens.sellerBadge,
                            ),
                          ],
                        ],
                      ),
                      if (store.categoryName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          store.categoryName!,
                          style: MarketplaceDesignTokens.cardSubtext(context),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ─── Action Buttons ────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed(Routes.STORE_PRODUCTS_PAGE,
                          arguments: store.id);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MarketplaceDesignTokens.primary,
                      side: const BorderSide(
                          color: MarketplaceDesignTokens.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Visit Store'.tr,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.toggleStoreFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isFollowingStore.value
                          ? MarketplaceDesignTokens.textSecondary(context)
                              .withValues(alpha: 0.2)
                          : MarketplaceDesignTokens.primary,
                      foregroundColor: controller.isFollowingStore.value
                          ? MarketplaceDesignTokens.textPrimary(context)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                    child: Text(
                      controller.isFollowingStore.value
                          ? 'Following'.tr
                          : 'Follow'.tr,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
