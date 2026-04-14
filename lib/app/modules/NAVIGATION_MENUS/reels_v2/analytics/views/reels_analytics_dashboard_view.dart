import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';
import '../widgets/plays_chart.dart';
import '../widgets/audience_demographics.dart';
import '../widgets/top_performing_list.dart';
import '../widgets/follower_growth_chart.dart';
import '../widgets/monetization_summary.dart';

class ReelsAnalyticsDashboardView extends GetView<ReelsAnalyticsController> {
  const ReelsAnalyticsDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Reels Analytics',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.white),
            onPressed: controller.exportAnalytics,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadOverview();
          await controller.loadTopReels();
          await controller.loadAudience();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period selector
              _buildPeriodSelector(),
              const SizedBox(height: 20),

              // Overview cards
              Obx(() => _buildOverviewCards()),
              const SizedBox(height: 24),

              // Plays chart
              const Text('Plays Over Time',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const SizedBox(height: 200, child: PlaysChart()),
              const SizedBox(height: 24),

              // Audience
              const Text('Audience',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const AudienceDemographicsWidget(),
              const SizedBox(height: 24),

              // Top Performing
              const Text('Top Performing Reels',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const TopPerformingList(),
              const SizedBox(height: 24),

              // Follower Growth
              const Text('Follower Growth',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const SizedBox(height: 180, child: FollowerGrowthChart()),
              const SizedBox(height: 24),

              // Monetization
              const Text('Monetization',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const MonetizationSummary(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['7d', '30d', '90d', 'lifetime'];
    final labels = ['7 days', '30 days', '90 days', 'Lifetime'];

    return Obx(() => Row(
          children: List.generate(periods.length, (i) {
            final isActive = controller.selectedPeriod.value == periods[i];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => controller.changePeriod(periods[i]),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: isActive ? Colors.black : Colors.white70,
                      fontSize: 13,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        ));
  }

  Widget _buildOverviewCards() {
    if (controller.overviewLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    final ov = controller.overview.value;
    if (ov == null) return const SizedBox();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _metricCard('Plays', _formatCount(ov.totalPlays), Icons.play_arrow),
        _metricCard('Likes', _formatCount(ov.totalLikes), Icons.favorite),
        _metricCard('Comments', _formatCount(ov.totalComments), Icons.comment),
        _metricCard('Shares', _formatCount(ov.totalShares), Icons.share),
        _metricCard('Saves', _formatCount(ov.totalSaves), Icons.bookmark),
        _metricCard(
            'Avg Watch',
            '${ov.avgWatchTimeSeconds.toStringAsFixed(1)}s',
            Icons.timer),
      ],
    );
  }

  Widget _metricCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 18),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
