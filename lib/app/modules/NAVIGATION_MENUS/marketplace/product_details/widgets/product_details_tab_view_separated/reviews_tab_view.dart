import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../../../../../extension/date_time_extension.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../controllers/product_details_controller.dart';
import '../../models/product_review_model.dart';

class ProductReviewsTabContent extends GetView<ProductDetailsController> {
  const ProductReviewsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final reviews = controller.productReviewDetailsList.value;
      final reviewData = controller.reviewData.value;

      if (reviews.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No reviews yet'.tr,
              style: MarketplaceDesignTokens.cardSubtext(context),
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Rating Summary ──────────────────
          if (reviewData != null) ...[
            const SizedBox(height: MarketplaceDesignTokens.spacingSm),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      (reviewData.averageRating ?? 0).toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: MarketplaceDesignTokens.textPrimary(context),
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: (reviewData.averageRating ?? 0).toDouble(),
                      ignoreGestures: true,
                      minRating: 0,
                      itemCount: 5,
                      itemSize: 16,
                      itemBuilder: (_, __) => const Icon(Icons.star_rounded,
                          color: MarketplaceDesignTokens.ratingStarFill),
                      onRatingUpdate: (_) {},
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}',
                      style: MarketplaceDesignTokens.cardSubtext(context),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: List.generate(5, (i) {
                      final star = 5 - i;
                      final count = _getStarCount(reviewData, star);
                      final total = reviews.length;
                      final pct = total > 0 ? count / total : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Text('$star',
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        MarketplaceDesignTokens.textSecondary(
                                            context))),
                            const SizedBox(width: 4),
                            const Icon(Icons.star_rounded,
                                size: 12,
                                color:
                                    MarketplaceDesignTokens.ratingStarFill),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor:
                                      MarketplaceDesignTokens.ratingStarEmpty,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MarketplaceDesignTokens
                                              .ratingStarFill),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 24,
                              child: Text(
                                '$count',
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        MarketplaceDesignTokens.textSecondary(
                                            context)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Divider(
              height: 24,
              color: MarketplaceDesignTokens.divider(context),
            ),
          ],

          // ─── Review List ─────────────────────
          ...reviews.map((review) => _buildReviewItem(context, review)),
        ],
      );
    });
  }

  int _getStarCount(ReviewData data, int star) {
    switch (star) {
      case 5:
        return data.fiveStarRating ?? 0;
      case 4:
        return data.fourStarRating ?? 0;
      case 3:
        return data.threeStarRating ?? 0;
      case 2:
        return data.twoStarRating ?? 0;
      case 1:
        return data.oneStarRating ?? 0;
      default:
        return 0;
    }
  }

  Widget _buildReviewItem(BuildContext context, ProductReviewDetails review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  (review.reviewUser?.profilePic ?? '').formatedProfileUrl,
                ),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${review.reviewUser?.firstName ?? ''} ${review.reviewUser?.lastName ?? ''}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MarketplaceDesignTokens.textPrimary(context),
                      ),
                    ),
                    Text(
                      (review.createdAt ?? '').toWordlyTimeText(),
                      style: MarketplaceDesignTokens.cardSubtext(context),
                    ),
                  ],
                ),
              ),
              RatingBar.builder(
                initialRating: review.rating?.toDouble() ?? 0.0,
                ignoreGestures: true,
                itemCount: 5,
                itemSize: 14,
                itemBuilder: (_, __) => const Icon(Icons.star_rounded,
                    color: MarketplaceDesignTokens.ratingStarFill),
                onRatingUpdate: (_) {},
              ),
            ],
          ),
          if (review.reviewTitle != null &&
              review.reviewTitle!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review.reviewTitle!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MarketplaceDesignTokens.textPrimary(context),
              ),
            ),
          ],
          if (review.reviewDescription != null &&
              review.reviewDescription!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              review.reviewDescription!,
              style: TextStyle(
                fontSize: 14,
                color: MarketplaceDesignTokens.textSecondary(context),
                height: 1.4,
              ),
            ),
          ],
          if (review.media != null && review.media!.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.media!.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              review.media![index]
                                  .formatedProductReviewUrlLive,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                  AppAssets.DEFAULT_IMAGE,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        review.media![index].formatedProductReviewUrlLive,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AppAssets.DEFAULT_IMAGE,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
