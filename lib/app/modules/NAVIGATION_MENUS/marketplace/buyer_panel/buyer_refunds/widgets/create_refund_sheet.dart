import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../controllers/buyer_refunds_controller.dart';

/// Bottom sheet for submitting a new refund request.
/// Expects arguments: { 'orderSubDetailsId': String, 'products': List<Map> }
/// Each product map: { product_id, variant_id, product_name, sell_price, quantity, media }
class CreateRefundSheet extends StatelessWidget {
  final String orderSubDetailsId;
  final List<Map<String, dynamic>> products;

  const CreateRefundSheet({
    super.key,
    required this.orderSubDetailsId,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerRefundsController>();
    controller.resetRefundForm();

    // Pre-populate refund items from products
    for (final product in products) {
      controller.addRefundItem({
        'product_id': product['product_id'],
        'variant_id': product['variant_id'],
        'refund_quantity': 1,
        'sell_price': product['sell_price'] ?? 0,
        'refund_note': '',
        '_display_name': product['product_name'] ?? 'Product',
        '_display_media': product['media'] ?? '',
        '_max_qty': product['quantity'] ?? 1,
      });
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(MarketplaceDesignTokens.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Handle Bar ─────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ─── Title ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MarketplaceDesignTokens.spacingMd,
              vertical: MarketplaceDesignTokens.spacingSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.replay_outlined,
                    color: MarketplaceDesignTokens.primary),
                const SizedBox(width: 8),
                Text(
                  'Request Refund',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ─── Scrollable Content ─────────────────────────
          Expanded(
            child: Obx(() => ListView(
                  padding: const EdgeInsets.all(
                      MarketplaceDesignTokens.spacingMd),
                  children: [
                    // Products to refund
                    Text(
                      'Items to Refund',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(
                        height: MarketplaceDesignTokens.spacingSm),

                    ...controller.refundItems
                        .asMap()
                        .entries
                        .map((entry) => _buildRefundItemTile(
                              context,
                              controller,
                              entry.key,
                              entry.value,
                            )),

                    const SizedBox(
                        height: MarketplaceDesignTokens.spacingMd),

                    // Delivery charge
                    _buildTextField(
                      context,
                      label: 'Delivery Charge (€)',
                      hintText: '0.00',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (val) {
                        controller.deliveryCharge.value =
                            double.tryParse(val) ?? 0;
                      },
                    ),

                    const SizedBox(
                        height: MarketplaceDesignTokens.spacingSm),

                    // Note
                    _buildTextField(
                      context,
                      label: 'Reason / Note',
                      hintText: 'Describe why you want a refund...',
                      controller: controller.noteController,
                      maxLines: 3,
                    ),

                    const SizedBox(
                        height: MarketplaceDesignTokens.spacingMd),

                    // Image picker
                    Text(
                      'Attach Evidence (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(
                        height: MarketplaceDesignTokens.spacingXs),
                    _buildImagePicker(context, controller),

                    const SizedBox(
                        height: MarketplaceDesignTokens.spacingLg),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isSubmitting.value
                            ? null
                            : () => controller.submitRefund(
                                orderSubDetailsId: orderSubDetailsId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MarketplaceDesignTokens.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MarketplaceDesignTokens.radiusMd),
                          ),
                        ),
                        child: controller.isSubmitting.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
                                'Submit Refund Request',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    const SizedBox(height: MarketplaceDesignTokens.spacingMd),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundItemTile(
    BuildContext context,
    BuyerRefundsController controller,
    int index,
    Map<String, dynamic> item,
  ) {
    final name = item['_display_name'] as String? ?? 'Product';
    final maxQty = item['_max_qty'] as int? ?? 1;
    final currentQty = item['refund_quantity'] as int? ?? 1;
    final price = (item['sell_price'] as num?)?.toDouble() ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: MarketplaceDesignTokens.spacingSm),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Remove button
              GestureDetector(
                onTap: () => controller.removeRefundItem(index),
                child: Icon(Icons.close, size: 18+ 0.0,
                    color: Colors.red.shade400),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                CurrencyHelper.formatPrice(price),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: MarketplaceDesignTokens.primary,
                ),
              ),
              const Spacer(),
              // Quantity selector
              Text('Qty: ',
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color)),
              _buildQtyButton(context, Icons.remove, () {
                if (currentQty > 1) {
                  controller.updateRefundItem(index, {
                    ...item,
                    'refund_quantity': currentQty - 1,
                  });
                }
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('$currentQty',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              _buildQtyButton(context, Icons.add, () {
                if (currentQty < maxQty) {
                  controller.updateRefundItem(index, {
                    ...item,
                    'refund_quantity': currentQty + 1,
                  });
                }
              }),
              Text(' / $maxQty',
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.5))),
            ],
          ),
          const SizedBox(height: 6),
          // Per-item note
          TextField(
            decoration: InputDecoration(
              hintText: 'Item-specific note (optional)',
              hintStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.4)),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .dividerColor
                        .withValues(alpha: 0.3)),
              ),
            ),
            style: const TextStyle(fontSize: 13),
            onChanged: (val) {
              controller.updateRefundItem(index, {
                ...item,
                'refund_note': val,
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(
      BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: MarketplaceDesignTokens.primary.withValues(alpha: 0.1),
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        child: Icon(icon, size: 16, color: MarketplaceDesignTokens.primary),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    String? hintText,
    TextEditingController? controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 13,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.4),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
              borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
              borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
              borderSide:
                  const BorderSide(color: MarketplaceDesignTokens.primary),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildImagePicker(
      BuildContext context, BuyerRefundsController controller) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...controller.refundImages.asMap().entries.map(
              (entry) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(entry.value.path),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: GestureDetector(
                      onTap: () =>
                          controller.removeRefundImage(entry.key),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        if (controller.refundImages.length < 5)
          GestureDetector(
            onTap: controller.pickRefundImage,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: MarketplaceDesignTokens.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      MarketplaceDesignTokens.primary.withValues(alpha: 0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 24, color: MarketplaceDesignTokens.primary),
                  SizedBox(height: 2),
                  Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 11,
                      color: MarketplaceDesignTokens.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
