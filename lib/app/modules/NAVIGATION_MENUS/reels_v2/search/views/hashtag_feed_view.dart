import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_search_controller.dart';
import '../../models/reel_v2_model.dart';
import '../../models/reel_hashtag_model.dart';

class HashtagFeedView extends GetView<ReelsSearchController> {
  const HashtagFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final tag = args?['tag'] ?? '';

    // Load feed on enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadHashtagFeed(tag);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(tag),
            // Hashtag Info
            Obx(() => _buildHashtagInfo()),
            // Reel Grid
            Expanded(child: Obx(() => _buildReelGrid())),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String tag) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 8),
          Text(
            '#$tag',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHashtagInfo() {
    final hashtag = controller.currentHashtag.value;
    if (hashtag == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tag, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatCount(hashtag.reelCount)} reels',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (hashtag.description != null)
                  Text(
                    hashtag.description!,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReelGrid() {
    if (controller.hashtagFeedLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }
    if (controller.hashtagReels.isEmpty) {
      return const Center(
        child: Text('No reels found',
            style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 9 / 16,
      ),
      itemCount: controller.hashtagReels.length,
      itemBuilder: (context, index) {
        final reel = controller.hashtagReels[index];
        return GestureDetector(
          onTap: () => Get.toNamed('/reels-v2/preview', arguments: reel),
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
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      _formatCount(reel.viewCount ?? 0),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
