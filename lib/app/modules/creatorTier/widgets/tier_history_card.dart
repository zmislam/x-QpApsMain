import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/creator_tier_controller.dart';
import '../models/creator_tier_models.dart';

/// Tier change history timeline
class TierHistoryCard extends GetView<CreatorTierController> {
  const TierHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final history = controller.tierHistory;
      if (history.isEmpty) return const SizedBox.shrink();

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
                Icon(Icons.history, size: 20, color: PRIMARY_COLOR),
                SizedBox(width: 8),
                Text('Tier History',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            ...history.map(_historyTile),
          ],
        ),
      );
    });
  }

  Widget _historyTile(TierHistoryEntry entry) {
    final isPromotion = entry.action == 'promotion';
    final color = isPromotion ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(isPromotion ? Icons.arrow_upward : Icons.arrow_downward,
              size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${entry.fromTier} → ${entry.toTier}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                if (entry.reason.isNotEmpty)
                  Text(entry.reason,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          if (entry.date != null)
            Text(
              '${entry.date!.month}/${entry.date!.day}',
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }
}
