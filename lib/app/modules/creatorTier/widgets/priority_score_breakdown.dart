import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../controllers/creator_tier_controller.dart';
import '../models/creator_tier_models.dart';

/// Detailed priority score breakdown per dimension
class PriorityScoreBreakdownWidget extends GetView<CreatorTierController> {
  const PriorityScoreBreakdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.priorityScore.value;
      if (data == null) return const SizedBox.shrink();

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
            Row(
              children: [
                const Icon(Icons.analytics_outlined,
                    size: 20, color: PRIMARY_COLOR),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Priority Score',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                Text('${data.totalScore}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 14),

            ...data.dimensions.entries.map(_dimensionDetail),
          ],
        ),
      );
    });
  }

  Widget _dimensionDetail(MapEntry<String, DimensionDetail> entry) {
    final d = entry.value;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${d.name} (${(d.weight * 100).round()}%)',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${d.rawScore.toStringAsFixed(1)} → ${d.weightedScore.toStringAsFixed(1)}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (d.rawScore / 100).clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
            ),
          ),
          if (d.tip != null && d.tip!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.lightbulb_outline,
                    size: 12, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(d.tip!,
                      style: TextStyle(
                          fontSize: 10, color: Colors.amber.shade800)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
