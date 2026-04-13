import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/buyer_reviews_controller.dart';

/// Bottom sheet for submitting a product review with rating, text, and images.
class SubmitReviewSheet extends StatelessWidget {
  final String productId;
  final String orderId;
  final String? productName;

  const SubmitReviewSheet({
    super.key,
    required this.productId,
    required this.orderId,
    this.productName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerReviewsController>();

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.cardBg(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: MarketplaceDesignTokens.textSecondary(context)
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Write a Review',
              style: MarketplaceDesignTokens.heading(context),
            ),
            if (productName != null) ...[
              const SizedBox(height: 4),
              Text(
                productName!,
                style: MarketplaceDesignTokens.cardSubtext(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 20),

            // Rating
            Text('Rating', style: MarketplaceDesignTokens.productName(context)),
            const SizedBox(height: 8),
            Obx(() => Row(
                  children: List.generate(
                    5,
                    (i) => GestureDetector(
                      onTap: () => controller.selectedRating.value = i + 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          i < controller.selectedRating.value
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: i < controller.selectedRating.value
                              ? MarketplaceDesignTokens.ratingStarFill
                              : MarketplaceDesignTokens.ratingStarEmpty,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 16),

            // Title field
            Text('Title', style: MarketplaceDesignTokens.productName(context)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.titleController,
              decoration: _inputDecoration(context, 'Review title'),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Description field
            Text('Description',
                style: MarketplaceDesignTokens.productName(context)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.descriptionController,
              decoration: _inputDecoration(context, 'Share your experience...'),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Image picker
            Text('Photos',
                style: MarketplaceDesignTokens.productName(context)),
            const SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...controller.selectedImages.asMap().entries.map(
                          (entry) => _ImageTile(
                            file: File(entry.value.path),
                            onRemove: () => controller.removeImage(entry.key),
                          ),
                        ),
                    if (controller.selectedImages.length < 5)
                      _AddImageButton(onTap: controller.pickImages),
                  ],
                )),
            const SizedBox(height: 24),

            // Submit button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () async {
                            final success = await controller.submitReview(
                              productId: productId,
                              orderId: orderId,
                            );
                            if (success) Get.back();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MarketplaceDesignTokens.pricePrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.cardRadius),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: MarketplaceDesignTokens.cardSubtext(context),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        borderSide:
            BorderSide(color: MarketplaceDesignTokens.cardBorder(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        borderSide:
            BorderSide(color: MarketplaceDesignTokens.cardBorder(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        borderSide: const BorderSide(
            color: MarketplaceDesignTokens.pricePrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const _ImageTile({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: -4,
          top: -4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: MarketplaceDesignTokens.cardBg(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: MarketplaceDesignTokens.cardBorder(context),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.add_a_photo_outlined,
          color: MarketplaceDesignTokens.textSecondary(context),
          size: 24,
        ),
      ),
    );
  }
}
