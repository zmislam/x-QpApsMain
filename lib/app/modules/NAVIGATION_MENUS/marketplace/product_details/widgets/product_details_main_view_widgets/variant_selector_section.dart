import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../controllers/product_details_controller.dart';

class VariantSelectorSection extends GetView<ProductDetailsController> {
  const VariantSelectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final variants = controller.product.value?.productVariant ?? [];
      if (variants.isEmpty) return const SizedBox.shrink();

      // Group attributes
      Map<String, List<String>> groupedAttributes = {};
      List<Map<String, dynamic>> colorAttributes = [];
      Set<String> uniqueColorNames = {};

      for (var variant in variants) {
        for (var attr in variant.attribute ?? []) {
          if (attr.name != null && attr.value != null) {
            groupedAttributes.putIfAbsent(attr.name!, () => []);
            if (!groupedAttributes[attr.name!]!.contains(attr.value!)) {
              groupedAttributes[attr.name!]!.add(attr.value!);
            }
          }
        }
        if (variant.color?.name != null &&
            variant.color?.value != null &&
            !uniqueColorNames.contains(variant.color!.name!)) {
          uniqueColorNames.add(variant.color!.name!);
          colorAttributes.add({
            'name': variant.color!.name!,
            'hex': variant.color!.value!,
            'id': variant.colorId ?? '',
          });
        }
      }

      if (groupedAttributes.isEmpty && colorAttributes.isEmpty) {
        return const SizedBox.shrink();
      }

      // Auto-select first attributes if none selected
      if (controller.selectedAttributes.isEmpty) {
        final first = variants.first;
        for (var attr in first.attribute ?? []) {
          if (attr.name != null && attr.value != null) {
            controller.selectedAttributes[attr.name!] = attr.value!;
          }
        }
        if (first.color?.name != null) {
          controller.selectedAttributes['Color'] = first.color!.name!;
          controller.selectedColorId.value = first.colorId ?? '';
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: MarketplaceDesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Attribute chips ─────────────────
            ...groupedAttributes.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key}:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MarketplaceDesignTokens.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.value.map((val) {
                        final isSelected =
                            controller.selectedAttributes[entry.key] == val;
                        return ChoiceChip(
                          label: Text(val),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedAttributes[entry.key] = val;
                              controller.fetchPriceBasedOnAttributes();
                            }
                          },
                          selectedColor: MarketplaceDesignTokens.primary,
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : null,
                          ),
                          checkmarkColor: Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? MarketplaceDesignTokens.primary
                                : MarketplaceDesignTokens.ratingStarEmpty,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),

            // ─── Color dots ─────────────────────
            if (colorAttributes.isNotEmpty) ...[
              Text(
                'Color:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MarketplaceDesignTokens.textPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: colorAttributes.map((color) {
                  final isSelected =
                      controller.selectedAttributes['Color'] == color['name'];
                  final colorValue = Color(int.parse(
                      '0xFF${color['hex'].toString().replaceAll('#', '')}'));
                  return GestureDetector(
                    onTap: () {
                      controller.selectedAttributes['Color'] = color['name'];
                      controller.selectedColorId.value = color['id'];
                      controller.fetchPriceBasedOnAttributes();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorValue,
                            border: Border.all(
                              color: isSelected
                                  ? MarketplaceDesignTokens.primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  size: 18, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          color['name'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? MarketplaceDesignTokens.primary
                                : MarketplaceDesignTokens.textSecondary(
                                    context),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      );
    });
  }
}
