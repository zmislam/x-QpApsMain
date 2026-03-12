import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import '../../../extension/date_time_extension.dart';
import '../../../services/video_sound_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../config/constants/video_ad_config.dart';
import '../../../config/constants/color.dart';
import '../../../utils/custom_controllers/video_payer_state_controller.dart';

class PostVideoPlayer extends StatefulWidget {
  final Function videoSoundSetupUpdate;
  final bool showControls;
  final VideoPlayerStateController videoPlayerStateController;

  const PostVideoPlayer(
      {super.key,
      required this.videoSoundSetupUpdate,
      required this.showControls,
      required this.videoPlayerStateController});

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  Timer? _visibilityDebounceTimer;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return VisibilityDetector(
      // key: ValueKey('${widget.postId}${widget.videoLink}'),
      key: UniqueKey(),
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
        // Reducing rechecks
        _visibilityDebounceTimer?.cancel();
        _visibilityDebounceTimer = Timer(const Duration(milliseconds: 300), () {
          if (visibilityInfo.visibleFraction > videoPlayFactorOnScreen) {
            widget.videoPlayerStateController.videoPlayerController.play();
            widget.videoSoundSetupUpdate();
          } else {
            widget.videoPlayerStateController.videoPlayerController.pause();
          }
        });
      },
      child: Container(
        width: size.width,
        padding: EdgeInsets.zero,
        color: Colors.black,
        child: Stack(
          children: [
            // Video Player
            widget.videoPlayerStateController.videoPlayerController.value
                    .isInitialized
                ? AspectRatio(
                    aspectRatio: widget.videoPlayerStateController
                        .videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(widget
                        .videoPlayerStateController.videoPlayerController),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),

            // Video Play controller widget with preview logic
            if (widget.showControls)
              VideoControllerOverlay(
                videoPlayerStateController: widget.videoPlayerStateController,
              ),

            // Video Sound setup
            Positioned(
              bottom: 8,
              right: 8,
              child: ValueListenableBuilder<bool>(
                  valueListenable: VideoSoundController.isMuted,
                  builder: (context, isMuted, child) {
                    return IconButton(
                      onPressed: () {
                        VideoSoundController.toggleMute();
                      },
                      icon: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle),
                        child: Icon(
                          isMuted ? Icons.volume_off : Icons.volume_up,
                          size: 20,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoControllerOverlay extends StatefulWidget {
  final VideoPlayerStateController videoPlayerStateController;

  const VideoControllerOverlay(
      {super.key, required this.videoPlayerStateController});

  @override
  State<VideoControllerOverlay> createState() => _VideoControllerOverlayState();
}

class _VideoControllerOverlayState extends State<VideoControllerOverlay> {
  int videoPlayed = 0;
  bool isVideoPlayingComplete = false;
  bool showControls = false;
  Timer timer = Timer(const Duration(milliseconds: 1), () {});

  @override
  void initState() {
    // handel the toggle of play and replay for init..

    // if (widget.videoPlayerStateController.videoPlayerController.value.position.inSeconds > 0 && widget.videoPlayerStateController.videoPlayerController.value.position.inSeconds != widget.videoPlayerStateController.videoPlayerController.value.duration.inSeconds) {
    //   isVideoPlayingComplete = false;
    // }
    // if (widget.videoPlayerStateController.videoPlayerController.value.position.inSeconds == widget.videoPlayerStateController.videoPlayerController.value.duration.inSeconds) {
    //   isVideoPlayingComplete = true;
    // }

    // Update controller visibility action..
    updateControllerVisibility();

    //As set state is present need to trigger it on screen ready only
    // During the play time...
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.videoPlayerStateController.videoPlayerController.addListener(
        () async {
          videoPlayed = widget.videoPlayerStateController.videoPlayerController
              .value.position.inSeconds;

          if (widget.videoPlayerStateController.videoPlayerController.value
                      .position.inSeconds >
                  0 &&
              widget.videoPlayerStateController.videoPlayerController.value
                      .position.inSeconds !=
                  widget.videoPlayerStateController.videoPlayerController.value
                      .duration.inSeconds) {
            isVideoPlayingComplete = false;
          } else if (widget.videoPlayerStateController.videoPlayerController
                  .value.position.inSeconds ==
              widget.videoPlayerStateController.videoPlayerController.value
                  .duration.inSeconds) {
            isVideoPlayingComplete = true;
          }
          if (mounted) {
            setState(() {});
          }
        },
      );
    });
    super.initState();
  }

  // video controller visibility function
  void updateControllerVisibility() {
    timer.cancel();
    setState(() {
      showControls = true;
    });
    timer = Timer(const Duration(seconds: 6), () {
      setState(() {
        showControls = false;
      });
    });
  }

  @override
  void dispose() {
    if (!timer.isBlank!) {
      timer.cancel();
    }
    super.dispose();
  }

  Future<void> onChangeOnVideoPosition({required double timePosition}) async {
    videoPlayed = timePosition.toInt();
    await widget.videoPlayerStateController.videoPlayerController
        .seekTo(Duration(seconds: timePosition.toInt()));
  }

  Future<void> goFiveSecondForward() async {
    final videoLength = widget.videoPlayerStateController.videoPlayerController
        .value.duration.inSeconds;
    videoPlayed = (videoPlayed + 5).clamp(0, videoLength);
    await widget.videoPlayerStateController.videoPlayerController
        .seekTo(Duration(seconds: videoPlayed));
  }

  Future<void> goFiveSecondBack() async {
    videoPlayed = (videoPlayed - 5).clamp(
        0,
        widget.videoPlayerStateController.videoPlayerController.value.duration
            .inSeconds);
    await widget.videoPlayerStateController.videoPlayerController
        .seekTo(Duration(seconds: videoPlayed));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: AspectRatio(
        aspectRatio: widget
            .videoPlayerStateController.videoPlayerController.value.aspectRatio,
        child: Stack(
          children: [
            // Visibility segment--------------------------
            GestureDetector(
              onTap: () {
                updateControllerVisibility();
                if (widget.videoPlayerStateController.videoPlayerController
                    .value.isPlaying) {
                  widget.videoPlayerStateController.videoPlayerController
                      .pause();
                } else {
                  widget.videoPlayerStateController.videoPlayerController
                      .play();
                }
              },
              child: Container(
                color: Colors.transparent,
                height: size.height,
                width: size.width,
              ),
            ),

            // Control Segment--------------------------
            Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Spacer(),

                // Play pause control
                AnimatedSwitcher(
                  reverseDuration: const Duration(milliseconds: 150),
                  duration: const Duration(milliseconds: 150),
                  child: showControls
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // skip 5  second forward
                            ActionIconButton(
                              onClick: () {
                                setState(() {
                                  goFiveSecondBack();
                                });
                              },
                              icon: const Icon(
                                Icons.replay_5,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),

                            // Video play || pause || replay
                            ActionIconButton(
                              onClick: () {
                                setState(() {
                                  widget
                                              .videoPlayerStateController
                                              .videoPlayerController
                                              .value
                                              .isPlaying &&
                                          !widget
                                              .videoPlayerStateController
                                              .videoPlayerController
                                              .value
                                              .isCompleted
                                      ? widget.videoPlayerStateController
                                          .videoPlayerController
                                          .pause()
                                      : widget.videoPlayerStateController
                                          .videoPlayerController
                                          .play();
                                  if (isVideoPlayingComplete) {
                                    isVideoPlayingComplete = false;
                                  }
                                });
                              },
                              icon: Icon(
                                widget
                                            .videoPlayerStateController
                                            .videoPlayerController
                                            .value
                                            .isPlaying &&
                                        !widget
                                            .videoPlayerStateController
                                            .videoPlayerController
                                            .value
                                            .isCompleted
                                    ? Icons.pause
                                    : widget
                                            .videoPlayerStateController
                                            .videoPlayerController
                                            .value
                                            .isCompleted
                                        ? Icons.replay
                                        : Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              ),
                              radius: 30,
                            ),

                            // go 5  second behind
                            ActionIconButton(
                              onClick: () {
                                setState(() {
                                  goFiveSecondForward();
                                });
                              },
                              icon: const Icon(
                                Icons.forward_5_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
                const Spacer(),
                // Drag control with timer
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    left: 10,
                    right: 50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('${widget.videoPlayerStateController.videoPlayerController.value.position.formatAsHMS()}/${widget.videoPlayerStateController.videoPlayerController.value.duration.formatAsHMS()}'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (widget
                          .videoPlayerStateController.showVideoPlayProgress)
                        FlutterSlider(
                          min: 0.0,
                          max: widget
                                  .videoPlayerStateController
                                  .videoPlayerController
                                  .value
                                  .duration
                                  .inSeconds
                                  .isNaN
                              ? 1
                              : widget
                                  .videoPlayerStateController
                                  .videoPlayerController
                                  .value
                                  .duration
                                  .inSeconds
                                  .toDouble(),
                          values: widget
                                  .videoPlayerStateController
                                  .videoPlayerController
                                  .value
                                  .position
                                  .inSeconds
                                  .isNaN
                              ? [0]
                              : [
                                  widget
                                      .videoPlayerStateController
                                      .videoPlayerController
                                      .value
                                      .position
                                      .inSeconds
                                      .toDouble()
                                ],
                          handler: FlutterSliderHandler(
                            child: Container(),
                          ),
                          handlerHeight: 12,
                          handlerWidth: 12,
                          onDragging: (_, value, v) {
                            onChangeOnVideoPosition(
                                timePosition: value.toDouble());
                          },
                          trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 5,
                              inactiveTrackBarHeight: 4,
                              activeTrackBar: const BoxDecoration(
                                color: PRIMARY_COLOR,
                              ),
                              inactiveTrackBar:
                                  BoxDecoration(color: Colors.grey.shade500)),
                        )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActionIconButton extends StatefulWidget {
  final Function onClick;
  final Widget icon;
  final double? radius;
  const ActionIconButton(
      {super.key, required this.onClick, required this.icon, this.radius});

  @override
  State<ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<ActionIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.onClick();
        },
        icon: CircleAvatar(
          radius: widget.radius ?? 25,
          backgroundColor: Colors.black54,
          child: widget.icon,
        ));
  }
}
