import 'package:flutter/material.dart';
import '../../models/reel_sound_model.dart';

/// Individual music track tile used in library, search, saved lists.
class MusicTile extends StatelessWidget {
  final ReelSoundModel sound;
  final VoidCallback onTap;
  final VoidCallback? onSave;
  final bool showTrendingBadge;
  final bool isPlaying;

  const MusicTile({
    super.key,
    required this.sound,
    required this.onTap,
    this.onSave,
    this.showTrendingBadge = false,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Cover art
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                    image: sound.coverUrl != null
                        ? DecorationImage(
                            image: NetworkImage(sound.coverUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: sound.coverUrl == null
                      ? const Icon(Icons.music_note, color: Colors.white24, size: 24)
                      : null,
                ),
                if (isPlaying)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.equalizer, color: Colors.purpleAccent, size: 24),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Title & info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (showTrendingBadge && (sound.trendingScore ?? 0) > 50)
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '🔥',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          sound.title ?? 'Untitled',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isPlaying ? Colors.purpleAccent : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          sound.artist ?? 'Unknown',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ),
                      if (sound.durationMs != null) ...[
                        const Text(' · ', style: TextStyle(color: Colors.white24)),
                        Text(
                          _formatDuration(sound.durationMs!),
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                      if ((sound.usageCount ?? 0) > 0) ...[
                        const Text(' · ', style: TextStyle(color: Colors.white24)),
                        Text(
                          '${_formatCount(sound.usageCount!)} reels',
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                  if (sound.isOriginal == true)
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Original',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Save button
            if (onSave != null)
              IconButton(
                onPressed: onSave,
                icon: Icon(
                  sound.isSaved == true ? Icons.bookmark : Icons.bookmark_border,
                  color: sound.isSaved == true ? Colors.amber : Colors.white38,
                  size: 22,
                ),
                visualDensity: VisualDensity.compact,
              ),
            // Use arrow
            const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
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
