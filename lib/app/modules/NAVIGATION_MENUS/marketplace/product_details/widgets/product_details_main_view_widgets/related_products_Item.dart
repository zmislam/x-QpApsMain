import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../config/constants/color.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../../components/wishlist_icon_button.dart';
import '../../controllers/product_details_controller.dart';
import '../../models/related_product_model.dart';

class RelatedProductComponent extends StatelessWidget {
  final ProductDetailsController controller;
  final AllRelatedProducts relatedProduct;
  const RelatedProductComponent(
      {super.key, required this.controller, required this.relatedProduct});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.getProductDetails(productId: relatedProduct.id);
      },
      child: Container(
        height: Get.height,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage(
                      placeholder: const AssetImage(AppAssets.DEFAULT_IMAGE),
                      image: relatedProduct.media != null &&
                              relatedProduct.media!.isNotEmpty
                          ? NetworkImage(
                              (relatedProduct.media!.first)
                                  .formatedProductUrlLive,
                            )
                          : const AssetImage(AppAssets.DEFAULT_IMAGE)
                              as ImageProvider,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          const Image(
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: AssetImage(AppAssets.DEFAULT_IMAGE),
                      ),
                    ),
                  ),
                  WishlistIconButton(
                    onPressed: () {
                      controller.marketPlaceController
                          .addToWishlist(
                        productId: relatedProduct.id ?? '',
                        storeId: relatedProduct.storeId?.id ?? '',
                        productVariantId:
                            relatedProduct.productVariant?.first.id ?? '',
                      )
                          .then((value) {
                        if (value == true) {
                          relatedProduct.wishProduct =
                              !relatedProduct.wishProduct!;
                          controller.relatedProductList.refresh();
                        }
                      });
                    },
                    isWishListed: relatedProduct.wishProduct ?? false,
                    topPosition: 5,
                    rightPosition: 5,
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // Product Name
              Text(
                relatedProduct.productName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              // Rating and Reviews
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: relatedProduct.productReview?.rating ?? 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 12,
                    ignoreGestures: true,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color(0xFFFF9017),
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${relatedProduct.productReview?.rating ?? '0'} '
                    '(${relatedProduct.productReview?.totalReview ?? '0'} Reviews)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              // Specifications
              SizedBox(
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i < (relatedProduct.specification?.length ?? 0);
                        i++)
                      if (i < 3)
                        Text('\u2022 ${relatedProduct.specification![i].label}: ${relatedProduct.specification![i].value}'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Pricing
              relatedProduct.productVariant != null &&
                      relatedProduct.productVariant!.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('\$${relatedProduct.productVariant?.first.mainPrice}'.tr,
                            style: const TextStyle(
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('\$${relatedProduct.productVariant?.first.sellPrice}'.tr,
                            style: const TextStyle(
                              fontSize: 10,
                              color: PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(height: 20),
              const Spacer(),
              // Add to Cart Button
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: relatedProduct.productVariant != null &&
                            relatedProduct.productVariant!.isNotEmpty &&
                            relatedProduct.totalStock != 0
                        ? PRIMARY_COLOR
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (relatedProduct.totalStock != 0) {
                      controller.marketPlaceController.addToCartPost(
                        productId: relatedProduct.id,
                        storeId: relatedProduct.store?.id,
                        productVariantId:
                            (relatedProduct.productVariant?.isNotEmpty ?? false)
                                ? relatedProduct.productVariant?.first.id
                                : '',
                        quantity: 1,
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      relatedProduct.totalStock != 0
                          ? Image.asset(
                              AppAssets.CART_NAVBAR_ICON,
                              height: 20,
                              width: 20,
                              color: Colors.white,
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        relatedProduct.totalStock == 0
                            ? 'Out of Stock'
                            : 'Add to Cart',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
