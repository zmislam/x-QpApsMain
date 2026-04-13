import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/product_details_controller.dart';
import 'product_details_tab_view_separated/description_tab_view.dart';
import 'product_details_tab_view_separated/specification_tab_view.dart';
import 'product_details_tab_view_separated/reviews_tab_view.dart';
import 'product_details_tab_view_separated/qa_tab_view.dart';

class ProductDetailsTabSection extends GetView<ProductDetailsController> {
  const ProductDetailsTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: MarketplaceDesignTokens.spacingMd),
      child: Column(
        children: [
          // ─── Tab Bar ──────────────────────────
          Container(
            decoration: BoxDecoration(
              color: MarketplaceDesignTokens.cardBg(context),
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
              border: Border.all(
                  color: MarketplaceDesignTokens.cardBorder(context)),
            ),
            child: TabBar(
              controller: controller.tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicator: BoxDecoration(
                color: MarketplaceDesignTokens.primary,
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor:
                  MarketplaceDesignTokens.textSecondary(context),
              labelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(3),
              tabs: [
                Tab(text: 'Description'.tr),
                Tab(text: 'Specs'.tr),
                Tab(text: 'Reviews'.tr),
                Tab(text: 'Q&A'.tr),
              ],
            ),
          ),
          const SizedBox(height: MarketplaceDesignTokens.spacingSm),

          // ─── Tab Content (no fixed height) ────
          Obx(() {
            final index = controller.currentTabIndex.value;
            switch (index) {
              case 0:
                return const ProductDescriptionTabContent();
              case 1:
                return const SpecificationTabContent();
              case 2:
                return const ProductReviewsTabContent();
              case 3:
                return const QATabContent();
              default:
                return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
