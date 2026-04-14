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
import 'earning_analytics_view.dart';
import '../services/earning_config_service.dart';
import '../../antiAbuse/widgets/account_warning_banner.dart';
import '../../antiAbuse/widgets/earning_frozen_banner.dart';
import '../../antiAbuse/services/anti_abuse_api_service.dart';
import '../../antiAbuse/models/anti_abuse_models.dart';

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
              icon: Icon(Icons.analytics_outlined, size: 18),
              text: 'Analytics',
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
          const EarningAnalyticsView(),
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
          children: [
            // Anti-abuse warning banners (Phase 7)
            Builder(builder: (_) {
              try {
                final configService = Get.find<EarningConfigService>();
                final antiAbuse = configService.antiAbuse;
                if (antiAbuse != null && antiAbuse.enabled) {
                  return FutureBuilder<AccountStanding?>(
                    future: AntiAbuseApiService().getAccountStanding(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const SizedBox.shrink();
                      }
                      final standing = snapshot.data!;
                      return Column(
                        children: [
                          if (standing.earningsFrozen)
                            EarningFrozenBanner(
                              frozenAmount: standing.frozenAmount ?? 0,
                            ),
                          if (standing.hasWarning && !standing.earningsFrozen)
                            const AccountWarningBanner(),
                          if (standing.hasWarning || standing.earningsFrozen)
                            const SizedBox(height: 12),
                        ],
                      );
                    },
                  );
                }
              } catch (_) {}
              return const SizedBox.shrink();
            }),
            const TodayEstimateCard(),
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
