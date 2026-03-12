import 'package:flutter/material.dart';
import '../../controllers/product_details_controller.dart';

import '../../../../../../config/constants/color.dart';
import 'package:get/get.dart';

class ProductHeaderInfo extends StatelessWidget {
  final ProductDetailsController controller;

  const ProductHeaderInfo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            controller.productDetailsList.value.first.productName.toString(),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        // ============================================================== Product Price ==============================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: controller.productDetailsList.value.first.productVariant !=
                          null &&
                      controller.productDetailsList.value.first.productVariant!
                          .isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('\$${controller.productDetailsList.value.first.productVariant?.first.mainPrice}'.tr,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 3,
                              decorationColor: Color.fromARGB(255, 196, 20, 7),
                              color: Colors.red,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text('\$${controller.productDetailsList.value.first.productVariant?.first.sellPrice}'.tr,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              color: PRIMARY_COLOR,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
            // const Spacer(),
          ],
        ),

        const SizedBox(
          height: 5,
        ),
        // ==============================================================  Vat ==============================================================
        Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                if (controller.productDetailsList.value.isNotEmpty &&
                    (controller.productDetailsList.value.first.productVariant
                            ?.isNotEmpty ??
                        false))
                  Text(
                    '${'Price including'.tr} ${controller.productDetailsList.value.first.vat}% ${'VAT:'.tr} '
                        '\$${((controller.productDetailsList.value.first.productVariant?.first.sellPrice ?? 0) * (1 + (controller.productDetailsList.value.first.vat ?? 0) / 100)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                const SizedBox(width: 5),
                const Icon(
                  Icons.error_outline_outlined,
                  size: 20,
                  color: PRIMARY_COLOR,
                ),
              ],
            )),
      ],
    );
  }
}
