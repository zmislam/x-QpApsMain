import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/reels_v2_api_service.dart';

/// V2 reel preview card for in-feed display (newsfeed).
/// Shows a horizontal scroll of V2 reel thumbnails within the newsfeed.
class NewsfeedReelsV2Card extends StatefulWidget {
  const NewsfeedReelsV2Card({super.key});

  @override
  State<NewsfeedReelsV2Card> createState() => _NewsfeedReelsV2CardState();
}

class _NewsfeedReelsV2CardState extends State<NewsfeedReelsV2Card> {
  final ReelsV2ApiService _apiService = ReelsV2ApiService();
  List<dynamic> _reels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrendingReels();
  }

  Future<void> _loadTrendingReels() async {
    try {
      final res = await _apiService.getTrendingFeed();
      if (res.isSuccessful && res.data != null) {
        final list = res.data as List<dynamic>;
        setState(() {
          _reels = list.take(6).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _reels.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reels',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to V2 reels feed
                    // Switch to V2 tab
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _reels.length,
              itemBuilder: (_, index) {
                final reel = _reels[index] as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/reels-v2/detail', arguments: {
                      'reelId': reel['_id'] ?? reel['id'],
                    });
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
                        // Gradient overlay at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12),
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
                        // Play count
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                _formatCount(reel['plays'] ?? reel['viewCount'] ?? 0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
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
          ),
        ],
      ),
    );
  }

  String _formatCount(dynamic count) {
    final n = count is int ? count : int.tryParse('$count') ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}
