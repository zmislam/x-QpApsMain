import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../components/shimmer_loaders/product_detail_shimmer_loader.dart';
import '../controllers/product_details_controller.dart';
import '../widgets/product_details_main_view_widgets/product_images_section.dart';
import '../widgets/product_details_main_view_widgets/product_header_section.dart';
import '../widgets/product_details_main_view_widgets/product_rating_widget.dart';
import '../widgets/product_details_main_view_widgets/store_info_widget.dart';
import '../widgets/product_details_main_view_widgets/variant_selector_section.dart';
import '../widgets/product_details_main_view_widgets/related_products_section.dart';
import '../widgets/product_details_main_view_widgets/quick_message_section.dart';
import '../widgets/product_details_main_view_widgets/location_section.dart';
import '../widgets/product_details_tab_view.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: Text(
          'Product Details'.tr,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            final p = controller.product.value;
            if (p == null) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    controller.marketPlaceController.addToWishlist(
                      productId: p.id ?? '',
                      storeId: p.storeId ?? '',
                      productVariantId: p.productVariant?.first.id ?? '',
                    ).then((value) {
                      if (value == true) {
                        p.wishProduct = !(p.wishProduct ?? false);
                        controller.product.refresh();
                      }
                    });
                  },
                  icon: Icon(
                    (p.wishProduct ?? false)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: (p.wishProduct ?? false)
                        ? Colors.red
                        : null,
                    size: 22,
                  ),
                ),
                IconButton(
                  onPressed: controller.shareProduct,
                  icon: const Icon(Icons.share_outlined, size: 22),
                ),
              ],
            );
          }),
        ],
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.product.value == null) {
          return const ProductDetailShimmerLoader();
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Hero Image Carousel ──────────────
                    const ProductImagesSection(),
                    const SizedBox(height: MarketplaceDesignTokens.spacingMd),

                    // ─── Badges + Name + Rating + Price ──
                    const ProductHeaderSection(),
                    const SizedBox(height: MarketplaceDesignTokens.spacingSm),

                    // ─── Rating ──────────────────────────
                    const ProductRatingSection(),
                    const SizedBox(height: MarketplaceDesignTokens.spacingMd),

                    // ─── Variant Selector (inline chips) ─
                    Obx(() => controller.hasVariants
                        ? const VariantSelectorSection()
                        : const SizedBox.shrink()),
                    const SizedBox(height: MarketplaceDesignTokens.spacingMd),

                    // ─── Store Info Card ─────────────────
                    const StoreInfoCard(),
                    const SizedBox(height: MarketplaceDesignTokens.spacingMd),

                    // ─── Location ────────────────────────
                    const LocationSection(),
                    const SizedBox(height: MarketplaceDesignTokens.spacingMd),

                    // ─── Tabs: Description / Specs / Reviews / Q&A
                    const ProductDetailsTabSection(),
                    const SizedBox(height: MarketplaceDesignTokens.spacingMd),

                    // ─── Quick Message ───────────────────
                    const QuickMessageSection(),
                    const SizedBox(height: MarketplaceDesignTokens.spacingMd),

                    // ─── Related Products ────────────────
                    const RelatedProductsSection(),
                    const SizedBox(height: 100), // space for bottom bar
                  ],
                ),
              ),
            ),

            // ─── Sticky Bottom Bar ───────────────────────
            _buildBottomBar(context),
          ],
        );
      }),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: MarketplaceDesignTokens.spacingMd,
        right: MarketplaceDesignTokens.spacingMd,
        top: MarketplaceDesignTokens.spacingSm,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.cardBg(context),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final inStock = controller.isInStock;
        return Row(
          children: [
            // Quantity Control
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: MarketplaceDesignTokens.primary.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _qtyButton(Icons.remove, controller.decrementQuantity),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${controller.productQuantity.value}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _qtyButton(Icons.add, controller.incrementQuantity),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Add to Cart
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: inStock
                      ? () {
                          controller.marketPlaceController.addToCartPost(
                            productId: controller.product.value?.id,
                            storeId: controller.product.value?.storeId,
                            productVariantId:
                                controller.selectedProductVariantId.value,
                            quantity: controller.productQuantity.value,
                          );
                        }
                      : null,
                  icon: Icon(
                    inStock
                        ? Icons.shopping_cart_outlined
                        : Icons.remove_shopping_cart,
                    size: 20,
                  ),
                  label: Text(
                    inStock ? 'Add to Cart'.tr : 'Out of Stock'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: inStock
                        ? MarketplaceDesignTokens.primary
                        : MarketplaceDesignTokens.outOfStock,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return Semantics(
      button: true,
      label: icon == Icons.add ? 'Increase quantity' : 'Decrease quantity',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: MarketplaceDesignTokens.primary),
        ),
      ),
    );
  }
}
