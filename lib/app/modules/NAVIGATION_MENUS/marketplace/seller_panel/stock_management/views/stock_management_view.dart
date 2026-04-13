import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../components/empty_state.dart';
import '../controllers/stock_management_controller.dart';
import '../widgets/stock_update_sheet.dart';

/// Stock Management tab in Seller Panel.
/// Two sub-tabs: Products & Stock | Stock History
/// Plus inventory alerts banner at top.
class StockManagementView extends GetView<StockManagementController> {
  const StockManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Alerts banner
          _AlertsBanner(),

          // Sub-tabs
          Container(
            color: MarketplaceDesignTokens.cardBg(context),
            child: TabBar(
              labelColor: MarketplaceDesignTokens.pricePrimary,
              unselectedLabelColor:
                  MarketplaceDesignTokens.textSecondary(context),
              indicatorColor: MarketplaceDesignTokens.pricePrimary,
              indicatorWeight: 2,
              labelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              tabs: const [
                Tab(text: 'Products & Stock'),
                Tab(text: 'Stock History'),
              ],
              onTap: (index) {
                if (index == 1 && controller.stockHistory.isEmpty) {
                  controller.fetchStockHistory();
                }
              },
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _ProductsStockTab(),
                _StockHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Alerts Banner ──────────────────────────────────────────
class _AlertsBanner extends GetView<StockManagementController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.alerts.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.all(MarketplaceDesignTokens.spacingSm),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingSm),
        decoration: BoxDecoration(
          color: MarketplaceDesignTokens.outOfStock.withValues(alpha: 0.08),
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
          border: Border.all(
            color: MarketplaceDesignTokens.outOfStock.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 20, color: MarketplaceDesignTokens.outOfStock),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${controller.alertCount.value} inventory alert${controller.alertCount.value == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: MarketplaceDesignTokens.outOfStock,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _showAlertsSheet(context),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
              ),
              child: const Text(
                'View',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MarketplaceDesignTokens.outOfStock,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showAlertsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: MarketplaceDesignTokens.cardBg(context),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(MarketplaceDesignTokens.radiusLg),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.spacingMd,
                  vertical: MarketplaceDesignTokens.spacingSm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 22,
                        color: MarketplaceDesignTokens.outOfStock),
                    const SizedBox(width: 8),
                    Text(
                      'Inventory Alerts',
                      style:
                          MarketplaceDesignTokens.sectionTitle(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Obx(() {
                  if (controller.alerts.isEmpty) {
                    return Center(
                      child: Text(
                        'No alerts',
                        style:
                            MarketplaceDesignTokens.cardSubtext(context),
                      ),
                    );
                  }
                  return ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(
                        MarketplaceDesignTokens.spacingMd),
                    itemCount: controller.alerts.length,
                    separatorBuilder: (_, __) => const SizedBox(
                        height: MarketplaceDesignTokens.spacingSm),
                    itemBuilder: (_, i) =>
                        _AlertItem(alert: controller.alerts[i]),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final Map<String, dynamic> alert;
  const _AlertItem({required this.alert});

  @override
  Widget build(BuildContext context) {
    final alertType = alert['alert_type'] as String? ?? 'low_stock';
    final currentStock = alert['current_stock'] as num? ?? 0;
    final threshold = alert['threshold'] as num? ?? 5;
    final product = alert['product_id'] as Map<String, dynamic>? ?? {};
    final productName = product['product_name'] as String? ?? 'Unknown';
    final isOutOfStock = alertType == 'out_of_stock';

    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isOutOfStock
                  ? MarketplaceDesignTokens.outOfStock
                      .withValues(alpha: 0.1)
                  : Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                  MarketplaceDesignTokens.radiusSm),
            ),
            child: Icon(
              isOutOfStock
                  ? Icons.remove_shopping_cart
                  : Icons.warning_amber_rounded,
              size: 20,
              color: isOutOfStock
                  ? MarketplaceDesignTokens.outOfStock
                  : Colors.amber[700],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: MarketplaceDesignTokens.bodyText(context)
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isOutOfStock
                      ? 'Out of stock'
                      : 'Low stock: $currentStock left (threshold: $threshold)',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOutOfStock
                        ? MarketplaceDesignTokens.outOfStock
                        : Colors.amber[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Products & Stock Tab ───────────────────────────────────
class _ProductsStockTab extends GetView<StockManagementController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: TextField(
            onChanged: (v) => controller.search(v),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: MarketplaceDesignTokens.cardBorder(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: MarketplaceDesignTokens.cardBorder(context)),
              ),
            ),
          ),
        ),

        // Product list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MarketplaceDesignTokens.pricePrimary,
                ),
              );
            }
            if (controller.products.isEmpty) {
              return MarketplaceEmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No products found',
                subtitle: 'Products will appear here once added',
              );
            }
            return RefreshIndicator(
              onRefresh: () => controller.fetchProducts(),
              color: MarketplaceDesignTokens.pricePrimary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.products.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.products.length) {
                    controller.fetchProducts(loadMore: true);
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: MarketplaceDesignTokens.pricePrimary,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  return _ProductStockCard(
                    product: controller.products[index],
                    onTap: () => _openStockSheet(
                        context, controller.products[index]['_id'] ?? ''),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void _openStockSheet(BuildContext context, String productId) {
    if (productId.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StockUpdateSheet(productId: productId),
    );
  }
}

class _ProductStockCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _ProductStockCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final name = product['product_name'] as String? ?? '';
    final stock = product['stock'] as num? ?? 0;
    final media = product['media'] as List? ?? [];
    final status = product['status'] as String? ?? '';
    final imageUrl = media.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/products/${media.first}'
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
            bottom: MarketplaceDesignTokens.gridSpacing),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  MarketplaceDesignTokens.radiusSm),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _placeholderImage(),
                    )
                  : _placeholderImage(),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: MarketplaceDesignTokens.bodyText(context)
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _StockBadge(stock: stock),
                      if (status.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          status.capitalizeFirst ?? status,
                          style: TextStyle(
                            fontSize: 11,
                            color: MarketplaceDesignTokens.textSecondary(
                                context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              size: 20,
              color: MarketplaceDesignTokens.textSecondary(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 52,
      height: 52,
      color: Colors.grey[200],
      child: const Icon(Icons.image_outlined, size: 24, color: Colors.grey),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final num stock;
  const _StockBadge({required this.stock});

  @override
  Widget build(BuildContext context) {
    final isLow = stock <= 5;
    final isOut = stock == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isOut
            ? MarketplaceDesignTokens.outOfStock.withValues(alpha: 0.1)
            : isLow
                ? Colors.amber.withValues(alpha: 0.1)
                : MarketplaceDesignTokens.inStock.withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
      child: Text(
        isOut ? 'Out of stock' : '$stock in stock',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isOut
              ? MarketplaceDesignTokens.outOfStock
              : isLow
                  ? Colors.amber[700]
                  : MarketplaceDesignTokens.inStock,
        ),
      ),
    );
  }
}

// ─── Stock History Tab ──────────────────────────────────────
class _StockHistoryTab extends GetView<StockManagementController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingHistory.value &&
          controller.stockHistory.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: MarketplaceDesignTokens.pricePrimary,
          ),
        );
      }
      if (controller.stockHistory.isEmpty) {
        return MarketplaceEmptyState(
          icon: Icons.history,
          title: 'No stock history',
          subtitle: 'Stock entries will appear here',
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchStockHistory(),
        color: MarketplaceDesignTokens.pricePrimary,
        child: ListView.builder(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          itemCount: controller.stockHistory.length +
              (controller.hasMoreHistory.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.stockHistory.length) {
              controller.fetchStockHistory(loadMore: true);
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: MarketplaceDesignTokens.pricePrimary,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            return _StockHistoryCard(
                entry: controller.stockHistory[index]);
          },
        ),
      );
    });
  }
}

class _StockHistoryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  const _StockHistoryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final productName = entry['product_name'] as String? ?? 'Unknown';
    final category = entry['category_name'] as String? ?? '';
    final quantity = entry['quantity'] as num? ?? 0;
    final date = entry['createdAt'] as String? ?? '';
    final media = entry['media'] as List? ?? [];
    final imageUrl = media.isNotEmpty
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/products/${media.first}'
        : '';

    String formattedDate = date;
    if (date.isNotEmpty) {
      try {
        final dt = DateTime.parse(date);
        formattedDate =
            '${dt.day}/${dt.month}/${dt.year}';
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(
          bottom: MarketplaceDesignTokens.gridSpacing),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44,
                      height: 44,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_outlined,
                          size: 20, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 44,
                    height: 44,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_outlined,
                        size: 20, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: MarketplaceDesignTokens.bodyText(context)
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (category.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    category,
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

          // Quantity + Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: MarketplaceDesignTokens.inStock
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
                child: Text(
                  '+$quantity',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: MarketplaceDesignTokens.inStock,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 11,
                  color:
                      MarketplaceDesignTokens.textSecondary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
