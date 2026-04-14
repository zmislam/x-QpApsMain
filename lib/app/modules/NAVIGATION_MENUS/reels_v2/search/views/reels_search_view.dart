import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_search_controller.dart';
import '../widgets/search_bar_header.dart';
import '../widgets/search_tab_bar.dart';
import '../widgets/trending_hashtag_grid.dart';
import '../widgets/challenge_card.dart';
import '../widgets/creator_spotlight_card.dart';
import '../../models/reel_v2_model.dart';
import '../../models/reel_sound_model.dart';
import '../../models/reel_hashtag_model.dart';

class ReelsSearchView extends GetView<ReelsSearchController> {
  const ReelsSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            const SearchBarHeader(),
            // Tab bar
            const SearchTabBar(),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.searchQuery.value.isEmpty) {
                  return _buildDiscoveryContent();
                }
                if (controller.isSearching.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return _buildSearchResults();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Recent Searches
          Obx(() {
            if (controller.recentSearches.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    GestureDetector(
                      onTap: controller.clearRecentSearches,
                      child: const Text('Clear all',
                          style:
                              TextStyle(color: Colors.blue, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.recentSearches.take(10).map((q) {
                    return GestureDetector(
                      onTap: () => controller.setSearchQuery(q),
                      child: Chip(
                        label: Text(q,
                            style:
                                const TextStyle(color: Colors.white70)),
                        backgroundColor: Colors.grey[900],
                        side: BorderSide.none,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],
            );
          }),

          // Trending Hashtags
          const Text('Trending',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          const TrendingHashtagGrid(),

          const SizedBox(height: 24),

          // Challenges Hub
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Challenges',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              GestureDetector(
                onTap: () {},
                child: const Text('See all',
                    style: TextStyle(color: Colors.blue, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.challengesLoading.value) {
              return const SizedBox(
                height: 160,
                child:
                    Center(child: CircularProgressIndicator(color: Colors.white)),
              );
            }
            return SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.challenges.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return ChallengeCard(
                      challenge: controller.challenges[index]);
                },
              ),
            );
          }),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      switch (controller.activeTab.value) {
        case 0:
          return _buildTopResults();
        case 1:
          return _buildReelResults();
        case 2:
          return _buildSoundResults();
        case 3:
          return _buildHashtagResults();
        case 4:
          return _buildCreatorResults();
        default:
          return const SizedBox();
      }
    });
  }

  Widget _buildTopResults() {
    return Obx(() {
      if (controller.topResults.isEmpty) {
        return _noResults();
      }
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.topResults.length,
        itemBuilder: (context, index) {
          final item = controller.topResults[index];
          if (item is ReelHashtagModel) {
            return _hashtagTile(item);
          } else if (item is ReelV2Model) {
            return _reelTile(item);
          } else if (item is ReelSoundModel) {
            return _soundTile(item);
          } else if (item is Map<String, dynamic>) {
            return CreatorSpotlightCard(creator: item);
          }
          return const SizedBox();
        },
      );
    });
  }

  Widget _buildReelResults() {
    return Obx(() {
      if (controller.reelResults.isEmpty) return _noResults();
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 9 / 16,
        ),
        itemCount: controller.reelResults.length,
        itemBuilder: (context, index) {
          final reel = controller.reelResults[index];
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
    });
  }

  Widget _buildSoundResults() {
    return Obx(() {
      if (controller.soundResults.isEmpty) return _noResults();
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.soundResults.length,
        itemBuilder: (context, index) {
          return _soundTile(controller.soundResults[index]);
        },
      );
    });
  }

  Widget _buildHashtagResults() {
    return Obx(() {
      if (controller.hashtagResults.isEmpty) return _noResults();
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.hashtagResults.length,
        itemBuilder: (context, index) {
          return _hashtagTile(controller.hashtagResults[index]);
        },
      );
    });
  }

  Widget _buildCreatorResults() {
    return Obx(() {
      if (controller.creatorResults.isEmpty) return _noResults();
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.creatorResults.length,
        itemBuilder: (context, index) {
          return CreatorSpotlightCard(
              creator: controller.creatorResults[index]);
        },
      );
    });
  }

  Widget _hashtagTile(ReelHashtagModel tag) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.tag, color: Colors.white, size: 22),
      ),
      title: Text('#${tag.name}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text('${_formatCount(tag.reelCount)} reels',
          style: const TextStyle(color: Colors.grey, fontSize: 13)),
      onTap: () => Get.toNamed('/reels-v2/search/hashtag',
          arguments: {'tag': tag.name}),
    );
  }

  Widget _soundTile(ReelSoundModel sound) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 44,
          color: Colors.grey[800],
          child: sound.coverUrl != null
              ? Image.network(sound.coverUrl!, fit: BoxFit.cover)
              : const Icon(Icons.music_note, color: Colors.white),
        ),
      ),
      title: Text(sound.title ?? 'Unknown',
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(sound.artist ?? '',
          style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: Text('${_formatCount(sound.usageCount ?? 0)} reels',
          style: const TextStyle(color: Colors.grey, fontSize: 12)),
      onTap: () => Get.toNamed('/reels-v2/sound', arguments: sound),
    );
  }

  Widget _reelTile(ReelV2Model reel) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 60,
          color: Colors.grey[800],
          child: reel.thumbnailUrl != null
              ? Image.network(reel.thumbnailUrl!, fit: BoxFit.cover)
              : const Icon(Icons.videocam, color: Colors.white),
        ),
      ),
      title: Text(reel.caption ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(reel.authorName ?? '',
          style: const TextStyle(color: Colors.grey, fontSize: 13)),
      onTap: () => Get.toNamed('/reels-v2/preview', arguments: reel),
    );
  }

  Widget _noResults() {
    return const Center(
      child: Text('No results found',
          style: TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
