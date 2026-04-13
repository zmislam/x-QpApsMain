import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../components/empty_state.dart';
import '../controllers/buyer_reviews_controller.dart';
import '../widgets/review_card.dart';

/// My Reviews list — displays all user reviews with delete option.
class BuyerReviewsView extends StatelessWidget {
  const BuyerReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerReviewsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: MarketplaceDesignTokens.pricePrimary,
          ),
        );
      }

      if (controller.reviews.isEmpty) {
        return MarketplaceEmptyState(
          icon: Icons.star_border_rounded,
          title: 'No Reviews Yet',
          subtitle: 'Your product reviews will appear here.',
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshReviews,
        color: MarketplaceDesignTokens.pricePrimary,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
              controller.loadMoreReviews();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.reviews.length + (controller.hasMoreData.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= controller.reviews.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: MarketplaceDesignTokens.pricePrimary,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }

              final review = controller.reviews[index];
              return Obx(() => ReviewCard(
                    review: review,
                    isDeleting: controller.isDeleting.value &&
                        controller.deletingReviewId.value == review.id,
                    onDelete: () => controller.deleteReview(review.id),
                  ));
            },
          ),
        ),
      );
    });
  }
}
