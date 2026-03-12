import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaPreview extends StatelessWidget {
  final File file;
  final double width;
  final double height;

  const MediaPreview({
    Key? key,
    required this.file,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  bool _isVideo(String path) {
    final p = path.toLowerCase();
    return p.endsWith('.mp4') ||
        p.endsWith('.mov') ||
        p.endsWith('.mkv') ||
        p.endsWith('.avi') ||
        p.endsWith('.webm');
  }

  Future<Uint8List?> _generateThumbnail(String videoPath) async {
    try {
      final data = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200, // maintain small size
        quality: 75,
      );
      return data;
    } catch (e) {
      // thumbnail generation failed
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = file.path;
    if (_isVideo(path)) {
      return FutureBuilder<Uint8List?>(
        future: _generateThumbnail(path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final thumbData = snapshot.data;
          if (thumbData != null) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.memory(
                    thumbData,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                ),
                Container( // subtle dark overlay
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black26,
                  ),
                ),
                const Icon(Icons.play_circle_fill, size: 36, color: Colors.white),
              ],
            );
          } else {
            // Fallback if thumbnail generation failed
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(child: Icon(Icons.videocam, size: 36)),
            );
          }
        },
      );
    } else {
      // It's an image — use Image.file safely
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(
          file,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // if image fails to load, show placeholder
            return Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, size: 36),
            );
          },
        ),
      );
    }
  }
}
