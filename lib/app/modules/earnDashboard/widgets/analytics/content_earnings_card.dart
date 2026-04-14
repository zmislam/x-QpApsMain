import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../controllers/earn_dashboard_controller.dart';
import '../../model/analytics_models.dart';

class ContentEarningsCard extends GetView<EarnDashboardController> {
  const ContentEarningsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final entries = controller.contentEarnings;
      final isLoading = controller.isAnalyticsLoading.value;

      return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.article_outlined,
                    size: 20, color: PRIMARY_COLOR),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Content Earnings',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                Text('${entries.length} items',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
            const SizedBox(height: 12),

            if (isLoading && entries.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: PRIMARY_COLOR)),
              )
            else if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text('No content earnings for this period',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500)),
                ),
              )
            else
              ...entries
                  .take(20)
                  .map((e) => _contentRow(e, entries.first.earned)),
          ],
        ),
      );
    });
  }

  Widget _contentRow(ContentEarningEntry entry, double maxEarned) {
    final barWidth = maxEarned > 0 ? (entry.earned / maxEarned) : 0.0;
    final typeIcon = _typeIcon(entry.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(typeIcon, size: 16, color: PRIMARY_COLOR),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.title,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('\$${entry.earned.toStringAsFixed(4)}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: barWidth.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: Colors.grey.shade100,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
            ),
          ),
          const SizedBox(height: 3),
          // Stats row
          Row(
            children: [
              _statChip(Icons.visibility_outlined, '${entry.views}'),
              const SizedBox(width: 10),
              _statChip(Icons.thumb_up_outlined, '${entry.engagement}'),
              const SizedBox(width: 10),
              _statChip(Icons.star_outline, entry.score.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: Colors.grey.shade400),
        const SizedBox(width: 2),
        Text(text,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
      ],
    );
  }

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'reel':
        return Icons.videocam_outlined;
      case 'video':
        return Icons.play_circle_outline;
      case 'image':
        return Icons.image_outlined;
      case 'story':
        return Icons.auto_stories_outlined;
      default:
        return Icons.article_outlined;
    }
  }
}
