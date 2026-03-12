import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../../components/custom_cached_image_view.dart';
import '../../../../../components/button.dart';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../utils/conditional_spacing_text.dart';
import '../../components/wishlist_icon_button.dart';
import '../models/all_product_model.dart';

class ProductGridItem extends StatelessWidget {
  final AllProducts productItem;
  final void Function() onPressedAddToCart;
  final void Function() onPressedAddToWishList;
  final bool isWishListed;
  const ProductGridItem({
    super.key,
    required this.productItem,
    required this.onPressedAddToCart,
    required this.isWishListed,
    required this.onPressedAddToWishList,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.PRODUCT_DETAILS, arguments: productItem.id);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* ================================================================= Product Image =================================================================
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0)),
                  child: CustomCachedNetworkImage(
                    height: Get.height * 0.12,
                    width: 240,
                    fit: BoxFit.contain,
                    imageUrl:
                        '${ApiConstant.SERVER_IP_PORT}/uploads/product/${productItem.media?.first}',
                    errorWidget: Image.asset(
                      AppAssets.DEFAULT_IMAGE,
                      fit: BoxFit.cover,
                    ),
                    placeholderImage: AppAssets.DEFAULT_IMAGE,
                  ),
                ),
                //* ================================================================= Wishlist Icon =================================================================

                WishlistIconButton(
                    isWishListed: isWishListed,
                    onPressed: onPressedAddToWishList),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    //* ================================================================= Product Name =================================================================

                    ConditionalSpacingText(
                        text: productItem.productName.toString()),
                    const SizedBox(height: 10),
                    //* ================================================================= Rating & Review =================================================================
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating:
                              productItem.productReview?.rating ?? 0.00,
                          ignoreGestures: true,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 14,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Color(0xFFFF9017),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        Text(
                          '${productItem.productReview?.rating.toString() ?? '0'} (${productItem.productReview?.totalReview.toString() ?? '0'} Reviews)',
                          style: TextStyle(
                            fontSize: Get.height * 0.014,
                            color: const Color(0xFFFF9017),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),

                    //* ================================================================= Product Specification =================================================================

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              productItem.specification != null &&
                                      productItem.specification!.isNotEmpty
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '\u2022 ${productItem.specification?.first.label}: ${productItem.specification?.first.value ?? ''}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  : const SizedBox(),
                              productItem.specification != null &&
                                      productItem.specification!.length > 1
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '\u2022 ${productItem.specification?[1].label}: ${productItem.specification?[1].value ?? ''}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  : const SizedBox(),
                              productItem.specification != null &&
                                      productItem.specification!.length > 2
                                  ? Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '\u2022 ${productItem.specification?[2].label}: ${productItem.specification?[2].value ?? ''}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    //* ================================================================= Product Price =================================================================
                    (productItem.productVariant?.isNotEmpty ?? false)
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text('\$${productItem.productVariant?.first.mainPrice?.toStringAsFixed(2)}'.tr,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 3,
                                        decorationColor:
                                            Color.fromARGB(255, 196, 20, 7),
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text('\$${productItem.productVariant?.first.sellPrice?.toStringAsFixed(2)}'.tr,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: PRIMARY_COLOR,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ))
                        : const SizedBox(height: 20),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    (productItem.totalStock != 0)
                        ? PrimaryIconButton(
                            backgroundColor: PRIMARY_COLOR,
                            text: 'Add to Cart'.tr,
                            horizontalPadding: 10,
                            verticalPadding: 10,
                            onPressed: onPressedAddToCart,
                            textColor: Colors.white,
                            iconWidget: const Image(
                              height: 20,
                              color: Colors.white,
                              image: AssetImage(AppAssets.CART_NAVBAR_ICON),
                            ),
                          )
                        : SizedBox(
                            width: Get.width,
                            child: TextButton(
                              onPressed: null, // Disabled when out of stock
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Out of Stock'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
