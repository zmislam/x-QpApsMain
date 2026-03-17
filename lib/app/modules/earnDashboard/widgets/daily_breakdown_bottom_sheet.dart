import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../config/constants/color.dart';
import '../controllers/earn_dashboard_controller.dart';
import '../model/revenue_share_models.dart';

void showDailyBreakdownBottomSheet(BuildContext context, String date) {
  final controller = Get.find<EarnDashboardController>();
  controller.fetchDailyBreakdown(date);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Daily Breakdown — ${_formatDate(date)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isBreakdownLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final bd = controller.selectedDayBreakdown.value;
                if (bd == null) {
                  return const Center(
                      child: Text('No data available',
                          style: TextStyle(color: Colors.grey)));
                }
                return ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Earning amount
                    _infoCard('Earning', '\$${bd.earningAmount.toStringAsFixed(4)}',
                        Icons.attach_money, Colors.green),
                    const SizedBox(height: 10),

                    // Score & Rank
                    Row(
                      children: [
                        Expanded(
                            child: _infoCard(
                                'Score',
                                bd.totalScore.toStringAsFixed(1),
                                Icons.bolt,
                                PRIMARY_COLOR)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _infoCard(
                                'Rank',
                                '#${bd.dailyRank}',
                                Icons.emoji_events,
                                Colors.amber.shade700)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Bonus & Percentile
                    Row(
                      children: [
                        Expanded(
                            child: _infoCard(
                                'Bonus',
                                '×${bd.bonusMultiplier.toStringAsFixed(2)}',
                                Icons.local_fire_department,
                                Colors.orange)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _infoCard(
                                'Percentile',
                                'Top ${bd.percentile.toStringAsFixed(1)}%',
                                Icons.trending_up,
                                Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Pool info
                    if (bd.distributionInfo != null) ...[
                      const Text('Distribution Info',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _detailRow(
                          'Total Ad Revenue',
                          '\$${bd.distributionInfo!.totalAdRevenue.toStringAsFixed(2)}'),
                      _detailRow(
                          'Creator Pool',
                          '\$${bd.distributionInfo!.creatorPool.toStringAsFixed(2)}'),
                      _detailRow('Users Paid',
                          '${bd.distributionInfo!.totalUsersPaid}'),
                      _detailRow('Your Pool Share',
                          '${bd.poolPercentage.toStringAsFixed(4)}%'),
                      _detailRow('Point Value',
                          '\$${bd.pointValue.toStringAsFixed(6)}'),
                      const SizedBox(height: 16),
                    ],

                    // Score breakdown
                    if (bd.scoreBreakdown != null) ...[
                      const Text('Activity Breakdown',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _activitySection(bd.scoreBreakdown!),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _infoCard(
    String label, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade600)),
              Text(value,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Text(value,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

Widget _activitySection(ScoreBreakdown sb) {
  final items = [
    _Act('Reactions Received', sb.postReactionsReceived),
    _Act('Comments Received', sb.postCommentsReceived),
    _Act('Shares Received', sb.postSharesReceived),
    _Act('Reel Views', sb.reelViewsReceived),
    _Act('Story Views', sb.storyViewsReceived),
    _Act('Reactions Given', sb.reactionsGiven),
    _Act('Comments Given', sb.commentsGiven),
    _Act('Shares Given', sb.sharesGiven),
    _Act('Campaign Impressions', sb.campaignImpressions),
    _Act('Campaign Clicks', sb.campaignClicks),
    _Act('Campaign Reactions', sb.campaignReactions),
    _Act('Campaign Comments', sb.campaignComments),
    _Act('Campaign Shares', sb.campaignShares),
    _Act('Campaign Watch 10s', sb.campaignWatch10sec),
  ];

  final active = items.where((a) => a.metric.count > 0 || a.metric.score > 0).toList();
  if (active.isEmpty) {
    return const Text('No activity recorded',
        style: TextStyle(color: Colors.grey, fontSize: 13));
  }

  return Column(
    children: active.map((a) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(a.label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ),
          Text('${a.metric.count}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text('${a.metric.score.toStringAsFixed(1)} pts',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ),
        ],
      ),
    )).toList(),
  );
}

String _formatDate(String dateStr) {
  final dt = DateTime.tryParse(dateStr);
  if (dt == null) return dateStr;
  return DateFormat('MMMM d, yyyy').format(dt);
}

class _Act {
  final String label;
  final ActivityMetric metric;
  const _Act(this.label, this.metric);
}
