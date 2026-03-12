import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class DetailsPostVideoPlayer extends StatefulWidget {
  final String videoSrc;
  const DetailsPostVideoPlayer({required this.videoSrc, super.key});

  @override
  State<DetailsPostVideoPlayer> createState() => _DetailsPostVideoPlayerState();
}

class _DetailsPostVideoPlayerState extends State<DetailsPostVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isBuffering = false;
  bool _isMuted = false;
  bool _isVideoSrcError = false;
  bool _isHidePlayButton = false;

  // =============================== initState method ==========================
  @override
  void initState() {
    super.initState();
    try {
      // =========================== initialize video controller ===============
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoSrc))
        ..initialize().then((_) {
          setState(() {});
        })
        ..play()
        ..setLooping(false)
        ..setVolume(1);
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

    // ============================ listen buffer ==============================
    _controller.addListener(() {
      setState(() {
        _isBuffering = _controller.value.isBuffering;
      });
    });
  }

  // ============================== Handle video play and pause ================
  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  // ============================== Handle video play back seeking =============
  void _seekBackward() {
    _controller
        .seekTo(_controller.value.position - const Duration(seconds: 10));
  }

  // ============================== Handle video play forward seeking ==========
  void _seekForward() {
    _controller
        .seekTo(_controller.value.position + const Duration(seconds: 10));
  }

  // ============================== handle video sound mute and unmute =========
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  // ============================== dispose method =============================
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVideoSrcError
        // ============================ video src error view =======================
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
        : _controller.value.isInitialized
            // ========================== main video view ======================
            ? Stack(
                alignment: Alignment.center,
                children: [
                  // ==================== video Player =========================
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isHidePlayButton = !_isHidePlayButton;
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  // ==================== buffer loading =======================
                  if (_isBuffering) const CircularProgressIndicator(),
                  // ==================== main video play action button ========
                  Align(
                    alignment: Alignment.center,
                    child: _isHidePlayButton
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ================ video seek backward ============
                              IconButton(
                                icon: Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.4),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.replay_10,
                                      color: Colors.white),
                                ),
                                onPressed: _seekBackward,
                              ),
                              // ================ video play and pause ===========
                              IconButton(
                                icon: Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.4),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: _togglePlayPause,
                              ),
                              // ================ video seek forward =============
                              IconButton(
                                icon: Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.4),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.forward_10,
                                      color: Colors.white),
                                ),
                                onPressed: _seekForward,
                              ),
                            ],
                          ),
                  ),
                  // ==================== progress and sound button ============
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ================ video progress indicator ===========
                        Expanded(
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.red,
                              bufferedColor: Colors.grey,
                              // backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        // ================= sound mute and unmute button ======
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 4),
                          child: IconButton(
                            icon: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  shape: BoxShape.circle),
                              child: Icon(
                                size: 20,
                                _isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: _toggleMute,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            // ========================== initial loading ======================
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
              );
  }
}
