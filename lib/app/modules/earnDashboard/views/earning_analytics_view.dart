import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../controllers/earn_dashboard_controller.dart';
import '../../widgets/analytics/earnings_trend_chart.dart';
import '../../widgets/analytics/period_compare_card.dart';
import '../../widgets/analytics/rank_tracker_card.dart';
import '../../widgets/analytics/content_earnings_card.dart';
import '../../widgets/analytics/score_optimizer_card.dart';
import '../../widgets/analytics/earning_forecast_card.dart';

class EarningAnalyticsView extends GetView<EarnDashboardController> {
  const EarningAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isAnalyticsLoading.value;

      return RefreshIndicator(
        color: PRIMARY_COLOR,
        onRefresh: () => controller.fetchAnalytics(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // Earnings trend chart with period selector
            const EarningsTrendChart(),
            const SizedBox(height: 14),

            // Period comparison
            const PeriodCompareCard(),
            const SizedBox(height: 14),

            // Rank tracker
            const RankTrackerCard(),
            const SizedBox(height: 14),

            // Content earnings breakdown
            const ContentEarningsCard(),
            const SizedBox(height: 14),

            // Score optimizer recommendations
            const ScoreOptimizerCard(),
            const SizedBox(height: 14),

            // Earning forecast
            const EarningForecastCard(),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }
}
