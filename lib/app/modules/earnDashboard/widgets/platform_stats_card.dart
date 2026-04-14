import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../../config/constants/color.dart';
import '../controllers/earn_dashboard_controller.dart';
import '../model/revenue_share_models.dart';
import '../services/earning_config_service.dart';

class PlatformStatsCard extends GetView<EarnDashboardController> {
  const PlatformStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.platformStats.value == null) {
        return _buildShimmer();
      }

      final stats = controller.platformStats.value;
      if (stats == null) return const SizedBox.shrink();

      final monthly = stats.monthlySummary;

      return GestureDetector(
        onTap: () => _showDetailModal(context),
        child: Container(
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
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.analytics,
                    size: 22, color: Colors.purple),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Platform Stats',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text(
                      monthly != null
                          ? '${monthly.totalUsersPaid} users paid this month'
                          : '${stats.revenueSharePercentage.toStringAsFixed(0)}% revenue share',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: PRIMARY_COLOR.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${stats.revenueSharePercentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: PRIMARY_COLOR),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                  size: 20, color: Colors.grey.shade400),
            ],
          ),
        ),
      );
    });
  }

  void _showDetailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _modalHandle(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.analytics,
                        size: 20, color: PRIMARY_COLOR),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Platform Stats',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87)),
                    ),
                    Obx(() {
                      final s = controller.platformStats.value;
                      return s != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: PRIMARY_COLOR.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${s.revenueSharePercentage.toStringAsFixed(0)}% Rev Share',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: PRIMARY_COLOR),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Obx(() => _buildDetailContent(scrollController)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailContent(ScrollController scrollController) {
    final stats = controller.platformStats.value;
    if (stats == null) {
      return const Center(
          child: Text('No data', style: TextStyle(color: Colors.grey)));
    }
    final monthly = stats.monthlySummary;
    final revPercent = stats.revenueSharePercentage > 0
        ? stats.revenueSharePercentage.toStringAsFixed(0)
        : Get.find<EarningConfigService>().revenueSharePercent.toStringAsFixed(0);
    final yesterdayPool = stats.recentDistributions.isNotEmpty
        ? stats.recentDistributions.first.creatorPool
        : 0.0;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // ── 4 Stat Cards (2×2 grid matching web) ──
        Row(
          children: [
            _statCard(
              icon: Icons.monetization_on,
              iconColor: Colors.green,
              label: 'Total Distributed (30 Days)',
              value: '\$${_formatNum(monthly?.totalCreatorPool ?? 0)}',
            ),
            const SizedBox(width: 10),
            _statCard(
              icon: Icons.people,
              iconColor: Colors.blue,
              label: 'Total Creators Earning',
              value: _formatCount(stats.totalCreatorsEarning),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _statCard(
              icon: Icons.auto_graph,
              iconColor: Colors.purple,
              label: 'Distributed Yesterday',
              value: '\$${_formatNum(yesterdayPool)}',
            ),
            const SizedBox(width: 10),
            _statCard(
              icon: Icons.show_chart,
              iconColor: Colors.orange,
              label: 'Avg Daily Distribution',
              value: '\$${_formatNum(monthly?.avgDailyPool ?? 0)}',
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Revenue Share Program ──
        Row(
          children: [
            const Icon(Icons.handshake, size: 20, color: Colors.amber),
            const SizedBox(width: 8),
            const Text('Revenue Share Program',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
              children: [
                const TextSpan(text: 'We share '),
                TextSpan(
                  text: '$revPercent%',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.green),
                ),
                const TextSpan(
                    text: ' of our ad revenue with active users. Engage with content, build your streak, and earn real money!'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Distribution Schedule ──
        Row(
          children: [
            const Icon(Icons.schedule, size: 20, color: PRIMARY_COLOR),
            const SizedBox(width: 8),
            const Text('Distribution Schedule',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _scheduleRow('Calculation Time',
                  'Daily at ${Get.find<EarningConfigService>().distributionTimeFormatted}'),
              const Divider(height: 16),
              _scheduleRow('Credit Time', 'Within 1 hour of calculation'),
              const Divider(height: 16),
              _scheduleRow('Minimum to Earn',
                  '${Get.find<EarningConfigService>().minEngagementScore.toStringAsFixed(0)} qualifying action'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── How to Earn More ──
        Row(
          children: [
            const Icon(Icons.lightbulb, size: 20, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('How to Earn More',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _EarnTip(icon: Icons.favorite, label: 'React to posts', color: Colors.red),
            _EarnTip(icon: Icons.chat_bubble, label: 'Comment on content', color: Colors.blue),
            _EarnTip(icon: Icons.share, label: 'Share interesting posts', color: Colors.teal),
            _EarnTip(icon: Icons.play_circle_fill, label: 'Watch reels (>50%)', color: Colors.purple),
            _EarnTip(icon: Icons.visibility, label: 'View stories', color: Colors.orange),
            _EarnTip(icon: Icons.local_fire_department, label: 'Build daily streaks', color: Colors.deepOrange),
          ],
        ),
        const SizedBox(height: 16),

        // ── Recent Distributions (if data available) ──
        if (stats.recentDistributions.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.history, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 8),
              const Text('Recent Distributions',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          ...stats.recentDistributions
              .take(7)
              .map((d) => _distributionRow(d)),
        ],
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: iconColor)),
          ],
        ),
      ),
    );
  }

  Widget _scheduleRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13, color: Colors.grey.shade600)),
        Text(value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _distributionRow(DistributionDay d) {
    final dt = DateTime.tryParse(d.date);
    final dateStr = dt != null ? DateFormat('MMM d').format(dt) : d.date;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(dateStr,
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade600)),
          ),
          Expanded(
            child: Text('\$${_formatNum(d.creatorPool)}',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          Text('${d.usersPaid} users',
              style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(width: 8),
          Text('avg \$${d.averageEarning.toStringAsFixed(4)}',
              style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  String _formatNum(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(2)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(2)}K';
    return n.toStringAsFixed(2);
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  Widget _modalHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      width: 40, height: 4,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2)),
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
        child: Row(
          children: [
            Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12))),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 110, height: 14, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(width: 80, height: 10, color: Colors.white),
                ],
              ),
            ),
            Container(width: 40, height: 22, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _EarnTip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _EarnTip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color)),
        ],
      ),
    );
  }
}
