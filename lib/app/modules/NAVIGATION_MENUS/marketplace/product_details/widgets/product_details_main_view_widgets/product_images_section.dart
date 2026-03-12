import 'package:flutter/material.dart';
import '../../controllers/product_details_controller.dart';

import '../../../components/productlist_carusel_slider.dart';
import '../../../components/wishlist_icon_button.dart';

class ProductImagesSection extends StatelessWidget {
  final ProductDetailsController controller;

  const ProductImagesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return // ============================================================== Product Corusel Slider ==============================================================
        Stack(
      children: [
        ProductListCarouselSlider(
          mediaList: controller.productDetailsList.value.isNotEmpty &&
                  controller.productDetailsList.value.first.media != null
              ? controller.productDetailsList.value.first.media!
              : [],
        ),
        // ============================================================== Wishlist Icon ==============================================================

        WishlistIconButton(
            topPosition: 15,
            rightPosition: 20,
            isWishListed:
                controller.productDetailsList.value.first.wishProduct ?? false,
            onPressed: () {
              controller.marketPlaceController
                  .addToWishlist(
                productId: controller.productDetailsList.value.first.id ?? '',
                storeId:
                    controller.productDetailsList.value.first.storeId ?? '',
                productVariantId: controller.productDetailsList.value.first
                        .productVariant?.first.id ??
                    '',
              )
                  .then((value) {
                if (value == true) {
                  controller.productDetailsList.value.first.wishProduct =
                      !controller.productDetailsList.value.first.wishProduct!;
                  controller.productDetailsList.refresh();
                }
              });
            }),
      ],
    );
  }
}
