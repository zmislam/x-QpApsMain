import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/constants/color.dart';
import '../controllers/earn_dashboard_controller.dart';
import 'dart:math' as math;

class ScoreWeightsCard extends GetView<EarnDashboardController> {
  const ScoreWeightsCard({super.key});

  List<_W> _buildWeights() {
    final sw = controller.scoreWeights.value?.scoreWeights ?? {};
    final breakdown = controller.todayEstimate.value?.scoreBreakdown;

    final receivedWeights = [
      _W('post_reaction_received', Icons.thumb_up, 'Reactions Received',
          'Others reacting to your posts', Colors.pink,
          sw['post_reaction_received'] ?? 1.0,
          breakdown?.postReactionsReceived.count ?? 0),
      _W('post_comment_received', Icons.comment, 'Comments Received',
          'Others commenting on your posts', Colors.indigo,
          sw['post_comment_received'] ?? 2.0,
          breakdown?.postCommentsReceived.count ?? 0),
      _W('post_share_received', Icons.share, 'Shares Received',
          'Others sharing your posts', Colors.teal,
          sw['post_share_received'] ?? 3.0,
          breakdown?.postSharesReceived.count ?? 0),
      _W('reel_view_received', Icons.play_arrow, 'Reel Views',
          'Others watching your reels (50%+)', Colors.purple,
          sw['reel_view_received'] ?? 0.5,
          breakdown?.reelViewsReceived.count ?? 0),
      _W('story_view_received', Icons.visibility, 'Story Views',
          'Others viewing your stories', Colors.orange,
          sw['story_view_received'] ?? 0.3,
          breakdown?.storyViewsReceived.count ?? 0),
    ];

    final givenWeights = [
      _W('reaction_given', Icons.favorite, 'Reactions Given',
          'Each reaction you give', Colors.red,
          sw['reaction_given'] ?? 0.2,
          breakdown?.reactionsGiven.count ?? 0),
      _W('comment_given', Icons.chat_bubble, 'Comments Made',
          'Each comment you post', Colors.blue,
          sw['comment_given'] ?? 0.5,
          breakdown?.commentsGiven.count ?? 0),
      _W('share_given', Icons.share, 'Content Shared',
          'Each post you share', Colors.green,
          sw['share_given'] ?? 0.3,
          breakdown?.sharesGiven.count ?? 0),
    ];

    final campaignCount = (breakdown?.campaignImpressions.count ?? 0) +
        (breakdown?.campaignClicks.count ?? 0) +
        (breakdown?.campaignReactions.count ?? 0) +
        (breakdown?.campaignComments.count ?? 0) +
        (breakdown?.campaignShares.count ?? 0) +
        (breakdown?.campaignWatch10sec.count ?? 0);
    final campaignWeights = [
      _W('campaign_interaction', Icons.campaign, 'Campaign',
          'Interact with campaigns', Colors.cyan,
          sw['campaign_click'] ?? 0.5, campaignCount),
    ];

    return [...receivedWeights, ...givenWeights, ...campaignWeights];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.scoreWeights.value == null) {
        return _buildShimmer();
      }

