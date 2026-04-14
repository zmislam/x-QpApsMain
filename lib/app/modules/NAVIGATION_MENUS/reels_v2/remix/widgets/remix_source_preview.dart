import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Source reel preview for remix — shows the original reel video
/// with author attribution overlay (dual profile display for collab).
class RemixSourcePreview extends StatelessWidget {
  final VideoPlayerController? videoController;
  final String? authorName;
  final String? authorAvatar;

  const RemixSourcePreview({
    super.key,
    this.videoController,
    this.authorName,
    this.authorAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video
        if (videoController != null && videoController!.value.isInitialized)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: videoController!.value.size.width,
              height: videoController!.value.size.height,
              child: VideoPlayer(videoController!),
            ),
          )
        else
          Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),

        // Gradient at bottom for attribution
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
        ),

        // Author attribution (collab dual profile display)
        Positioned(
          bottom: 8,
          left: 8,
          child: Row(
            children: [
              // Author avatar
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey[700],
                backgroundImage:
                    authorAvatar != null ? NetworkImage(authorAvatar!) : null,
                child: authorAvatar == null
                    ? const Icon(Icons.person, size: 14, color: Colors.white54)
                    : null,
              ),
              const SizedBox(width: 6),
              // Author name
              if (authorName != null)
                Text(
                  '@$authorName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  ),
                ),
              const SizedBox(width: 4),
              // Original label
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Original',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
