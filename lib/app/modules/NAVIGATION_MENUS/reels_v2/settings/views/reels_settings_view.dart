import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reels_settings_controller.dart';
import '../widgets/autoplay_toggle.dart';
import '../widgets/data_saver_toggle.dart';
import '../widgets/content_preferences.dart';
import '../widgets/hidden_words_editor.dart';
import '../widgets/notification_preferences.dart';

class ReelsSettingsView extends GetView<ReelsSettingsController> {
  const ReelsSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reels Settings'),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // ─── Playback ────────────────────────────────
            _sectionHeader('Playback'),
            const AutoplayToggle(),
            const DataSaverToggle(),

            const Divider(height: 32),

            // ─── Accessibility ───────────────────────────
            _sectionHeader('Accessibility'),
            _switchTile(
              title: 'Auto-Captions',
              subtitle: 'Show server-generated subtitles',
              value: controller.autoCaptionsEnabled.value,
              onChanged: controller.toggleAutoCaptions,
            ),
            _switchTile(
              title: 'Caption Translation',
              subtitle: 'Translate captions to your language',
              value: controller.captionTranslationEnabled.value,
              onChanged: controller.toggleCaptionTranslation,
            ),

            const Divider(height: 32),

            // ─── Content Preferences ─────────────────────
            _sectionHeader('Content Preferences'),
            const ContentPreferences(),

            const Divider(height: 32),

            // ─── Hidden Words ────────────────────────────
            _sectionHeader('Hidden Words'),
            const HiddenWordsEditor(),

            const Divider(height: 32),

            // ─── Notifications ────────────────────────────
            _sectionHeader('Notifications'),
            const NotificationPreferences(),

            const Divider(height: 32),

            // ─── History & Liked ─────────────────────────
            _sectionHeader('History & Saved'),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Watch History'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showWatchHistory(context),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Liked Reels'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLikedReels(context),
            ),

            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      onChanged: onChanged,
    );
  }

  // ─── Watch History Bottom Sheet ─────────────────────

  void _showWatchHistory(BuildContext context) {
    controller.loadWatchHistory();
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Watch History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clearWatchHistory();
                      Get.back();
                    },
                    child: const Text('Clear All', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingHistory.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.watchHistory.isEmpty) {
                  return const Center(child: Text('No watch history'));
                }
                return ListView.builder(
                  itemCount: controller.watchHistory.length,
                  itemBuilder: (_, i) {
                    final item = controller.watchHistory[i];
                    return ListTile(
                      leading: Container(
                        width: 48,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                          image: item['thumbnail'] != null
                              ? DecorationImage(
                                  image: NetworkImage(item['thumbnail']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      title: Text(
                        item['caption'] ?? 'Reel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(item['watchedAt'] ?? ''),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ─── Liked Reels Bottom Sheet ───────────────────────

  void _showLikedReels(BuildContext context) {
    controller.loadLikedReels();
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Liked Reels',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingLiked.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.likedReels.isEmpty) {
                  return const Center(child: Text('No liked reels'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 9 / 16,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: controller.likedReels.length,
                  itemBuilder: (_, i) {
                    final item = controller.likedReels[i];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to reel detail
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: item['thumbnail'] != null
                              ? DecorationImage(
                                  image: NetworkImage(item['thumbnail']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  '${item['plays'] ?? 0}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
