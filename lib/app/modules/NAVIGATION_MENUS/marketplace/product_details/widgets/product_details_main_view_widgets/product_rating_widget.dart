import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../controllers/product_details_controller.dart';

class ProductRatingWidget extends StatelessWidget {
  final ProductDetailsController controller;

  const ProductRatingWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 20,
      child: Row(
        children: [
          RatingBar.builder(
            initialRating: controller
                    .productDetailsList.value.first.productReview?.rating ??
                0.00,
            ignoreGestures: true,
            minRating: 1,
            direction: Axis.vertical,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 14,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          ),
          Text(
            '${controller.productDetailsList.value.first.productReview?.rating.toString() ?? '0'} (${controller.productDetailsList.value.first.productReview?.totalReview.toString() ?? '0'} Reviews)',
            style: TextStyle(
              fontSize: Get.height * 0.014,
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
