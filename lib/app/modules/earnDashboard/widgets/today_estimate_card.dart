import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/constants/color.dart';
import '../controllers/earn_dashboard_controller.dart';
import 'streak_rules_bottom_sheet.dart';

class TodayEstimateCard extends GetView<EarnDashboardController> {
  const TodayEstimateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.todayEstimate.value == null) {
        return _buildShimmer();
      }
      final est = controller.todayEstimate.value;
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
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.access_time,
                      size: 16, color: PRIMARY_COLOR),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text("Today's Estimated Earning",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('Live',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.green.shade700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Stats Grid — 3 columns
            Row(
              children: [
                // Score
                Expanded(
                  child: _statColumn(
                    icon: Icons.bolt,
                    iconColor: PRIMARY_COLOR,
                    value: est?.currentScore.toStringAsFixed(1) ?? '0.0',
                    label: 'Your Score',
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                // Rank
                Expanded(
                  child: _statColumn(
                    icon: Icons.emoji_events,
                    iconColor: Colors.amber.shade600,
                    value: '#${est?.rank ?? '-'}',
                    label: 'Your Rank',
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                // Active Users
                Expanded(
                  child: _statColumn(
                    icon: Icons.people,
                    iconColor: Colors.blue,
                    value: '${est?.totalUsers ?? 0}',
                    label: 'Active Users',
                  ),
                ),
              ],
            ),

            // Streak button
            if (est != null && est.streakDays > 0) ...[
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => showStreakRulesBottomSheet(context, est.streakDays),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${est.streakDays} Day Streak',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade800),
                        ),
                      ),
                      Text(
                        est.bonusMultiplier > 1
                            ? '+${((est.bonusMultiplier - 1) * 100).toStringAsFixed(0)}% Bonus'
                            : 'Keep going!',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 18, color: Colors.orange.shade400),
                    ],
                  ),
                ),
              ),
            ],

            // Countdown
            Obx(() {
              final text = controller.countdownText.value;
              if (text.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('Next Distribution',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: PRIMARY_COLOR,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _statColumn({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }

  Widget _buildShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 120, height: 16, color: Colors.white),
                const Spacer(),
                Container(
                    width: 50,
                    height: 24,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12))),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  3,
                  (_) => Column(children: [
                        Container(
                            width: 40, height: 20, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(
                            width: 50, height: 10, color: Colors.white),
                      ])),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
      ),
    );
  }
}
