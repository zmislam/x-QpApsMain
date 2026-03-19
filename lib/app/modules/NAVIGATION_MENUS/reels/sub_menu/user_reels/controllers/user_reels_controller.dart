import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../data/login_creadential.dart';
import '../../../../../../models/api_response.dart';
import '../../../../../../repository/reels_repository.dart';
import '../../../../../../repository/report_repository.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../user_menu/sub_menus/all_pages/pages/model/report_model.dart';
import '../../../model/reels_comment_model.dart';
import '../../../model/reels_model.dart';

/// Controller for viewing all reels from a specific user/creator.
///
/// Opens from the eye icon on a reel, shows list of creator's reels,
/// and allows viewing them in a full-screen swipeable viewer.
class UserReelsController extends GetxController {
  // ─── Dependencies ──────────────────────────────────────────────────────────
  final ReelsRepository reelsRepository = ReelsRepository();
  final ReportRepository reportRepository = ReportRepository();
  final LoginCredential loginCredential = LoginCredential();

  // ─── State ─────────────────────────────────────────────────────────────────
  Rx<List<ReelsModel>> reelsModelList = Rx([]);
  Rx<List<ReelsCommentModel>> reelsCommentModelList = Rx([]);
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isCommentLoading = true.obs;
  RxBool isViewerMode = false.obs;

  late PageController pageController;
  late TextEditingController reelsCommentController;
  late TextEditingController reelsCommentReplyController;
  late TextEditingController reportDescription;

  Rx<List<PageReportModel>> pageReportList = Rx([]);
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;

  // The user ID whose reels we're viewing
  String userId = '';
  String username = '';
  String userFullName = '';
  String userProfilePic = '';

  /// Type of reels: 'original' (user's own) or 'repost' (user's reposted)
  String reelType = 'original';

  // Pagination
  int _skip = 0;
  final int _limit = 20;
  bool _hasMore = true;

  // Track current page index for end-of-queue detection
  int currentPageIndex = 0;

  /// Whether we already triggered the transition to regular reels
  bool _hasTransitioned = false;

  /// Whether the user is currently viewing the end card
  RxBool isOnEndCard = false.obs;

  /// Auto-forward countdown seconds
  RxInt autoForwardCountdown = 3.obs;

  /// Timer for auto-forward countdown
  Timer? _autoForwardTimer;

  /// Called when user lands on the end card page
  void onEndCardViewed() {
    if (_hasTransitioned) return;
    isOnEndCard.value = true;
    autoForwardCountdown.value = 3;
    _startAutoForwardTimer();
  }

