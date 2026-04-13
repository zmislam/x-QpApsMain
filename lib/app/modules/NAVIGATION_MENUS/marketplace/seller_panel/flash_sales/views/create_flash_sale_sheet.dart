import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../controllers/flash_sales_controller.dart';

class CreateFlashSaleSheet extends StatefulWidget {
  const CreateFlashSaleSheet({super.key});

  @override
  State<CreateFlashSaleSheet> createState() => _CreateFlashSaleSheetState();
}

class _CreateFlashSaleSheetState extends State<CreateFlashSaleSheet> {
  final SellerRepository _repo = SellerRepository();
  final _ctrl = Get.find<FlashSalesController>();

  final _titleCtrl = TextEditingController();
  String? _selectedStoreId;
  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _endTime = DateTime.now().add(const Duration(hours: 25));

  // Product entries
  final RxList<Map<String, dynamic>> _allProducts =
      <Map<String, dynamic>>[].obs;
  final RxBool _productsLoading = false.obs;
  final RxList<_FlashProduct> _selectedProducts = <_FlashProduct>[].obs;
  final RxBool _saving = false.obs;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProducts(String storeId) async {
    _productsLoading.value = true;
    _selectedProducts.clear();
    final res = await _repo.getMyProducts(skip: 0, limit: 100);
    _productsLoading.value = false;
    if (res.isSuccessful && res.data is List) {
      _allProducts.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .where((p) {
        final pStore = p['store_id'];
        final pStoreId =
            pStore is Map ? pStore['_id']?.toString() : pStore?.toString();
        return pStoreId == storeId;
      }).toList();
    } else {
      _allProducts.clear();
    }
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startTime : _endTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
    );
    if (time == null) return;
    final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStart) {
        _startTime = dt;
        if (_endTime.isBefore(_startTime.add(const Duration(hours: 1)))) {
          _endTime = _startTime.add(const Duration(hours: 24));
        }
      } else {
        _endTime = dt;
      }
    });
  }

  void _addProduct() {
    if (_allProducts.isEmpty) return;
    _selectedProducts.add(_FlashProduct());
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      showErrorSnackkbar(message: 'Enter a title');
      return;
    }
    if (_selectedStoreId == null) {
      showErrorSnackkbar(message: 'Select a store');
      return;
    }
    if (_selectedProducts.isEmpty) {
      showErrorSnackkbar(message: 'Add at least one product');
      return;
    }
    for (final p in _selectedProducts) {
      if (p.productId == null || p.flashPrice <= 0 || p.originalPrice <= 0) {
        showErrorSnackkbar(
            message: 'Fill in all product fields (product, prices)');
        return;
      }
    }

    _saving.value = true;
    final data = {
      'store_id': _selectedStoreId,
      'title': _titleCtrl.text.trim(),
      'start_time': _startTime.toIso8601String(),
      'end_time': _endTime.toIso8601String(),
      'products': _selectedProducts
          .map((p) => {
                'product_id': p.productId,
                'flash_price': p.flashPrice,
                'original_price': p.originalPrice,
                if (p.quantityLimit != null)
                  'quantity_limit': p.quantityLimit,
              })
          .toList(),
    };
    await _ctrl.createFlashSale(data);
    _saving.value = false;
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
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
          children: [
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
            Text('Create Flash Sale',
                style: MarketplaceDesignTokens.heading(context)),
            const SizedBox(height: 20),

            // ── Title ──
            _label('Title'),
            const SizedBox(height: 8),
            TextField(
              controller: _titleCtrl,
              decoration: _inputDeco('e.g. Summer Flash Deal'),
            ),
            const SizedBox(height: 16),

            // ── Store ──
            _label('Store'),
            const SizedBox(height: 8),
            Obx(() {
              if (_ctrl.isStoresLoading.value) {
                return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2));
              }
              return DropdownButtonFormField<String>(
                initialValue: _selectedStoreId,
                decoration: _inputDeco('Select store'),
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

            // ── Schedule ──
            _label('Schedule'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child: _DateTimeTile(
                  label: 'Start',
                  dt: _startTime,
                  onTap: () => _pickDateTime(true),
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _DateTimeTile(
                  label: 'End',
                  dt: _endTime,
                  onTap: () => _pickDateTime(false),
                )),
              ],
            ),
            const SizedBox(height: 20),

            // ── Products ──
            Row(
              children: [
                Expanded(child: _label('Products')),
                TextButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                      foregroundColor: MarketplaceDesignTokens.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (_productsLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_selectedProducts.isEmpty) {
                return Text('Tap "Add" to add products',
                    style: MarketplaceDesignTokens.cardSubtext(context));
              }
              return Column(
                children: List.generate(_selectedProducts.length, (i) {
                  return _ProductEntry(
                    index: i,
                    fp: _selectedProducts[i],
                    allProducts: _allProducts,
                    onRemove: () => _selectedProducts.removeAt(i),
                    onChange: () => _selectedProducts.refresh(),
                  );
                }),
              );
            }),
            const SizedBox(height: 24),

            // ── Submit ──
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
                        : const Text('Create Flash Sale',
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

  Widget _label(String text) => Text(text,
      style: MarketplaceDesignTokens.bodyText(context)
          .copyWith(fontWeight: FontWeight.w600));

  InputDecoration _inputDeco(String hint) => InputDecoration(
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

// ── Flash product mutable holder ──
class _FlashProduct {
  String? productId;
  double flashPrice = 0;
  double originalPrice = 0;
  int? quantityLimit;
}

// ── Product entry row ──
class _ProductEntry extends StatelessWidget {
  final int index;
  final _FlashProduct fp;
  final RxList<Map<String, dynamic>> allProducts;
  final VoidCallback onRemove;
  final VoidCallback onChange;

  const _ProductEntry({
    required this.index,
    required this.fp,
    required this.allProducts,
    required this.onRemove,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('#${index + 1}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.textSecondary(context))),
              const Spacer(),
              InkWell(
                onTap: onRemove,
                child: const Icon(Icons.close, size: 18, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
                initialValue: fp.productId,
                decoration: const InputDecoration(
                  hintText: 'Select product',
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                items: allProducts
                    .map((p) => DropdownMenuItem(
                          value: p['_id']?.toString(),
                          child: Text(
                            p['product_name']?.toString() ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (v) {
                  fp.productId = v;
                  // auto-fill original price
                  final prod = allProducts.firstWhereOrNull(
                      (p) => p['_id']?.toString() == v);
                  if (prod != null) {
                    final price =
                        (prod['base_selling_price'] as num?)?.toDouble() ?? 0;
                    fp.originalPrice = price;
                    fp.flashPrice = (price * 0.8); // default 20% off
                  }
                  onChange();
                },
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Flash €',
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController(
                      text: fp.flashPrice > 0
                          ? fp.flashPrice.toStringAsFixed(2)
                          : ''),
                  onChanged: (v) {
                    fp.flashPrice = double.tryParse(v) ?? 0;
                    onChange();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Original €',
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController(
                      text: fp.originalPrice > 0
                          ? fp.originalPrice.toStringAsFixed(2)
                          : ''),
                  onChanged: (v) {
                    fp.originalPrice = double.tryParse(v) ?? 0;
                    onChange();
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 70,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Qty',
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    fp.quantityLimit = int.tryParse(v);
                    onChange();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── DateTime Tile ──
class _DateTimeTile extends StatelessWidget {
  final String label;
  final DateTime dt;
  final VoidCallback onTap;
  const _DateTimeTile({
    required this.label,
    required this.dt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color:
                        MarketplaceDesignTokens.textSecondary(context))),
            const SizedBox(height: 2),
            Text(
              '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MarketplaceDesignTokens.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
