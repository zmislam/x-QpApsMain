import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../models/api_response.dart';
import '../../../../../../repository/reels_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../../../model/reels_model.dart';

class WatchedReelsController extends GetxController {
  final ReelsRepository _reelsRepository = ReelsRepository();

  Rx<List<ReelsModel>> watchedReels = Rx([]);
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  int _skip = 0;
  final int _limit = 20;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    _loadWatchHistory();
  }

  Future<void> _loadWatchHistory() async {
    isLoading.value = true;
    try {
      final ApiResponse response = await _reelsRepository.getWatchHistory(
        limit: _limit,
        skip: 0,
      );
      if (response.isSuccessful && response.data != null) {
        watchedReels.value = response.data as List<ReelsModel>;
        _skip = watchedReels.value.length;
        _hasMore = watchedReels.value.length >= _limit;
      }
    } catch (_) {
      // fail silently
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !_hasMore) return;
    isLoadingMore.value = true;
    try {
      final ApiResponse response = await _reelsRepository.getWatchHistory(
        limit: _limit,
        skip: _skip,
      );
      if (response.isSuccessful && response.data != null) {
        final newReels = response.data as List<ReelsModel>;
        watchedReels.value = [...watchedReels.value, ...newReels];
        _skip += newReels.length;
        _hasMore = newReels.length >= _limit;
      }
    } catch (_) {
      // fail silently
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> removeFromHistory(String reelId) async {
    // Optimistic removal from UI
    final removedIndex = watchedReels.value.indexWhere((r) => r.id == reelId);
    if (removedIndex == -1) return;

    final removedItem = watchedReels.value[removedIndex];
    watchedReels.value = List.from(watchedReels.value)..removeAt(removedIndex);

    try {
      final response = await _reelsRepository.removeFromWatchHistory(reelId: reelId);
      if (!response.isSuccessful) {
        // Revert on failure
        watchedReels.value = List.from(watchedReels.value)..insert(removedIndex, removedItem);
        showErrorSnackkbar(message: 'Failed to remove');
      }
    } catch (_) {
      watchedReels.value = List.from(watchedReels.value)..insert(removedIndex, removedItem);
      showErrorSnackkbar(message: 'Failed to remove');
    }
  }

  Future<void> clearAllHistory(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Watch History'),
        content: const Text('Are you sure you want to clear your entire watch history? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final backup = List<ReelsModel>.from(watchedReels.value);
    watchedReels.value = [];

    try {
      final response = await _reelsRepository.clearWatchHistory();
      if (!response.isSuccessful) {
        watchedReels.value = backup;
        showErrorSnackkbar(message: 'Failed to clear history');
      }
    } catch (_) {
      watchedReels.value = backup;
      showErrorSnackkbar(message: 'Failed to clear history');
    }
  }

  Future<void> saveReel(String reelId) async {
    await _reelsRepository.toggleBookmark(reelId: reelId);
  }

  Future<void> markNotInterested(String reelId) async {
    await _reelsRepository.sendFeedback(reelId: reelId, signalType: 'not_interested');
    await removeFromHistory(reelId);
  }

  @override
  Future<void> refresh() async {
    _skip = 0;
    _hasMore = true;
    await _loadWatchHistory();
  }
}
