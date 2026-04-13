import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/review_reply_controller.dart';

class ReviewReplyView extends GetView<ReviewReplyController> {
  const ReviewReplyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rate_review_outlined,
                  size: 64,
                  color: MarketplaceDesignTokens.textSecondary(context)),
              const SizedBox(height: 16),
              Text('No products with reviews',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  )),
            ],
          ),
        );
      }
      return Column(
        children: [
          // ─── Product selector ───
          Padding(
            padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Product',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
              value: controller.selectedProductId.value.isEmpty
                  ? null
                  : controller.selectedProductId.value,
              items: controller.products
                  .map((p) => DropdownMenuItem<String>(
                        value: p['_id']?.toString() ?? '',
                        child: Text(
                          p['product_name']?.toString() ?? 'Unnamed',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              onChanged: (id) {
                if (id != null) controller.loadReviews(id);
              },
            ),
          ),

          // ─── Reviews list ───
          Expanded(
            child: Obx(() {
              if (controller.isReviewsLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.reviews.isEmpty) {
                return Center(
                  child: Text('No reviews for this product',
                      style: TextStyle(
                        color:
                            MarketplaceDesignTokens.textSecondary(context),
                        fontSize: 14,
                      )),
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    controller.loadReviews(controller.selectedProductId.value),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: MarketplaceDesignTokens.spacingMd),
                  itemCount: controller.reviews.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: MarketplaceDesignTokens.spacingSm),
                  itemBuilder: (context, index) {
                    final review = controller.reviews[index];
                    return _ReviewCard(review: review, context: context);
                  },
                ),
              );
            }),
          ),
        ],
      );
    });
  }

  Widget _ReviewCard(
      {required Map<String, dynamic> review, required BuildContext context}) {
    final rating = (review['rating'] as num?)?.toInt() ?? 0;
    final title = review['review_title']?.toString() ?? '';
    final description = review['review_description']?.toString() ?? '';
    final reply = review['reply']?.toString();
    final hasReply = reply != null && reply.isNotEmpty;
    final reviewId = review['_id']?.toString() ?? '';
    final user = review['user_id'];
    final userName = user is Map
        ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
        : 'Buyer';
    final createdAt = review['createdAt']?.toString() ?? '';

    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header: name + rating ───
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    MarketplaceDesignTokens.primary.withValues(alpha: 0.1),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: const TextStyle(
                      color: MarketplaceDesignTokens.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: MarketplaceDesignTokens.textPrimary(context),
                        )),
                    if (createdAt.isNotEmpty)
                      Text(_formatDate(createdAt),
                          style: MarketplaceDesignTokens.cardSubtext(context)),
                  ],
                ),
              ),
              // Stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    5,
                    (i) => Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        )),
              ),
            ],
          ),

          if (title.isNotEmpty) ...[
            const SizedBox(height: MarketplaceDesignTokens.spacingSm),
            Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: MarketplaceDesignTokens.textPrimary(context),
                )),
          ],

          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(description,
                style: MarketplaceDesignTokens.bodyText(context)),
          ],

          const SizedBox(height: MarketplaceDesignTokens.spacingSm),
          const Divider(height: 1),
          const SizedBox(height: MarketplaceDesignTokens.spacingSm),

          // ─── Reply section ───
          if (hasReply) ...[
            Container(
              padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingSm),
              decoration: BoxDecoration(
                color: MarketplaceDesignTokens.primary.withValues(alpha: 0.05),
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.reply,
                      size: 16, color: MarketplaceDesignTokens.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Reply',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: MarketplaceDesignTokens.primary,
                            )),
                        const SizedBox(height: 2),
                        Text(reply,
                            style:
                                MarketplaceDesignTokens.bodyTextSmall(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showReplyDialog(context, reviewId),
                icon: const Icon(Icons.reply, size: 18),
                label: const Text('Reply'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: MarketplaceDesignTokens.primary,
                  side: const BorderSide(
                      color: MarketplaceDesignTokens.primary, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusSm),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, String reviewId) {
    final replyCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: MarketplaceDesignTokens.spacingMd,
          right: MarketplaceDesignTokens.spacingMd,
          top: MarketplaceDesignTokens.spacingMd,
          bottom: MediaQuery.of(ctx).viewInsets.bottom +
              MarketplaceDesignTokens.spacingMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reply to Review',
                style: MarketplaceDesignTokens.sectionTitle(ctx)),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),
            TextField(
              controller: replyCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isReplying.value
                        ? null
                        : () {
                            if (replyCtrl.text.trim().isNotEmpty) {
                              controller
                                  .replyToReview(reviewId, replyCtrl.text)
                                  .then((_) => Navigator.pop(ctx));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketplaceDesignTokens.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusSm),
                      ),
                    ),
                    child: controller.isReplying.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Send Reply',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
