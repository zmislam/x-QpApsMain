import 'dart:io';
import 'package:flutter/material.dart';

/// Displays a thumbnail preview for a clip in the timeline.
/// For videos: shows first frame capture.
/// For images: shows the image directly.
class ClipThumbnail extends StatelessWidget {
  final String filePath;
  final bool isVideo;

  const ClipThumbnail({
    super.key,
    required this.filePath,
    this.isVideo = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: _buildThumbnail(),
    );
  }

  Widget _buildThumbnail() {
    final file = File(filePath);

    if (!isVideo) {
      // Image clip — show image directly
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    // Video clip — show placeholder with film icon
    // In production, use video_thumbnail package to extract first frame
    return _videoThumbnailPlaceholder();
  }

  Widget _videoThumbnailPlaceholder() {
    return Container(
      color: Colors.grey[850],
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[900]!,
                ],
              ),
            ),
          ),
          // Film strip pattern
          Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.white.withValues(alpha: 0.05),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          // Center icon
          const Center(
            child: Icon(
              Icons.videocam_rounded,
              color: Colors.white24,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.white24, size: 20),
      ),
    );
  }
}
