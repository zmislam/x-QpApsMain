import 'package:get/get.dart';
import '../../services/reels_v2_api_service.dart';
import '../../models/reel_v2_model.dart';
import '../../models/reel_sound_model.dart';
import '../../models/reel_hashtag_model.dart';
import '../../utils/reel_constants.dart';

class ReelsSearchController extends GetxController {
  final ReelsV2ApiService _apiService = ReelsV2ApiService();

  // ─── Search State ─────────────────────────────────────────
  final searchQuery = ''.obs;
  final activeTab = 0.obs; // 0=Top, 1=Reels, 2=Sounds, 3=Hashtags, 4=Creators
  final isSearching = false.obs;

  // ─── Results ──────────────────────────────────────────────
  final topResults = <dynamic>[].obs;
  final reelResults = <ReelV2Model>[].obs;
  final soundResults = <ReelSoundModel>[].obs;
  final hashtagResults = <ReelHashtagModel>[].obs;
  final creatorResults = <Map<String, dynamic>>[].obs;

  // ─── Trending / Suggestions ───────────────────────────────
  final trendingHashtags = <ReelHashtagModel>[].obs;
  final recentSearches = <String>[].obs;
  final suggestedSearches = <String>[].obs;

  // ─── Hashtag Feed ─────────────────────────────────────────
  final hashtagReels = <ReelV2Model>[].obs;
  final hashtagFeedLoading = false.obs;
  final currentHashtag = Rxn<ReelHashtagModel>();

  // ─── Location Feed ────────────────────────────────────────
  final locationReels = <ReelV2Model>[].obs;
  final locationFeedLoading = false.obs;
  final currentLocationId = ''.obs;
  final currentLocationName = ''.obs;

  // ─── Challenges ───────────────────────────────────────────
  final challenges = <Map<String, dynamic>>[].obs;
  final challengesLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTrendingHashtags();
    _loadChallenges();
    debounce(searchQuery, (_) => _performSearch(),
        time: const Duration(milliseconds: 400));
  }

  // ─── Search ───────────────────────────────────────────────

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setActiveTab(int index) {
    activeTab.value = index;
    if (searchQuery.value.isNotEmpty) {
      _performSearch();
    }
  }

  Future<void> _performSearch() async {
    final q = searchQuery.value.trim();
    if (q.isEmpty) {
      _clearResults();
      return;
    }

    isSearching.value = true;

    try {
      switch (activeTab.value) {
        case 0:
          await _searchTop(q);
          break;
        case 1:
          await _searchReels(q);
          break;
        case 2:
          await _searchSounds(q);
          break;
        case 3:
          await _searchHashtags(q);
          break;
        case 4:
          await _searchCreators(q);
          break;
      }
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> _searchTop(String query) async {
    // Fetch mixed results across all types
    await Future.wait([
      _searchReels(query),
      _searchSounds(query),
      _searchHashtags(query),
      _searchCreators(query),
    ]);

    topResults.value = [
      ...hashtagResults.take(3),
      ...reelResults.take(5),
      ...soundResults.take(3),
      ...creatorResults.take(3),
    ];
  }

  Future<void> _searchReels(String query) async {
    final res = await _apiService.searchReels(query);
    if (res.isSuccessful && res.data != null) {
      final data = res.data is Map ? (res.data as Map)['reels'] ?? [] : res.data;
      reelResults.value =
          (data as List).map((e) => ReelV2Model.fromMap(e)).toList();
    }
  }

  Future<void> _searchSounds(String query) async {
    final res = await _apiService.searchSounds(query);
    if (res.isSuccessful && res.data != null) {
      final data = res.data is Map ? (res.data as Map)['sounds'] ?? [] : res.data;
      soundResults.value =
          (data as List).map((e) => ReelSoundModel.fromMap(e)).toList();
    }
  }

  Future<void> _searchHashtags(String query) async {
    final res = await _apiService.searchHashtags(query);
    if (res.isSuccessful && res.data != null) {
      final data = res.data is Map ? (res.data as Map)['hashtags'] ?? [] : res.data;
      hashtagResults.value =
          (data as List).map((e) => ReelHashtagModel.fromMap(e)).toList();
    }
  }

  Future<void> _searchCreators(String query) async {
    final res = await _apiService.searchCreators(query);
    if (res.isSuccessful && res.data != null) {
      final data = res.data is Map ? (res.data as Map)['creators'] ?? [] : res.data;
      creatorResults.value =
          (data as List).map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  void _clearResults() {
    topResults.clear();
    reelResults.clear();
    soundResults.clear();
    hashtagResults.clear();
    creatorResults.clear();
  }

  void addToRecentSearches(String query) {
    recentSearches.remove(query);
    recentSearches.insert(0, query);
    if (recentSearches.length > 20) {
      recentSearches.removeLast();
    }
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }

  // ─── Hashtag Feed ─────────────────────────────────────────

  Future<void> loadHashtagFeed(String tag) async {
    hashtagFeedLoading.value = true;
    try {
      final res = await _apiService.getHashtagFeed(tag);
      if (res.isSuccessful && res.data != null) {
        final data = res.data is Map ? (res.data as Map)['reels'] ?? [] : res.data;
        hashtagReels.value =
            (data as List).map((e) => ReelV2Model.fromMap(e)).toList();

        // Also load hashtag meta if available
        if (res.data is Map && (res.data as Map)['hashtag'] != null) {
          currentHashtag.value =
              ReelHashtagModel.fromMap((res.data as Map)['hashtag']);
        }
      }
    } finally {
      hashtagFeedLoading.value = false;
    }
  }

  // ─── Location Feed ────────────────────────────────────────

  Future<void> loadLocationFeed(String locationId, {String? name}) async {
    currentLocationId.value = locationId;
    if (name != null) currentLocationName.value = name;
    locationFeedLoading.value = true;

    try {
      final res = await _apiService.getLocationFeed(locationId);
      if (res.isSuccessful && res.data != null) {
        final data = res.data is Map ? (res.data as Map)['reels'] ?? [] : res.data;
        locationReels.value =
            (data as List).map((e) => ReelV2Model.fromMap(e)).toList();
      }
    } finally {
      locationFeedLoading.value = false;
    }
  }

  // ─── Trending & Challenges ────────────────────────────────

  Future<void> _loadTrendingHashtags() async {
    final res = await _apiService.getTrendingHashtags();
    if (res.isSuccessful && res.data != null) {
      final data = res.data is Map ? (res.data as Map)['hashtags'] ?? [] : res.data;
      trendingHashtags.value =
          (data as List).map((e) => ReelHashtagModel.fromMap(e)).toList();
    }
  }

  Future<void> _loadChallenges() async {
    challengesLoading.value = true;
    try {
      final res = await _apiService.getChallenges();
      if (res.isSuccessful && res.data != null) {
        final data = res.data is Map ? (res.data as Map)['challenges'] ?? [] : res.data;
        challenges.value =
            (data as List).map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } finally {
      challengesLoading.value = false;
    }
  }

  void joinChallenge(String challengeId) {
    Get.toNamed('/reels-v2/camera', arguments: {
      'challengeId': challengeId,
    });
  }
}
