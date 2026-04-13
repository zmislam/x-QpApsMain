import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../controllers/product_details_controller.dart';

class QuickMessageSection extends GetView<ProductDetailsController> {
  const QuickMessageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: MarketplaceDesignTokens.spacingMd),
      child: Container(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.chat_bubble_outline,
                    size: 20, color: MarketplaceDesignTokens.primary),
                const SizedBox(width: 8),
                Text(
                  'Quick Message to Seller'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageTextController,
                    decoration: InputDecoration(
                      hintText: 'Ask about this product...'.tr,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: MarketplaceDesignTokens.textSecondary(context),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                        borderSide: BorderSide(
                            color:
                                MarketplaceDesignTokens.cardBorder(context)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                        borderSide: BorderSide(
                            color:
                                MarketplaceDesignTokens.cardBorder(context)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                        borderSide: const BorderSide(
                            color: MarketplaceDesignTokens.primary),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: controller.sendQuickMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketplaceDesignTokens.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Icon(Icons.send, size: 20),
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
