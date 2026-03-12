import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../button.dart';
import '../custom_volume_control.dart';
import '../../config/constants/color.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlay extends StatefulWidget {
  final String videoLink;
  final VoidCallback? onSixSeconds;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;

  const VideoPlay({
    super.key,
    required this.videoLink,
    this.onSixSeconds,
    this.adVideoLink,
    this.campaignWebUrl,
    this.campaignName,
    this.actionButtonText,
    this.campaignDescription,
    this.campaignCallToAction,
  });

  @override
  VideoPlayState createState() => VideoPlayState();
}

class VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _mainVideoController;
  ChewieController? _mainChewieController;
  bool isPlayingAd = false;
  bool hasTriggeredSixSeconds = false;
  VideoPlayerController? _adController;
  ChewieController? _adChewieController;
  int countdown = 6;

  @override
  void initState() {
    super.initState();
    _initializeMainVideo();
  }

  void _initializeMainVideo() {
    _mainVideoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoLink))
          ..initialize().then(
            (_) {
              _mainVideoController.setVolume(0);
              setState(() {
                _mainChewieController = ChewieController(
                  videoPlayerController: _mainVideoController,
                  autoPlay: false,
                  looping: false,
                );
                _mainVideoController.play(); // Explicitly start playback
              });
            },
          )
          ..addListener(() {
            if (_mainVideoController
                    .value.isPlaying && // Ensure the video is playing
                _mainVideoController.value.position.inSeconds >=
                    6 && // Check for 6 seconds
                !hasTriggeredSixSeconds && // Avoid multiple triggers
                widget.adVideoLink != null) {
              hasTriggeredSixSeconds = true; // Mark the trigger
              _playAdVideo(); // Play the ad video
              if (widget.onSixSeconds != null) widget.onSixSeconds!();
            }
          });
  }

  void _playAdVideo() {
    _mainVideoController.pause();
    _mainChewieController?.dispose();

    _adController =
        VideoPlayerController.networkUrl(Uri.parse(widget.adVideoLink ?? ''));
    _adController!.initialize().then((_) {
      _adController!.setVolume(0); // Mute the ad video initially
      setState(() {
        _adChewieController = ChewieController(
            videoPlayerController: _adController!,
            autoPlay: true,
            looping: false,
            showControls: false,
            customControls: const VolumeControlOnly());
        isPlayingAd = true;
        _startCountdown();
      });
    });
  }

  void _startCountdown() {
    countdown = 6;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown <= 0 || !isPlayingAd) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  void _resumeMainVideo() {
    _adController?.dispose();
    _adChewieController?.dispose();

    _mainVideoController.seekTo(const Duration(seconds: 7));
    setState(() {
      _mainChewieController = ChewieController(
        videoPlayerController: _mainVideoController,
        autoPlay: true,
        looping: false,
      );
      isPlayingAd = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: isPlayingAd
              ? (_adChewieController != null &&
                      _adChewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(controller: _adChewieController!)
                  : const Center(child: CircularProgressIndicator()))
              : (_mainChewieController != null &&
                      _mainChewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(controller: _mainChewieController!)
                  : const Center(child: CircularProgressIndicator())),
        ),
        if (isPlayingAd)
          Positioned(
            top: 16,
            right: 16,
            child: countdown > 0
                ? Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Skip Ad in 0:0$countdown'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _resumeMainVideo,
                    child: Text('Skip Ads'.tr),
                  ),
          ),
        if (isPlayingAd)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: widget.campaignCallToAction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.campaignWebUrl.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.campaignName.toString().capitalizeFirst ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.campaignDescription.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (isPlayingAd)
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: widget.campaignCallToAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.actionButtonText ?? 'Book Now'),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mainVideoController.dispose();
    _mainChewieController?.dispose();
    _adController?.dispose();
    _adChewieController?.dispose();
    super.dispose();
  }
}

class CustomVideoPlayer extends StatefulWidget {
  final String videoLink;
  final String postId;
  bool isAdVolumeOff;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;
  CustomVideoPlayer({
    super.key,
    required this.videoLink,
    required this.postId,
    required this.isAdVolumeOff,
    this.adVideoLink,
    this.campaignWebUrl,
    this.campaignName,
    this.actionButtonText,
    this.campaignDescription,
    this.campaignCallToAction,
  });

