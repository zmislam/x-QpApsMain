import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/stock_management_controller.dart';

/// Bottom sheet showing variant-level stock for a product.
/// Allows updating stock quantities and setting low-stock thresholds.
class StockUpdateSheet extends StatefulWidget {
  final String productId;
  const StockUpdateSheet({super.key, required this.productId});

  @override
  State<StockUpdateSheet> createState() => _StockUpdateSheetState();
}

class _StockUpdateSheetState extends State<StockUpdateSheet> {
  final StockManagementController controller = Get.find();
  final Map<String, TextEditingController> _qtyControllers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    controller.fetchVariantStocks(widget.productId);
  }

  @override
  void dispose() {
    for (final c in _qtyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: MarketplaceDesignTokens.cardBg(context),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(MarketplaceDesignTokens.radiusLg),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Obx(() => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MarketplaceDesignTokens.spacingMd,
                      vertical: MarketplaceDesignTokens.spacingSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.selectedProductName.value,
                            style:
                                MarketplaceDesignTokens.sectionTitle(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),

              const Divider(height: 1),

              // Variants list
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingVariants.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MarketplaceDesignTokens.pricePrimary,
                      ),
                    );
                  }
                  if (controller.variants.isEmpty) {
                    return Center(
                      child: Text(
                        'No variants found',
                        style: MarketplaceDesignTokens.cardSubtext(context),
                      ),
                    );
                  }

                  return ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(
                        MarketplaceDesignTokens.spacingMd),
                    itemCount: controller.variants.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: MarketplaceDesignTokens.spacingSm),
                    itemBuilder: (context, index) {
                      final v = controller.variants[index];
                      return _VariantStockCard(
                        variant: v,
                        qtyController: _getQtyController(v['_id'] ?? ''),
                        onSetThreshold: () =>
                            _showThresholdDialog(context, v),
                      );
                    },
                  );
                }),
              ),

              // Update button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(
                      MarketplaceDesignTokens.spacingMd),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitStockUpdate,
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: Text(
                          _isSubmitting ? 'Updating...' : 'Add Stock'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            MarketplaceDesignTokens.pricePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusMd,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TextEditingController _getQtyController(String variantId) {
    return _qtyControllers.putIfAbsent(
      variantId,
      () => TextEditingController(),
    );
  }

  Future<void> _submitStockUpdate() async {
    final updates = <Map<String, dynamic>>[];
    for (final entry in _qtyControllers.entries) {
      final text = entry.value.text.trim();
      if (text.isEmpty) continue;
      final qty = int.tryParse(text);
      if (qty != null && qty > 0) {
        updates.add({'variant_id': entry.key, 'addQuantity': qty});
      }
    }

    if (updates.isEmpty) {
      Get.snackbar('Info', 'Enter quantity for at least one variant',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isSubmitting = true);
    await controller.updateStocks(widget.productId, updates);
    setState(() => _isSubmitting = false);

    // Clear inputs after success
    for (final c in _qtyControllers.values) {
      c.clear();
    }
  }

  void _showThresholdDialog(
      BuildContext context, Map<String, dynamic> variant) {
    final tCtrl = TextEditingController(
      text: (variant['low_stock_threshold'] ?? 5).toString(),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Low-Stock Threshold'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              variant['variant_string'] as String? ?? 'Variant',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Threshold',
                hintText: 'e.g. 5',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(tCtrl.text.trim());
              if (val != null && val >= 0) {
                Navigator.pop(ctx);
                controller.setThreshold(variant['_id'] ?? '', val);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    // dispose the controller when dialog closes
    tCtrl.addListener(() {});
  }
}

class _VariantStockCard extends StatelessWidget {
  final Map<String, dynamic> variant;
  final TextEditingController qtyController;
  final VoidCallback onSetThreshold;

  const _VariantStockCard({
    required this.variant,
    required this.qtyController,
    required this.onSetThreshold,
  });

  @override
  Widget build(BuildContext context) {
    final variantName = variant['variant_string'] as String? ?? '—';
    final color = variant['color'] as String? ?? '';
    final stocks = variant['stocks'] as num? ?? 0;
    final threshold = variant['low_stock_threshold'] as num? ?? 5;
    final isLow = stocks <= threshold;

    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Variant header
          Row(
            children: [
              if (color.isNotEmpty) ...[
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _parseColor(color),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  variantName,
                  style: MarketplaceDesignTokens.bodyText(context)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              // Stock badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isLow
                      ? MarketplaceDesignTokens.outOfStock
                          .withValues(alpha: 0.1)
                      : MarketplaceDesignTokens.inStock
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
                child: Text(
                  '$stocks in stock',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isLow
                        ? MarketplaceDesignTokens.outOfStock
                        : MarketplaceDesignTokens.inStock,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Threshold + Add qty row
          Row(
            children: [
              // Threshold indicator
              GestureDetector(
                onTap: onSetThreshold,
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 14,
                        color:
                            MarketplaceDesignTokens.textSecondary(context)),
                    const SizedBox(width: 4),
                    Text(
                      'Threshold: $threshold',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            MarketplaceDesignTokens.textSecondary(context),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.edit,
                        size: 12,
                        color:
                            MarketplaceDesignTokens.textSecondary(context)),
                  ],
                ),
              ),
              const Spacer(),

              // Add quantity field
              SizedBox(
                width: 100,
                height: 36,
                child: TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '+ Qty',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color:
                          MarketplaceDesignTokens.textSecondary(context),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                      borderSide: BorderSide(
                        color:
                            MarketplaceDesignTokens.cardBorder(context),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                      borderSide: BorderSide(
                        color:
                            MarketplaceDesignTokens.cardBorder(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorName) {
    final lower = colorName.toLowerCase();
    const colorMap = <String, Color>{
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'black': Colors.black,
      'white': Colors.white,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'grey': Colors.grey,
      'gray': Colors.grey,
      'brown': Colors.brown,
      'navy': Color(0xFF000080),
      'teal': Colors.teal,
      'cyan': Colors.cyan,
    };
    return colorMap[lower] ?? Colors.grey;
  }
}
