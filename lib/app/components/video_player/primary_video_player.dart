import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../config/constants/color.dart';
import '../../utils/video_manager/video_manager_value_notifier_singleton.dart';


class PrimaryVideoPlayer extends StatefulWidget {
  final String videoLink;

  const PrimaryVideoPlayer({super.key, required this.videoLink});

  @override
  _PrimaryVideoPlayerState createState() => _PrimaryVideoPlayerState();
}


class _PrimaryVideoPlayerState extends State<PrimaryVideoPlayer> {
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoLink),
    )
      ..addListener(() {
        if (mounted) setState(() {});
      })
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      customControls: CustomPlayPauseMuteControls(
        controller: videoPlayerController,
        onPlay: () {
          VideoManager().setActiveController(videoPlayerController);
        },
      ),
      autoPlay: false,
      looping: false,
    );

    // Listen to changes in the VideoManager
    VideoManager().addListener(_updateState);
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

 @override
void dispose() {
  VideoManager().removeListener(_updateState); // Remove listener
  if (VideoManager().currentController == videoPlayerController) {
    VideoManager().clearController(); // Reset the controller
  }
  chewieController.dispose();
  videoPlayerController.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: Chewie(controller: chewieController),
              )
            : const CircularProgressIndicator(
                color: PRIMARY_COLOR,
              ),
      ),
    );
  }
}

// Custom  Play Pause Button
class CustomPlayPauseMuteControls extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onPlay;

  const CustomPlayPauseMuteControls({
    super.key,
    required this.controller,
    required this.onPlay,
  });

  @override
  _CustomPlayPauseMuteControlsState createState() =>
      _CustomPlayPauseMuteControlsState();
}

class _CustomPlayPauseMuteControlsState
    extends State<CustomPlayPauseMuteControls> {
  @override
  void initState() {
    super.initState();
    VideoManager().addListener(_updateState); // Listen to updates
  }

  @override
  void dispose() {
    VideoManager().removeListener(_updateState); // Clean up listener
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayerController = widget.controller;
    final isPlaying = videoPlayerController.value.isPlaying;

    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              if (isPlaying) {
                videoPlayerController.pause();
              } else {
                videoPlayerController.play();
                widget.onPlay(); // Notify the manager when this video plays
              }
              setState(() {});
            },
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              final isMuted = videoPlayerController.value.volume == 0;
              videoPlayerController.setVolume(isMuted ? 1 : 0);
              setState(() {});
            },
            child: Icon(
              videoPlayerController.value.volume == 0
                  ? Icons.volume_off
                  : Icons.volume_up,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }
}