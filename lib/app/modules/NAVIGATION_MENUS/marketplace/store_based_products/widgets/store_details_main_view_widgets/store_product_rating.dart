import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../models/store_products_model.dart';

class StoreProductRatingWidget extends StatelessWidget {
  final StoreProductsDetails? storeProductsDetails;
  const StoreProductRatingWidget({super.key, this.storeProductsDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: storeProductsDetails?.productReview?.rating ?? 0.0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 10,
          ignoreGestures: true,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Color(0xFFFF9017),
          ),
          onRatingUpdate: (rating) {},
        ),
        const SizedBox(width: 3),
        Text(
          '${storeProductsDetails?.productReview?.rating ?? '0'} '
          '(${storeProductsDetails?.productReview?.totalReview ?? '0'} Reviews)',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}