      final allWeights = _buildWeights();
      final totalPts =
          allWeights.fold<double>(0, (s, w) => s + w.weight * w.count);
      final actCount =
          allWeights.fold<int>(0, (s, w) => s + w.count);

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
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.pie_chart_outline,
                    size: 22, color: Colors.blue),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Score Weights',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text(
                      '$actCount activities today',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              if (totalPts > 0) ...[
                Text('+${totalPts.toStringAsFixed(1)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: PRIMARY_COLOR)),
                const SizedBox(width: 2),
                Text(' pts',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500)),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.pie_chart_outline,
                        size: 20, color: PRIMARY_COLOR),
                    SizedBox(width: 8),
                    Text('Score Weights',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87)),
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
    final sw = controller.scoreWeights.value?.scoreWeights ?? {};
    final breakdown = controller.todayEstimate.value?.scoreBreakdown;

    final receivedWeights = [
      _W('post_reaction_received', Icons.thumb_up, 'Reactions Received',
          'Others reacting to your posts', Colors.pink,
          sw['post_reaction_received'] ?? 1.0,
          breakdown?.postReactionsReceived.count ?? 0),
      _W('post_comment_received', Icons.comment, 'Comments Received',
          'Others commenting on your posts', Colors.indigo,
          sw['post_comment_received'] ?? 2.0,
          breakdown?.postCommentsReceived.count ?? 0),
      _W('post_share_received', Icons.share, 'Shares Received',
          'Others sharing your posts', Colors.teal,
          sw['post_share_received'] ?? 3.0,
          breakdown?.postSharesReceived.count ?? 0),
      _W('reel_view_received', Icons.play_arrow, 'Reel Views',
          'Others watching your reels (50%+)', Colors.purple,
          sw['reel_view_received'] ?? 0.5,
          breakdown?.reelViewsReceived.count ?? 0),
      _W('story_view_received', Icons.visibility, 'Story Views',
          'Others viewing your stories', Colors.orange,
          sw['story_view_received'] ?? 0.3,
          breakdown?.storyViewsReceived.count ?? 0),
    ];

    final givenWeights = [
      _W('reaction_given', Icons.favorite, 'Reactions Given',
          'Each reaction you give', Colors.red,
          sw['reaction_given'] ?? 0.2,
          breakdown?.reactionsGiven.count ?? 0),
      _W('comment_given', Icons.chat_bubble, 'Comments Made',
          'Each comment you post', Colors.blue,
          sw['comment_given'] ?? 0.5,
          breakdown?.commentsGiven.count ?? 0),
      _W('share_given', Icons.share, 'Content Shared',
          'Each post you share', Colors.green,
          sw['share_given'] ?? 0.3,
          breakdown?.sharesGiven.count ?? 0),
    ];

    final campaignCount = (breakdown?.campaignImpressions.count ?? 0) +
        (breakdown?.campaignClicks.count ?? 0) +
        (breakdown?.campaignReactions.count ?? 0) +
        (breakdown?.campaignComments.count ?? 0) +
        (breakdown?.campaignShares.count ?? 0) +
        (breakdown?.campaignWatch10sec.count ?? 0);
    final campaignWeights = [
      _W('campaign_interaction', Icons.campaign, 'Campaign',
          'Interact with campaigns', Colors.cyan,
          sw['campaign_click'] ?? 0.5, campaignCount),
    ];

    final allWeights = [
      ...receivedWeights, ...givenWeights, ...campaignWeights
    ];
    final maxPts = allWeights
        .map((w) => w.weight * w.count)
        .fold<double>(0, (a, b) => math.max(a, b))
        .clamp(1.0, double.infinity);
    final totalPts =
        allWeights.fold<double>(0, (s, w) => s + w.weight * w.count);
    final receivedPts =
        receivedWeights.fold<double>(0, (s, w) => s + w.weight * w.count);
    final givenPts =
        givenWeights.fold<double>(0, (s, w) => s + w.weight * w.count);
    final campaignPts =
        campaignWeights.fold<double>(0, (s, w) => s + w.weight * w.count);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // Today's Total
        if (totalPts > 0)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: PRIMARY_COLOR.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Points",
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade600)),
                Text('+${totalPts.toStringAsFixed(1)} pts',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PRIMARY_COLOR)),
              ],
            ),
          ),
        const SizedBox(height: 14),

        _sectionHeader(
            '\u{1F4E5} Engagement Received', receivedPts, Colors.pink),
        const SizedBox(height: 6),
        ...receivedWeights.map((w) => _weightItem(w, maxPts)),
        const SizedBox(height: 14),

        _sectionHeader(
            '\u{1F4E4} Your Activities', givenPts, Colors.blue),
        const SizedBox(height: 6),
        ...givenWeights.map((w) => _weightItem(w, maxPts)),
        const SizedBox(height: 14),

        _sectionHeader(
            '\u{1F4E2} Campaign', campaignPts, Colors.cyan),
        const SizedBox(height: 6),
        ...campaignWeights.map((w) => _weightItem(w, maxPts)),
      ],
    );
  }

  Widget _sectionHeader(String title, double pts, MaterialColor color) {
    return Row(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 0.5)),
        const Spacer(),
        if (pts > 0)
          Text('+${pts.toStringAsFixed(1)} pts',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: color.shade500)),
      ],
    );
  }

  Widget _weightItem(_W w, double maxPts) {
    final pts = w.weight * w.count;
    final progress = maxPts > 0 ? pts / maxPts : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: w.color.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: w.color.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: w.color.shade100, shape: BoxShape.circle),
                child: Icon(w.icon, size: 16, color: w.color.shade600),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(w.label,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(w.description,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\u00d7${w.weight}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  Text('${w.count} acts',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(w.color.shade400),
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('+${pts.toStringAsFixed(1)} pts',
                  style: TextStyle(fontSize: 10, color: w.color.shade600)),
              Text('${w.count} \u00d7 ${w.weight} = ${pts.toStringAsFixed(1)}',
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey.shade500)),
            ],
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
                  Container(width: 110, height: 14, color: Colors.white),
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

class _W {
  final String key;
  final IconData icon;
  final String label;
  final String description;
  final MaterialColor color;
  final double weight;
  final int count;
  const _W(this.key, this.icon, this.label, this.description, this.color,
      this.weight, this.count);
}
