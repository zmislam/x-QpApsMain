import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelsVideoPlayer extends StatefulWidget {
  final String videoSrc;
  final double videoSpeed;
  const ReelsVideoPlayer(
      {required this.videoSrc, required this.videoSpeed, super.key});

  @override
  State<ReelsVideoPlayer> createState() => _ReelsVideoPlayerState();
}

class _ReelsVideoPlayerState extends State<ReelsVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoSrc))
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0)
      ..setPlaybackSpeed(widget.videoSpeed)
      ..setLooping(true)
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(widget.videoSrc),
        onVisibilityChanged: (visibilityInfo) {},
        child: _controller.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: SizedBox(
                    height: _controller.value.size.height,
                    width: _controller.value.size.width,
                    child: VideoPlayer(
                      _controller,
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
