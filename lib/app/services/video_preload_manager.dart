import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/api_constant.dart';
import 'package:quantum_possibilities_flutter/app/services/video_preloader.dart';

/// Manages a pool of pre-initialized [VideoPlayerController] instances for
/// smooth reel transitions.  Keeps controllers for (current - 1), current,
/// and (current + 1) reels alive; disposes everything else.
class VideoPreloadManager {
  VideoPreloadManager._();
  static final VideoPreloadManager instance = VideoPreloadManager._();

  final VideoPreloader _preloader = VideoPreloader();

  /// Currently managed controllers keyed by reel ID.
  final Map<String, _PoolEntry> _pool = {};

  /// Maximum number of controllers alive at one time.
  static const int _maxPoolSize = 3;

  /// IDs that are currently being initialized (avoid duplicate init).
  final Set<String> _initializing = {};

  // ─── Public API ──────────────────────────────────────────────────────────

  /// Returns a ready-to-use [VideoPlayerController] for [reelId], or null if
  /// none is prepared.  The controller is looping, paused, and already
  /// initialized.
  VideoPlayerController? getController(String reelId) {
    final entry = _pool[reelId];
    if (entry != null && entry.isReady) return entry.controller;
    return null;
  }

  /// Call this whenever the visible reel changes.  It will:
  ///  1. Pre-initialize controllers for the current and adjacent reels.
  ///  2. Dispose controllers that are no longer in the keep-alive window.
  void onPageChanged({
    required int currentIndex,
    required List<ReelRef> reels,
  }) {
    // Determine which reel IDs to keep alive.
    final keepIds = <String>{};
    for (int offset = -1; offset <= 1; offset++) {
      final idx = currentIndex + offset;
      if (idx >= 0 && idx < reels.length) {
        keepIds.add(reels[idx].id);
      }
    }

    // Kick off initialization for any not-yet-ready reels.
    for (final id in keepIds) {
      final ref = reels.firstWhere((r) => r.id == id);
      _ensureInitialized(ref);
    }

    // Dispose controllers outside the window.
    final toRemove = _pool.keys.where((id) => !keepIds.contains(id)).toList();
    for (final id in toRemove) {
      _disposeEntry(id);
    }
  }

  /// Dispose ALL managed controllers (e.g. when leaving the reels screen).
  void disposeAll() {
    for (final id in _pool.keys.toList()) {
      _disposeEntry(id);
    }
    _pool.clear();
    _initializing.clear();
  }

  // ─── Internal ────────────────────────────────────────────────────────────

  Future<void> _ensureInitialized(ReelRef ref) async {
    if (_pool.containsKey(ref.id) || _initializing.contains(ref.id)) return;
    _initializing.add(ref.id);

    try {
      final url =
          '${ApiConstant.SERVER_IP_PORT}/uploads/reels/${ref.videoPath}';

      // Try to get a cached file first for instant playback.
      VideoPlayerController controller;
      final cachedFile = await _preloader.getCachedFile(url);
      if (cachedFile != null && await cachedFile.exists()) {
        controller = VideoPlayerController.file(cachedFile);
      } else {
        controller = VideoPlayerController.networkUrl(Uri.parse(url));
      }

      await controller.initialize();
      controller.setLooping(true);
      // Start paused — ReelsComponent will call play() when visible.
      await controller.pause();

      // Guard: we may have been disposed while awaiting.
      if (!_initializing.contains(ref.id)) {
        controller.dispose();
        return;
      }

      _pool[ref.id] = _PoolEntry(controller: controller, isReady: true);

      // Evict oldest if over capacity.
      _trimPool();
    } catch (e) {
      debugPrint('VideoPreloadManager: init failed for ${ref.id}: $e');
    } finally {
      _initializing.remove(ref.id);
    }
  }

  void _trimPool() {
    while (_pool.length > _maxPoolSize) {
      final oldestId = _pool.keys.first;
      _disposeEntry(oldestId);
    }
  }

  void _disposeEntry(String id) {
    final entry = _pool.remove(id);
    if (entry != null) {
      try {
        entry.controller.pause();
      } catch (_) {}
      try {
        entry.controller.dispose();
      } catch (_) {}
    }
  }
}

// ─── Helper types ────────────────────────────────────────────────────────────

class _PoolEntry {
  final VideoPlayerController controller;
  final bool isReady;
  _PoolEntry({required this.controller, required this.isReady});
}

/// Lightweight reference to a reel, used to avoid passing the full model.
class ReelRef {
  final String id;
  final String videoPath;
  const ReelRef({required this.id, required this.videoPath});
}
