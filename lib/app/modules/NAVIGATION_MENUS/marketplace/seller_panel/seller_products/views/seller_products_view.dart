import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../components/empty_state.dart';
import '../../../components/status_badge.dart';
import '../controllers/seller_products_controller.dart';

/// Seller product list with search, status filter, toggle & delete.
class SellerProductsView extends GetView<SellerProductsController> {
  const SellerProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
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
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: MarketplaceDesignTokens.cardBorder(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: MarketplaceDesignTokens.cardBorder(context)),
              ),
            ),
          ),
        ),

        // Status filter chips
        SizedBox(
          height: MarketplaceDesignTokens.chipHeight,
          child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: controller.statusFilter.value.isEmpty,
                    onTap: () => controller.setStatusFilter(''),
                  ),
                  _FilterChip(
                    label: 'Published',
                    selected: controller.statusFilter.value == 'published',
                    onTap: () => controller.setStatusFilter('published'),
                  ),
                  _FilterChip(
                    label: 'Draft',
                    selected: controller.statusFilter.value == 'draft',
                    onTap: () => controller.setStatusFilter('draft'),
                  ),
                  _FilterChip(
                    label: 'Inactive',
                    selected: controller.statusFilter.value == 'inactive',
                    onTap: () => controller.setStatusFilter('inactive'),
                  ),
                ],
              )),
        ),
        const SizedBox(height: 8),

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
                subtitle: 'Tap + to add your first product',
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
                      )),
                    );
                  }
                  return _ProductListItem(
                    product: controller.products[index],
                    onToggle: (status) => controller.toggleStatus(
                      controller.products[index]['_id'],
                      status,
                    ),
                    onEdit: () {
                      Get.toNamed(
                        Routes.MARKETPLACE_EDIT_PRODUCT,
                        arguments: {'product_id': controller.products[index]['_id']},
                      );
                    },
                    onDelete: () => _confirmDelete(
                        context, controller.products[index]['_id']),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content:
            const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteProduct(productId);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: MarketplaceDesignTokens.outOfStock),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor:
            MarketplaceDesignTokens.pricePrimary.withValues(alpha: 0.15),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected
              ? MarketplaceDesignTokens.pricePrimary
              : MarketplaceDesignTokens.textSecondary(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        side: BorderSide(
          color: selected
              ? MarketplaceDesignTokens.pricePrimary
              : MarketplaceDesignTokens.cardBorder(context),
        ),
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(String status) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductListItem({
    required this.product,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = product['product_name'] as String? ?? '';
    final status = product['status'] as String? ?? 'draft';
    final sellPrice = product['sell_price'] ?? product['base_selling_price'] ?? 0;
    final media = product['media'] as List? ?? [];
    final stock = product['stock'] as num? ?? 0;
    final imageUrl = media.isNotEmpty ? media.first.toString() : '';

    return Container(
      margin: const EdgeInsets.only(bottom: MarketplaceDesignTokens.gridSpacing),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderImage(),
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
                    Text(
                      CurrencyHelper.formatPrice(sellPrice),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: MarketplaceDesignTokens.pricePrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Stock: $stock',
                      style: TextStyle(
                        fontSize: 12,
                        color: stock == 0
                            ? MarketplaceDesignTokens.outOfStock
                            : MarketplaceDesignTokens.textSecondary(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                StatusBadge(
                  status: status,
                  color: _statusColor(status),
                ),
              ],
            ),
          ),

          // Actions popup
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 20),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  onEdit();
                  break;
                case 'publish':
                  onToggle('published');
                  break;
                case 'draft':
                  onToggle('draft');
                  break;
                case 'inactive':
                  onToggle('inactive');
                  break;
                case 'delete':
                  onDelete();
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              if (status != 'published')
                const PopupMenuItem(value: 'publish', child: Text('Publish')),
              if (status != 'draft')
                const PopupMenuItem(
                    value: 'draft', child: Text('Move to Draft')),
              if (status != 'inactive')
                const PopupMenuItem(
                    value: 'inactive', child: Text('Deactivate')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 56,
      height: 56,
      color: const Color(0xFFF0F0F0),
      child: const Icon(Icons.image_outlined, color: Colors.grey, size: 24),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'published':
        return MarketplaceDesignTokens.inStock;
      case 'draft':
        return MarketplaceDesignTokens.lowStock;
      case 'inactive':
        return MarketplaceDesignTokens.orderCancelled;
      default:
        return MarketplaceDesignTokens.orderPending;
    }
  }
}
