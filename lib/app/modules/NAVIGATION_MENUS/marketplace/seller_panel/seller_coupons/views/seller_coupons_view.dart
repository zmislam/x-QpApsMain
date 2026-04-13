import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../components/empty_state.dart';
import '../controllers/seller_coupons_controller.dart';

/// Seller Coupon management — list, create, edit coupons per store.
class SellerCouponsView extends GetView<SellerCouponsController> {
  const SellerCouponsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Store selector + Add button
        Padding(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: Row(
            children: [
              Expanded(child: _StoreDropdown()),
              const SizedBox(width: 10),
              _AddCouponButton(onTap: () => _showCouponForm(context)),
            ],
          ),
        ),

        // Coupon list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.coupons.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MarketplaceDesignTokens.pricePrimary,
                ),
              );
            }
            if (controller.stores.isEmpty) {
              return MarketplaceEmptyState(
                icon: Icons.store_outlined,
                title: 'No stores found',
                subtitle: 'Create a store to manage coupons',
              );
            }
            if (controller.coupons.isEmpty) {
              return MarketplaceEmptyState(
                icon: Icons.local_offer_outlined,
                title: 'No coupons yet',
                subtitle: 'Create your first coupon for this store',
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchCoupons(),
              color: MarketplaceDesignTokens.pricePrimary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.coupons.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.coupons.length) {
                    controller.fetchCoupons(loadMore: true);
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
                  return _CouponCard(
                    coupon: controller.coupons[index],
                    onToggle: () => controller.toggleCouponStatus(
                      controller.coupons[index]['_id']?.toString() ?? '',
                      controller.coupons[index]['status']?.toString() ??
                          'active',
                    ),
                    onEdit: () => _showCouponForm(
                      context,
                      coupon: controller.coupons[index],
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showCouponForm(BuildContext context,
      {Map<String, dynamic>? coupon}) {
    final isEditing = coupon != null;
    final codeCtrl =
        TextEditingController(text: coupon?['coupon_code']?.toString() ?? '');
    final amountCtrl = TextEditingController(
        text: coupon?['coupon_amount']?.toString() ?? '');
    final minAmountCtrl = TextEditingController(
        text: coupon?['minimum_amount']?.toString() ?? '0');
    final maxDiscountCtrl = TextEditingController(
        text: coupon?['max_discount_amount']?.toString() ?? '0');
    final countCtrl = TextEditingController(
        text: coupon?['count_by_user']?.toString() ?? '1');

    String discountType =
        coupon?['discount_type']?.toString() ?? 'percentage';
    String status = coupon?['status']?.toString() ?? 'active';

    DateTime? startDate;
    DateTime? endDate;
    try {
      if (coupon?['start_date'] != null) {
        startDate = DateTime.parse(coupon!['start_date'].toString());
      }
      if (coupon?['end_date'] != null) {
        endDate = DateTime.parse(coupon!['end_date'].toString());
      }
    } catch (_) {}

    bool submitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
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

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MarketplaceDesignTokens.spacingMd,
                      vertical: MarketplaceDesignTokens.spacingSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer_outlined, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          isEditing ? 'Edit Coupon' : 'Create Coupon',
                          style:
                              MarketplaceDesignTokens.sectionTitle(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(
                          MarketplaceDesignTokens.spacingMd),
                      children: [
                        // Coupon code
                        _FormField(
                          label: 'Coupon Code',
                          child: TextField(
                            controller: codeCtrl,
                            textCapitalization:
                                TextCapitalization.characters,
                            decoration: _inputDecoration(
                                context, 'e.g. SAVE20'),
                          ),
                        ),

                        // Discount type
                        _FormField(
                          label: 'Discount Type',
                          child: Row(
                            children: [
                              _TypeChip(
                                label: 'Percentage',
                                selected: discountType == 'percentage',
                                onTap: () => setState(
                                    () => discountType = 'percentage'),
                              ),
                              const SizedBox(width: 8),
                              _TypeChip(
                                label: 'Flat',
                                selected: discountType == 'flat',
                                onTap: () =>
                                    setState(() => discountType = 'flat'),
                              ),
                            ],
                          ),
                        ),

                        // Amount
                        _FormField(
                          label: discountType == 'percentage'
                              ? 'Discount (%)'
                              : 'Discount Amount (€)',
                          child: TextField(
                            controller: amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                              context,
                              discountType == 'percentage'
                                  ? 'e.g. 20'
                                  : 'e.g. 10',
                            ),
                          ),
                        ),

                        // Min amount
                        _FormField(
                          label: 'Minimum Order Amount (€)',
                          child: TextField(
                            controller: minAmountCtrl,
                            keyboardType: TextInputType.number,
                            decoration:
                                _inputDecoration(context, 'e.g. 50'),
                          ),
                        ),

                        // Max discount (for percentage)
                        if (discountType == 'percentage')
                          _FormField(
                            label: 'Max Discount Cap (€, 0 = no cap)',
                            child: TextField(
                              controller: maxDiscountCtrl,
                              keyboardType: TextInputType.number,
                              decoration:
                                  _inputDecoration(context, 'e.g. 100'),
                            ),
                          ),

                        // Uses per user
                        _FormField(
                          label: 'Max Uses Per User',
                          child: TextField(
                            controller: countCtrl,
                            keyboardType: TextInputType.number,
                            decoration:
                                _inputDecoration(context, 'e.g. 3'),
                          ),
                        ),

                        // Date range
                        _FormField(
                          label: 'Valid From',
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: startDate ?? DateTime.now(),
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() => startDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        MarketplaceDesignTokens.cardBorder(
                                            context)),
                                borderRadius: BorderRadius.circular(
                                    MarketplaceDesignTokens.radiusMd),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      startDate != null
                                          ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                                          : 'Select start date',
                                      style: TextStyle(
                                        color: startDate != null
                                            ? MarketplaceDesignTokens
                                                .textPrimary(context)
                                            : MarketplaceDesignTokens
                                                .textSecondary(context),
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.calendar_today,
                                      size: 18,
                                      color: MarketplaceDesignTokens
                                          .textSecondary(context)),
                                ],
                              ),
                            ),
                          ),
                        ),

                        _FormField(
                          label: 'Valid Until',
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: endDate ??
                                    DateTime.now()
                                        .add(const Duration(days: 30)),
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() => endDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        MarketplaceDesignTokens.cardBorder(
                                            context)),
                                borderRadius: BorderRadius.circular(
                                    MarketplaceDesignTokens.radiusMd),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      endDate != null
                                          ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                          : 'Select end date',
                                      style: TextStyle(
                                        color: endDate != null
                                            ? MarketplaceDesignTokens
                                                .textPrimary(context)
                                            : MarketplaceDesignTokens
                                                .textSecondary(context),
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.calendar_today,
                                      size: 18,
                                      color: MarketplaceDesignTokens
                                          .textSecondary(context)),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Status
                        _FormField(
                          label: 'Status',
                          child: Row(
                            children: [
                              _TypeChip(
                                label: 'Active',
                                selected: status == 'active',
                                onTap: () =>
                                    setState(() => status = 'active'),
                              ),
                              const SizedBox(width: 8),
                              _TypeChip(
                                label: 'Inactive',
                                selected: status == 'inactive',
                                onTap: () =>
                                    setState(() => status = 'inactive'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Submit
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(
                          MarketplaceDesignTokens.spacingMd),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: submitting
                              ? null
                              : () async {
                                  final code = codeCtrl.text.trim();
                                  final amount =
                                      double.tryParse(amountCtrl.text.trim());
                                  if (code.isEmpty || amount == null) {
                                    Get.snackbar('Missing',
                                        'Code and amount are required',
                                        snackPosition: SnackPosition.BOTTOM);
                                    return;
                                  }

                                  setState(() => submitting = true);
                                  final data = <String, dynamic>{
                                    'coupon_code': code,
                                    'discount_type': discountType,
                                    'coupon_amount': amount,
                                    'minimum_amount': double.tryParse(
                                            minAmountCtrl.text.trim()) ??
                                        0,
                                    'count_by_user':
                                        int.tryParse(countCtrl.text.trim()) ??
                                            1,
                                    'status': status,
                                  };
                                  if (discountType == 'percentage') {
                                    data['max_discount_amount'] =
                                        double.tryParse(maxDiscountCtrl.text
                                                .trim()) ??
                                            0;
                                  }
                                  if (startDate != null) {
                                    data['start_date'] =
                                        startDate!.toIso8601String();
                                  }
                                  if (endDate != null) {
                                    data['end_date'] =
                                        endDate!.toIso8601String();
                                  }

                                  bool ok;
                                  if (isEditing) {
                                    ok = await controller.updateCoupon(
                                      coupon['_id'].toString(),
                                      data,
                                    );
                                  } else {
                                    ok = await controller.createCoupon(data);
                                  }
                                  setState(() => submitting = false);
                                  if (ok && ctx.mounted) Navigator.pop(ctx);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                MarketplaceDesignTokens.pricePrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MarketplaceDesignTokens.radiusMd),
                            ),
                          ),
                          child: Text(
                            submitting
                                ? 'Saving...'
                                : isEditing
                                    ? 'Update Coupon'
                                    : 'Create Coupon',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    );
  }
}

// ─── Store Dropdown ─────────────────────────────────────────
class _StoreDropdown extends GetView<SellerCouponsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.stores.isEmpty) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
              color: MarketplaceDesignTokens.cardBorder(context)),
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedStoreId.value.isEmpty
                ? null
                : controller.selectedStoreId.value,
            isExpanded: true,
            hint: const Text('Select store'),
            items: controller.stores.map((s) {
              return DropdownMenuItem(
                value: s['_id']?.toString() ?? '',
                child: Text(
                  s['store_name']?.toString() ?? 'Store',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                final store = controller.stores
                    .firstWhere((s) => s['_id']?.toString() == val);
                controller.selectStore(
                    val, store['store_name']?.toString() ?? 'Store');
              }
            },
          ),
        ),
      );
    });
  }
}

