import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/custom_cached_image_view.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../../../../extension/date_time_extension.dart';
import '../../../../../../routes/app_pages.dart';
import '../controllers/buyer_recent_activity_controller.dart';

class BuyerRecentActivityView
    extends GetView<BuyerRecentActivityController> {
  const BuyerRecentActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Filter Chips ──
        Padding(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: Obx(() => Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: controller.filterType.value.isEmpty,
                    onTap: () => controller.filterType.value = '',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Purchased',
                    isSelected:
                        controller.filterType.value == 'purchased',
                    onTap: () =>
                        controller.filterType.value = 'purchased',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Saved',
                    isSelected: controller.filterType.value == 'saved',
                    onTap: () => controller.filterType.value = 'saved',
                  ),
                ],
              )),
        ),

        // ── Activity List ──
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredActivities.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: controller.fetchActivity,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.filteredActivities.length,
                separatorBuilder: (_, __) => const SizedBox(
                    height: MarketplaceDesignTokens.spacingSm),
                itemBuilder: (context, index) => _ActivityCard(
                    activity: controller.filteredActivities[index]),
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
          Icon(Icons.history,
              size: 64,
              color: MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(height: 16),
          Text(
            'No recent activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MarketplaceDesignTokens.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your purchases and saved items will appear here',
            style: TextStyle(
              fontSize: 14,
              color: MarketplaceDesignTokens.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? MarketplaceDesignTokens.primary
              : MarketplaceDesignTokens.cardBg(context),
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
          border: Border.all(
            color: isSelected
                ? MarketplaceDesignTokens.primary
                : Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : MarketplaceDesignTokens.textPrimary(context),
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final RecentActivityItem activity;

  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isPurchased = activity.type == 'purchased';
    final imageUrl = activity.productMedia.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/products/${activity.productMedia.first}'
        : null;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          if (activity.productId != null) {
            Get.toNamed(Routes.PRODUCT_DETAILS,
                arguments: activity.productId);
          }
        },
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        child: Padding(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusSm),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: imageUrl != null
                      ? CustomCachedNetworkImage(imageUrl: imageUrl)
                      : Container(
                          color: MarketplaceDesignTokens.primary
                              .withOpacity(0.1),
                          child: const Icon(Icons.image_outlined,
                              color: MarketplaceDesignTokens.primary,
                              size: 24),
                        ),
                ),
              ),
              const SizedBox(width: MarketplaceDesignTokens.spacingMd),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      activity.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            MarketplaceDesignTokens.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Activity info row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPurchased
                                ? MarketplaceDesignTokens.primary
                                    .withOpacity(0.1)
                                : Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isPurchased ? 'Purchased' : 'Saved',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isPurchased
                                  ? MarketplaceDesignTokens.primary
                                  : Colors.amber.shade700,
                            ),
                          ),
                        ),
                        if (isPurchased && activity.price != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            CurrencyHelper.formatPrice(activity.price),
                            style: MarketplaceDesignTokens.productPrice,
                          ),
                          if (activity.quantity != null &&
                              activity.quantity! > 1) ...[
                            const SizedBox(width: 4),
                            Text(
                              'x${activity.quantity}',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    MarketplaceDesignTokens.textSecondary(
                                        context),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),

                    // Store + Date
                    if (activity.storeName != null ||
                        activity.date != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        [
                          if (activity.storeName != null)
                            activity.storeName!,
                          if (activity.date != null)
                            activity.date!.toFormatDateOfBirth(),
                        ].join(' • '),
                        style: TextStyle(
                          fontSize: 11,
                          color: MarketplaceDesignTokens.textSecondary(
                              context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow
              Icon(Icons.chevron_right,
                  size: 20,
                  color:
                      MarketplaceDesignTokens.textSecondary(context)),
            ],
          ),
        ),
      ),
    );
  }
}
