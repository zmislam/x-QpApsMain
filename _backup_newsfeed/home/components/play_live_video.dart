import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PlayLiveVideo extends StatefulWidget {
  final bool isAudience;
  final String videoSrc;
  final int? videoPlayTime;
  final bool? isLive;
  final bool isAutoPlayEnabled;
  const PlayLiveVideo(
      {required this.videoSrc,
      this.videoPlayTime,
      this.isAudience = false,
      this.isAutoPlayEnabled = true,
      this.isLive = false,
      super.key});

  @override
  State<PlayLiveVideo> createState() => _PlayLiveVideoState();
}

class _PlayLiveVideoState extends State<PlayLiveVideo> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _isHidePlayButton = false;
  bool _isBuffering = false;
  bool _isVideoSrcError = false;

  @override
  void initState() {
    super.initState();

    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoSrc))
        ..initialize().then((_) {
          setState(() {});
          if (widget.isAutoPlayEnabled) {
            _controller.play();
            _isPlaying = true;
          }
        })
        ..seekTo(Duration(milliseconds: widget.videoPlayTime ?? 0))
        ..setVolume(1)
        ..setLooping(false)
        ..play();
    } catch (e) {
      setState(() {
        _isVideoSrcError = true;
      });
    }

    _controller.addListener(
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    // Listen for video state changes
    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    });

    _controller.addListener(() {
      if (_controller.value.isBuffering) {
        setState(() {
          _isBuffering = true;
        });
      } else {
        setState(() {
          _isBuffering = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return _isVideoSrcError
        ? SizedBox(
            width: Get.width,
            height: 200,
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error,
                        color: Colors.black.withValues(alpha: 0.5), size: 24),
                    const SizedBox(height: 4),
                    Text('Unable to load video source'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          )
        : VisibilityDetector(
            key: Key(widget.videoSrc),
            onVisibilityChanged: (visibilityInfo) {
              var visiblePercentage = visibilityInfo.visibleFraction * 100;
              if (visiblePercentage < 70) {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                  setState(() {
                    _isPlaying = false;
                  });
                }
              } else {
                if (!_controller.value.isPlaying && widget.isAutoPlayEnabled) {
                  _controller.play();
                  setState(() {
                    _isPlaying = true;
                  });
                }
              }
            },
            child: _controller.value.isInitialized
                ? Stack(alignment: Alignment.center, children: [
                    // =========================== video player ==========================================
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isHidePlayButton = !_isHidePlayButton;
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(
                          _controller,
                        ),
                      ),
                    ),

                    // ========================= video play and pause button =============================
                    _isHidePlayButton
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _togglePlayPause,
                              icon: Container(
                                height: 64,
                                width: 64,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: Colors.black26,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                    // ================================ live text section =====================================
                    widget.isAudience
                        ? const SizedBox()
                        : widget.isLive == true
                            ? Positioned(
                                left: 12,
                                top: 12,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
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
                    if (_isBuffering) const CircularProgressIndicator(),
                  ])
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
