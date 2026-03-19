import 'package:get/get.dart';

import '../../../../../../models/api_response.dart';
import '../../../../../../repository/reels_repository.dart';
import '../../../model/reels_model.dart';

class SavedReelsController extends GetxController {
  final ReelsRepository _reelsRepository = ReelsRepository();

  Rx<List<ReelsModel>> savedReels = Rx([]);
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  int _skip = 0;
  final int _limit = 20;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    _loadSavedReels();
  }

  Future<void> _loadSavedReels() async {
    isLoading.value = true;
    try {
      final ApiResponse response = await _reelsRepository.getMyBookmarkedReels(
        limit: _limit,
        skip: 0,
      );
      print('[SavedReels] response.isSuccessful=${response.isSuccessful}, data type=${response.data?.runtimeType}, data=${response.data}');
      if (response.isSuccessful && response.data != null) {
        savedReels.value = response.data as List<ReelsModel>;
        _skip = savedReels.value.length;
        _hasMore = savedReels.value.length >= _limit;
        print('[SavedReels] Loaded ${savedReels.value.length} reels');
      } else {
        print('[SavedReels] API failed: ${response.message}');
      }
    } catch (e, st) {
      print('[SavedReels] Exception: $e\n$st');
    }
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !_hasMore) return;
    isLoadingMore.value = true;
    try {
      final ApiResponse response = await _reelsRepository.getMyBookmarkedReels(
        limit: _limit,
        skip: _skip,
      );
      if (response.isSuccessful && response.data != null) {
        final newReels = response.data as List<ReelsModel>;
        savedReels.value = [...savedReels.value, ...newReels];
        _skip += newReels.length;
        _hasMore = newReels.length >= _limit;
      }
    } catch (_) {}
    isLoadingMore.value = false;
  }

  Future<void> refresh() async {
    _skip = 0;
    _hasMore = true;
    await _loadSavedReels();
  }

  /// Unsave (remove bookmark from) a reel
  Future<void> unsaveReel(String reelId) async {
    if (reelId.isEmpty) return;
    
    try {
      final response = await _reelsRepository.toggleBookmark(reelId: reelId);
      if (response.isSuccessful) {
        // Remove from local list
        savedReels.value = savedReels.value.where((r) => r.id != reelId).toList();
        savedReels.refresh();
      }
    } catch (e) {
      print('[SavedReels] Error unsaving reel: $e');
    }
  }
}
