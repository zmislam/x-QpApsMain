import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_search_controller.dart';

class TrendingHashtagGrid extends GetView<ReelsSearchController> {
  const TrendingHashtagGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hashtags = controller.trendingHashtags;
      if (hashtags.isEmpty) return const SizedBox();

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: hashtags.take(12).map((tag) {
          return GestureDetector(
            onTap: () => Get.toNamed('/reels-v2/search/hashtag',
                arguments: {'tag': tag.name}),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: tag.isTrending
                    ? Border.all(color: Colors.orange.withOpacity(0.5))
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tag.isTrending)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.local_fire_department,
                          color: Colors.orange, size: 16),
                    ),
                  Text(
                    '#${tag.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatCount(tag.reelCount),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
