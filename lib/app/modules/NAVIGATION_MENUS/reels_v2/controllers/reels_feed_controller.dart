import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/reel_v2_model.dart';
import '../services/reels_v2_feed_service.dart';
import '../services/reels_v2_cache_service.dart';
import '../services/reels_v2_preload_service.dart';
import '../utils/reel_constants.dart';
import '../utils/reel_enums.dart';
import '../sponsored/controllers/reels_sponsored_controller.dart';
import '../sponsored/models/sponsored_reel_model.dart';

/// Feed controller for Reels V2.
/// Manages feed data, pagination, and reel list per feed type.
class ReelsFeedController extends GetxController {
  // ─── Dependencies ──────────────────────────────────────
  late final ReelsV2FeedService feedService;
  late final ReelsV2CacheService cacheService;
  late final ReelsV2PreloadService preloadService;

  // ─── Feed State ────────────────────────────────────────
  final Rx<ReelFeedType> currentFeedType = ReelFeedType.forYou.obs;
  final RxList<ReelV2Model> reels = <ReelV2Model>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentIndex = 0.obs;
  String? _nextCursor;

  // ─── Page Controller ───────────────────────────────────
  late PageController pageController;

  // ─── Per-feed cursor tracking ──────────────────────────
  final Map<ReelFeedType, List<ReelV2Model>> _feedData = {};
  final Map<ReelFeedType, String?> _feedCursors = {};

  // ─── Sponsored Reel Merge ──────────────────────────────
  ReelsSponsoredController? _sponsoredController;
  final Map<int, SponsoredReelModel> sponsoredSlots = {};

  /// Get the sponsored controller (lazy init).
  ReelsSponsoredController get _sponsored {
    _sponsoredController ??= Get.find<ReelsSponsoredController>();
    return _sponsoredController!;
  }

  /// Check if a particular index is a sponsored slot.
  bool isSponsoredIndex(int index) => sponsoredSlots.containsKey(index);

  /// Get the sponsored reel at a given feed index, or null.
  SponsoredReelModel? getSponsoredAtIndex(int index) => sponsoredSlots[index];

  @override
  void onInit() {
    super.onInit();
    feedService = Get.find<ReelsV2FeedService>();
    cacheService = Get.find<ReelsV2CacheService>();
    preloadService = Get.find<ReelsV2PreloadService>();
    pageController = PageController();

    // Load sponsored reels for feed merge
    _loadSponsoredReels();
  }

  /// Load sponsored reels and compute merge slots.
  Future<void> _loadSponsoredReels() async {
    try {
      await _sponsored.loadSponsoredReels();
      _computeSponsoredSlots();
    } catch (_) {
      // Sponsored ads are non-critical — don't block feed
    }
  }

  /// Compute which feed indices should show a sponsored reel.
  void _computeSponsoredSlots() {
    sponsoredSlots.clear();
    if (_sponsored.sponsoredReels.isEmpty) return;

    final totalReels = reels.length;
    for (int i = ReelConstants.sponsoredInterval - 1; i < totalReels + 10; i += ReelConstants.sponsoredInterval) {
      final ad = _sponsored.getAdForIndex(i);
      if (ad != null) {
        sponsoredSlots[i] = ad;
      }
    }
  }

  /// Load initial feed for a given type.
  Future<void> loadFeed(ReelFeedType type) async {
    currentFeedType.value = type;
    isLoading.value = true;

    // Check cache first
    final cacheKey = _cacheKeyForType(type);
    final cached = await cacheService.getCachedFeed(cacheKey);
    if (cached != null && cached.reels.isNotEmpty) {
      reels.assignAll(cached.reels);
      _nextCursor = cached.nextCursor;
      hasMore.value = cached.nextCursor != null;
      isLoading.value = false;
      _initPreload();
      _computeSponsoredSlots();
      return;
    }

    // Fetch from API
    try {
      final response = await feedService.fetchFeed(
        feedType: type,
        limit: ReelConstants.defaultPageSize,
      );

      if (response.isSuccessful) {
        reels.assignAll(response.reels);
        _nextCursor = response.nextCursor;
        hasMore.value = response.hasMore;

        // Store in per-feed data
        _feedData[type] = List.from(response.reels);
        _feedCursors[type] = response.nextCursor;

        // Cache the response
        await cacheService.cacheFeed(cacheKey, response.reels, response.nextCursor);

        _initPreload();
        _computeSponsoredSlots();
      }
    } catch (e) {
      debugPrint('[ReelsFeed] Error loading feed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load next page (infinite scroll).
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value || _nextCursor == null) return;
    isLoadingMore.value = true;

    try {
      final response = await feedService.fetchFeed(
        feedType: currentFeedType.value,
        cursor: _nextCursor,
        limit: ReelConstants.defaultPageSize,
      );

      if (response.isSuccessful) {
        reels.addAll(response.reels);
        _nextCursor = response.nextCursor;
        hasMore.value = response.hasMore;

        // Update per-feed data
        _feedData[currentFeedType.value]?.addAll(response.reels);
        _feedCursors[currentFeedType.value] = response.nextCursor;

        preloadService.setTotalReels(reels.length);
        _computeSponsoredSlots();
      }
    } catch (e) {
      debugPrint('[ReelsFeed] Error loading more: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Switch to a different feed type (tab change).
  void switchFeed(ReelFeedType type) {
    if (type == currentFeedType.value && reels.isNotEmpty) return;

    currentFeedType.value = type;

    // Restore cached feed data if available
    if (_feedData.containsKey(type) && _feedData[type]!.isNotEmpty) {
      reels.assignAll(_feedData[type]!);
      _nextCursor = _feedCursors[type];
      hasMore.value = _nextCursor != null;
      currentIndex.value = 0;
      pageController.jumpToPage(0);
      _initPreload();
      return;
    }

    // Otherwise load fresh
    loadFeed(type);
  }

  /// Refresh the current feed (pull-to-refresh or double-tap tab).
  Future<void> refreshCurrentFeed() async {
    _nextCursor = null;
    hasMore.value = true;
    currentIndex.value = 0;

    // Invalidate cache
    await cacheService.invalidateFeed(_cacheKeyForType(currentFeedType.value));

    // Reload
    await loadFeed(currentFeedType.value);

    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
  }

  /// Called when user swipes to a new reel.
  void onPageChanged(int index) {
    currentIndex.value = index;

    // Trigger preload window update
    preloadService.onIndexChanged(index, reels);

    // Auto-load more when near the end (3 reels from end)
    if (index >= reels.length - 3 && hasMore.value) {
      loadMore();
    }
  }

  void _initPreload() {
    if (reels.isEmpty) return;
    preloadService.setTotalReels(reels.length);
    preloadService.onIndexChanged(currentIndex.value, reels);
  }

  String _cacheKeyForType(ReelFeedType type) {
    switch (type) {
      case ReelFeedType.forYou:
        return ReelConstants.cacheForYou;
      case ReelFeedType.following:
        return ReelConstants.cacheFollowing;
      case ReelFeedType.trending:
        return ReelConstants.cacheTrending;
      default:
        return 'rv2_feed_${type.name}';
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
