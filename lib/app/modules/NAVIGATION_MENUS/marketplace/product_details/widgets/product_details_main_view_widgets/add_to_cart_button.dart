import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_details_controller.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../config/constants/color.dart';

class AddToCartButton extends StatelessWidget {
  final ProductDetailsController controller;

  const AddToCartButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (controller.productDetailsList.value.first.productVariant !=
                  null &&
              controller
                  .productDetailsList.value.first.productVariant!.isNotEmpty &&
              (controller.productDetailsList.value.first.productVariant!.first
                          .stock ??
                      0) >=
                  1) {
            controller.marketPlaceController.addToCartPost(
              productId: controller.productDetailsList.value.first.id,
              storeId: controller.productDetailsList.value.first.storeId,
              productVariantId: controller
                  .productDetailsList.value.first.productVariant?.first.id,
              quantity: 1,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              (controller.productDetailsList.value.first.productVariant !=
                          null &&
                      controller.productDetailsList.value.first.productVariant!
                          .isNotEmpty &&
                      (controller.productDetailsList.value.first.productVariant!
                                  .first.stock ??
                              0) >=
                          1)
                  ? PRIMARY_COLOR
                  : Colors.deepOrange,
          foregroundColor:
              (controller.productDetailsList.value.first.productVariant !=
                          null &&
                      controller.productDetailsList.value.first.productVariant!
                          .isNotEmpty &&
                      (controller.productDetailsList.value.first.productVariant!
                                  .first.stock ??
                              0) >=
                          1)
                  ? Colors.white
                  : Colors.deepOrange,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: (controller
                              .productDetailsList.value.first.productVariant !=
                          null &&
                      controller.productDetailsList.value.first.productVariant!
                          .isNotEmpty &&
                      (controller.productDetailsList.value.first.productVariant!
                                  .first.stock ??
                              0) >=
                          1)
                  ? PRIMARY_COLOR
                  : Colors.deepOrange, // Border color based on stock
              width: 2.0, // Border width
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.productDetailsList.value.first.productVariant !=
                    null &&
                controller.productDetailsList.value.first.productVariant!
                    .isNotEmpty &&
                (controller.productDetailsList.value.first.productVariant!.first
                            .stock ??
                        0) >=
                    1)
              Image.asset(
                AppAssets.CART_NAVBAR_ICON,
                height: 30,
                width: 30,
                color: Colors.white,
              ),
            if (controller.productDetailsList.value.first.productVariant !=
                    null &&
                controller.productDetailsList.value.first.productVariant!
                    .isNotEmpty &&
                (controller.productDetailsList.value.first.productVariant!.first
                            .stock ??
                        0) >=
                    1)
              const SizedBox(width: 10),
            Text(
              (controller.productDetailsList.value.first.productVariant !=
                          null &&
                      controller.productDetailsList.value.first.productVariant!
                          .isNotEmpty &&
                      (controller.productDetailsList.value.first.productVariant!
                                  .first.stock ??
                              0) >=
                          1)
                  ? 'Add to Cart'.tr
                  : 'Out of Stock'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
