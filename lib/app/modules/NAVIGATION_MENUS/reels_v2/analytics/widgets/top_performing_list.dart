import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_analytics_controller.dart';
import '../../models/reel_v2_model.dart';

class TopPerformingList extends GetView<ReelsAnalyticsController> {
  const TopPerformingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.topReelsLoading.value) {
        return const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        );
      }

      if (controller.topReels.isEmpty) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('No reels data',
                style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      return Column(
        children: List.generate(
          controller.topReels.length.clamp(0, 10),
          (index) {
            final reel = controller.topReels[index];
            return _reelRow(reel, index + 1);
          },
        ),
      );
    });
  }

  Widget _reelRow(ReelV2Model reel, int rank) {
    return GestureDetector(
      onTap: () => Get.toNamed('/reels-v2/analytics/insight',
          arguments: reel.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 28,
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: rank <= 3 ? Colors.amber : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 44,
                height: 56,
                color: Colors.grey[800],
                child: reel.thumbnailUrl != null
                    ? Image.network(reel.thumbnailUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.videocam,
                        color: Colors.grey, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reel.caption ?? 'Untitled',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _miniStat(Icons.play_arrow, reel.viewCount ?? 0),
                      const SizedBox(width: 12),
                      _miniStat(Icons.favorite, reel.likeCount ?? 0),
                      const SizedBox(width: 12),
                      _miniStat(Icons.comment, reel.commentCount ?? 0),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(IconData icon, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey, size: 12),
        const SizedBox(width: 2),
        Text(_formatCount(count),
            style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
