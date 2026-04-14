import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_boost_controller.dart';
import '../widgets/boost_budget_selector.dart';
import '../widgets/boost_audience_picker.dart';
import '../widgets/boost_schedule_picker.dart';
import '../widgets/boost_preview_card.dart';
import '../widgets/boost_cta_selector.dart';

/// Main Boost Reel view — multi-step form for configuring and
/// submitting a boost campaign for a V2 reel.
class ReelsBoostView extends GetView<ReelsBoostController> {
  const ReelsBoostView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boost Reel'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview
            BoostPreviewCard(
              thumbnailUrl: controller.reelThumbnail,
              caption: controller.reelCaption,
            ),
            const SizedBox(height: 24),

            // Budget
            _sectionHeader(context, 'Budget', Icons.account_balance_wallet_outlined),
            const SizedBox(height: 12),
            const BoostBudgetSelector(),
            const SizedBox(height: 24),

            // Audience
            _sectionHeader(context, 'Audience', Icons.people_outline),
            const SizedBox(height: 12),
            const BoostAudiencePicker(),
            const SizedBox(height: 24),

            // Schedule
            _sectionHeader(context, 'Schedule', Icons.calendar_today_outlined),
            const SizedBox(height: 12),
            const BoostSchedulePicker(),
            const SizedBox(height: 24),

            // CTA
            _sectionHeader(context, 'Call to Action', Icons.touch_app_outlined),
            const SizedBox(height: 12),
            const BoostCtaSelector(),
            const SizedBox(height: 32),

            // Estimated results
            Obx(() => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Results',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _estimateRow(
                        'Daily reach',
                        '${(controller.dailyBudget.value * 200).toStringAsFixed(0)} - ${(controller.dailyBudget.value * 400).toStringAsFixed(0)}',
                        isDark,
                      ),
                      _estimateRow(
                        'Total impressions',
                        '${(controller.totalBudget * 150).toStringAsFixed(0)} - ${(controller.totalBudget * 350).toStringAsFixed(0)}',
                        isDark,
                      ),
                      _estimateRow(
                        'Total budget',
                        '\$${controller.totalBudget.toStringAsFixed(2)}',
                        isDark,
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),

            // Submit
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () async {
                            final success = await controller.submitBoost();
                            if (success) Get.back();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                            'Boost Reel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _estimateRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13, color: isDark ? Colors.white60 : Colors.black54)),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }
}
