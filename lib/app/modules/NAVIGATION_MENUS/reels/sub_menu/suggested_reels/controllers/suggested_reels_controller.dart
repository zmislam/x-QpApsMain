import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../data/login_creadential.dart';
import '../../../../../../models/api_response.dart';
import '../../../../../../repository/reels_repository.dart';
import '../../../../../../repository/report_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../../../../user_menu/sub_menus/all_pages/pages/model/report_model.dart';
import '../../../components/reels_comment_component.dart';
import '../../../model/reels_comment_model.dart';
import '../../../model/reels_comment_reply_model.dart';
import '../../../model/reels_model.dart';
import '../../../model/reels_reacted_user_model.dart';

/// Controller for the Suggested Reels Viewer page.
///
/// This is a self-contained controller for viewing a fixed queue of suggested
/// reels opened from the newsfeed suggestion card. It reuses the same
/// repository methods as the main ReelsController but has:
///  - A fixed queue (no infinite scroll)
///  - Its own view tracking + batch flush
///  - Preloading for the next 1-2 videos
class SuggestedReelsController extends GetxController {
  // ─── Dependencies ──────────────────────────────────────────────────────────
  final ReelsRepository reelsRepository = ReelsRepository();
  final ReportRepository reportRepository = ReportRepository();
  final LoginCredential loginCredential = LoginCredential();

  // ─── State ─────────────────────────────────────────────────────────────────
  Rx<List<ReelsModel>> reelsModelList = Rx([]);
  Rx<List<ReelsCommentModel>> reelsCommentModelList = Rx([]);
  RxBool isLoading = true.obs;
  RxBool isCommentLoading = true.obs;

  late PageController pageController;
  late TextEditingController reelsCommentController;
  late TextEditingController reelsCommentReplyController;
  late TextEditingController reportDescription;

  Rx<List<PageReportModel>> pageReportList = Rx([]);
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;
  RxBool isLoadingUserPages = false.obs;

  // The list of reel IDs from the suggestion card
  List<String> queueIds = [];
  // The reel ID the user tapped on (to start at that index)
  String startReelId = '';

