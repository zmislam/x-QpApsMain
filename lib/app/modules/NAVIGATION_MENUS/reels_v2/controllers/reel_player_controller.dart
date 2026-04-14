import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../models/reel_v2_model.dart';
import '../services/reels_v2_preload_service.dart';
import '../services/reels_v2_api_service.dart';
import '../utils/reel_enums.dart';

/// Player controller for individual reel playback.
/// Manages video player lifecycle, play/pause, looping, and tracking.
class ReelPlayerController extends GetxController {
  // ─── Dependencies ──────────────────────────────────────
  late final ReelsV2PreloadService preloadService;
  late final ReelsV2ApiService apiService;

  // ─── Player State ──────────────────────────────────────
  final Rx<ReelPlayerState> playerState = ReelPlayerState.idle.obs;
  final RxInt currentIndex = (-1).obs;
  final RxBool isMuted = false.obs;
  final RxInt loopCount = 0.obs;
  final RxDouble progress = 0.0.obs;
  final RxBool isBuffering = false.obs;

  // ─── Tracking ──────────────────────────────────────────
  DateTime? _viewStartTime;
  int _lastTrackedPosition = 0;
  bool _viewTracked = false;

  @override
  void onInit() {
    super.onInit();
    preloadService = Get.find<ReelsV2PreloadService>();
    apiService = Get.find<ReelsV2ApiService>();
  }

  /// Start playing a reel at the given index.
  Future<void> playReel(int index, ReelV2Model reel) async {
    if (index == currentIndex.value) return;

    // Stop tracking previous reel
    _stopTracking();

    currentIndex.value = index;
    playerState.value = ReelPlayerState.loading;
    loopCount.value = 0;
    progress.value = 0.0;
    _viewTracked = false;

    // Wait for controller to be ready from preload service
    final controller = preloadService.getController(index);
    if (controller != null && controller.value.isInitialized) {
      _attachListeners(controller);
      await preloadService.playAt(index);
      playerState.value = ReelPlayerState.playing;
      _startTracking(reel);
    } else {
      // Controller not yet preloaded — wait briefly
      playerState.value = ReelPlayerState.loading;
      await Future.delayed(const Duration(milliseconds: 500));
      final retryController = preloadService.getController(index);
      if (retryController != null && retryController.value.isInitialized) {
        _attachListeners(retryController);
        await preloadService.playAt(index);
        playerState.value = ReelPlayerState.playing;
        _startTracking(reel);
      } else {
        playerState.value = ReelPlayerState.error;
      }
    }
  }

  /// Toggle play/pause.
  void togglePlayPause() {
    final controller = preloadService.getController(currentIndex.value);
    if (controller == null) return;

    if (controller.value.isPlaying) {
      controller.pause();
      playerState.value = ReelPlayerState.paused;
    } else {
      controller.play();
      playerState.value = ReelPlayerState.playing;
    }
  }

  /// Toggle mute.
  void toggleMute() {
    final controller = preloadService.getController(currentIndex.value);
    if (controller == null) return;

    isMuted.value = !isMuted.value;
    controller.setVolume(isMuted.value ? 0.0 : 1.0);
  }

  /// Seek to position (0.0 to 1.0).
  void seekTo(double fraction) {
    final controller = preloadService.getController(currentIndex.value);
    if (controller == null || !controller.value.isInitialized) return;

    final duration = controller.value.duration;
    final position = Duration(
      milliseconds: (duration.inMilliseconds * fraction).round(),
    );
    controller.seekTo(position);
  }

  /// Get the current VideoPlayerController for UI binding.
  VideoPlayerController? get currentController {
    if (currentIndex.value < 0) return null;
    return preloadService.getController(currentIndex.value);
  }

  void _attachListeners(VideoPlayerController controller) {
    controller.addListener(() {
      if (!controller.value.isInitialized) return;

      // Update progress
      final duration = controller.value.duration.inMilliseconds;
      final position = controller.value.position.inMilliseconds;
      if (duration > 0) {
        progress.value = position / duration;
      }

      // Detect buffering
      isBuffering.value = controller.value.isBuffering;

      // Detect loop completion (position resets near 0 after reaching near end)
      if (position < _lastTrackedPosition && _lastTrackedPosition > duration * 0.8) {
        loopCount.value++;
      }
      _lastTrackedPosition = position;
    });
  }

  void _startTracking(ReelV2Model reel) {
    _viewStartTime = DateTime.now();

    // Track view after 3 seconds of watching
    Future.delayed(const Duration(seconds: 3), () {
      if (currentIndex.value >= 0 &&
          playerState.value == ReelPlayerState.playing &&
          !_viewTracked &&
          reel.id != null) {
        _viewTracked = true;
        apiService.trackView([
          {
            'reel_id': reel.id,
            'source': 'feed',
            'watch_duration': 3,
          }
        ]);
      }
    });
  }

  void _stopTracking() {
    if (_viewStartTime != null && currentIndex.value >= 0) {
      final watchDuration = DateTime.now().difference(_viewStartTime!).inSeconds;
      if (watchDuration > 1) {
        // Track watch time if meaningful
        apiService.trackWatchTime({
          'watch_duration': watchDuration,
          'loop_count': loopCount.value,
          'position': progress.value,
        });
      }
    }
    _viewStartTime = null;
    _lastTrackedPosition = 0;
  }

  /// Pause current playback (e.g., when app goes to background).
  void pauseCurrent() {
    if (currentIndex.value >= 0) {
      preloadService.pauseAt(currentIndex.value);
      playerState.value = ReelPlayerState.paused;
    }
  }

  /// Resume current playback.
  void resumeCurrent() {
    if (currentIndex.value >= 0) {
      preloadService.playAt(currentIndex.value);
      playerState.value = ReelPlayerState.playing;
    }
  }

  @override
  void onClose() {
    _stopTracking();
    super.onClose();
  }
}
