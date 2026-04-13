import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/flash_sales_controller.dart';
import 'create_flash_sale_sheet.dart';

class FlashSalesView extends GetView<FlashSalesController> {
  const FlashSalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.flashSales.isEmpty) {
            return _buildEmpty(context);
          }
          return RefreshIndicator(
            onRefresh: () => controller.fetchFlashSales(refresh: true),
            child: ListView.separated(
              padding:
                  const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
              itemCount: controller.flashSales.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: MarketplaceDesignTokens.spacingSm),
              itemBuilder: (_, i) =>
                  _FlashSaleCard(sale: controller.flashSales[i]),
            ),
          );
        }),
        // ── FAB ──
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'createFlashSale',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const CreateFlashSaleSheet(),
              );
            },
            backgroundColor: MarketplaceDesignTokens.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.flash_on, size: 20),
            label: const Text('Flash Sale',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flash_on_outlined,
              size: 64,
              color: MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(height: 16),
          Text('No flash sales yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: MarketplaceDesignTokens.textPrimary(context),
              )),
          const SizedBox(height: 8),
          Text('Create limited-time deals for your products',
              style: TextStyle(
                fontSize: 14,
                color: MarketplaceDesignTokens.textSecondary(context),
              )),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━ Flash Sale Card ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
class _FlashSaleCard extends GetView<FlashSalesController> {
  final Map<String, dynamic> sale;
  const _FlashSaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    final title = sale['title']?.toString() ?? 'Untitled';
    final status = sale['status']?.toString() ?? '';
    final startTime = sale['start_time']?.toString() ?? '';
    final endTime = sale['end_time']?.toString() ?? '';
    final products = (sale['products'] as List?) ?? [];
    final isFeatured = sale['is_featured'] == true;

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Icon(Icons.flash_on,
                  size: 20, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    )),
              ),
              if (isFeatured)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Featured',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber)),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      controller.statusColor(status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(controller.statusLabel(status),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: controller.statusColor(status),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Time Range ──
          Row(
            children: [
              Icon(Icons.schedule,
                  size: 14,
                  color: MarketplaceDesignTokens.textSecondary(context)),
              const SizedBox(width: 4),
              Text(
                '${_formatDateTime(startTime)} – ${_formatDateTime(endTime)}',
                style: TextStyle(
                  fontSize: 12,
                  color: MarketplaceDesignTokens.textSecondary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Products ──
          Text('${products.length} product${products.length == 1 ? '' : 's'}',
              style: MarketplaceDesignTokens.cardSubtext(context)),
          const SizedBox(height: 8),
          ...products.take(3).map((p) => _ProductRow(p, context)),
          if (products.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('+${products.length - 3} more',
                  style: TextStyle(
                      fontSize: 12,
                      color: MarketplaceDesignTokens.primary,
                      fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }

  Widget _ProductRow(dynamic p, BuildContext ctx) {
    if (p is! Map) return const SizedBox.shrink();
    final product = p['product_id'];
    final name = (product is Map ? product['product_name'] : null)
            ?.toString() ??
        'Product';
    final flashPrice = (p['flash_price'] as num?) ?? 0;
    final originalPrice = (p['original_price'] as num?) ?? 0;
    final soldCount = (p['sold_count'] as num?) ?? 0;
    final qtyLimit = p['quantity_limit'] as num?;
    final discount = originalPrice > 0
        ? ((1 - flashPrice / originalPrice) * 100).toStringAsFixed(0)
        : '0';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MarketplaceDesignTokens.bodyTextSmall(ctx)),
          ),
          Text('€${flashPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: MarketplaceDesignTokens.pricePrimary)),
          const SizedBox(width: 6),
          Text('€${originalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 11,
                decoration: TextDecoration.lineThrough,
                color: MarketplaceDesignTokens.textSecondary(ctx),
              )),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('-$discount%',
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.red)),
          ),
          if (qtyLimit != null) ...[
            const SizedBox(width: 6),
            Text('$soldCount/$qtyLimit',
                style: TextStyle(
                  fontSize: 10,
                  color: MarketplaceDesignTokens.textSecondary(ctx),
                )),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(String iso) {
    if (iso.isEmpty) return '--';
    try {
      final d = DateTime.parse(iso);
      return '${d.day}/${d.month} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '--';
    }
  }
}
