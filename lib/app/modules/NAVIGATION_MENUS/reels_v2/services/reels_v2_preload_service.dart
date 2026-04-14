import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../models/reel_v2_model.dart';
import '../utils/reel_constants.dart';

/// Preload service for Reels V2.
/// Manages a 5-reel video preload window (2 prev + current + 2 next).
/// Maintains a pool of VideoPlayerControllers to avoid creating/disposing
/// too many controllers simultaneously.
class ReelsV2PreloadService {
  /// Pool of active video controllers keyed by reel index in the feed.
  final Map<int, VideoPlayerController> _controllerPool = {};

  /// Track which indexes are currently being preloaded.
  final Set<int> _preloading = {};

  /// Total number of reels in the feed (updated by the feed controller).
  int _totalReels = 0;

  /// Update the total reel count when feed changes.
  void setTotalReels(int count) {
    _totalReels = count;
  }

  /// Called when the user swipes to a new index.
  /// Preloads the window around [currentIndex] and disposes controllers
  /// outside the window.
  Future<void> onIndexChanged(int currentIndex, List<ReelV2Model> reels) async {
    _totalReels = reels.length;

    final windowStart = (currentIndex - ReelConstants.preloadBefore).clamp(0, _totalReels - 1);
    final windowEnd = (currentIndex + ReelConstants.preloadAfter).clamp(0, _totalReels - 1);

    // Dispose controllers outside the window
    final toDispose = _controllerPool.keys
        .where((i) => i < windowStart || i > windowEnd)
        .toList();
    for (final index in toDispose) {
      await _disposeController(index);
    }

    // Preload controllers within the window
    for (int i = windowStart; i <= windowEnd; i++) {
      if (!_controllerPool.containsKey(i) && !_preloading.contains(i)) {
        _preloadAt(i, reels[i]);
      }
    }
  }

  /// Preload a video at the given index.
  Future<void> _preloadAt(int index, ReelV2Model reel) async {
    if (reel.videoUrl == null || reel.videoUrl!.isEmpty) return;
    _preloading.add(index);

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(reel.videoUrl!),
      );
      await controller.initialize();
      controller.setLooping(true);

      // Only add to pool if still within valid range
      if (index >= 0 && index < _totalReels) {
        _controllerPool[index] = controller;
      } else {
        controller.dispose();
      }
    } catch (e) {
      // Silently handle preload failures
    } finally {
      _preloading.remove(index);
    }
  }

  /// Get the controller for a specific index. Returns null if not preloaded.
  VideoPlayerController? getController(int index) {
    return _controllerPool[index];
  }

  /// Check if a controller exists and is initialized for the given index.
  bool isReady(int index) {
    final controller = _controllerPool[index];
    return controller != null && controller.value.isInitialized;
  }

  /// Play video at specific index, pause all others.
  Future<void> playAt(int index) async {
    for (final entry in _controllerPool.entries) {
      if (entry.key == index) {
        if (entry.value.value.isInitialized && !entry.value.value.isPlaying) {
          await entry.value.play();
        }
      } else {
        if (entry.value.value.isPlaying) {
          await entry.value.pause();
        }
      }
    }
  }

  /// Pause video at specific index.
  Future<void> pauseAt(int index) async {
    final controller = _controllerPool[index];
    if (controller != null && controller.value.isPlaying) {
      await controller.pause();
    }
  }

  /// Pause all playing videos.
  Future<void> pauseAll() async {
    for (final controller in _controllerPool.values) {
      if (controller.value.isPlaying) {
        await controller.pause();
      }
    }
  }

  /// Dispose a single controller.
  Future<void> _disposeController(int index) async {
    final controller = _controllerPool.remove(index);
    if (controller != null) {
      await controller.pause();
      await controller.dispose();
    }
  }

  /// Dispose all controllers — call when leaving the reels screen.
  Future<void> disposeAll() async {
    for (final controller in _controllerPool.values) {
      try {
        await controller.pause();
        await controller.dispose();
      } catch (_) {}
    }
    _controllerPool.clear();
    _preloading.clear();
  }
}
