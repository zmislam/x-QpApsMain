import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../controllers/earn_dashboard_controller.dart';

/// Rank progression chart showing rank over time
class RankTrackerCard extends GetView<EarnDashboardController> {
  const RankTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trend = controller.earningsTrend.value;
      if (trend == null || trend.dailyData.isEmpty) {
        return const SizedBox.shrink();
      }

      // Build rank spots from dailyData (rank field)
      final rankData = trend.dailyData
          .where((d) => d.rank != null && d.rank! > 0)
          .toList();

      if (rankData.isEmpty) return const SizedBox.shrink();

      final ranks = rankData.map((d) => d.rank!.toDouble()).toList();
      final maxRank = ranks.reduce((a, b) => a > b ? a : b);
      final minRank = ranks.reduce((a, b) => a < b ? a : b);
      final currentRank = ranks.last.toInt();
      final bestRank = minRank.toInt();

      final spots = <FlSpot>[];
      for (var i = 0; i < rankData.length; i++) {
        spots.add(FlSpot(i.toDouble(), rankData[i].rank!.toDouble()));
      }

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
                const Icon(Icons.leaderboard_outlined,
                    size: 20, color: PRIMARY_COLOR),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Rank Tracker',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Stats row
            Row(
              children: [
                _statBox('Current', '#$currentRank', PRIMARY_COLOR),
                const SizedBox(width: 12),
                _statBox('Best', '#$bestRank', Colors.green),
              ],
            ),
            const SizedBox(height: 14),

            // Chart (inverted Y — lower rank = better)
            SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval:
                        ((maxRank - minRank) / 3).ceilToDouble().clamp(1, 100),
                    getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.grey.shade200, strokeWidth: 0.8),
                  ),
                  titlesData: const FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  // Invert: lower rank is higher on chart
                  minY: minRank - 1,
                  maxY: maxRank + 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.25,
                      color: PRIMARY_COLOR,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: rankData.length <= 14,
                        getDotPainter: (_, __, ___, ____) =>
                            FlDotCirclePainter(
                                radius: 2.5,
                                strokeWidth: 0,
                                color: PRIMARY_COLOR),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            PRIMARY_COLOR.withValues(alpha: 0.15),
                            PRIMARY_COLOR.withValues(alpha: 0.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text('↓ Lower rank = better position',
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey.shade400)),
            ),
          ],
        ),
      );
    });
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
