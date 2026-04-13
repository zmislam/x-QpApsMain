import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../components/empty_state.dart';
import '../controllers/store_reviews_controller.dart';

/// Store reviews view — review list + submit form.
class StoreReviewsView extends GetView<StoreReviewsController> {
  const StoreReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.storeName.value.isNotEmpty
                  ? '${controller.storeName.value} — Reviews'
                  : 'Store Reviews',
              style: MarketplaceDesignTokens.heading(context),
            )),
        centerTitle: false,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubmitReview(context),
        backgroundColor: MarketplaceDesignTokens.pricePrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.rate_review_outlined, size: 18),
        label: const Text('Write Review'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.reviews.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: MarketplaceDesignTokens.pricePrimary,
            ),
          );
        }
        if (controller.reviews.isEmpty) {
          return MarketplaceEmptyState(
            icon: Icons.reviews_outlined,
            title: 'No reviews yet',
            subtitle: 'Be the first to review this store',
          );
        }

        return CustomScrollView(
          slivers: [
            // Averages header
            if (controller.averages.value != null)
              SliverToBoxAdapter(child: _AveragesCard()),

            // Reviews list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  if (i >= controller.reviews.length) {
                    controller.fetchReviews(loadMore: true);
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
                  return _ReviewCard(review: controller.reviews[i]);
                },
                childCount: controller.reviews.length +
                    (controller.hasMore.value ? 1 : 0),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showSubmitReview(BuildContext context) {
    int overall = 0;
    int? shipping;
    int? communication;
    int? accuracy;
    final textCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: MarketplaceDesignTokens.cardBg(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(MarketplaceDesignTokens.radiusLg),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.spacingMd,
                    vertical: MarketplaceDesignTokens.spacingSm,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_outline, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Rate This Store',
                        style:
                            MarketplaceDesignTokens.sectionTitle(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(
                        MarketplaceDesignTokens.spacingMd),
                    children: [
                      // Overall rating (required)
                      _RatingRow(
                        label: 'Overall Rating *',
                        value: overall,
                        onChanged: (v) => setState(() => overall = v),
                      ),
                      const SizedBox(height: 12),

                      // Shipping
                      _RatingRow(
                        label: 'Shipping',
                        value: shipping ?? 0,
                        onChanged: (v) => setState(() => shipping = v),
                      ),
                      const SizedBox(height: 12),

                      // Communication
                      _RatingRow(
                        label: 'Communication',
                        value: communication ?? 0,
                        onChanged: (v) =>
                            setState(() => communication = v),
                      ),
                      const SizedBox(height: 12),

                      // Accuracy
                      _RatingRow(
                        label: 'Accuracy',
                        value: accuracy ?? 0,
                        onChanged: (v) => setState(() => accuracy = v),
                      ),
                      const SizedBox(height: 16),

                      // Review text
                      Text(
                        'Your Review',
                        style: MarketplaceDesignTokens.bodyText(context)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: textCtrl,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Share your experience...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                MarketplaceDesignTokens.radiusMd),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                MarketplaceDesignTokens.radiusMd),
                            borderSide: BorderSide(
                              color: MarketplaceDesignTokens.cardBorder(
                                  context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(
                        MarketplaceDesignTokens.spacingMd),
                    child: Obx(() => SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: controller.isSubmitting.value
                                ? null
                                : () async {
                                    if (overall < 1) {
                                      Get.snackbar('Required',
                                          'Overall rating is required',
                                          snackPosition:
                                              SnackPosition.BOTTOM);
                                      return;
                                    }
                                    final ok =
                                        await controller.submitReview(
                                      overallRating: overall,
                                      shippingRating:
                                          shipping != null && shipping! > 0
                                              ? shipping
                                              : null,
                                      communicationRating:
                                          communication != null &&
                                                  communication! > 0
                                              ? communication
                                              : null,
                                      accuracyRating:
                                          accuracy != null && accuracy! > 0
                                              ? accuracy
                                              : null,
                                      reviewText: textCtrl.text.trim(),
                                    );
                                    if (ok && ctx.mounted) {
                                      Navigator.pop(ctx);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  MarketplaceDesignTokens.pricePrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    MarketplaceDesignTokens.radiusMd),
                              ),
                            ),
                            child: Text(
                              controller.isSubmitting.value
                                  ? 'Submitting...'
                                  : 'Submit Review',
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Averages Card ──────────────────────────────────────────
class _AveragesCard extends GetView<StoreReviewsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final avg = controller.averages.value;
      if (avg == null) return const SizedBox.shrink();

      final overall =
          (avg['avg_overall'] as num?)?.toDouble() ?? 0.0;
      final shipping =
          (avg['avg_shipping'] as num?)?.toDouble() ?? 0.0;
      final communication =
          (avg['avg_communication'] as num?)?.toDouble() ?? 0.0;
      final accuracy =
          (avg['avg_accuracy'] as num?)?.toDouble() ?? 0.0;

      return Container(
        margin: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          children: [
            // Big overall score
            Row(
              children: [
                Text(
                  overall.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: MarketplaceDesignTokens.pricePrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < overall.round()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 18,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    Text(
                      '${controller.totalReviews.value} review${controller.totalReviews.value != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: MarketplaceDesignTokens.textSecondary(
                            context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Sub-ratings
            if (shipping > 0)
              _SubRatingBar(label: 'Shipping', value: shipping),
            if (communication > 0)
              _SubRatingBar(label: 'Communication', value: communication),
            if (accuracy > 0)
              _SubRatingBar(label: 'Accuracy', value: accuracy),
          ],
        ),
      );
    });
  }
}

class _SubRatingBar extends StatelessWidget {
  final String label;
  final double value;

  const _SubRatingBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: MarketplaceDesignTokens.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value / 5,
                minHeight: 6,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.amber),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─── Review Card ────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final user = review['user_id'];
    String userName = 'Anonymous';
    if (user is Map<String, dynamic>) {
      userName = user['fullName']?.toString() ?? 'Anonymous';
    }
    final rating = (review['overall_rating'] as num?)?.toInt() ?? 0;
    final text = review['review_text']?.toString() ?? '';
    final isVerified = review['is_verified_purchase'] == true;
    final dateStr = review['createdAt']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: MarketplaceDesignTokens.cardPadding,
        vertical: MarketplaceDesignTokens.spacingXs,
      ),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User + stars
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: MarketplaceDesignTokens.pricePrimary
                    .withValues(alpha: 0.1),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: MarketplaceDesignTokens.pricePrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: MarketplaceDesignTokens.bodyText(context)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              size: 14,
                              color: MarketplaceDesignTokens.inStock),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(
                            i < rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 14,
                            color: Colors.amber,
                          );
                        }),
                        if (dateStr.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(dateStr),
                            style: TextStyle(
                              fontSize: 11,
                              color: MarketplaceDesignTokens.textSecondary(
                                  context),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              text,
              style: MarketplaceDesignTokens.bodyTextSmall(context),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String d) {
    try {
      final dt = DateTime.parse(d);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return d;
    }
  }
}

// ─── Star Rating Row ────────────────────────────────────────
class _RatingRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _RatingRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: MarketplaceDesignTokens.bodyText(context)
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        ...List.generate(5, (i) {
          return GestureDetector(
            onTap: () => onChanged(i + 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                i < value ? Icons.star_rounded : Icons.star_border_rounded,
                size: 28,
                color: Colors.amber,
              ),
            ),
          );
        }),
      ],
    );
  }
}
