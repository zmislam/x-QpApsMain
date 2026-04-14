import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/page_monetization_controller.dart';
import '../models/page_monetization_models.dart';
import 'page_tier_badge.dart';

/// Tier progression with dimension bars and history
class PageTierProgress extends GetView<PageMonetizationController> {
  const PageTierProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tier = controller.tierInfo.value;
      final history = controller.tierHistory;
      if (tier == null) return const SizedBox.shrink();

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.trending_up, size: 20, color: PRIMARY_COLOR),
                SizedBox(width: 8),
                Text('Tier Progress',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),

            // Current tier badge
            PageTierBadge(
              tierName: tier.tierName,
              multiplier: tier.multiplier,
              size: 'medium',
            ),
            const SizedBox(height: 14),

            // Dimension bars (dynamic from API)
            ...tier.dimensions.entries.map(_dimensionBar),

            // Progress to next tier
            if (tier.nextTierThreshold > 0) ...[
              const SizedBox(height: 12),
              _nextTierProgress(tier),
            ],

            // Tier history
            if (history.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text('History',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              ...history.take(5).map(_historyItem),
            ],
          ],
        ),
      );
    });
  }

  Widget _dimensionBar(MapEntry<String, DimensionScore> entry) {
    final d = entry.value;
    final pct = d.weight > 0 ? (d.weightedScore / d.weight).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${d.name} (${(d.weight * 100).round()}%)',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Text(d.score.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextTierProgress(PageTierInfo tier) {
    final progress = tier.nextTierThreshold > 0
        ? (tier.currentProgress / tier.nextTierThreshold).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: PRIMARY_COLOR.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Progress to next tier',
                  style: TextStyle(fontSize: 12)),
              const Spacer(),
              Text('${tier.currentProgress}/${tier.nextTierThreshold}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem(PageTierHistoryEntry entry) {
    final isPromotion = entry.action == 'promotion';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isPromotion ? Icons.arrow_upward : Icons.arrow_downward,
            size: 14,
            color: isPromotion ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${entry.fromTier} → ${entry.toTier}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (entry.date != null)
            Text(
              '${entry.date!.month}/${entry.date!.day}/${entry.date!.year}',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }
}
