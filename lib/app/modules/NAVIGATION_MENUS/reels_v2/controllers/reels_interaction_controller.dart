import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/reel_v2_model.dart';
import '../services/reels_v2_api_service.dart';
import '../utils/reel_enums.dart';
import '../controllers/reels_comment_controller.dart';
import '../widgets/comment/comment_sheet.dart';
import '../widgets/interaction/reel_share_sheet.dart';
import '../widgets/interaction/not_interested_menu.dart';

/// Interaction controller for Reels V2.
/// Manages: like/reaction, bookmark, share, follow, overlay visibility,
/// scrubber overlay, comment sheet, and more menu.
class ReelsInteractionController extends GetxController {
  late final ReelsV2ApiService _apiService;

  // ─── Overlay State ─────────────────────────────────────
  final RxBool isOverlayVisible = true.obs;
  final RxBool isScrubberVisible = false.obs;

  // ─── Like State (local cache of liked reel IDs) ────────
  final RxSet<String> likedReelIds = <String>{}.obs;
  final RxSet<String> bookmarkedReelIds = <String>{}.obs;
  final RxSet<String> followingUserIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ReelsV2ApiService>();
  }

  // ═══════════════════════════════════════════════════════
  // OVERLAY
  // ═══════════════════════════════════════════════════════

  /// Toggle overlay visibility (immersive mode).
  void toggleOverlayVisibility() {
    isOverlayVisible.value = !isOverlayVisible.value;
  }

  /// Show/hide scrubber overlay (long-press state).
  void showScrubberOverlay(bool show) {
    isScrubberVisible.value = show;
  }

  // ═══════════════════════════════════════════════════════
  // LIKE / REACTION
  // ═══════════════════════════════════════════════════════

  bool isReelLiked(String reelId) => likedReelIds.contains(reelId);

  /// Toggle like on a reel. Optimistic update.
  Future<void> likeReel(String reelId, {ReelReactionType type = ReelReactionType.like}) async {
    if (reelId.isEmpty) return;

    if (likedReelIds.contains(reelId)) {
      // Unlike — optimistic remove
      likedReelIds.remove(reelId);
      try {
        await _apiService.removeReaction(reelId);
      } catch (_) {
        // Rollback on failure
        likedReelIds.add(reelId);
      }
    } else {
      // Like — optimistic add
      likedReelIds.add(reelId);
      try {
        await _apiService.addReaction(reelId, type.value);
      } catch (_) {
        // Rollback on failure
        likedReelIds.remove(reelId);
      }
    }
  }

  // ═══════════════════════════════════════════════════════
  // BOOKMARK
  // ═══════════════════════════════════════════════════════

  bool isReelBookmarked(String reelId) => bookmarkedReelIds.contains(reelId);

  /// Toggle bookmark. Optimistic update.
  Future<void> toggleBookmark(String reelId, {String? collectionId}) async {
    if (reelId.isEmpty) return;

    if (bookmarkedReelIds.contains(reelId)) {
      bookmarkedReelIds.remove(reelId);
      try {
        await _apiService.toggleBookmark(reelId, collectionId: collectionId);
      } catch (_) {
        bookmarkedReelIds.add(reelId);
      }
    } else {
      bookmarkedReelIds.add(reelId);
      try {
        await _apiService.toggleBookmark(reelId, collectionId: collectionId);
      } catch (_) {
        bookmarkedReelIds.remove(reelId);
      }
    }
  }

  // ═══════════════════════════════════════════════════════
  // FOLLOW
  // ═══════════════════════════════════════════════════════

  bool isFollowing(String userId) => followingUserIds.contains(userId);

  /// Toggle follow for reel author. Optimistic update.
  Future<void> toggleFollow(String userId, String reelId) async {
    if (userId.isEmpty) return;

    if (followingUserIds.contains(userId)) {
      followingUserIds.remove(userId);
      try {
        await _apiService.followAuthor(reelId);
      } catch (_) {
        followingUserIds.add(userId);
      }
    } else {
      followingUserIds.add(userId);
      try {
        await _apiService.followAuthor(reelId);
      } catch (_) {
        followingUserIds.remove(userId);
      }
    }
  }

  // ═══════════════════════════════════════════════════════
  // NAVIGATION / SHEETS
  // ═══════════════════════════════════════════════════════

  /// Open comment sheet with full Phase 2 implementation.
  void openCommentSheet(String reelId) {
    if (reelId.isEmpty) return;
    final commentController = Get.find<ReelsCommentController>();
    commentController.loadComments(reelId);
    Get.bottomSheet(
      CommentSheet(reelId: reelId),
      isScrollControlled: true,
    );
  }

  /// Open share sheet with full Phase 2 implementation.
  void openShareSheet(ReelV2Model reel) {
    Get.bottomSheet(
      ReelShareSheet(reel: reel),
    );
  }

  /// Show more menu with full Phase 2 implementation.
  void showMoreMenu(ReelV2Model reel) {
    final context = Get.context;
    if (context == null) return;
    NotInterestedMenu.show(context, reel);
  }

  /// Navigate to user profile.
  void navigateToProfile(String userId) {
    if (userId.isEmpty) return;
    Get.toNamed('/profile/$userId');
  }

  /// Hydrate interaction state from reel data (call when feed loads).
  void hydrateFromReels(List<ReelV2Model> reels) {
    for (final reel in reels) {
      if (reel.id == null) continue;
      // API should return user_liked, user_bookmarked, user_following fields
      // These will be populated when backend returns them in feed response
    }
  }
}
