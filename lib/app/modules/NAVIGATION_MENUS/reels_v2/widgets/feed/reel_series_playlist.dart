import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reel_v2_model.dart';

class ReelSeriesPlaylist extends StatelessWidget {
  final String seriesTitle;
  final String? seriesDescription;
  final List<ReelV2Model> reels;
  final String? seriesId;

  const ReelSeriesPlaylist({
    super.key,
    required this.seriesTitle,
    this.seriesDescription,
    required this.reels,
    this.seriesId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.grey[900]?.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.playlist_play,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Text('Series: $seriesTitle',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                if (seriesDescription != null) ...[
                  const SizedBox(height: 4),
                  Text(seriesDescription!,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _seriesReelCard(reels[index], index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _seriesReelCard(ReelV2Model reel, int episodeNumber) {
    return GestureDetector(
      onTap: () => Get.toNamed('/reels-v2/preview', arguments: reel),
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  image: reel.thumbnailUrl != null
                      ? DecorationImage(
                          image: NetworkImage(reel.thumbnailUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    // Episode number badge
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Ep $episodeNumber',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Play icon overlay
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              reel.caption ?? 'Episode $episodeNumber',
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
