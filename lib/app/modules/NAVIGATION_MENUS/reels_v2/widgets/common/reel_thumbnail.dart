import 'package:flutter/material.dart';

/// Reel thumbnail widget — displays a reel's thumbnail image
/// with optional play indicator and duration badge.
class ReelThumbnail extends StatelessWidget {
  final String? thumbnailUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final int? viewCount;
  final int? durationMs;
  final VoidCallback? onTap;

  const ReelThumbnail({
    super.key,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.viewCount,
    this.durationMs,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Thumbnail image
              if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
                Image.network(
                  thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              else
                _placeholder(),

              // Play icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              // Duration badge (bottom-right)
              if (durationMs != null)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      _formatDuration(durationMs!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              // View count (bottom-left)
              if (viewCount != null)
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow,
                          color: Colors.white, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        _formatCount(viewCount!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[850],
      child: const Center(
        child: Icon(Icons.videocam_off_outlined, color: Colors.white24, size: 28),
      ),
    );
  }

  String _formatDuration(int ms) {
    final seconds = (ms / 1000).round();
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
