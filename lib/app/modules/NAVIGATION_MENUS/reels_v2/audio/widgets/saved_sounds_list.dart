import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_audio_controller.dart';
import 'music_tile.dart';

/// Saved sounds collection — all bookmarked sounds.
class SavedSoundsList extends StatelessWidget {
  const SavedSoundsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();

    return Obx(() {
      if (controller.isLoadingSaved.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.purpleAccent),
        );
      }

      if (controller.savedSounds.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border,
                  color: Colors.white24,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'No Saved Sounds',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Bookmark sounds to find them easily later',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  // Navigate to trending sounds
                  Get.back();
                },
                icon: const Icon(Icons.explore, size: 16),
                label: const Text('Browse Sounds'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purpleAccent,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.savedSounds.length} Saved Sounds',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Sort option
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort, color: Colors.white54, size: 20),
                  color: const Color(0xFF2A2A2A),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'recent',
                      child: Text('Recently Saved', style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: 'name',
                      child: Text('Name', style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: 'popular',
                      child: Text('Most Popular', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onSelected: (value) {
                    // Sort logic handled by controller
                  },
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: controller.savedSounds.length,
              itemBuilder: (context, index) {
                final sound = controller.savedSounds[index];
                return Dismissible(
                  key: Key(sound.id ?? 'saved_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent.withOpacity(0.3),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => controller.toggleSaveSound(sound),
                  child: MusicTile(
                    sound: sound,
                    onTap: () {
                      controller.selectSound(sound);
                      Get.back();
                    },
                    onSave: () => controller.toggleSaveSound(sound),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
