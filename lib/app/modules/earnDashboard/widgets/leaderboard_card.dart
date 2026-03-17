import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/constants/color.dart';
import '../controllers/earn_dashboard_controller.dart';
import '../model/revenue_share_models.dart';

class LeaderboardCard extends GetView<EarnDashboardController> {
  const LeaderboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final entries = controller.leaderboard;
      if (controller.isLoading.value && entries.isEmpty) {
        return _buildShimmer();
      }

      final summary = controller.leaderboardSummary.value;
      // Find current user entry for summary display
      final myEntry = entries.cast<LeaderboardEntry?>().firstWhere(
          (e) => e?.isCurrentUser == true,
          orElse: () => null);
      final topEntry = entries.isNotEmpty ? entries.first : null;

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
                  color: Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.leaderboard,
                    size: 22, color: Colors.amber),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Leaderboard',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text(
                      myEntry != null
                          ? 'Your rank: #${myEntry.rank}${summary != null ? " of ${summary.totalUsersWithScore}" : ""}'
                          : '${summary?.totalUsersWithScore ?? entries.length} active users',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              if (topEntry != null) ...[
                Text('\u{1F947}', style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Text(_formatScore(topEntry.score),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.amber)),
              ],
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
                    const Icon(Icons.leaderboard,
                        size: 20, color: PRIMARY_COLOR),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Leaderboard',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87)),
                    ),
                    Obx(() {
                      final s = controller.leaderboardSummary.value;
                      return s != null
                          ? Text('${s.totalUsersWithScore} users',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500))
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Obx(() {
                  final entries = controller.leaderboard;
                  if (entries.isEmpty) {
                    return const Center(
                        child: Text('No leaderboard data yet',
                            style: TextStyle(color: Colors.grey)));
                  }
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: entries.length,
                    itemBuilder: (_, i) =>
                        _leaderboardRow(entries[i], i),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leaderboardRow(LeaderboardEntry entry, int index) {
    final isTop3 = entry.rank <= 3;
    final medal = _medalEmoji(entry.rank);
    final isCurrentUser = entry.isCurrentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? PRIMARY_COLOR.withValues(alpha: 0.08)
            : (isTop3
                ? Colors.amber.withValues(alpha: 0.06)
                : Colors.transparent),
        borderRadius: BorderRadius.circular(10),
        border: isCurrentUser
            ? Border.all(color: PRIMARY_COLOR.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: medal != null
                ? Text(medal,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center)
                : Text('#${entry.rank}',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600),
                    textAlign: TextAlign.center),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 16,
            backgroundColor: PRIMARY_COLOR.withValues(alpha: 0.1),
            backgroundImage:
                entry.user?.profilePicture.isNotEmpty == true
                    ? NetworkImage(entry.user!.profilePicture)
                    : null,
            child: entry.user?.profilePicture.isEmpty != false
                ? const Icon(Icons.person, size: 16, color: PRIMARY_COLOR)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.user?.name ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isCurrentUser)
                  const Text('You',
                      style: TextStyle(
                          fontSize: 11, color: PRIMARY_COLOR)),
              ],
            ),
          ),
          Text(
            _formatScore(entry.score),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isTop3 ? Colors.amber.shade800 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String? _medalEmoji(int rank) {
    switch (rank) {
      case 1: return '\u{1F947}';
      case 2: return '\u{1F948}';
      case 3: return '\u{1F949}';
      default: return null;
    }
  }

  String _formatScore(double score) {
    if (score >= 1000) return '${(score / 1000).toStringAsFixed(1)}K';
    return score.toStringAsFixed(1);
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
                  Container(width: 100, height: 14, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(width: 70, height: 10, color: Colors.white),
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
