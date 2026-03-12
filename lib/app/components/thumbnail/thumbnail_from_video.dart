import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ThumbnailFromVideo extends StatefulWidget {
  final String videoFilePath;
  const ThumbnailFromVideo({required this.videoFilePath, super.key});

  @override
  State<ThumbnailFromVideo> createState() => _ThumbnailFromVideoState();
}

class _ThumbnailFromVideoState extends State<ThumbnailFromVideo> {
  late VideoPlayerController videoPlayerController;
  bool _isVideoSrcError = false;

  @override
  void initState() {
    super.initState();
    try {
      videoPlayerController =
          VideoPlayerController.file(File(widget.videoFilePath))
            ..initialize().then((_) {
              if (!mounted) return;
              setState(() {});
            });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVideoSrcError = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVideoSrcError
        ? SizedBox(
            height: 100,
            width: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1)),
              child: const Center(
                child: Icon(Icons.error, color: Colors.teal, size: 20),
              ),
            ),
          )
        : VisibilityDetector(
            key: Key(widget.videoFilePath),
            onVisibilityChanged: (info) {},
            child: videoPlayerController.value.isInitialized
                ? SizedBox(
                    height: 100,
                    width: 100,
                    child: VideoPlayer(videoPlayerController),
                  )
                : SizedBox(
                    height: 100,
                    width: 100,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black, width: 1)),
                      child: const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.teal, strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),
          );
  }
}
