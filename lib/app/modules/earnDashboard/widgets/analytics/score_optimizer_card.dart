import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../controllers/earn_dashboard_controller.dart';
import '../../model/analytics_models.dart';
import '../../services/earning_config_service.dart';

class ScoreOptimizerCard extends GetView<EarnDashboardController> {
  const ScoreOptimizerCard({super.key});

  EarningConfigService get _config => Get.find<EarningConfigService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.scoreOptimizer.value;
      final isLoading = controller.isAnalyticsLoading.value;

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
                const Icon(Icons.auto_awesome,
                    size: 20, color: PRIMARY_COLOR),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Score Optimizer',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (isLoading && data == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: PRIMARY_COLOR)),
              )
            else if (data == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text('Optimizer data unavailable',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500)),
                ),
              )
            else ...[
              // Week summary
              _weekSummary(data.weekSummary),
              const SizedBox(height: 12),

              // Streak
              _streakSection(data.streak),
              const SizedBox(height: 12),

              // Recommendations
              if (data.recommendations.isNotEmpty) ...[
                Text('Recommendations',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                ...data.recommendations.map(_recommendationTile),
              ],
              const SizedBox(height: 12),

              // Activity ROI
              if (data.activityROI.isNotEmpty) ...[
                Text('Activity ROI',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                ...data.activityROI.map(_roiRow),
              ],
            ],
          ],
        ),
      );
    });
  }

  Widget _weekSummary(WeekSummary s) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PRIMARY_COLOR.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _miniStat('Avg Score', s.avgScore.toStringAsFixed(1)),
          _miniStat('Posts', '${s.totalPosts}'),
          _miniStat('Earned', '\$${s.totalEarned.toStringAsFixed(4)}'),
          _miniStat('Best', s.bestDay),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _streakSection(StreakStatus streak) {
    final streakColor = streak.currentStreak >= 7
        ? Colors.orange
        : streak.currentStreak >= 3
            ? PRIMARY_COLOR
            : Colors.grey;

    // Use dynamic tier labels from config
    final tierLabel = _config.getStreakTierLabel(streak.currentStreak);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: streakColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department,
              color: streakColor, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$tierLabel · ${streak.currentStreak} day streak',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                    'Best: ${streak.bestStreak} days · Multiplier: ${streak.multiplier}x',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationTile(Recommendation r) {
    final priorityColor = r.priority == 'high'
        ? Colors.red
        : r.priority == 'medium'
            ? Colors.orange
            : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: priorityColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: priorityColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 5),
            decoration:
                BoxDecoration(color: priorityColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(r.description,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600)),
                if (r.impact.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text('Impact: ${r.impact}',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: priorityColor)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roiRow(ActivityROI roi) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(roi.activity,
                style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text('+${roi.scoreImpact.toStringAsFixed(1)} pts',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700)),
          ),
          Expanded(
            flex: 2,
            child: Text(roi.effort,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500)),
          ),
        ],
      ),
    );
  }
}
