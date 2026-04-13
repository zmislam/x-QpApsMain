import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../controllers/product_details_controller.dart';

class ProductDescriptionTabContent extends GetView<ProductDetailsController> {
  const ProductDescriptionTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final desc = controller.product.value?.description;
    if (desc == null || desc.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No description available'.tr,
            style: MarketplaceDesignTokens.cardSubtext(context),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: MarketplaceDesignTokens.spacingSm),
      child: HtmlWidget(
        '<div style="color: #4A4A4A; text-align: justify;">${desc.replaceAll('\n', '<br />')}</div>',
        textStyle: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: MarketplaceDesignTokens.textPrimary(context),
        ),
      ),
    );
  }
}
