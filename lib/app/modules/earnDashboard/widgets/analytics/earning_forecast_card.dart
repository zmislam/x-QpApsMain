import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../controllers/earn_dashboard_controller.dart';
import '../../model/analytics_models.dart';
import '../../services/earning_config_service.dart';

class EarningForecastCard extends GetView<EarnDashboardController> {
  const EarningForecastCard({super.key});

  EarningConfigService get _config => Get.find<EarningConfigService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final forecast = controller.earningForecast.value;
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
                const Icon(Icons.auto_graph,
                    size: 20, color: PRIMARY_COLOR),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Earning Forecast',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (isLoading && forecast == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: PRIMARY_COLOR)),
              )
            else if (forecast == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text('Forecast data unavailable',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500)),
                ),
              )
            else ...[
              // Projected earnings row
              Row(
                children: [
                  Expanded(
                    child: _projectedTile(
                        'Next 7 Days', forecast.projected7d),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _projectedTile(
                        'Next 30 Days', forecast.projected30d),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Confidence
              _confidenceBar(forecast.confidence),
              const SizedBox(height: 14),

              // Trend direction
              _trendRow(forecast),
              const SizedBox(height: 14),

              // Revenue share disclaimer (dynamic from config)
              _disclaimer(),
            ],
          ],
        ),
      );
    });
  }

  Widget _projectedTile(String label, double amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PRIMARY_COLOR.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text('\$${amount.toStringAsFixed(4)}',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _confidenceBar(double confidence) {
    final pct = (confidence * 100).round();
    final barColor = confidence >= 0.7
        ? Colors.green
        : confidence >= 0.4
            ? Colors.orange
            : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Confidence',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700)),
            const Spacer(),
            Text('$pct%',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: barColor)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  Widget _trendRow(EarningForecastData f) {
    final isUp = f.trendDirection == 'up';
    final color = isUp ? Colors.green : Colors.red;
    final icon = isUp ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(f.trendDirection == 'up' ? 'Upward trend' : 'Downward trend',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color)),
          const Spacer(),
          if (f.basedOnDays > 0)
            Text('Based on ${f.basedOnDays} days',
                style: TextStyle(
                    fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    final revenueShare = _config.revenueSharePercent;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 14, color: Colors.amber.shade700),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Projections are estimates based on current activity. '
              'Actual earnings depend on platform revenue share ($revenueShare%) '
              'and content performance.',
              style: TextStyle(fontSize: 10, color: Colors.amber.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
