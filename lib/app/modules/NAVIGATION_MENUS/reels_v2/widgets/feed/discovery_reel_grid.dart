import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reel_v2_model.dart';

class DiscoveryReelGrid extends StatelessWidget {
  final List<ReelV2Model> reels;
  final String? sectionTitle;
  final bool showViewAll;
  final VoidCallback? onViewAll;

  const DiscoveryReelGrid({
    super.key,
    required this.reels,
    this.sectionTitle,
    this.showViewAll = false,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (reels.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sectionTitle!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                if (showViewAll)
                  GestureDetector(
                    onTap: onViewAll,
                    child: const Text('View all',
                        style: TextStyle(color: Colors.blue, fontSize: 13)),
                  ),
              ],
            ),
          ),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 9 / 16,
          ),
          itemCount: reels.length,
          itemBuilder: (context, index) {
            final reel = reels[index];
            return GestureDetector(
              onTap: () =>
                  Get.toNamed('/reels-v2/preview', arguments: reel),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                  image: reel.thumbnailUrl != null
                      ? DecorationImage(
                          image: NetworkImage(reel.thumbnailUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Row(
                        children: [
                          const Icon(Icons.play_arrow,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            _formatCount(reel.viewCount ?? 0),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