  @override
  CustomVideoPlayerState createState() => CustomVideoPlayerState();
}

class CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _mainVideoPlayerController;
  ChewieController? _mainChewieController;
  late VideoPlayerController _addVideoPlayerController;
  bool playAddVideo = false;
  bool showSkipAddButton = false;
  bool addPlayed = false;

  ///

  @override
  void initState() {
    super.initState();
    //============================================================================ Main Video =================================================

    _mainVideoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoLink,
      ),
    )
      ..initialize().then((_) {
        setState(() {
          _mainVideoPlayerController.setVolume(0);
          _mainChewieController = ChewieController(
            videoPlayerController: _mainVideoPlayerController,
            aspectRatio: _mainVideoPlayerController.value.aspectRatio,
            autoPlay: false,
            looping: false,
          );
        });
      })
      ..addListener(() {
        if (_mainVideoPlayerController
                .value.isPlaying && //done: Ensure the video is playing
            _mainVideoPlayerController.value.position.inSeconds == 6 &&
            !addPlayed &&
            widget.adVideoLink != null) {
          _mainChewieController?.pause();
          setState(() {
            playAddVideo = true;
          });
        }
      });

    //============================================================================ Add Video =================================================

    if (widget.adVideoLink != null) {
      // Run the below code if the video is not null

      _addVideoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.adVideoLink ?? '',
        ),
      )
        ..initialize().then((_) {
          setState(() {});
        })
        ..addListener(() {
          if (_addVideoPlayerController
                  .value.isPlaying && // Ensure the video is playing
              _addVideoPlayerController.value.position.inSeconds == 5) {
            setState(() {
              showSkipAddButton = true;
            });
          } else if (_addVideoPlayerController.value.isCompleted) {
            setState(() {
              playAddVideo = false;
              showSkipAddButton = false;
            });
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return playAddVideo
        //================================================================ Advertisement Video =================================
        ? VisibilityDetector(
            key: Key('${widget.postId}${widget.adVideoLink}'),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction == 1.0) {
                _addVideoPlayerController.play();
                _addVideoPlayerController.setVolume(0);
              } else {
                _addVideoPlayerController.pause();
              }
            },
            child: ((_addVideoPlayerController.value.isInitialized))
                ? Stack(
                    children: [
                      AspectRatio(
                        aspectRatio:
                            _addVideoPlayerController.value.aspectRatio,
                        child: VideoPlayer(
                          _addVideoPlayerController,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.isAdVolumeOff = !widget.isAdVolumeOff;
                              if (widget.isAdVolumeOff) {
                                _addVideoPlayerController.setVolume(0); // Mute
                              } else {
                                _addVideoPlayerController
                                    .setVolume(3); // Unmute
                              }
                            });
                          },
                          icon: Icon(
                            widget.isAdVolumeOff == true
                                ? Icons.volume_off
                                : Icons.volume_up,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (showSkipAddButton)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: PrimaryButton(
                              verticalPadding: 10,
                              horizontalPadding: 20,
                              fontSize: 14,
                              onPressed: () {
                                setState(() {
                                  playAddVideo = false;
                                  showSkipAddButton = false;
                                  addPlayed = true;
                                });
                              },
                              text: 'Skip Ad'.tr),
                        ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: widget.campaignCallToAction,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.campaignWebUrl.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.campaignName
                                          .toString()
                                          .capitalizeFirst ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.campaignDescription.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: widget.campaignCallToAction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(widget.actionButtonText ?? 'Book Now'),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          )
        //================================================================ Main Video =================================
        : VisibilityDetector(
            key: Key('${widget.postId}${widget.videoLink}'),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction == 1.0) {
                _mainVideoPlayerController.play();
              } else {
                _mainVideoPlayerController.pause();
              }
            },
            child: ((_mainChewieController != null) &&
                    (_mainChewieController
                            ?.videoPlayerController.value.isInitialized ??
                        false))
                ? AspectRatio(
                    aspectRatio: _mainVideoPlayerController.value.aspectRatio,
                    child: Chewie(
                      controller: _mainChewieController!,
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _mainVideoPlayerController.dispose();
    _mainChewieController?.dispose();
  }
}
