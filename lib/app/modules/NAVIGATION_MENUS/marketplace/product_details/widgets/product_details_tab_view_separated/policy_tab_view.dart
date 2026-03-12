import 'package:flutter/material.dart';
import '../../controllers/product_details_controller.dart';
import 'package:get/get.dart';

class ProductPolicyTabView extends StatelessWidget {
  final ProductDetailsController controller;
  const ProductPolicyTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return controller.productDetailsList.value.first.store?.shipping != null ||
            controller.productDetailsList.value.first.store?.delivery != null ||
            controller.productDetailsList.value.first.store?.returns != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              if (controller.productDetailsList.value.first.store?.shipping !=
                  null) ...[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Shipping: '.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: controller.productDetailsList.value.first.store
                                ?.shipping ??
                            '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
              if (controller.productDetailsList.value.first.store?.delivery !=
                  null) ...[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Delivery: '.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: controller.productDetailsList.value.first.store
                                ?.delivery ??
                            '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
              if (controller.productDetailsList.value.first.store?.returns !=
                  null) ...[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Returns: '.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: controller.productDetailsList.value.first.store
                                ?.returns ??
                            '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Payments: '.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'QP Coins'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: Text('No Policy Available'.tr,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
