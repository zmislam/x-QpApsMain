import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reel_sound_model.dart';
import '../controllers/reels_audio_controller.dart';

/// Soundtrack page — shows all reels using a specific sound.
/// Accessed by tapping the sound ticker on any reel.
class SoundtrackPageView extends StatefulWidget {
  final ReelSoundModel sound;

  const SoundtrackPageView({super.key, required this.sound});

  @override
  State<SoundtrackPageView> createState() => _SoundtrackPageViewState();
}

class _SoundtrackPageViewState extends State<SoundtrackPageView> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsAudioController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // App bar with sound info
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purpleAccent.withOpacity(0.3),
                      Colors.black,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                  child: Row(
                    children: [
                      // Cover art
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          image: widget.sound.coverUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(widget.sound.coverUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: widget.sound.coverUrl == null
                            ? const Icon(Icons.music_note,
                                color: Colors.white38, size: 32)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // Sound details
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.sound.title ?? 'Original Sound',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.sound.artist ?? 'Unknown Artist',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _InfoChip(
                                  icon: Icons.play_arrow,
                                  label: _formatCount(
                                      widget.sound.usageCount ?? 0),
                                ),
                                const SizedBox(width: 12),
                                if (widget.sound.durationMs != null)
                                  _InfoChip(
                                    icon: Icons.timer,
                                    label: _formatDuration(
                                        widget.sound.durationMs!),
                                  ),
                                if (widget.sound.genre != null) ...[
                                  const SizedBox(width: 12),
                                  _InfoChip(
                                    icon: Icons.category,
                                    label: widget.sound.genre!,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Action buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Play preview
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _isPlaying = !_isPlaying);
                      },
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 18,
                      ),
                      label: Text(_isPlaying ? 'Pause' : 'Preview'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Use this sound
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.selectSound(widget.sound);
                        Get.back();
                      },
                      icon: const Icon(Icons.music_note, size: 18),
                      label: const Text('Use Sound'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Save
                  IconButton(
                    onPressed: () => controller.toggleSaveSound(widget.sound),
                    icon: Icon(
                      widget.sound.isSaved == true
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: widget.sound.isSaved == true
                          ? Colors.amber
                          : Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Reels using this sound header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.grid_view, color: Colors.white54, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${_formatCount(widget.sound.usageCount ?? 0)} Reels',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Grid of reels using this sound (placeholder)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 9 / 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    color: Colors.white10,
                    child: const Center(
                      child: Icon(Icons.movie, color: Colors.white12, size: 24),
                    ),
                  );
                },
                childCount: 12, // Placeholder count
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int ms) {
    final seconds = (ms / 1000).round();
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min}:${sec.toString().padLeft(2, '0')}';
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white38),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }
}
