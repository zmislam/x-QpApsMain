import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/constants/color.dart';
import '../../controllers/earn_dashboard_controller.dart';
import '../../model/analytics_models.dart';

class EarningsTrendChart extends GetView<EarnDashboardController> {
  const EarningsTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trend = controller.earningsTrend.value;
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
            // Header + period selector
            Row(
              children: [
                const Icon(Icons.show_chart, size: 20, color: PRIMARY_COLOR),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Earnings Trend',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                _periodSelector(),
              ],
            ),
            const SizedBox(height: 16),

            // Chart area
            if (isLoading && trend == null)
              const SizedBox(
                  height: 180,
                  child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: PRIMARY_COLOR)))
            else if (trend == null || trend.dailyData.isEmpty)
              SizedBox(
                height: 180,
                child: Center(
                  child: Text('No data for this period',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500)),
                ),
              )
            else ...[
              SizedBox(
                height: 180,
                child: _buildChart(trend.dailyData),
              ),
              const SizedBox(height: 12),
              // Summary row
              _summaryRow(trend),
            ],
          ],
        ),
      );
    });
  }

  Widget _periodSelector() {
    return Obx(() {
      final selected = controller.analyticsPeriod.value;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: ['7d', '30d', '90d'].map((p) {
          final active = selected == p;
          return GestureDetector(
            onTap: () => controller.setAnalyticsPeriod(p),
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: active
                    ? PRIMARY_COLOR
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(p,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : Colors.grey.shade600)),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildChart(List<DailyTrendPoint> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].earned));
    }
    final maxY =
        data.map((d) => d.earned).reduce((a, b) => a > b ? a : b) * 1.2;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? maxY / 4 : 1,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.grey.shade200,
            strokeWidth: 0.8,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (data.length / 5).ceilToDouble().clamp(1, 30),
              getTitlesWidget: (val, _) {
                final idx = val.toInt();
                if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                final dt = DateTime.tryParse(data[idx].date);
                if (dt == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(DateFormat('M/d').format(dt),
                      style: TextStyle(
                          fontSize: 9, color: Colors.grey.shade500)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: maxY > 0 ? maxY : 1,
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((s) {
              final idx = s.x.toInt();
              final dt = idx < data.length
                  ? DateTime.tryParse(data[idx].date)
                  : null;
              final dateStr = dt != null ? DateFormat('MMM d').format(dt) : '';
              return LineTooltipItem(
                '\$$dateStr\n\$${s.y.toStringAsFixed(4)}',
                const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: PRIMARY_COLOR,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: data.length <= 14,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 3, strokeWidth: 0, color: PRIMARY_COLOR),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PRIMARY_COLOR.withValues(alpha: 0.2),
                  PRIMARY_COLOR.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(EarningsTrendData trend) {
    final trendColor = trend.trend == 'up'
        ? Colors.green
        : trend.trend == 'down'
            ? Colors.red
            : Colors.grey;
    final trendIcon = trend.trend == 'up'
        ? Icons.trending_up
        : trend.trend == 'down'
            ? Icons.trending_down
            : Icons.trending_flat;

    return Row(
      children: [
        _summaryItem('Total', '\$${trend.totalEarned.toStringAsFixed(4)}'),
        _summaryDivider(),
        _summaryItem('Avg/Day', '\$${trend.avgDaily.toStringAsFixed(4)}'),
        _summaryDivider(),
        _summaryItem(
          'Trend',
          trend.trend.capitalizeFirst ?? 'Stable',
          valueColor: trendColor,
          icon: trendIcon,
        ),
      ],
    );
  }

  Widget _summaryItem(String label, String value,
      {Color? valueColor, IconData? icon}) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: valueColor ?? PRIMARY_COLOR),
                const SizedBox(width: 2),
              ],
              Flexible(
                child: Text(value,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: valueColor ?? Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(label,
              style:
                  TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _summaryDivider() =>
      Container(width: 1, height: 28, color: Colors.grey.shade200);
}
