import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/video_ad_config.dart';
import '../../../services/video_sound_controller.dart';
import '../../../utils/video_manager/video_manager_value_notifier_singleton.dart';

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
  final String? thumbnailUrl;

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
      this.thumbnailUrl,
      super.key});

  @override
  State<NewsFeedPostVideoPlayer> createState() =>
      _NewsfeedPostVideoPlayerState();
}

class _NewsfeedPostVideoPlayerState extends State<NewsFeedPostVideoPlayer> {
  VideoPlayerController? _controller;
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

  // ============================ Buffer/playing state listener ================
  void _onPlayerStateChanged() {
    if (!mounted || _isDisposing) return;
    final ctrl = _controller;
    if (ctrl == null) return;
    final newBuffering = ctrl.value.isBuffering;
    final newPlaying = ctrl.value.isPlaying;
    if (newBuffering != _isBuffering || newPlaying != _isPlaying) {
      setState(() {
        _isBuffering = newBuffering;
        _isPlaying = newPlaying;
      });
    }
  }

  // ============================ Lazy initialization ==========================
  /// Called the first time the video becomes visible on screen.
  /// Defers heavy VideoPlayerController creation until needed.
  void _initializeController() {
    if (_initialized) return;
    try {
      debugPrint('VIDEO LIVE URL : ${widget.isLive}');
      debugPrint(widget.videoSrc);

      final ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.videoSrc));
      ctrl.setLooping(false);

      _controller = ctrl;
      _initialized = true;

      ctrl.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        videoSoundSetupUpdate();
        if (widget.isAutoPlayEnabled) {
          // Register with VideoManager to pause any other playing video
          VideoManager().setActiveController(ctrl);
          ctrl.play();
          _isPlaying = true;
        }
      });

      // Listen to global mute state
      VideoSoundController.isMuted.addListener(videoSoundSetupUpdate);

      // Listen to buffer/playing changes (named method — removable)
      ctrl.addListener(_onPlayerStateChanged);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVideoSrcError = true;
      });
    }
  }

  // ============================ initState method =============================
  @override
  void initState() {
    super.initState();
    // Controller is NOT created here — see _initializeController().
    // It will be lazily initialized when the widget first scrolls into view.
  }

  // ============================== Handle video play and pause ================
  void _togglePlayPause() {
    final ctrl = _controller;
    if (ctrl == null) return;
    setState(() {
      if (ctrl.value.isPlaying) {
        ctrl.pause();
        _isManuallyPaused = true;
      } else {
        ctrl.play();
        _isManuallyPaused = false;
      }
      _isPlaying = ctrl.value.isPlaying;
    });
  }

  // ============================== video sound set up =========================
  void videoSoundSetupUpdate() {
    final ctrl = _controller;
    if (ctrl != null && ctrl.value.isInitialized) {
      double volume = VideoSoundController.isMuted.value ? 0.0 : 1.0;
      ctrl.setVolume(volume);
    }
  }

  // ============================ dispose method ===============================
  @override
  void dispose() {
    _isDisposing = true;
    VideoSoundController.isMuted.removeListener(videoSoundSetupUpdate);
    if (_initialized && _controller != null) {
      _controller!.removeListener(_onPlayerStateChanged);
      _controller!.dispose();
    }
    _hidePlayButtonTimer?.cancel();
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

              // Lazy init: create the controller on first visibility
              if (isVisible && !_initialized && !_isDisposing) {
                _initializeController();
                return; // controller is initializing — wait for next callback
              }

              final ctrl = _controller;
              if (ctrl == null || !_initialized || _isDisposing) return;

              if (isVisible) {
                if (!ctrl.value.isPlaying &&
                    widget.isAutoPlayEnabled &&
                    !_isManuallyPaused) {
                  // Register with VideoManager — auto-pauses the previous video
                  VideoManager().setActiveController(ctrl);
                  ctrl.play();
                  setState(() {
                    _isPlaying = true;
                  });
                }
              } else {
                if (ctrl.value.isPlaying) {
                  ctrl.pause();
                  setState(() {
                    _isPlaying = false;
                  });
                }
              }
            },
            child: (_controller != null && _controller!.value.isInitialized)
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      // ===================== main video section ==============
                      InkWell(
                        onTap: widget.onNavigate,
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(
                            _controller!,
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
                    aspectRatio: 16 / 9, // default aspect ratio while loading
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Thumbnail placeholder (instead of black rectangle)
                        if (widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: widget.thumbnailUrl!,
                            fit: BoxFit.cover,
                            memCacheWidth: (MediaQuery.of(context).size.width *
                                    MediaQuery.of(context).devicePixelRatio)
                                .toInt(),
                            errorWidget: (_, __, ___) => const DecoratedBox(
                              decoration: BoxDecoration(color: Colors.black),
                              child: SizedBox.expand(),
                            ),
                          )
                        else
                          const DecoratedBox(
                            decoration: BoxDecoration(color: Colors.black),
                            child: SizedBox.expand(),
                          ),
                        // Play icon + loading spinner overlay
                        Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
  }
}
