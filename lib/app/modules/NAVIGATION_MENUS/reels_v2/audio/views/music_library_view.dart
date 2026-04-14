import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_audio_controller.dart';
import '../widgets/music_tile.dart';

/// Music library view — browse by mood, genre, trending, saved.
class MusicLibraryView extends StatelessWidget {
  const MusicLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Sounds', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.purpleAccent,
            tabs: [
              Tab(text: 'Trending'),
              Tab(text: 'Browse'),
              Tab(text: 'Saved'),
              Tab(text: 'Recent'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Get.to(() => const _SoundSearchDelegate()),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Trending
            _TrendingTab(controller: controller),
            // Browse by genre/mood
            _BrowseTab(controller: controller),
            // Saved
            _SavedTab(controller: controller),
            // Recent
            _RecentTab(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _TrendingTab extends StatelessWidget {
  final ReelsAudioController controller;
  const _TrendingTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingTrending.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.white24));
      }
      if (controller.trendingSounds.isEmpty) {
        return const Center(
          child: Text('No trending sounds', style: TextStyle(color: Colors.white38)),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.trendingSounds.length,
        itemBuilder: (context, index) {
          final sound = controller.trendingSounds[index];
          return MusicTile(
            sound: sound,
            showTrendingBadge: true,
            onTap: () => controller.selectSound(sound),
            onSave: () => controller.toggleSaveSound(sound),
          );
        },
      );
    });
  }
}

class _BrowseTab extends StatelessWidget {
  final ReelsAudioController controller;
  const _BrowseTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genres',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.genres.map((genre) {
              return ActionChip(
                label: Text(genre),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                backgroundColor: Colors.white12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed: () => controller.fetchSoundsByGenre(genre),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Moods',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.moods.map((mood) {
              return ActionChip(
                label: Text(mood),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                backgroundColor: Colors.purple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed: () => controller.fetchSoundsByMood(mood),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Search results (if any genre/mood selected)
          Obx(() {
            if (controller.isSearching.value) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator(color: Colors.white24)),
              );
            }
            if (controller.searchResults.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.white12),
                ...controller.searchResults.map(
                  (sound) => MusicTile(
                    sound: sound,
                    onTap: () => controller.selectSound(sound),
                    onSave: () => controller.toggleSaveSound(sound),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _SavedTab extends StatelessWidget {
  final ReelsAudioController controller;
  const _SavedTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSaved.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.white24));
      }
      if (controller.savedSounds.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bookmark_border, color: Colors.white24, size: 48),
              SizedBox(height: 8),
              Text('No saved sounds', style: TextStyle(color: Colors.white38)),
              Text(
                'Tap the bookmark icon on any sound to save it',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.savedSounds.length,
        itemBuilder: (context, index) {
          final sound = controller.savedSounds[index];
          return MusicTile(
            sound: sound,
            onTap: () => controller.selectSound(sound),
            onSave: () => controller.toggleSaveSound(sound),
          );
        },
      );
    });
  }
}

class _RecentTab extends StatelessWidget {
  final ReelsAudioController controller;
  const _RecentTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.recentSounds.isEmpty) {
        return const Center(
          child: Text('No recent sounds', style: TextStyle(color: Colors.white38)),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.recentSounds.length,
        itemBuilder: (context, index) {
          final sound = controller.recentSounds[index];
          return MusicTile(
            sound: sound,
            onTap: () => controller.selectSound(sound),
            onSave: () => controller.toggleSaveSound(sound),
          );
        },
      );
    });
  }
}

class _SoundSearchDelegate extends StatelessWidget {
  const _SoundSearchDelegate();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search songs, artists, lyrics...',
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
          onChanged: (q) => controller.searchSounds(q),
        ),
      ),
      body: Obx(() {
        if (controller.isSearching.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white24));
        }
        if (controller.searchResults.isEmpty) {
          return const Center(
            child: Text('Search by name, artist, or lyrics', style: TextStyle(color: Colors.white38)),
          );
        }
        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            final sound = controller.searchResults[index];
            return MusicTile(
              sound: sound,
              onTap: () {
                controller.selectSound(sound);
                Get.back();
              },
              onSave: () => controller.toggleSaveSound(sound),
            );
          },
        );
      }),
    );
  }
}
