import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/product_settings_controller.dart';

class ProductSettingsView extends GetView<ProductSettingsController> {
  const ProductSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Sub-tabs: Attributes | Colors ───
        Obx(() => Padding(
              padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
              child: Row(
                children: [
                  _chip(context, 'Attributes', 0),
                  const SizedBox(width: MarketplaceDesignTokens.spacingSm),
                  _chip(context, 'Colors', 1),
                ],
              ),
            )),
        Expanded(
          child: Obx(() => controller.tabIndex.value == 0
              ? _attributesTab(context)
              : _colorsTab(context)),
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, int index) {
    final selected = controller.tabIndex.value == index;
    return GestureDetector(
      onTap: () => controller.tabIndex.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? MarketplaceDesignTokens.primary
              : MarketplaceDesignTokens.primary.withValues(alpha: 0.08),
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
        ),
        child: Text(label,
            style: TextStyle(
              color: selected ? Colors.white : MarketplaceDesignTokens.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ATTRIBUTES TAB
  // ═══════════════════════════════════════════════════════════
  Widget _attributesTab(BuildContext context) {
    if (controller.isAttrLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        if (controller.attributes.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tune_outlined,
                    size: 64,
                    color: MarketplaceDesignTokens.textSecondary(context)),
                const SizedBox(height: 16),
                Text('No attributes yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    )),
                const SizedBox(height: 4),
                Text('Tap + to add size, material, etc.',
                    style: MarketplaceDesignTokens.cardSubtext(context)),
              ],
            ),
          )
        else
          RefreshIndicator(
            onRefresh: controller.fetchAttributes,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              itemCount: controller.attributes.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: MarketplaceDesignTokens.spacingSm),
              itemBuilder: (ctx, i) =>
                  _attributeCard(ctx, controller.attributes[i]),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            heroTag: 'add_attr',
            backgroundColor: MarketplaceDesignTokens.primary,
            onPressed: () => _showAttributeSheet(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _attributeCard(BuildContext context, Map<String, dynamic> attr) {
    final name = attr['name']?.toString() ?? '';
    final values = attr['value'];
    final isRequired = attr['is_required'] == true;
    final id = attr['_id']?.toString() ?? '';

    // Parse value map
    final valueEntries = <String>[];
    if (values is Map) {
      for (final v in values.values) {
        valueEntries.add(v.toString());
      }
    }

    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: MarketplaceDesignTokens.textPrimary(context),
                        )),
                    if (isRequired) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Required',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
                if (valueEntries.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: valueEntries
                        .map((v) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: MarketplaceDesignTokens.primary
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(
                                    MarketplaceDesignTokens.radiusSm),
                              ),
                              child: Text(v,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color:
                                          MarketplaceDesignTokens.primary)),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (action) {
              if (action == 'edit') {
                _showAttributeSheet(context, existing: attr);
              } else if (action == 'delete') {
                _confirmDelete(context, () => controller.deleteAttribute(id));
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  void _showAttributeSheet(BuildContext context,
      {Map<String, dynamic>? existing}) {
    final isEdit = existing != null;
    final nameCtrl =
        TextEditingController(text: isEdit ? existing['name']?.toString() : '');
    final valuesCtrl = TextEditingController();
    final isRequired = (existing?['is_required'] == true).obs;

    // Pre-fill values as comma-separated key:val pairs
    if (isEdit && existing['value'] is Map) {
      final entries = (existing['value'] as Map)
          .entries
          .map((e) => '${e.key}:${e.value}')
          .join(', ');
      valuesCtrl.text = entries;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: MarketplaceDesignTokens.spacingMd,
          right: MarketplaceDesignTokens.spacingMd,
          top: MarketplaceDesignTokens.spacingMd,
          bottom: MediaQuery.of(ctx).viewInsets.bottom +
              MarketplaceDesignTokens.spacingMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEdit ? 'Edit Attribute' : 'New Attribute',
                style: MarketplaceDesignTokens.sectionTitle(ctx)),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Name (e.g. Size)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingSm),
            TextField(
              controller: valuesCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Values (key:label, comma separated)',
                hintText: 'S:Small, M:Medium, L:Large',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingSm),
            Obx(() => CheckboxListTile(
                  value: isRequired.value,
                  onChanged: (v) => isRequired.value = v ?? false,
                  title: const Text('Required attribute'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                )),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isSaving.value
                        ? null
                        : () {
                            final name = nameCtrl.text.trim();
                            if (name.isEmpty) return;
                            final valMap = _parseKeyValuePairs(valuesCtrl.text);
                            if (isEdit) {
                              controller
                                  .updateAttribute(
                                      existing['_id'].toString(), name, valMap)
                                  .then((_) => Navigator.pop(ctx));
                            } else {
                              controller
                                  .saveAttribute(
                                      name, valMap, isRequired.value)
                                  .then((_) => Navigator.pop(ctx));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketplaceDesignTokens.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                      ),
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(isEdit ? 'Update' : 'Create',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Map<String, String> _parseKeyValuePairs(String text) {
    final result = <String, String>{};
    final parts = text.split(',');
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      final colonIdx = trimmed.indexOf(':');
      if (colonIdx > 0) {
        result[trimmed.substring(0, colonIdx).trim()] =
            trimmed.substring(colonIdx + 1).trim();
      } else {
        // No colon — use value as both key and label
        result[trimmed] = trimmed;
      }
    }
    return result;
  }

  // ═══════════════════════════════════════════════════════════
  // COLORS TAB
  // ═══════════════════════════════════════════════════════════
  Widget _colorsTab(BuildContext context) {
    if (controller.isColorLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        if (controller.colors.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.palette_outlined,
                    size: 64,
                    color: MarketplaceDesignTokens.textSecondary(context)),
                const SizedBox(height: 16),
                Text('No colors yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    )),
                const SizedBox(height: 4),
                Text('Tap + to add product colors',
                    style: MarketplaceDesignTokens.cardSubtext(context)),
              ],
            ),
          )
        else
          RefreshIndicator(
            onRefresh: controller.fetchColors,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              itemCount: controller.colors.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: MarketplaceDesignTokens.spacingSm),
              itemBuilder: (ctx, i) =>
                  _colorCard(ctx, controller.colors[i]),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            heroTag: 'add_color',
            backgroundColor: MarketplaceDesignTokens.primary,
            onPressed: () => _showColorSheet(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _colorCard(BuildContext context, Map<String, dynamic> color) {
    final name = color['name']?.toString() ?? '';
    final hex = color['value']?.toString() ?? '#000000';
    final id = color['_id']?.toString() ?? '';
    final parsedColor = _hexToColor(hex);

    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: parsedColor,
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
              border: Border.all(
                  color: MarketplaceDesignTokens.cardBorder(context)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    )),
                Text(hex.toUpperCase(),
                    style: MarketplaceDesignTokens.cardSubtext(context)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (action) {
              if (action == 'edit') {
                _showColorSheet(context, existing: color);
              } else if (action == 'delete') {
                _confirmDelete(context, () => controller.deleteColor(id));
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  void _showColorSheet(BuildContext context,
      {Map<String, dynamic>? existing}) {
    final isEdit = existing != null;
    final nameCtrl = TextEditingController(
        text: isEdit ? existing['name']?.toString() : '');
    final hexCtrl = TextEditingController(
        text: isEdit ? existing['value']?.toString() : '#');
    final previewColor = Rx<Color>(_hexToColor(hexCtrl.text));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: MarketplaceDesignTokens.spacingMd,
          right: MarketplaceDesignTokens.spacingMd,
          top: MarketplaceDesignTokens.spacingMd,
          bottom: MediaQuery.of(ctx).viewInsets.bottom +
              MarketplaceDesignTokens.spacingMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEdit ? 'Edit Color' : 'New Color',
                style: MarketplaceDesignTokens.sectionTitle(ctx)),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Color Name (e.g. Red)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingSm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hexCtrl,
                    decoration: InputDecoration(
                      labelText: 'Hex Value',
                      hintText: '#FF0000',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                      ),
                    ),
                    onChanged: (v) =>
                        previewColor.value = _hexToColor(v),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(() => Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: previewColor.value,
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                        border: Border.all(
                            color:
                                MarketplaceDesignTokens.cardBorder(ctx)),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),
            // Quick-pick palette
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '#FF0000', '#FF5722', '#FF9800', '#FFEB3B',
                '#4CAF50', '#009688', '#2196F3', '#3F51B5',
                '#9C27B0', '#E91E63', '#795548', '#607D8B',
                '#000000', '#FFFFFF',
              ]
                  .map((hex) => GestureDetector(
                        onTap: () {
                          hexCtrl.text = hex;
                          previewColor.value = _hexToColor(hex);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _hexToColor(hex),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isSaving.value
                        ? null
                        : () {
                            final name = nameCtrl.text.trim();
                            final hex = hexCtrl.text.trim();
                            if (name.isEmpty || hex.isEmpty) return;
                            if (isEdit) {
                              controller
                                  .updateColor(
                                      existing['_id'].toString(), name, hex)
                                  .then((_) => Navigator.pop(ctx));
                            } else {
                              controller
                                  .saveColor(name, hex)
                                  .then((_) => Navigator.pop(ctx));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketplaceDesignTokens.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                      ),
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(isEdit ? 'Update' : 'Create',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // ─── Shared helpers ───
  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    final clean = hex.replaceAll('#', '').trim();
    if (clean.length == 6) {
      return Color(int.parse('FF$clean', radix: 16));
    }
    if (clean.length == 8) {
      return Color(int.parse(clean, radix: 16));
    }
    return Colors.grey;
  }
}
