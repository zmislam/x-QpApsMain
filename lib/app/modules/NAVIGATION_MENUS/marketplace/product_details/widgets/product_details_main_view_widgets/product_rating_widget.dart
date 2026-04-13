import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../controllers/product_details_controller.dart';

class ProductRatingSection extends GetView<ProductDetailsController> {
  const ProductRatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final review = controller.product.value?.productReview;
      final rating = review?.rating ?? 0.0;
      final totalReview = review?.totalReview ?? 0;

      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: MarketplaceDesignTokens.spacingMd),
        child: Row(
          children: [
            RatingBar.builder(
              initialRating: rating,
              ignoreGestures: true,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 18,
              itemBuilder: (_, __) => const Icon(
                Icons.star_rounded,
                color: MarketplaceDesignTokens.ratingStarFill,
              ),
              onRatingUpdate: (_) {},
            ),
            const SizedBox(width: 8),
            Text(
              '${rating.toStringAsFixed(1)} ($totalReview ${totalReview == 1 ? 'review' : 'reviews'})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: MarketplaceDesignTokens.textSecondary(context),
              ),
            ),
          ],
        ),
      );
    });
  }
}