  // ─── View Tracking ─────────────────────────────────────────────────────────
  final Map<String, int> _viewStartTimes = {};
  final List<Map<String, dynamic>> _pendingViewTracks = [];
  String _currentVisibleReelId = '';
  final Set<String> _preloadedReelIds = {};

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

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
      queueIds = List<String>.from(args['reelIds'] ?? []);
      startReelId = args['startReelId'] ?? '';
    }

    if (queueIds.isNotEmpty) {
      _fetchSuggestedQueue();
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Flush any pending view tracks
    _flushPendingViewTracks();

    pageController.dispose();
    reelsCommentController.dispose();
    reelsCommentReplyController.dispose();
    reportDescription.dispose();

    _viewStartTimes.clear();
    _pendingViewTracks.clear();
    _preloadedReelIds.clear();

    super.onClose();
  }

  // ─── Data Fetching ─────────────────────────────────────────────────────────

  Future<void> _fetchSuggestedQueue() async {
    isLoading.value = true;

    final ApiResponse response =
        await reelsRepository.getSuggestedQueue(ids: queueIds);

    if (response.isSuccessful && response.data != null) {
      reelsModelList.value = List<ReelsModel>.from(response.data as List);

      // Jump to the startReelId index
      if (startReelId.isNotEmpty) {
        final startIndex =
            reelsModelList.value.indexWhere((r) => r.id == startReelId);
        if (startIndex > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (pageController.hasClients) {
              pageController.jumpToPage(startIndex);
            }
          });
        }
      }
    }

    isLoading.value = false;
  }

  // ─── View Tracking ─────────────────────────────────────────────────────────

  void onReelViewed(String reelId, int currentIndex) {
    // End tracking for the previous reel
    if (_currentVisibleReelId.isNotEmpty &&
        _currentVisibleReelId != reelId) {
      _endTrackingForReel(_currentVisibleReelId);
    }

    _currentVisibleReelId = reelId;
    _viewStartTimes[reelId] = DateTime.now().millisecondsSinceEpoch;

    // Legacy view click call
    reelsViewClick(reelId);

    // Preload upcoming videos
    _preloadUpcomingVideos(currentIndex);
  }

  void _endTrackingForReel(String reelId) {
    final startTime = _viewStartTimes.remove(reelId);
    if (startTime == null) return;

    final watchTimeMs =
        DateTime.now().millisecondsSinceEpoch - startTime;

    // Track individual view
    reelsRepository.trackReelView(
      reelId: reelId,
      watchTimeMs: watchTimeMs,
      completed: false,
    );

    // Queue for batch
    _pendingViewTracks.add({
      'reelId': reelId,
      'watchTimeMs': watchTimeMs,
      'completed': false,
    });
  }

  Future<void> _flushPendingViewTracks() async {
    // End tracking for current reel if any
    if (_currentVisibleReelId.isNotEmpty) {
      _endTrackingForReel(_currentVisibleReelId);
      _currentVisibleReelId = '';
    }

    if (_pendingViewTracks.isEmpty) return;

    try {
      await reelsRepository.batchTrackReelViews(
        views: List.from(_pendingViewTracks),
      );
    } catch (e) {
      debugPrint('Failed to flush view tracks: $e');
    }
    _pendingViewTracks.clear();
  }

  // ─── Preloading ────────────────────────────────────────────────────────────

  void _preloadUpcomingVideos(int currentIndex) {
    final list = reelsModelList.value;
    // Preload next 1-2 videos
    for (int offset = 1; offset <= 2; offset++) {
      final idx = currentIndex + offset;
      if (idx < list.length) {
        final reel = list[idx];
        final videoPath = reel.video;
        if (videoPath != null &&
            videoPath.isNotEmpty &&
            !_preloadedReelIds.contains(reel.id)) {
          _preloadedReelIds.add(reel.id ?? '');
          _preloadVideo(videoPath);
        }
      }
    }
  }

  Future<void> _preloadVideo(String videoPath) async {
    try {
      final url = '${ApiConstant.SERVER_IP_PORT}/uploads/reels/$videoPath';
      await Dio().head(url);
    } catch (_) {}
  }

  // ─── Legacy View Click ─────────────────────────────────────────────────────

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
      postId: postId, reactionType: reactionType);
    if (apiResponse.isSuccessful) {
      reelsModelList.value[index] = apiResponse.data as ReelsModel;
      reelsModelList.refresh();
    }
  }

  // ─── Comments ──────────────────────────────────────────────────────────────

  void reelsComments(
      String postId, String comment, int index, String key) async {
    if (reelsCommentController.text.isNotEmpty) {
      final String commentText = reelsCommentController.text.trim();
      reelsCommentController.clear();
      reelsCommentController.clearComposing();

      ApiResponse apiResponse = await reelsRepository.commentOnAReel(
        postId: postId,
        userId: loginCredential.getUserData().id.toString(),
        media: '',
        comment: commentText,
        key: key,
      );
      if (apiResponse.isSuccessful) {
        reelsModelList.value[index].comment_count =
            (reelsModelList.value[index].comment_count ?? 0) + 1;
        reelsModelList.refresh();
        getReelCommentList(postId);
      }
    }
  }

  void reelsCommentsReply({
    required String comment_id,
    required String replies_user_id,
    required String replies_comment_name,
    required String post_id,
    required String file,
    required String key,
  }) async {
    if (replies_comment_name.isNotEmpty) {
      final String replyComment = reelsCommentReplyController.text.trim();
      reelsCommentReplyController.clear();
      reelsCommentReplyController.clearComposing();

      ApiResponse apiResponse = await reelsRepository.replyToReelComment(
        comment_id: comment_id,
        replies_user_id: replies_user_id,
        replies_comment_name: replyComment,
        post_id: post_id,
        file: file,
        key: key,
      );
      if (apiResponse.isSuccessful) {
        getReelCommentList(post_id);
      }
    }
  }

  Future<void> getReelCommentList(String reelsId) async {
    isCommentLoading.value = true;
    ApiResponse response =
        await reelsRepository.getAllCommentsOfAReel(reelsId: reelsId);
    if (response.isSuccessful) {
      reelsCommentModelList.value = (response.data as List<ReelsCommentModel>);
    }
  }

  void reelsCommentDelete(
      String commentId, String postId, int postIndex, String key) async {
    ApiResponse apiResponse = await reelsRepository.deleteACommentFromReel(
        comment_id: commentId, post_id: postId, key: key);
    if (apiResponse.isSuccessful) {
      getReelCommentList(postId);
    }
  }

  void reelsCommentReplyDelete(
      String replyId, String postId, int postIndex, String key) async {
    ApiResponse apiResponse = await reelsRepository
        .deleteAReplyFromAReelComment(reply_id: replyId, post_id: postId, key: key);
    if (apiResponse.isSuccessful) {
      getReelCommentList(postId);
    }
  }

  void reelsCommentReaction({
    required String? reactionType,
    required String post_id,
    required String comment_id,
    required String userId,
  }) async {
    ApiResponse apiResponse = await reelsRepository.reactOnAReelComment(
        reactionType: reactionType,
        post_id: post_id,
        comment_id: comment_id,
        userId: userId);
    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
    }
  }

  void reelsReplyCommentReaction({
    required String? reactionType,
    required String post_id,
    required String comment_id,
    required String comment_reply_id,
    required String userId,
  }) async {
    ApiResponse apiResponse = await reelsRepository.reactOnAReplayOfReelComment(
        reactionType: reactionType,
        post_id: post_id,
        comment_id: comment_id,
        comment_reply_id: comment_reply_id,
        userId: userId);
    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
    }
  }

  // ─── Delete ────────────────────────────────────────────────────────────────

  Future<void> deleteReels(String reelId, String key) async {
    ApiResponse apiResponse =
        await reelsRepository.deleteReel(reelId: reelId, key: key);
    if (apiResponse.isSuccessful) {
      reelsModelList.value.removeWhere((r) => r.id == reelId);
      reelsModelList.refresh();
      if (reelsModelList.value.isEmpty) {
        Get.back();
      }
      showSuccessSnackkbar(message: 'Reel deleted successfully');
    }
  }

  // ─── Reports ───────────────────────────────────────────────────────────────

  Future<void> getReports() async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await reportRepository.getAllReports();
    if (apiResponse.isSuccessful) {
      pageReportList.value =
          List.from(apiResponse.data as List<PageReportModel>);
    }
    isLoadingUserPages.value = false;
  }
}
