import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../components/custom_cached_image_view.dart';
import '../models/buyer_review_model.dart';

/// A card displaying a single review with rating, text, product info, and seller reply.
class ReviewCard extends StatelessWidget {
  final BuyerReviewItem review;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ReviewCard({
    super.key,
    required this.review,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final productImage = (review.product?.media.isNotEmpty ?? false)
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/products/${review.product!.media.first}'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product info row
          Row(
            children: [
              if (productImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: CustomCachedNetworkImage(imageUrl: productImage),
                  ),
                ),
              if (productImage != null) const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.product?.productName ?? 'Product',
                      style: MarketplaceDesignTokens.productName(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    _buildRating(context),
                  ],
                ),
              ),
              // Delete button
              if (onDelete != null)
                isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: MarketplaceDesignTokens.orderCancelled,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: MarketplaceDesignTokens.orderCancelled,
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
            ],
          ),
          const SizedBox(height: 10),

          // Review title
          if (review.reviewTitle != null && review.reviewTitle!.isNotEmpty)
            Text(
              review.reviewTitle!,
              style: MarketplaceDesignTokens.productName(context),
            ),

          // Review description
          if (review.reviewDescription != null &&
              review.reviewDescription!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              review.reviewDescription!,
              style: MarketplaceDesignTokens.bodyText(context),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Review images
          if (review.media.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.media.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: CustomCachedNetworkImage(
                        imageUrl:
                            '${ApiConstant.SERVER_IP_PORT}/uploads/reviews/${review.media[i]}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Seller reply
          if (review.reply != null && review.reply!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MarketplaceDesignTokens.pricePrimary
                    .withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seller Reply',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.pricePrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review.reply!,
                    style: MarketplaceDesignTokens.bodyTextSmall(context),
                  ),
                ],
              ),
            ),
          ],

          // Date
          if (review.createdAt != null) ...[
            const SizedBox(height: 8),
            Text(
              _formatDate(review.createdAt!),
              style: MarketplaceDesignTokens.cardSubtext(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          5,
          (i) => Icon(
            i < review.rating
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            size: 16,
            color: i < review.rating
                ? MarketplaceDesignTokens.ratingStarFill
                : MarketplaceDesignTokens.ratingStarEmpty,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '${review.rating}.0',
          style: MarketplaceDesignTokens.cardSubtext(context),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
