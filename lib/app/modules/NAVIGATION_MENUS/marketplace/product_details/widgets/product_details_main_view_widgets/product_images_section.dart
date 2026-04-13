import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../components/custom_cached_image_view.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../controllers/product_details_controller.dart';

class ProductImagesSection extends GetView<ProductDetailsController> {
  const ProductImagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final media = controller.product.value?.media ?? [];
      if (media.isEmpty) {
        return Container(
          height: 300,
          width: double.infinity,
          color: MarketplaceDesignTokens.cardBg(context),
          child: Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.contain),
        );
      }

      return SizedBox(
        height: 320,
        child: Stack(
          children: [
            // ─── Full-width PageView carousel ─────
            PageView.builder(
              controller: controller.imagePageController,
              itemCount: media.length,
              onPageChanged: (i) => controller.currentImageIndex.value = i,
              itemBuilder: (context, index) {
                return CustomCachedNetworkImage(
                  imageUrl: media[index].formatedProductUrlLive,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorWidget: Image.asset(
                    AppAssets.DEFAULT_IMAGE,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  placeholderImage: AppAssets.DEFAULT_IMAGE,
                );
              },
            ),

            // ─── Dot indicators ───────────────────
            if (media.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    media.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: controller.currentImageIndex.value == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.currentImageIndex.value == i
                            ? MarketplaceDesignTokens.primary
                            : MarketplaceDesignTokens.ratingStarEmpty,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

            // ─── Image counter badge ──────────────
            if (media.length > 1)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.currentImageIndex.value + 1}/${media.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
