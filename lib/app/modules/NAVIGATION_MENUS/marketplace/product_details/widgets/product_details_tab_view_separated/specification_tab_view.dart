import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../controllers/product_details_controller.dart';

class SpecificationTabContent extends GetView<ProductDetailsController> {
  const SpecificationTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final specs = controller.product.value?.specification ?? [];
    if (specs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No specifications available'.tr,
            style: MarketplaceDesignTokens.cardSubtext(context),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: MarketplaceDesignTokens.spacingSm),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
        },
        border: TableBorder(
          horizontalInside: BorderSide(
            color: MarketplaceDesignTokens.divider(context),
          ),
        ),
        children: specs.map((spec) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  spec.label ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  spec.value ?? 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
