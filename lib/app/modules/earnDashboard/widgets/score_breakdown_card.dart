import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/constants/color.dart';
import '../controllers/earn_dashboard_controller.dart';
import '../model/revenue_share_models.dart';

class ScoreBreakdownCard extends GetView<EarnDashboardController> {
  const ScoreBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pages = controller.pageBreakdown;
      if (controller.isLoading.value && pages.isEmpty) {
        return _buildShimmer();
      }
      if (pages.isEmpty) return const SizedBox.shrink();

      final totalScore =
          pages.fold<double>(0.0, (sum, p) => sum + p.score);
      final topPage = pages.isNotEmpty ? pages.first : null;

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
                  color: PRIMARY_COLOR.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.pie_chart,
                    size: 22, color: PRIMARY_COLOR),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Score Breakdown',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text(
                      '${pages.length} ${pages.length == 1 ? "source" : "sources"}${topPage != null ? " · Top: ${topPage.name.isNotEmpty ? topPage.name : "Personal"}" : ""}',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(totalScore.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: PRIMARY_COLOR)),
              const SizedBox(width: 2),
              Text(' pts',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade500)),
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
                    const Icon(Icons.pie_chart,
                        size: 20, color: PRIMARY_COLOR),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Score Breakdown',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87)),
                    ),
                    Obx(() {
                      final total = controller.pageBreakdown
                          .fold<double>(0, (s, p) => s + p.score);
                      return Text('Total: ${total.toStringAsFixed(1)} pts',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: PRIMARY_COLOR));
                    }),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Obx(() {
                  final pages = controller.pageBreakdown;
                  final totalScore =
                      pages.fold<double>(0, (s, p) => s + p.score);
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: pages.length,
                    itemBuilder: (_, i) =>
                        _pageItem(pages[i], totalScore),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageItem(PageBreakdownEntry entry, double totalScore) {
    final pct = totalScore > 0 ? (entry.score / totalScore * 100) : 0.0;
    final isPersonal = entry.type == 'personal';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: PRIMARY_COLOR.withValues(alpha: 0.1),
                backgroundImage: entry.profilePic.isNotEmpty
                    ? NetworkImage(entry.profilePic)
                    : null,
                child: entry.profilePic.isEmpty
                    ? Icon(isPersonal ? Icons.person : Icons.pages,
                        size: 18, color: PRIMARY_COLOR)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name.isNotEmpty
                          ? entry.name
                          : (isPersonal ? 'Personal Profile' : 'Page'),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(isPersonal ? 'Personal' : 'Page',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${entry.score.toStringAsFixed(1)} pts',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: PRIMARY_COLOR)),
                  Text('${pct.toStringAsFixed(1)}%',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ],
          ),
          if (entry.streakDays > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('\u{1F525}', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text('${entry.streakDays} day streak',
                    style: TextStyle(
                        fontSize: 11, color: Colors.orange.shade700)),
                if (entry.bonusMultiplier > 1) ...[
                  const Spacer(),
                  Text(
                    '+${((entry.bonusMultiplier - 1) * 100).toStringAsFixed(0)}% bonus',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: totalScore > 0 ? entry.score / totalScore : 0,
              minHeight: 5,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
            ),
          ),
        ],
      ),
    );
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
                  Container(width: 120, height: 14, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(width: 80, height: 10, color: Colors.white),
                ],
              ),
            ),
            Container(width: 50, height: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
