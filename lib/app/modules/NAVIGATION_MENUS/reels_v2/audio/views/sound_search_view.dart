import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_audio_controller.dart';
import '../widgets/music_tile.dart';

/// Dedicated sound search view — search by name, artist, lyrics snippet.
class SoundSearchView extends StatefulWidget {
  const SoundSearchView({super.key});

  @override
  State<SoundSearchView> createState() => _SoundSearchViewState();
}

class _SoundSearchViewState extends State<SoundSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 40,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Search songs, artists, lyrics...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
              prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
              suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white38, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        controller.searchSounds('');
                      },
                    )
                  : const SizedBox.shrink()),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (q) => controller.searchSounds(q),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.searchQuery.value.isEmpty) {
          return _buildSuggestions(controller);
        }
        if (controller.isSearching.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.purpleAccent),
          );
        }
        if (controller.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.music_off, color: Colors.white24, size: 48),
                const SizedBox(height: 8),
                Text(
                  'No results for "${controller.searchQuery.value}"',
                  style: const TextStyle(color: Colors.white38),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildSuggestions(ReelsAudioController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches placeholder
          const Text(
            'Popular Searches',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Trending', 'Viral', 'Dance', 'Funny', 'Sad',
              'Party', 'Workout', 'Love', 'Summer', 'Chill'
            ].map((term) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = term;
                  controller.searchSounds(term);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    term,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Trending sounds preview
          if (controller.trendingSounds.isNotEmpty) ...[
            Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                const Text(
                  'Trending Now',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...controller.trendingSounds.take(5).map(
              (sound) => MusicTile(
                sound: sound,
                showTrendingBadge: true,
                onTap: () {
                  controller.selectSound(sound);
                  Get.back();
                },
                onSave: () => controller.toggleSaveSound(sound),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