class _AddCouponButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCouponButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add', style: TextStyle(fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: MarketplaceDesignTokens.pricePrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MarketplaceDesignTokens.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
    );
  }
}

// ─── Form Field Wrapper ─────────────────────────────────────
class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: MarketplaceDesignTokens.bodyText(context)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? MarketplaceDesignTokens.pricePrimary
                  .withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
          border: Border.all(
            color: selected
                ? MarketplaceDesignTokens.pricePrimary
                : MarketplaceDesignTokens.cardBorder(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? MarketplaceDesignTokens.pricePrimary
                : MarketplaceDesignTokens.textSecondary(context),
          ),
        ),
      ),
    );
  }
}

// ─── Coupon Card ────────────────────────────────────────────
class _CouponCard extends StatelessWidget {
  final Map<String, dynamic> coupon;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  const _CouponCard({
    required this.coupon,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final code = coupon['coupon_code'] as String? ?? '';
    final type = coupon['discount_type'] as String? ?? 'percentage';
    final amount = coupon['coupon_amount'] ?? 0;
    final status = coupon['status'] as String? ?? 'active';
    final minAmount = coupon['minimum_amount'] ?? 0;
    final maxDiscount = coupon['max_discount_amount'] ?? 0;
    final usesPerUser = coupon['count_by_user'] ?? 1;
    final startDateStr = coupon['start_date']?.toString() ?? '';
    final endDateStr = coupon['end_date']?.toString() ?? '';
    final isActive = status == 'active';
    final numMaxDiscount = maxDiscount is num ? maxDiscount : (num.tryParse(maxDiscount.toString()) ?? 0);
    final numUsesPerUser = usesPerUser is num ? usesPerUser : (num.tryParse(usesPerUser.toString()) ?? 1);

    return Container(
      margin: const EdgeInsets.only(
          bottom: MarketplaceDesignTokens.gridSpacing),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: code + discount
          Row(
            children: [
              // Coupon code badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: MarketplaceDesignTokens.pricePrimary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                  border: Border.all(
                    color: MarketplaceDesignTokens.pricePrimary
                        .withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: MarketplaceDesignTokens.pricePrimary,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  type == 'percentage' ? '$amount% OFF' : '€$amount OFF',
                  style: MarketplaceDesignTokens.bodyText(context)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),

              // Status + toggle
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? MarketplaceDesignTokens.inStock
                            .withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusSm),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? MarketplaceDesignTokens.inStock
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Details row
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _DetailTag(
                  icon: Icons.shopping_cart_outlined,
                  text: 'Min: €$minAmount'),
              if (type == 'percentage' && numMaxDiscount > 0)
                _DetailTag(
                    icon: Icons.vertical_align_top,
                    text: 'Max: €$maxDiscount'),
              _DetailTag(
                  icon: Icons.person_outline,
                  text: '$usesPerUser use${numUsesPerUser != 1 ? 's' : ''}/user'),
            ],
          ),

          // Date range
          if (startDateStr.isNotEmpty || endDateStr.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '${_formatDate(startDateStr)} — ${_formatDate(endDateStr)}',
              style: TextStyle(
                fontSize: 11,
                color: MarketplaceDesignTokens.textSecondary(context),
              ),
            ),
          ],

          // Edit button
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: MarketplaceDesignTokens.pricePrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '—';
    try {
      final d = DateTime.parse(dateStr);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return dateStr;
    }
  }
}

class _DetailTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailTag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 14,
            color: MarketplaceDesignTokens.textSecondary(context)),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: MarketplaceDesignTokens.textSecondary(context),
          ),
        ),
      ],
    );
  }
}
