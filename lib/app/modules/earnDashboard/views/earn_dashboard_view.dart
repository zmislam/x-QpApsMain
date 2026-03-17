import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/color.dart';
import '../controllers/earn_dashboard_controller.dart';
import '../widgets/today_estimate_card.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/score_breakdown_card.dart';
import '../widgets/leaderboard_card.dart';
import '../widgets/score_weights_card.dart';
import '../widgets/earning_history_card.dart';
import '../widgets/platform_stats_card.dart';
import 'earning_guide_view.dart';

class EarnDashboardView extends GetView<EarnDashboardController> {
  const EarnDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: const Text('Earning Dashboard',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: PRIMARY_COLOR,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: PRIMARY_COLOR,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          tabs: const [
            Tab(
              icon: Icon(Icons.bar_chart, size: 18),
              text: 'Dashboard',
            ),
            Tab(
              icon: Icon(Icons.menu_book, size: 18),
              text: 'Rulebook',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _DashboardTab(),
          const EarningGuideView(),
        ],
      ),
    );
  }
}

class _DashboardTab extends GetView<EarnDashboardController> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: PRIMARY_COLOR,
      onRefresh: () => controller.refreshDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            TodayEstimateCard(),
            SizedBox(height: 12),
            WalletBalanceCard(),
            SizedBox(height: 12),
            ScoreBreakdownCard(),
            SizedBox(height: 12),
            LeaderboardCard(),
            SizedBox(height: 12),
            ScoreWeightsCard(),
            SizedBox(height: 12),
            EarningHistoryCard(),
            SizedBox(height: 12),
            PlatformStatsCard(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
