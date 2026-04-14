import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';
import '../widgets/plays_chart.dart';
import '../widgets/retention_curve.dart';
import '../widgets/reach_source_breakdown.dart';
import '../widgets/ab_thumbnail_result.dart';

class ReelInsightView extends GetView<ReelsAnalyticsController> {
  const ReelInsightView({super.key});

  @override
  Widget build(BuildContext context) {
    final reelId = Get.arguments as String? ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadReelInsight(reelId);
      controller.loadRetentionCurve(reelId);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Reel Insights',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.reelInsightLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        final insight = controller.reelInsight.value;
        if (insight == null) {
          return const Center(
            child: Text('No data available',
                style: TextStyle(color: Colors.grey)),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Key Metrics
              _buildMetricsRow(insight),
              const SizedBox(height: 24),

              // Plays over time
              const Text('Plays Over Time',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const SizedBox(height: 200, child: PlaysChart()),
              const SizedBox(height: 24),

              // Retention curve
              const Text('Audience Retention',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                'Avg watch time: ${insight.avgWatchTimeSeconds.toStringAsFixed(1)}s',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 180, child: RetentionCurve()),
              const SizedBox(height: 24),

              // Reach sources
              const Text('Reach Sources',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ReachSourceBreakdown(sources: insight.reachSources),
              const SizedBox(height: 24),

              // A/B Thumbnail result (if applicable)
              if (insight.hasAbThumbnail) ...[
                const Text('A/B Thumbnail Results',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                AbThumbnailResult(
                  thumbnailAUrl: insight.thumbnailAUrl,
                  thumbnailBUrl: insight.thumbnailBUrl,
                  thumbnailAImpressions: insight.thumbnailAImpressions,
                  thumbnailBImpressions: insight.thumbnailBImpressions,
                  thumbnailACtr: insight.thumbnailACtr,
                  thumbnailBCtr: insight.thumbnailBCtr,
                ),
                const SizedBox(height: 24),
              ],

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMetricsRow(dynamic insight) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _metricChip('Plays', _formatCount(insight.plays), Icons.play_arrow),
        _metricChip('Likes', _formatCount(insight.likes), Icons.favorite),
        _metricChip('Comments', _formatCount(insight.comments), Icons.comment),
        _metricChip('Shares', _formatCount(insight.shares), Icons.share),
        _metricChip('Saves', _formatCount(insight.saves), Icons.bookmark),
        _metricChip('Reach', _formatCount(insight.reach), Icons.visibility),
      ],
    );
  }

  Widget _metricChip(String label, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
