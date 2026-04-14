import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/reels_v2_api_service.dart';
import '../services/reels_v2_cache_service.dart';
import '../services/reels_v2_preload_service.dart';
import '../utils/reel_enums.dart';
import 'reels_feed_controller.dart';
import 'reel_player_controller.dart';

/// Main orchestrating controller for Reels V2.
/// Manages page state, tab switching, and coordinates sub-controllers.
class ReelsV2MainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ─── Dependencies ──────────────────────────────────────
  late final ReelsV2ApiService apiService;
  late final ReelsV2CacheService cacheService;
  late final ReelsV2PreloadService preloadService;
  late final ReelsFeedController feedController;
  late final ReelPlayerController playerController;

  // ─── Tab Controller (For You / Following / Trending) ───
  late TabController tabController;
  final RxInt currentTabIndex = 0.obs;
  final List<ReelFeedType> feedTabs = [
    ReelFeedType.forYou,
    ReelFeedType.following,
    ReelFeedType.trending,
  ];

  // ─── Page State ────────────────────────────────────────
  final RxBool isInitialized = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Resolve dependencies
    apiService = Get.find<ReelsV2ApiService>();
    cacheService = Get.find<ReelsV2CacheService>();
    preloadService = Get.find<ReelsV2PreloadService>();
    feedController = Get.find<ReelsFeedController>();
    playerController = Get.find<ReelPlayerController>();

    // Setup tab controller
    tabController = TabController(length: feedTabs.length, vsync: this);
    tabController.addListener(_onTabChanged);

    // Load initial feed
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await feedController.loadFeed(feedTabs[currentTabIndex.value]);
      isInitialized.value = true;
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void _onTabChanged() {
    if (tabController.indexIsChanging) return;
    final newIndex = tabController.index;
    if (newIndex == currentTabIndex.value) return;

    currentTabIndex.value = newIndex;
    preloadService.pauseAll();
    feedController.switchFeed(feedTabs[newIndex]);
  }

  /// Called when a tab is tapped directly.
  void onTabTapped(int index) {
    if (index == currentTabIndex.value) {
      // Double-tap: scroll to top and refresh
      feedController.refreshCurrentFeed();
      return;
    }
    tabController.animateTo(index);
  }

  /// Refresh the current feed.
  Future<void> refreshFeed() async {
    await feedController.refreshCurrentFeed();
  }

  /// Pause all V2 reel playback (called when navigating away from V2 tab).
  void pauseAllReels() {
    try {
      preloadService.pauseAll();
      playerController.pauseCurrent();
    } catch (e) {
      debugPrint('Error pausing V2 reels: $e');
    }
  }

  /// Resume V2 reel playback (called when entering V2 tab).
  void resumeReels() {
    try {
      playerController.resumeCurrent();
    } catch (e) {
      debugPrint('Error resuming V2 reels: $e');
    }
  }

  @override
  void onClose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    preloadService.disposeAll();
    super.onClose();
  }
}
