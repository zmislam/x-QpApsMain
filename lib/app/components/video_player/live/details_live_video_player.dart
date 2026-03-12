import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/video_size_convertion_util.dart';
import 'package:video_player/video_player.dart';
class DetailsLiveVideoPlayer extends StatefulWidget {
  final String videoSrc;
  final int videoPlayTime;
  final bool? hasLive;
  const DetailsLiveVideoPlayer({
    required this.videoSrc,
    this.videoPlayTime = 0,
    this.hasLive,
    super.key,
  });

  @override
  State<DetailsLiveVideoPlayer> createState() => _DetailsLiveVideoPlayerState();
}

class _DetailsLiveVideoPlayerState extends State<DetailsLiveVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isBuffering = false;
  bool _isMuted = false;
  bool _isVideoSrcError = false;
  bool _isHidePlayButton = false;
  bool _isInitialized = false;
  Size videoScale = const Size(0, 0);
  bool useOriginalScale = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    if (widget.videoSrc.isEmpty) {
      setState(() {
        _isVideoSrcError = true;
      });
      return;
    }

    // Debug: Print the URL being used
    debugPrint('🎥 Initializing video from: ${widget.videoSrc}');

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoSrc),
      );

      // CRITICAL: Use await instead of .then() to properly catch errors
      await _controller.initialize();

      if (!mounted) return;

      // Check aspect ratio after initialization
      if (_controller.value.aspectRatio > 1) {
        useOriginalScale = true;
      }

      // Set up video properties
      _controller.setLooping(false);
      _controller.setVolume(1);

      // Add listeners
      _controller.addListener(_videoListener);

      // Start playing
      await _controller.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        debugPrint('✅ Video initialized and playing');
      }
    } catch (e) {
      debugPrint('❌ Video initialization error: $e');
      if (mounted) {
        setState(() {
          _isVideoSrcError = true;
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted) return;

    final isBuffering = _controller.value.isBuffering;
    if (_isBuffering != isBuffering) {
      setState(() {
        _isBuffering = isBuffering;
      });
    }

    // Calculate video scale if needed
    if (!useOriginalScale &&
        _controller.value.aspectRatio != 1 &&
        videoScale.height == 0 &&
        videoScale.width == 0) {
      final size = MediaQuery.sizeOf(context);
      videoScale = getScaledSizeEX(_controller.value.size, size);
      setState(() {});
    }
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _seekBackward() {
    _controller.seekTo(_controller.value.position - const Duration(seconds: 10));
  }

  void _seekForward() {
    _controller.seekTo(_controller.value.position + const Duration(seconds: 10));
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Show error state
    if (_isVideoSrcError) {
      return SizedBox(
        width: Get.width,
        height: size.height,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.black),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red.withValues(alpha: 0.8), size: 48),
                const SizedBox(height: 12),
                Text('Unable to load video'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text('Video source not found (404)'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show loading state
    if (!_isInitialized) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
          child: CircularProgressIndicator(color: Colors.teal),
        ),
      );
    }

    // Show video player
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isHidePlayButton = !_isHidePlayButton;
              });
            },
            child: useOriginalScale
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : Container(
              decoration: const BoxDecoration(color: Colors.black),
              height: _controller.value.size.height,
              child: Transform.scale(
                scaleX: 1.5,
                scaleY: 1.2,
                child: AspectRatio(
                  aspectRatio: videoScale.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          ),
          if (_isBuffering) const CircularProgressIndicator(),
          if (widget.hasLive != true)
            Align(
              alignment: Alignment.center,
              child: _isHidePlayButton
                  ? const SizedBox()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.replay_10, color: Colors.white),
                    ),
                    onPressed: _seekBackward,
                  ),
                  IconButton(
                    icon: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _togglePlayPause,
                  ),
                  IconButton(
                    icon: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.forward_10, color: Colors.white),
                    ),
                    onPressed: _seekForward,
                  ),
                ],
              ),
            ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4),
                  child: IconButton(
                    icon: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        size: 20,
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _toggleMute,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}