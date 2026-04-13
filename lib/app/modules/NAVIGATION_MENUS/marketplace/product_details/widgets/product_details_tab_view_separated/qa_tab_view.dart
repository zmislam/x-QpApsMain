import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../extension/date_time_extension.dart';
import '../../controllers/product_details_controller.dart';

class QATabContent extends GetView<ProductDetailsController> {
  const QATabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: MarketplaceDesignTokens.spacingSm),

          // ─── Ask a Question ──────────────────
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.questionTextController,
                  decoration: InputDecoration(
                    hintText: 'Ask a question about this product...'.tr,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: MarketplaceDesignTokens.textSecondary(context),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                      borderSide: BorderSide(
                          color: MarketplaceDesignTokens.cardBorder(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                      borderSide: BorderSide(
                          color: MarketplaceDesignTokens.cardBorder(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                      borderSide: const BorderSide(
                          color: MarketplaceDesignTokens.primary),
                    ),
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: controller.submitQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarketplaceDesignTokens.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text('Ask'.tr,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: MarketplaceDesignTokens.spacingMd),

          // ─── Questions List ──────────────────
          if (controller.isLoadingQuestions.value)
            const Center(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ))
          else if (controller.questions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No questions yet. Be the first to ask!'.tr,
                  style: MarketplaceDesignTokens.cardSubtext(context),
                ),
              ),
            )
          else
            ...controller.questions.map((q) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(
                      MarketplaceDesignTokens.cardPadding),
                  decoration: MarketplaceDesignTokens.cardDecoration(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Q:',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: MarketplaceDesignTokens.primary,
                              )),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              q.question ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MarketplaceDesignTokens.textPrimary(
                                    context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${q.user?.firstName ?? ''} ${q.user?.lastName ?? ''}'
                            .trim(),
                        style: TextStyle(
                          fontSize: 12,
                          color: MarketplaceDesignTokens.textSecondary(context),
                        ),
                      ),
                      if (q.createdAt != null)
                        Text(
                          q.createdAt!.toIso8601String().toWordlyTimeText(),
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                MarketplaceDesignTokens.textSecondary(context),
                          ),
                        ),

                      // Answer
                      if (q.answer != null && q.answer!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Divider(
                            height: 1,
                            color: MarketplaceDesignTokens.divider(context)),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('A:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: MarketplaceDesignTokens.inStock,
                                )),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                q.answer!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: MarketplaceDesignTokens.textPrimary(
                                      context),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const SizedBox(height: 4),
                        Text(
                          'Awaiting seller response'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color:
                                MarketplaceDesignTokens.textSecondary(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                )),
        ],
      );
    });
  }
}
