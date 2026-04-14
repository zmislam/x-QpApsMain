import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../controllers/earn_dashboard_controller.dart';
import '../../model/analytics_models.dart';

class PeriodCompareCard extends GetView<EarnDashboardController> {
  const PeriodCompareCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final compare = controller.earningsTrend.value?.periodCompare;
      if (compare == null) return const SizedBox.shrink();

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
            // Header
            Row(
              children: [
                const Icon(Icons.compare_arrows,
                    size: 20, color: PRIMARY_COLOR),
                const SizedBox(width: 8),
                const Text('Period Comparison',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),

            // Two columns
            Row(
              children: [
                Expanded(
                  child: _periodColumn(
                    label: 'Current',
                    earned: compare.currentEarned,
                    posts: compare.currentPosts,
                    avgScore: compare.currentAvgScore,
                    highlight: true,
                  ),
                ),
                Container(
                    width: 1, height: 70, color: Colors.grey.shade200),
                Expanded(
                  child: _periodColumn(
                    label: 'Previous',
                    earned: compare.previousEarned,
                    posts: compare.previousPosts,
                    avgScore: compare.previousAvgScore,
                    highlight: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Change indicator
            _changeRow(compare),
          ],
        ),
      );
    });
  }

  Widget _periodColumn({
    required String label,
    required double earned,
    required int posts,
    required double avgScore,
    required bool highlight,
  }) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: highlight ? PRIMARY_COLOR : Colors.grey.shade600)),
        const SizedBox(height: 8),
        Text('\$${earned.toStringAsFixed(4)}',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: highlight ? Colors.black87 : Colors.grey.shade500)),
        const SizedBox(height: 4),
        Text('$posts posts · Avg ${avgScore.toStringAsFixed(1)}',
            style:
                TextStyle(fontSize: 10, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _changeRow(PeriodCompareData c) {
    final isUp = c.changePercent >= 0;
    final color = isUp ? Colors.green : Colors.red;
    final icon = isUp ? Icons.arrow_upward : Icons.arrow_downward;
    final sign = isUp ? '+' : '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text('$sign${c.changePercent.toStringAsFixed(1)}%',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(width: 8),
        Text('vs previous period',
            style:
                TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }
}
