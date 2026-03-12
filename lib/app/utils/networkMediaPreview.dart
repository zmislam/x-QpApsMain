import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../components/video_player/post/post_details_video_screen.dart';
import '../config/constants/app_assets.dart';

class NetworkMediaPreview extends StatelessWidget {
  final String? mediaPath; // relative path as stored in your model e.g. 'uploads/file.mp4'
  final String serverBase; // e.g. ApiConstant.SERVER_IP_PORT
  final String? thumbnailUrl; // optional: server-provided thumbnail full URL
  final double width;
  final double height;
  final bool usePlayerOnTap; // if true navigate to PostDetailsVideoScreen on tap

  const NetworkMediaPreview({
    super.key,
    required this.mediaPath,
    required this.serverBase,
    this.thumbnailUrl,
    this.width = 100,
    this.height = 100,
    this.usePlayerOnTap = true,
  });

  bool _isVideo(String path) {
    final p = path.toLowerCase();
    return p.endsWith('.mp4') ||
        p.endsWith('.mov') ||
        p.endsWith('.mkv') ||
        p.endsWith('.avi') ||
        p.endsWith('.webm');
  }

  @override
  Widget build(BuildContext context) {
    if (mediaPath == null || mediaPath!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final media = mediaPath!;
    final mediaUrl = '$serverBase/$media';

    if (_isVideo(media)) {
      // Use provided thumbnailUrl if available, otherwise show local placeholder
      final thumb = thumbnailUrl ?? ''; // full URL string or empty
      return InkWell(
        onTap: () {
          if (usePlayerOnTap) {
            Get.to(() => PostDetailsVideoScreen(videoSrc: mediaUrl));
          }
        },
        child: Container(
          width: width,
          height: height,
          color: Colors.black12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // show thumbnail if available
                if (thumb.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: thumb,
                    fit: BoxFit.cover,
                    placeholder: (c, s) =>
                        Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.cover),
                    errorWidget: (c, s, e) =>
                        Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.cover),
                  )
                else
                  Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.cover),
                Container(color: Colors.black26),
                const Center(
                  child: Icon(Icons.play_circle_fill, size: 36, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // image branch
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage(
          height: height,
          width: width,
          placeholder: const AssetImage(AppAssets.DEFAULT_IMAGE),
          image: NetworkImage(mediaUrl),
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(AppAssets.DEFAULT_IMAGE, fit: BoxFit.cover, height: height, width: width);
          },
        ),
      );
    }
  }
}
