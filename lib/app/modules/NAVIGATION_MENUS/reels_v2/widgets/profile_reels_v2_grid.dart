import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/reels_v2_api_service.dart';
import '../utils/reel_constants.dart';

/// V2 Reel grid for profile views.
/// Replaces V1 ProfileReelsComponent when V2 is the default.
class ProfileReelsV2Grid extends StatefulWidget {
  final String userId;
  const ProfileReelsV2Grid({super.key, required this.userId});

  @override
  State<ProfileReelsV2Grid> createState() => _ProfileReelsV2GridState();
}

class _ProfileReelsV2GridState extends State<ProfileReelsV2Grid> {
  final ReelsV2ApiService _apiService = ReelsV2ApiService();
  List<dynamic> _reels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReels();
  }

  Future<void> _loadReels() async {
    try {
      final res = await _apiService.getUserReels(widget.userId);
      if (res.isSuccessful && res.data != null) {
        setState(() {
          _reels = res.data as List<dynamic>;
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
    if (_isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_reels.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.video_library_outlined, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text('No reels yet', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(2),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 9 / 16,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final reel = _reels[index] as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                // Navigate to V2 reel detail
                Get.toNamed('/reels-v2/detail', arguments: {
                  'reelId': reel['_id'] ?? reel['id'],
                });
              },
              child: Container(
                decoration: BoxDecoration(
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
                    Positioned(
                      bottom: 4,
                      left: 4,
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
                              shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
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
          childCount: _reels.length,
        ),
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
