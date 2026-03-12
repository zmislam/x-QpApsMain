import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/video_ad_config.dart';
import '../../../services/video_sound_controller.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NewsFeedPostVideoPlayer extends StatefulWidget {
  final String videoSrc;
  final int? videoPlayTime;
  final bool? isLive;
  final bool isAutoPlayEnabled;
  final String postId;
  final String? adVideoLink;
  final String? campaignWebUrl;
  final String? campaignName;
  final String? campaignDescription;
  final String? actionButtonText;
  final VoidCallback? campaignCallToAction;
  final VoidCallback? onNavigate;

  const NewsFeedPostVideoPlayer(
      {required this.videoSrc,
      this.videoPlayTime,
      this.isAutoPlayEnabled = true,
      this.isLive = false,
      required this.postId,
      this.adVideoLink,
      this.campaignWebUrl,
      this.campaignName,
      this.campaignDescription,
      this.actionButtonText,
      this.campaignCallToAction,
      this.onNavigate,
      super.key});

  @override
  State<NewsFeedPostVideoPlayer> createState() =>
      _NewsfeedPostVideoPlayerState();
}

class _NewsfeedPostVideoPlayerState extends State<NewsFeedPostVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isHidePlayButton = false;
  bool _isBuffering = false;
  bool _isVideoSrcError = false;
  bool _isPlaying = false;
  bool _initialized = false;
  bool _isDisposing = false;
  bool _isManuallyPaused = false; // Flag to track manual pause/play
  Timer? _hidePlayButtonTimer; // Timer to hide the play button

  // ============================ Start the hide play button timer =============
  void _startHidePlayButtonTimer() {
    _hidePlayButtonTimer?.cancel(); // Cancel any existing timer
    _hidePlayButtonTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isHidePlayButton = true;
        });
      }
    });
  }

  // ============================ initState method =============================
  @override
  void initState() {
    try {
      debugPrint('VIDEO LIVE URL : ${widget.isLive}');
      debugPrint(widget.videoSrc);

      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoSrc))
        ..initialize().then((_) {
          // ================ check if widget is still mounted =================
          if (!mounted) return;
          setState(() {});
          // ================ ensure volume is set on initialization ===========
          videoSoundSetupUpdate();
          if (widget.isAutoPlayEnabled) {
            _controller.play();
            _isPlaying = true;
          }
        })
        ..setLooping(false);
      _initialized = true;

      // ==================== listen to global mute state ======================
      VideoSoundController.isMuted.addListener(videoSoundSetupUpdate);

      // ============================ listen buffer ============================
      _controller.addListener(() {
        if (!mounted) return;
        final newBuffering = _controller.value.isBuffering;
        final newPlaying = _controller.value.isPlaying;
        if (newBuffering != _isBuffering || newPlaying != _isPlaying) {
          setState(() {
            _isBuffering = newBuffering;
            _isPlaying = newPlaying;
          });
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVideoSrcError = true;
      });
    }

    super.initState();
  }

  // ============================== Handle video play and pause ================
  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isManuallyPaused = true; // Mark as manually paused
      } else {
        _controller.play();
        _isManuallyPaused = false; // Reset manual pause flag
      }
      _isPlaying = _controller.value.isPlaying;
    });
  }

  // ============================== video sound set up =========================
  void videoSoundSetupUpdate() {
    if (_controller.value.isInitialized) {
      double volume = VideoSoundController.isMuted.value ? 0.0 : 1.0;
      _controller.setVolume(volume);
      // Mute icon updates via ValueListenableBuilder — no setState needed
    }
  }

  // ============================ dispose method ===============================
  @override
  void dispose() {
    _isDisposing = true;
    VideoSoundController.isMuted.removeListener(videoSoundSetupUpdate);
    if (_initialized) {
      _controller.removeListener(() {});
      _controller.dispose();
    }
    _hidePlayButtonTimer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVideoSrcError
        ? SizedBox(
            width: Get.width,
            height: 200,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: Theme.of(context).cardTheme.color),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 24),
                    SizedBox(height: 4),
                    Text('Unable to load video source'.tr,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          )
        : VisibilityDetector(
            key: Key(widget.videoSrc),
            onVisibilityChanged: (visibilityInfo) {
              double visibleFraction = visibilityInfo.visibleFraction;
              bool isVisible = visibleFraction >= videoPlayFactorOnScreen;
              if (isVisible) {
                if (_initialized &&
                    !_isDisposing &&
                    !_controller.value.isPlaying &&
                    widget.isAutoPlayEnabled &&
                    !_isManuallyPaused) {
                  _controller.play();
                  setState(() {
                    _isPlaying = true;
                  });
                }
              } else {
                if (_initialized &&
                    !_isDisposing &&
                    _controller.value.isPlaying) {
                  _controller.pause();
                  setState(() {
                    _isPlaying = false;
                  });
                }
              }
            },
            child: _controller.value.isInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      // ===================== main video section ==============
                      InkWell(
                        onTap: widget.onNavigate,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(
                            _controller,
                          ),
                        ),
                      ),

                      // ===================== live text section ===============
                      widget.isLive == true
                          ? Positioned(
                              left: 12,
                              top: 12,
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.red),
                                child: Text('Live'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                            )
                          : const SizedBox(),

                      // ====================== play and pause button ==========
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isHidePlayButton = !_isHidePlayButton;
                              if (!_isHidePlayButton) {
                                _startHidePlayButtonTimer(); // Start the timer when the button is shown
                              }
                            });
                          },
                          child: Container(
                            width: Get.width,
                            color: Colors.transparent,
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 16, vertical: 8),
                            alignment: Alignment.center,
                            child: _isHidePlayButton
                                ? const SizedBox()
                                : IconButton(
                                    icon: Container(
                                      height: 40,
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.4),
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      _togglePlayPause();
                                      _startHidePlayButtonTimer();
                                    },
                                  ),
                          ),
                        ),
                      ),
                      // ======================= handle video sound ============
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
                                      color:
                                          Colors.black.withValues(alpha: 0.4),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    isMuted
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    size: 20,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              );
                            }),
                      ),
                      // ===================== video buffering =================
                      if (_isBuffering) const CircularProgressIndicator(),
                    ],
                  )
                : AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.teal),
                      ),
                    ),
                  ));
  }
}
