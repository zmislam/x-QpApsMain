import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../../config/constants/color.dart';
import '../controllers/earn_dashboard_controller.dart';
import '../model/revenue_share_models.dart';
import 'daily_breakdown_bottom_sheet.dart';

class EarningHistoryCard extends GetView<EarnDashboardController> {
  const EarningHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isEarningsLoading.value &&
          controller.dailyEarnings.isEmpty) {
        return _buildShimmer();
      }

      final summary = controller.dailyEarningsSummary.value;
      final earnings = controller.dailyEarnings;
      // "Total Shown" = sum of current page entries (matches web)
      final totalShown =
          earnings.fold<double>(0, (sum, e) => sum + e.amount);

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
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bar_chart,
                    size: 22, color: Colors.green),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Earning History',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text(
                      summary != null
                          ? 'Avg: \$${summary.avgEarning.toStringAsFixed(4)}/day'
                          : '${earnings.length} days',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Shown',
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey.shade400)),
                  Text('\$${totalShown.toStringAsFixed(4)}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.green.shade700)),
                ],
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
        initialChildSize: 0.8,
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
              // Header with Total Shown
              Obx(() {
                final earnings = controller.dailyEarnings;
                final totalShown =
                    earnings.fold<double>(0, (s, e) => s + e.amount);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.bar_chart,
                          size: 20, color: PRIMARY_COLOR),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Earning History',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total Shown',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade400)),
                          Text('\$${totalShown.toStringAsFixed(4)}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade700)),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              // Summary chips: Best Day, Average, Days Active
              Obx(() {
                final summary = controller.dailyEarningsSummary.value;
                final pagination =
                    controller.dailyEarningsPagination.value;
                if (summary == null) return const SizedBox.shrink();
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _summaryChip('Best Day',
                          '\$${summary.bestDayAmount.toStringAsFixed(4)}'),
                      const SizedBox(width: 8),
                      _summaryChip('Average',
                          '\$${summary.avgEarning.toStringAsFixed(4)}'),
                      const SizedBox(width: 8),
                      _summaryChip('Days Active',
                          '${pagination?.total ?? 0}'),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              const Divider(height: 1),
              // List
              Expanded(
                child: Obx(() {
                  final earnings = controller.dailyEarnings;
                  final pagination =
                      controller.dailyEarningsPagination.value;
                  if (earnings.isEmpty) {
                    return const Center(
                        child: Text('No earnings yet',
                            style: TextStyle(color: Colors.grey)));
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: earnings.length,
                          itemBuilder: (ctx, i) =>
                              _earningRow(ctx, earnings[i],
                                  i + 1 < earnings.length
                                      ? earnings[i + 1]
                                      : null),
                        ),
                      ),
                      if (pagination != null && pagination.pages > 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _pageButton(Icons.chevron_left,
                                  enabled:
                                      controller.earningsCurrentPage.value >
                                          1,
                                  onTap: () =>
                                      controller.fetchDailyEarnings(
                                          page: controller
                                                  .earningsCurrentPage
                                                  .value -
                                              1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14),
                                child: Text(
                                  '${controller.earningsCurrentPage.value} / ${pagination.pages}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              _pageButton(Icons.chevron_right,
                                  enabled:
                                      controller.earningsCurrentPage.value <
                                          pagination.pages,
                                  onTap: () =>
                                      controller.fetchDailyEarnings(
                                          page: controller
                                                  .earningsCurrentPage
                                                  .value +
                                              1)),
                            ],
                          ),
                        ),
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

  Widget _summaryChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: PRIMARY_COLOR)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Widget _earningRow(BuildContext context, DailyEarningEntry e,
      DailyEarningEntry? prevEntry) {
    final dt = DateTime.tryParse(e.date);
    final now = DateTime.now();
    String dateStr;
    if (dt != null) {
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final entryDay = DateTime(dt.year, dt.month, dt.day);
      if (entryDay == today) {
        dateStr = 'Today';
      } else if (entryDay == yesterday) {
        dateStr = 'Yesterday';
      } else {
        dateStr = DateFormat('E, MMM d').format(dt);
      }
    } else {
      dateStr = e.date;
    }

    // % change vs previous (next item in list since sorted newest first)
    double? pctChange;
    if (prevEntry != null && prevEntry.amount > 0) {
      pctChange =
          ((e.amount - prevEntry.amount) / prevEntry.amount) * 100;
    }

    // Bonus badges
    final hasBonuses =
        e.verifiedBonus > 0 || e.streakBonus > 0;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).pop();
        showDailyBreakdownBottomSheet(context, e.date);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date + rank + pts + bonus badges
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateStr,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    'Rank #${e.rank} \u00b7 ${e.finalScore.toStringAsFixed(1)} pts',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500),
                  ),
                  if (hasBonuses) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: [
                        if (e.verifiedBonus > 0)
                          _bonusBadge(
                            '\u2713 Verified +${(e.verifiedBonus * 100).toStringAsFixed(0)}%',
                            Colors.teal,
                          ),
                        if (e.streakBonus > 0)
                          _bonusBadge(
                            '\u{1F525} Streak +${(e.streakBonus * 100).toStringAsFixed(0)}%',
                            Colors.orange,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Amount + % change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${e.amount.toStringAsFixed(4)}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700),
                ),
                if (pctChange != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${pctChange >= 0 ? "\u223c+" : "\u223c"}${pctChange.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 11,
                      color: pctChange >= 0
                          ? Colors.green.shade600
                          : Colors.red.shade400,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(Icons.chevron_right,
                  size: 16, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bonusBadge(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color.shade700)),
    );
  }

  Widget _pageButton(IconData icon,
      {required bool enabled, required VoidCallback onTap}) {
    return Material(
      color: enabled ? PRIMARY_COLOR : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          child: Icon(icon,
              size: 18, color: enabled ? Colors.white : Colors.grey),
        ),
      ),
    );
  }

  Widget _modalHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      width: 40,
      height: 4,
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
                width: 42,
                height: 42,
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
            Container(width: 60, height: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