  /// Start the auto-forward countdown timer
  void _startAutoForwardTimer() {
    _cancelAutoForwardTimer();
    _autoForwardTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_hasTransitioned) {
        timer.cancel();
        return;
      }
      if (autoForwardCountdown.value > 1) {
        autoForwardCountdown.value--;
      } else {
        timer.cancel();
        _triggerTransition();
      }
    });
  }

  /// Cancel auto-forward timer
  void _cancelAutoForwardTimer() {
    _autoForwardTimer?.cancel();
    _autoForwardTimer = null;
  }

  /// Reset end card state when navigating away from it
  void onLeftEndCard() {
    isOnEndCard.value = false;
    _cancelAutoForwardTimer();
  }

  /// Manually trigger transition to main reels
  void continueToReels() {
    _triggerTransition();
  }

  void _triggerTransition() {
    if (_hasTransitioned) return;
    _hasTransitioned = true;
    _cancelAutoForwardTimer();
    Get.back();
    Get.toNamed(Routes.REELS);
  }

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  // Start index when opening from profile (to start at a specific reel)
  int _startAtIndex = -1;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    reelsCommentController = TextEditingController();
    reelsCommentReplyController = TextEditingController();
    reportDescription = TextEditingController();

    // Read arguments passed via Get.arguments
    final args = Get.arguments;
    if (args != null) {
      userId = args['userId'] ?? '';
      username = args['username'] ?? '';
      userFullName = args['userFullName'] ?? '';
      userProfilePic = args['userProfilePic'] ?? '';
      _startAtIndex = args['startIndex'] ?? -1;
      reelType = args['reelType'] ?? 'original';
    }

    if (username.isNotEmpty) {
      _fetchUserReels();
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _cancelAutoForwardTimer();
    pageController.dispose();
    reelsCommentController.dispose();
    reelsCommentReplyController.dispose();
    reportDescription.dispose();
    super.onClose();
  }

  // ─── Data Fetching ─────────────────────────────────────────────────────────

  Future<void> _fetchUserReels() async {
    isLoading.value = true;
    _skip = 0;
    _hasMore = true;

    // Fetch either original, repost, or saved reels based on reelType
    final ApiResponse response;
    if (reelType == 'repost') {
      response = await reelsRepository.getUserRepostReels(
        username: username,
        limit: _limit,
        skip: _skip,
      );
    } else if (reelType == 'saved') {
      response = await reelsRepository.getMyBookmarkedReels(
        limit: _limit,
        skip: _skip,
      );
    } else {
      response = await reelsRepository.getUserReels(
        username: username,
        userId: userId,
        limit: _limit,
        skip: _skip,
      );
    }

    if (response.isSuccessful && response.data != null) {
      reelsModelList.value = List<ReelsModel>.from(response.data as List);
      _skip = reelsModelList.value.length;
      _hasMore = reelsModelList.value.length >= _limit;

      // If started with a specific index, enter viewer mode
      if (_startAtIndex >= 0 && _startAtIndex < reelsModelList.value.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          enterViewerMode(_startAtIndex);
        });
        _startAtIndex = -1; // Reset so it doesn't re-trigger
      }
    }

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !_hasMore) return;
    isLoadingMore.value = true;

    // Fetch either original, repost, or saved reels based on reelType
    final ApiResponse response;
    if (reelType == 'repost') {
      response = await reelsRepository.getUserRepostReels(
        username: username,
        limit: _limit,
        skip: _skip,
      );
    } else if (reelType == 'saved') {
      response = await reelsRepository.getMyBookmarkedReels(
        limit: _limit,
        skip: _skip,
      );
    } else {
      response = await reelsRepository.getUserReels(
        username: username,
        userId: userId,
        limit: _limit,
        skip: _skip,
      );
    }

    if (response.isSuccessful && response.data != null) {
      final newReels = response.data as List<ReelsModel>;
      reelsModelList.value = [...reelsModelList.value, ...newReels];
      _skip += newReels.length;
      _hasMore = newReels.length >= _limit;
    }

    isLoadingMore.value = false;
  }

  @override
  Future<void> refresh() async {
    await _fetchUserReels();
  }

  // ─── Viewer Mode ───────────────────────────────────────────────────────────

  void enterViewerMode(int startIndex) {
    isViewerMode.value = true;
    currentPageIndex = startIndex;
    _hasTransitioned = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.jumpToPage(startIndex);
      }
    });
  }

  void exitViewerMode() {
    isViewerMode.value = false;
    _cancelAutoForwardTimer();
    isOnEndCard.value = false;
  }

  // ─── View Tracking ─────────────────────────────────────────────────────────

  void onReelViewed(String reelId, int currentIndex) {
    reelsViewClick(reelId);
  }

  void reelsViewClick(String reelsId) async {
    await reelsRepository.notifyServerOnReelView(reelsId: reelsId);
  }

  // ─── Like ──────────────────────────────────────────────────────────────────

  void reelsLike(String postId, int index) async {
    ApiResponse apiResponse = await reelsRepository.LikeAReel(postId: postId);
    if (apiResponse.isSuccessful) {
      reelsModelList.value[index] = apiResponse.data as ReelsModel;
      reelsModelList.refresh();
    }
  }

  // ─── Reaction with Type ────────────────────────────────────────────────────

  void reelsReaction(String postId, int index, String reactionType) async {
    ApiResponse apiResponse = await reelsRepository.reactOnAReel(
      postId: postId,
      reactionType: reactionType,
    );
    if (apiResponse.isSuccessful) {
      reelsModelList.value[index] = apiResponse.data as ReelsModel;
      reelsModelList.refresh();
    }
  }

  // ─── Comments ──────────────────────────────────────────────────────────────

  void getReelCommentList(String postId) async {
    isCommentLoading.value = true;
    final apiResponse = await reelsRepository.getAllCommentsOfAReel(reelsId: postId);
    if (apiResponse.isSuccessful && apiResponse.data != null) {
      reelsCommentModelList.value = List<ReelsCommentModel>.from(apiResponse.data as List);
    }
    isCommentLoading.value = false;
  }

  void reelsComments(String postId, String comment, int index, String key) async {
    final userId = loginCredential.getUserData().id ?? '';
    ApiResponse apiResponse = await reelsRepository.commentOnAReel(
      postId: postId,
      userId: userId,
      media: '',
      comment: comment,
      key: key,
    );
    if (apiResponse.isSuccessful) {
      getReelCommentList(postId);
      
      // Update comment count
      final current = reelsModelList.value[index];
      final updatedCount = (current.comment_count ?? 0) + 1;
      final updatedModel = current.copyWith(comment_count: updatedCount);
      final updatedList = List<ReelsModel>.from(reelsModelList.value);
      updatedList[index] = updatedModel;
      reelsModelList.value = updatedList;
    }
  }

  void reelsCommentsReply({
    required String comment_id,
    required String replies_comment_name,
    required String post_id,
    required String replies_user_id,
    required String? file,
    required String key,
  }) async {
    ApiResponse apiResponse = await reelsRepository.replyToReelComment(
      comment_id: comment_id,
      replies_comment_name: replies_comment_name,
      post_id: post_id,
      replies_user_id: replies_user_id,
      file: file ?? '',
      key: key,
    );
    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
    }
  }

  void reelsCommentReaction({
    required String reactionType,
    required String post_id,
    required String comment_id,
    required String userId,
  }) async {
    await reelsRepository.reactOnAReelComment(
      reactionType: reactionType,
      post_id: post_id,
      comment_id: comment_id,
      userId: userId,
    );
    getReelCommentList(post_id);
  }

  void reelsReplyCommentReaction({
    required String reactionType,
    required String post_id,
    required String comment_id,
    required String comment_reply_id,
    required String userId,
  }) async {
    await reelsRepository.reactOnAReplayOfReelComment(
      reactionType: reactionType,
      post_id: post_id,
      comment_id: comment_id,
      comment_reply_id: comment_reply_id,
      userId: userId,
    );
    getReelCommentList(post_id);
  }

  void reelsCommentDelete(String commentId, String postId, int index, String key) async {
    ApiResponse apiResponse = await reelsRepository.deleteACommentFromReel(
      comment_id: commentId,
      post_id: postId,
      key: key,
    );
    if (apiResponse.isSuccessful) {
      reelsCommentModelList.value.removeWhere((c) => c.id == commentId);
      reelsCommentModelList.refresh();
      
      // Update comment count
      final current = reelsModelList.value[index];
      final updatedCount = (current.comment_count ?? 1) - 1;
      final updatedModel = current.copyWith(comment_count: updatedCount < 0 ? 0 : updatedCount);
      final updatedList = List<ReelsModel>.from(reelsModelList.value);
      updatedList[index] = updatedModel;
      reelsModelList.value = updatedList;
    }
  }

  void reelsCommentReplyDelete(String replyId, String commentId, String postId, String key) async {
    ApiResponse apiResponse = await reelsRepository.deleteAReplyFromAReelComment(
      reply_id: replyId,
      post_id: postId,
      key: key,
    );
    if (apiResponse.isSuccessful) {
      getReelCommentList(postId);
    }
  }

  // ─── Delete Reel ───────────────────────────────────────────────────────────

  void deleteReels(String reelId, String key) async {
    ApiResponse apiResponse = await reelsRepository.deleteReel(
      reelId: reelId,
      key: key,
    );
    if (apiResponse.isSuccessful) {
      reelsModelList.value.removeWhere((r) => r.id == reelId);
      reelsModelList.refresh();
      if (isViewerMode.value && reelsModelList.value.isEmpty) {
        Get.back();
      }
    }
  }

  // ─── Reports ───────────────────────────────────────────────────────────────

  Future<void> getReports() async {
    final apiResponse = await reportRepository.getAllReports();
    if (apiResponse.isSuccessful && apiResponse.data != null) {
      pageReportList.value = (apiResponse.data as List).cast<PageReportModel>();
    }
  }
}
