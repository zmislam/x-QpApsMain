import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../search/controllers/reels_search_controller.dart';

/// V2 Search tab for Advance Search.
/// Replaces V1 ReelsTab when V2 is the default search experience.
class AdvanceSearchReelsV2Tab extends StatelessWidget {
  final String query;
  const AdvanceSearchReelsV2Tab({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _searchReels(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_library_outlined, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'No reels found for "$query"',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.65,
          ),
          itemCount: results.length,
          itemBuilder: (_, index) {
            final reel = results[index] as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                Get.toNamed('/reels-v2/detail', arguments: {
                  'reelId': reel['_id'] ?? reel['id'],
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                  image: reel['thumbnailUrl'] != null
                      ? DecorationImage(
                          image: NetworkImage(reel['thumbnailUrl']),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Caption + play count
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (reel['caption'] != null)
                            Text(
                              reel['caption'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.play_arrow, color: Colors.white70, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                _formatCount(reel['plays'] ?? 0),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<dynamic>> _searchReels(String query) async {
    try {
      final apiService = Get.find<dynamic>(); // Uses ReelsV2ApiService
      final res = await apiService.searchReels(query);
      if (res.isSuccessful && res.data != null) {
        return res.data as List<dynamic>;
      }
    } catch (_) {}
    return [];
  }

  String _formatCount(dynamic count) {
    final n = count is int ? count : int.tryParse('$count') ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}
