import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../controllers/seller_promotions_controller.dart';

/// Bottom sheet for creating a new promotion with budget estimator.
class CreatePromotionSheet extends StatefulWidget {
  const CreatePromotionSheet({super.key});

  @override
  State<CreatePromotionSheet> createState() => _CreatePromotionSheetState();
}

class _CreatePromotionSheetState extends State<CreatePromotionSheet> {
  final SellerRepository _repo = SellerRepository();
  final _ctrl = Get.find<SellerPromotionsController>();

  // Form state
  String _promotionType = 'boost_product';
  String? _selectedStoreId;
  String? _selectedProductId;
  final String _billingType = 'daily_flat';
  String _paymentMethod = 'wallet';
  final _dailyBudgetCtrl = TextEditingController(text: '5.00');
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 8));
  final List<String> _placements = ['search_results', 'category_page'];

  // Products for selected store
  final RxList<Map<String, dynamic>> _products = <Map<String, dynamic>>[].obs;
  final RxBool _productsLoading = false.obs;

  // Estimate
  final RxMap<String, dynamic> _estimate = <String, dynamic>{}.obs;
  final RxBool _estimateLoading = false.obs;

  // Save
  final RxBool _saving = false.obs;

  @override
  void dispose() {
    _dailyBudgetCtrl.dispose();
    super.dispose();
  }

  int get _durationDays {
    return _endDate.difference(_startDate).inDays.clamp(1, 365);
  }

  int get _dailyBudgetCents {
    final val = double.tryParse(_dailyBudgetCtrl.text) ?? 0;
    return (val * 100).round();
  }

  double get _totalBudget {
    return (_dailyBudgetCents * _durationDays) / 100;
  }

  Future<void> _loadProducts(String storeId) async {
    _productsLoading.value = true;
    _selectedProductId = null;
    final res = await _repo.getMyProducts(skip: 0, limit: 100);
    _productsLoading.value = false;
    if (res.isSuccessful && res.data is List) {
      // Filter products by selected store
      _products.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .where((p) {
        final pStore = p['store_id'];
        final pStoreId =
            pStore is Map ? pStore['_id']?.toString() : pStore?.toString();
        return pStoreId == storeId;
      }).toList();
    } else {
      _products.clear();
    }
  }

  Future<void> _fetchEstimate() async {
    if (_dailyBudgetCents < 100) return;
    _estimateLoading.value = true;
    final res = await _repo.estimatePromotionCost(
      promotionType: _promotionType,
      durationDays: _durationDays,
      dailyBudgetCents: _dailyBudgetCents,
    );
    _estimateLoading.value = false;
    if (res.isSuccessful && res.data is Map) {
      _estimate.value = Map<String, dynamic>.from(res.data as Map);
    }
  }

  Future<void> _submit() async {
    if (_selectedStoreId == null) {
      showErrorSnackkbar(message: 'Please select a store');
      return;
    }
    if (_promotionType != 'promote_store' && _selectedProductId == null) {
      showErrorSnackkbar(message: 'Please select a product');
      return;
    }
    if (_dailyBudgetCents < 100) {
      showErrorSnackkbar(message: 'Min daily budget is €1.00');
      return;
    }

    _saving.value = true;
    final data = <String, dynamic>{
      'promotion_type': _promotionType,
      'store_id': _selectedStoreId,
      'daily_budget_cents': _dailyBudgetCents,
      'start_date': _startDate.toIso8601String(),
      'end_date': _endDate.toIso8601String(),
      'placements': _placements,
      'billing_type': _billingType,
      'payment_method': _paymentMethod,
    };
    if (_promotionType != 'promote_store') {
      data['product_id'] = _selectedProductId;
    }

    final res = await _repo.createPromotion(promotionData: data);
    _saving.value = false;

    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Promotion created');
      _ctrl.fetchPromotions(refresh: true);
      Get.back();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to create promotion');
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate.add(const Duration(days: 1)))) {
            _endDate = _startDate.add(const Duration(days: 7));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: MarketplaceDesignTokens.cardBg(context),
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(MarketplaceDesignTokens.radiusLg)),
        ),
        child: ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Create Promotion',
                style: MarketplaceDesignTokens.heading(context)),
            const SizedBox(height: 20),

            // ── Promotion Type ──
            _SectionLabel('Promotion Type'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _typeChip('Boost Product', 'boost_product',
                    Icons.rocket_launch_outlined),
                _typeChip('Featured Product', 'featured_product',
                    Icons.star_outline),
                _typeChip(
                    'Promote Store', 'promote_store', Icons.storefront_outlined),
              ],
            ),
            const SizedBox(height: 16),

            // ── Store Selector ──
            _SectionLabel('Store'),
            const SizedBox(height: 8),
            Obx(() {
              if (_ctrl.isStoresLoading.value) {
                return const Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)));
              }
              return DropdownButtonFormField<String>(
                initialValue: _selectedStoreId,
                decoration: _inputDecoration('Select store'),
                items: _ctrl.stores
                    .map((s) => DropdownMenuItem(
                          value: s['_id']?.toString(),
                          child: Text(s['name']?.toString() ?? 'Untitled'),
                        ))
                    .toList(),
                onChanged: (v) {
                  setState(() => _selectedStoreId = v);
                  if (v != null) _loadProducts(v);
                },
              );
            }),
            const SizedBox(height: 16),

            // ── Product Selector (for product promotions) ──
            if (_promotionType != 'promote_store') ...[
              _SectionLabel('Product'),
              const SizedBox(height: 8),
              Obx(() {
                if (_productsLoading.value) {
                  return const Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)));
                }
                if (_products.isEmpty) {
                  return Text('Select a store first',
                      style: MarketplaceDesignTokens.cardSubtext(context));
                }
                return DropdownButtonFormField<String>(
                  initialValue: _selectedProductId,
                  decoration: _inputDecoration('Select product'),
                  items: _products
                      .map((p) => DropdownMenuItem(
                            value: p['_id']?.toString(),
                            child: Text(
                              p['product_name']?.toString() ?? 'Untitled',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedProductId = v),
                );
              }),
              const SizedBox(height: 16),
            ],

            // ── Budget ──
            _SectionLabel('Daily Budget (€)'),
            const SizedBox(height: 8),
            TextField(
              controller: _dailyBudgetCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('e.g. 5.00'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // ── Date Range ──
            _SectionLabel('Schedule'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DatePicker(
                    label: 'Start',
                    date: _startDate,
                    onTap: () => _pickDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DatePicker(
                    label: 'End',
                    date: _endDate,
                    onTap: () => _pickDate(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$_durationDays days • Total: €${_totalBudget.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MarketplaceDesignTokens.pricePrimary,
              ),
            ),
            const SizedBox(height: 16),

            // ── Placements ──
            _SectionLabel('Placements'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _placementChip('Search Results', 'search_results'),
                _placementChip('Category Page', 'category_page'),
                _placementChip('Homepage', 'homepage_carousel'),
                _placementChip('Product Detail', 'product_detail'),
                _placementChip('Newsfeed', 'newsfeed'),
              ],
            ),
            const SizedBox(height: 16),

            // ── Payment Method ──
            _SectionLabel('Payment'),
            const SizedBox(height: 8),
            Row(
              children: [
                _paymentChip('Wallet', 'wallet', Icons.account_balance_wallet),
                const SizedBox(width: 8),
                _paymentChip('Stripe', 'stripe', Icons.credit_card),
              ],
            ),
            const SizedBox(height: 16),

            // ── Estimate Button ──
            OutlinedButton.icon(
              onPressed: _fetchEstimate,
              icon: const Icon(Icons.calculate_outlined, size: 18),
              label: const Text('Get Cost Estimate'),
              style: OutlinedButton.styleFrom(
                foregroundColor: MarketplaceDesignTokens.primary,
                side: const BorderSide(
                    color: MarketplaceDesignTokens.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusMd),
                ),
              ),
            ),
            Obx(() {
              if (_estimateLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (_estimate.isEmpty) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(top: 12),
                padding:
                    const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
                decoration: MarketplaceDesignTokens.cardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimated Cost',
                        style: MarketplaceDesignTokens.sectionTitle(context)),
                    const SizedBox(height: 8),
                    ..._estimate.entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  e.key
                                      .replaceAll('_', ' ')
                                      .capitalizeFirst ??
                                      e.key,
                                  style: MarketplaceDesignTokens.bodyTextSmall(
                                      context)),
                              Text(
                                e.value is num
                                    ? '€${((e.value as num) / 100).toStringAsFixed(2)}'
                                    : e.value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: MarketplaceDesignTokens.textPrimary(
                                      context),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // ── Submit Button ──
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketplaceDesignTokens.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusMd),
                      ),
                    ),
                    child: _saving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Create Promotion',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Chip Builders ──
  Widget _typeChip(String label, String value, IconData icon) {
    final active = _promotionType == value;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16,
              color: active
                  ? MarketplaceDesignTokens.primary
                  : MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: active,
      onSelected: (_) => setState(() => _promotionType = value),
      selectedColor:
          MarketplaceDesignTokens.primary.withValues(alpha: 0.12),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        color: active
            ? MarketplaceDesignTokens.primary
            : MarketplaceDesignTokens.textSecondary(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
    );
  }

  Widget _placementChip(String label, String value) {
    final active = _placements.contains(value);
    return FilterChip(
      label: Text(label),
      selected: active,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _placements.add(value);
          } else {
            _placements.remove(value);
          }
        });
      },
      selectedColor:
          MarketplaceDesignTokens.primary.withValues(alpha: 0.12),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        color: active
            ? MarketplaceDesignTokens.primary
            : MarketplaceDesignTokens.textSecondary(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
    );
  }

  Widget _paymentChip(String label, String value, IconData icon) {
    final active = _paymentMethod == value;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16,
              color: active
                  ? MarketplaceDesignTokens.primary
                  : MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: active,
      onSelected: (_) => setState(() => _paymentMethod = value),
      selectedColor:
          MarketplaceDesignTokens.primary.withValues(alpha: 0.12),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        color: active
            ? MarketplaceDesignTokens.primary
            : MarketplaceDesignTokens.textSecondary(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}

// ── Section Label ──
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: MarketplaceDesignTokens.bodyText(context)
          .copyWith(fontWeight: FontWeight.w600),
    );
  }
}

// ── Date Picker Tile ──
class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  const _DatePicker({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 16,
                color: MarketplaceDesignTokens.textSecondary(context)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: MarketplaceDesignTokens.textSecondary(
                            context))),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        MarketplaceDesignTokens.textPrimary(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
