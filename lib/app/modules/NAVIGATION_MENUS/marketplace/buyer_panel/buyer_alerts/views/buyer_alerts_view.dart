import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../components/custom_cached_image_view.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../../../../routes/app_pages.dart';
import '../controllers/buyer_alerts_controller.dart';

class BuyerAlertsView extends GetView<BuyerAlertsController> {
  const BuyerAlertsView({super.key});

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
                    label: 'Price Drops',
                    isSelected:
                        controller.filterType.value == 'price_drop',
                    onTap: () =>
                        controller.filterType.value = 'price_drop',
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Back in Stock',
                    isSelected:
                        controller.filterType.value == 'back_in_stock',
                    onTap: () =>
                        controller.filterType.value = 'back_in_stock',
                  ),
                ],
              )),
        ),

        // ── Alerts List ──
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.filteredAlerts.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: controller.fetchAlerts,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.filteredAlerts.length,
                separatorBuilder: (_, __) => const SizedBox(
                    height: MarketplaceDesignTokens.spacingSm),
                itemBuilder: (context, index) => _AlertCard(
                    alert: controller.filteredAlerts[index]),
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
          Icon(Icons.notifications_none,
              size: 64,
              color: MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(height: 16),
          Text(
            'No alerts yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MarketplaceDesignTokens.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save items to your wishlist to get price drop\nand back-in-stock alerts',
            textAlign: TextAlign.center,
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

class _AlertCard extends StatelessWidget {
  final BuyerAlert alert;

  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final isPriceDrop = alert.type == 'price_drop';
    final imageUrl = alert.productMedia.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/products/${alert.productMedia.first}'
        : null;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          final productId = alert.product?['_id'];
          if (productId != null) {
            Get.toNamed(Routes.PRODUCT_DETAILS, arguments: productId);
          }
        },
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        child: Padding(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: Row(
            children: [
              // Alert type icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isPriceDrop
                      ? Colors.green.withOpacity(0.1)
                      : MarketplaceDesignTokens.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
                child: Icon(
                  isPriceDrop
                      ? Icons.trending_down
                      : Icons.inventory_2_outlined,
                  size: 20,
                  color: isPriceDrop
                      ? Colors.green
                      : MarketplaceDesignTokens.primary,
                ),
              ),
              const SizedBox(width: MarketplaceDesignTokens.spacingMd),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPriceDrop ? 'Price Drop' : 'Back in Stock',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPriceDrop
                            ? Colors.green
                            : MarketplaceDesignTokens.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alert.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            MarketplaceDesignTokens.textPrimary(context),
                      ),
                    ),
                    if (isPriceDrop &&
                        alert.oldPrice != null &&
                        alert.newPrice != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            CurrencyHelper.formatPrice(alert.oldPrice),
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color:
                                  MarketplaceDesignTokens.textSecondary(
                                      context),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            CurrencyHelper.formatPrice(alert.newPrice),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Product thumbnail
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: CustomCachedNetworkImage(imageUrl: imageUrl),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
