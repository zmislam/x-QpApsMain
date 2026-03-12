import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string.dart';
import 'package:dio/dio.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../repository/page_repository.dart';
import '../../../../repository/report_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/login_creadential.dart';
import '../../../../data/post_local_data.dart';
import '../../../../models/api_response.dart';
import '../../../../models/user.dart';
import '../../../../repository/reels_repository.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/logger/logger.dart';
import '../../../../utils/post_utlis.dart';
import '../../../../utils/snackbar.dart';
import '../../../shared/modules/create_post/models/fileCheckState.dart';
import '../../../shared/modules/create_post/models/imageCheckerModel.dart';
import '../../../shared/modules/create_post/service/imageCheckerService.dart';
import '../../home/controllers/home_controller.dart';
import '../../user_menu/sub_menus/all_pages/pages/model/report_model.dart';
import '../components/reels_comment_component.dart';
import '../model/reels_campaign_model.dart';
import '../model/reels_comment_model.dart';
import '../model/reels_comment_reply_model.dart';
import '../model/reels_model.dart';

class ReelsController extends GetxController {
  final bool? triggerDataFetchOnInit;
  ReelsController({this.triggerDataFetchOnInit});
  final RxString checkingStatus = ''.obs;
  final RxBool isCheckingFiles = false.obs;
  final RxList<String> processedFileData = <String>[].obs;
  final processedCommentFileData = ''.obs;
  RxList<FileCheckingState> fileCheckingStates = <FileCheckingState>[].obs;

  late ApiCommunication _apiCommunication;
  late TextEditingController reelsDescriptionController;

  LoginCredential loginCredential = LoginCredential();
  ReelsRepository reelsRepository = ReelsRepository();
  PageRepository pageRepository = PageRepository();
  ReportRepository reportRepository = ReportRepository();
  late UserModel userModel;
  Rx<String> searchUsername = Rx('');

  RxString dropdownValue = reelsPrivacyList.first.obs;
  RxString reelsPrivacy = 'public'.obs;
  HomeController homeController = Get.find();

  Rx<Color> reactionColor = Colors.white.obs;
  Rx<List<XFile>> xfiles = Rx([]);
  Rx<int> userVisibleCount = 8.obs;

  Rx<List<ReelsModel>> reelsModelList = Rx([]);
  Rx<List<ReelsCampaignResults>> reelsCampaignResultList = Rx([]);
  Rx<List<ReelsCommentModel>> reelsCommentModelList = Rx([]);
  Rx<List<ReelsCommentReplyModel>> reelsCommentReplyModelList = Rx([]);

  RxString reelsCommentID = ''.obs;
  String reelIDFromNotification = '';
  String reelCommentIDFromNotification = '';
  String reelsID = '';
  String username = '';
  RxString reelsCommentReplyID = ''.obs;
  RxString reelsPostID = ''.obs;
  RxBool isReply = false.obs;
  RxBool isReplyOfReply = false.obs;
  RxBool isLoadingUserPages = false.obs;
  // RxBool myLike = false.obs;
  Rx<ReelsCommentModel> reelsCommentModel = ReelsCommentModel().obs;
  Rx<ReelsCommentReplyModel> reelsCommentReplyModel =
      ReelsCommentReplyModel().obs;
  var reelsCommentModl = ReelsCommentModel().obs;
  late TextEditingController reelsCommentController = TextEditingController();
  late TextEditingController reelsCommentReplyController =
      TextEditingController();
  Rx<List<PageReportModel>> pageReportList = Rx([]);
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;
  late TextEditingController reportDescription;

  RxBool isLoading = true.obs;
  RxBool isCommentLoading = true.obs;
  late PageController pageController;
  late PageController reelsTabPageController;
  RxBool isFromTabView = true.obs;
  final specificReels = ''.obs;
  RxBool isLoadingMore = false.obs;

  // ─── Feed Tab State ──────────────────────────────────────────────────────────
  /// 0 = For You, 1 = Following, 2 = Trending
  RxInt activeFeedTab = 0.obs;
  RxString forYouCursor = ''.obs;
  RxString followingCursor = ''.obs;
  RxBool forYouHasMore = true.obs;
  RxBool followingHasMore = true.obs;

  // ─── View Tracking State ─────────────────────────────────────────────────────
  /// Tracks {reelId → startTimestamp} for computing watch duration
  final Map<String, int> _viewStartTimes = {};
  /// Tracks views to batch-send on close: [{reelId, watchTimeMs, completed}]
  final List<Map<String, dynamic>> _pendingViewTracks = [];
  /// ID of the currently visible reel
  String _currentVisibleReelId = '';

  // ─── Video Preloading ────────────────────────────────────────────────────────
  /// Set of reel IDs whose videos have been preloaded / are being preloaded
  final Set<String> _preloadedReelIds = {};

  //==============================Get Reels All User =========================================//

  Future<void> getReels({
    int? length,
    bool? enableLoading,
    String? reelId,
  }) async {
    if (length != null && length > 0) {
      isLoadingMore.value = true;
    }
    ApiResponse response = await reelsRepository.getAllReels(
        limit: 2,
        skip: length ?? reelsModelList.value.length,
        reelId: reelId,
        enableLoading: enableLoading);
    if (response.isSuccessful) {
      reelsModelList.value.addAll((response.data as List<ReelsModel>));
      isLoading.value = false;
      isLoadingMore.value = false; // ← STOP LOADING INDICATOR
      reelsModelList.refresh();
      debugPrint(reelsModelList.value.length.toString());
    } else {
      isLoadingMore.value = false; // ← STOP LOADING INDICATOR ON ERROR
    }
  }

  // ═══════════════════════ Feed Tab Methods ═══════════════════════════════════

  /// Switch between feed tabs: 0=ForYou, 1=Following, 2=Trending
  void switchFeedTab(int tabIndex) {
    if (activeFeedTab.value == tabIndex) return;
    activeFeedTab.value = tabIndex;

    // Reset the page view to top
    if (reelsTabPageController.hasClients) {
      reelsTabPageController.jumpToPage(0);
    }

    // Clear current list and reload for new tab
    reelsModelList.value.clear();
    reelsModelList.refresh();
    _preloadedReelIds.clear();

    fetchReelsForActiveTab();
  }

  /// Fetch reels based on the currently active feed tab
  Future<void> fetchReelsForActiveTab({bool loadMore = false}) async {
    if (!loadMore) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    switch (activeFeedTab.value) {
      case 0:
        await _fetchForYouReels(loadMore: loadMore);
        break;
      case 1:
        await _fetchFollowingReels(loadMore: loadMore);
        break;
      case 2:
        await _fetchTrendingReels();
        break;
      default:
        await _fetchForYouReels(loadMore: loadMore);
    }

    isLoading.value = false;
    isLoadingMore.value = false;
  }

  Future<void> _fetchForYouReels({bool loadMore = false}) async {
    final excludeIds = reelsModelList.value
        .where((r) => r.id != null)
        .map((r) => r.id!)
        .toList();

    ApiResponse response = await reelsRepository.getForYouReels(
      limit: 10,
      cursor: loadMore ? forYouCursor.value : null,
      excludeIds: loadMore ? [] : excludeIds,
    );

    if (response.isSuccessful && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final List<ReelsModel> newReels =
          (data['reels'] as List).cast<ReelsModel>();
      final bool hasMore = data['hasMore'] ?? false;
      final String? nextCursor = data['nextCursor'];

      reelsModelList.value.addAll(newReels);
      reelsModelList.refresh();

      forYouHasMore.value = hasMore;
      if (nextCursor != null) forYouCursor.value = nextCursor;

      // Preload videos for visible + next reels
      _preloadUpcomingVideos(0);
    }
  }

  Future<void> _fetchFollowingReels({bool loadMore = false}) async {
    ApiResponse response = await reelsRepository.getFollowingReels(
      limit: 10,
      cursor: loadMore ? followingCursor.value : null,
    );

    if (response.isSuccessful && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final List<ReelsModel> newReels =
          (data['reels'] as List).cast<ReelsModel>();
      final bool hasMore = data['hasMore'] ?? false;
      final String? nextCursor = data['nextCursor'];

      reelsModelList.value.addAll(newReels);
      reelsModelList.refresh();

      followingHasMore.value = hasMore;
      if (nextCursor != null) followingCursor.value = nextCursor;

      _preloadUpcomingVideos(0);
    }
  }

  Future<void> _fetchTrendingReels() async {
    ApiResponse response = await reelsRepository.getTrendingReels(
      limit: 20,
      timeframe: '7d',
    );

    if (response.isSuccessful && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final List<ReelsModel> newReels =
          (data['reels'] as List).cast<ReelsModel>();

      reelsModelList.value.addAll(newReels);
      reelsModelList.refresh();

      _preloadUpcomingVideos(0);
    }
  }

  /// Check if more data is available for the active tab
  bool get activeTabHasMore {
    switch (activeFeedTab.value) {
      case 0:
        return forYouHasMore.value;
      case 1:
        return followingHasMore.value;
      case 2:
        return false; // Trending loads all at once
      default:
        return false;
    }
  }

  // ═══════════════════════ Enhanced View Tracking ═════════════════════════════

  /// Called when a reel becomes visible (onPageChanged).
  /// Records the start time and fires the new track-view endpoint.
  void onReelViewed(String reelId, int currentIndex) {
    if (reelId.isEmpty) return;

    // End tracking for previous reel
    _endTrackingForReel(_currentVisibleReelId);

    // Start tracking for new reel
    _currentVisibleReelId = reelId;
    _viewStartTimes[reelId] = DateTime.now().millisecondsSinceEpoch;

    // Also fire legacy view (backwards compat)
    reelsViewClick(reelId);

    // Preload upcoming videos
    _preloadUpcomingVideos(currentIndex);
  }

  /// End tracking for a specific reel — computes watch duration and queues it
  void _endTrackingForReel(String reelId) {
    if (reelId.isEmpty) return;
    final startTime = _viewStartTimes.remove(reelId);
    if (startTime == null) return;

    final watchTimeMs = DateTime.now().millisecondsSinceEpoch - startTime;
    _pendingViewTracks.add({
      'reelId': reelId,
      'watchTimeMs': watchTimeMs,
      'completed': watchTimeMs > 10000, // >10s = completed
    });

    // Also fire individual track-view
    reelsRepository.trackReelView(
      reelId: reelId,
      watchTimeMs: watchTimeMs,
      completed: watchTimeMs > 10000,
    );
  }

  /// Flush all pending view tracks to the server in a batch
  Future<void> _flushPendingViewTracks() async {
    if (_pendingViewTracks.isEmpty) return;

    // End tracking for current reel
    _endTrackingForReel(_currentVisibleReelId);
    _currentVisibleReelId = '';

    final views = List<Map<String, dynamic>>.from(_pendingViewTracks);
    _pendingViewTracks.clear();

    if (views.isNotEmpty) {
      await reelsRepository.batchTrackReelViews(views: views);
    }
  }

  // ═══════════════════════ Video Preloading ═══════════════════════════════════

  /// Preload the next 1-2 videos from the current index
  void _preloadUpcomingVideos(int currentIndex) {
    final list = reelsModelList.value;
    for (int offset = 1; offset <= 2; offset++) {
      final nextIndex = currentIndex + offset;
      if (nextIndex < list.length) {
        final reel = list[nextIndex];
        final reelId = reel.id ?? '';
        final videoPath = reel.video ?? '';
        if (reelId.isNotEmpty &&
            videoPath.isNotEmpty &&
            !_preloadedReelIds.contains(reelId)) {
          _preloadedReelIds.add(reelId);
          // Fire-and-forget: preload video into cache
          _preloadVideo(videoPath);
        }
      }
    }
  }

  /// Download video into the default cache (fire-and-forget)
  Future<void> _preloadVideo(String videoPath) async {
    try {
      final url =
          '${ApiConstant.SERVER_IP_PORT}/uploads/reels/$videoPath';
      // Use a lightweight HEAD request to prime the connection;
      // Full download is handled by video_player when the reel becomes visible.
      // This at least resolves DNS and warms the TCP connection.
      final dio = Dio();
      await dio.head(url);
      dio.close();
    } catch (_) {
      // Ignore errors — preloading is best-effort
    }
  }

  //==============================Get Reels All User Individual=========================================//

  Future<void> getIndividualReels() async {
    isLoading.value = true;

    ApiResponse response = await reelsRepository.getAllReelsOfAnIndividual(
        fromCount: reelsModelList.value.length, userName: username);
    if (response.isSuccessful) {
      reelsModelList.value.addAll((response.data as List<ReelsModel>));
      isLoading.value = false;
      reelsModelList.refresh();
      debugPrint(reelsModelList.value.length.toString());
    }
  }

  //==============================Pause and Resume Reels =========================================//
  final RxBool _shouldPauseReels = false.obs;
  RxBool get shouldPauseReels => _shouldPauseReels;
  void pauseAllReels() {
    debugPrint('🛑 Pausing all reels');
    // Notify all reel components to pause
    _shouldPauseReels.value = true;
  }

  void resumeReels() {
    debugPrint('▶️ Resuming reels');
    _shouldPauseReels.value = false;
  }

  //==============================Get Reels Campaign List =========================================//

  Future<void> getReelsCampaignList() async {
    isCommentLoading.value = true;
    ApiResponse response = await reelsRepository.getAllReelCampaigns();

    if (response.isSuccessful) {
      reelsCampaignResultList.value =
          (response.data as List<ReelsCampaignResults>);
      debugPrint(
          ':::::::::::::::::::Reels Campaign Result LIST: ${response.data}');
    } else {
      debugPrint('Error in getReelsCampaignList: ${response.message}');
    }
  }

  //==============================Get Reels By Id =========================================//

  Future<void> getReelsById() async {
    // ! Unused Function ----------------------------> still implemented in repository
    isLoading.value = true;
    ApiResponse response = await reelsRepository.getReelsByID(reelsID: reelsID);
    if (response.isSuccessful) {
      reelsModelList.value.addAll((response.data as List<ReelsModel>));
      isLoading.value = false;
      reelsModelList.refresh();
      // getIndividualReels();
      debugPrint(reelsModelList.value.length.toString());
    }
  }

  //==============================Post Reels Like =========================================//

  void reelsLike(String postId, int index) async {
    ApiResponse apiResponse = await reelsRepository.LikeAReel(postId: postId);
    if (apiResponse.isSuccessful) {
      reelsModelList.value[index] = apiResponse.data as ReelsModel;
      reelsModelList.refresh();
    }
  }

  //=========================== Reels Ads Give Like ================================//
  void reelsAdsLike(String postId, int index, String key) async {
    ApiResponse apiResponse =
        await reelsRepository.LikeAddsOfAReel(postId: postId, key: key);
    if (apiResponse.isSuccessful) {
      getReelsCampaignList();
    }
  }
  //============================== Post Reels Comments =========================================//

  void reelsComments(String postId, String comment, int index, String key) async {
    if (reelsCommentController.text.isNotEmpty ||
        processedCommentFileData.value.isNotEmpty) {
      final String comment = reelsCommentController.text.trim();
      reelsCommentController.clear();
      reelsCommentController.clearComposing();

      ApiResponse apiResponse = await reelsRepository.commentOnAReel(
          postId: postId,
          userId: loginCredential.getUserData().id.toString(),
          media: processedCommentFileData.value,
          comment: comment, key: key);
      if (apiResponse.isSuccessful) {
        reelsModelList.value[index].comment_count =
            (reelsModelList.value[index].comment_count ?? 0) + 1;
        reelsModelList.refresh();
        getReelCommentList(postId);
      }
    } else {
      debugPrint('Failure');
    }
  }

  void reelsAdsComments(String postId, String comment, int index, String key) async {
    ApiResponse apiResponse = await reelsRepository.commentOnAReelsAdd(
        postId: postId,
        userId: loginCredential.getUserData().id.toString(),
        comment: comment, key: key);

    if (apiResponse.isSuccessful) {
      // reelsCampaignResultList.value[index].commentCount =
      //     (reelsCampaignResultList.value[index].commentCount ?? 0) + 1;
      // reelsCampaignResultList.refresh();
      getReelAdsCommentList(postId);
    }
  }
  //==============================Post Reels Comment Reply =========================================//

  void reelsCommentsReply({
    required String comment_id,
    required String replies_user_id,
    required String replies_comment_name,
    required String post_id,
    required String file,
    required String key,
  }) async {
    if (replies_comment_name.isNotEmpty ||
        processedCommentFileData.value.isNotEmpty) {
      final String replyComment = reelsCommentReplyController.text.trim();
      reelsCommentReplyController.clear();
      reelsCommentReplyController.clearComposing();
      xfiles.value.clear();
      xfiles.refresh();
      ApiResponse apiResponse = await reelsRepository.replyToReelComment(
        comment_id: comment_id,
        replies_user_id: replies_user_id,
        replies_comment_name: replyComment,
        post_id: post_id,
        file: file,
        key: key
      );

      debugPrint(
          '=================Reels Comment reply uploader====================$apiResponse');
      if (apiResponse.isSuccessful) {
        debugPrint(
            '=================Reels Comment reply uploader if success====================$apiResponse');

        //  getReels();
        getReelCommentList(post_id);
        //  Get.back();
      }
    }
  }

  void reelsAdsCommentsReply({
    required String comment_id,
    required String replies_user_id,
    required String replies_comment_name,
    required String post_id,
    required String file,
  }) async {
    ApiResponse apiResponse = await reelsRepository.replyToReelsAdComment(
        comment_id: comment_id,
        replies_user_id: replies_user_id,
        replies_comment_name: replies_comment_name,
        post_id: post_id,
        file: file);

    debugPrint(
        '=================Reels Comment reply uploader====================$apiResponse');
    if (apiResponse.isSuccessful) {
      debugPrint(
          '=================Reels Comment reply uploader if success====================$apiResponse');

      //  getReels();
      getReelAdsCommentList(post_id);
      //  Get.back();
    } else {
      debugPrint(
          '=================Reels Comment reply uploader if fail====================$apiResponse');
    }
  }
  //==============================Get Reels Comments List =========================================//

  Future<void> getReelCommentList(String reelsId) async {
    isCommentLoading.value = true;
    ApiResponse response =
        await reelsRepository.getAllCommentsOfAReel(reelsId: reelsId);
    if (response.isSuccessful) {
      reelsCommentModelList.value = (response.data as List<ReelsCommentModel>);
      debugPrint(':::::::::::::::::::COMMENT MODEL LIST: ${response.data}');
    }
  }

  Future<void> getReelAdsCommentList(String reelsAdId) async {
    isCommentLoading.value = true;
    ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'campaign/get-reels-ads-comments/$reelsAdId',
        responseDataKey: 'comments');
    if (response.isSuccessful) {
      reelsCommentModelList.value = (response.data as List<ReelsCommentModel>);
      debugPrint(':::::::::::::::::::COMMENT MODEL LIST: ${response.data}');
    }
  }

  //-------------------------------------- follow-page ----------------------------//

  Future<void> followPage(String pageId) async {
    final ApiResponse response = await pageRepository.followPage(pageId);

    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Page Followed Successfully');
    } else {
      debugPrint('');
    }
  }

  //=================================unfollow==========================//
  Future<void> unfollow(String pageId) async {
    final apiResponse = await pageRepository.unfollowPage(pageId: pageId);

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Unfollowed this pages successfully');
    } else {}
  }

  //--------------------------------------- Report ----------------------------//
  Future<void> getReports() async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await reportRepository.getAllReports();

    if (apiResponse.isSuccessful) {
      pageReportList.value =
          List.from(apiResponse.data as List<PageReportModel>);
    }
    isLoadingUserPages.value = false;
  }

  //============================= Delete Reels ===============================//
  Future deleteReels(String reelId, String key) async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await reelsRepository.deleteReel(reelId: reelId, key: key);

    if (apiResponse.isSuccessful) {
      reelsModelList.value.clear();
      // reelsModelList.refresh();
      Get.back();
      await getReels(length: 0);
      showSuccessSnackkbar(message: 'Reels Deleted Successfully');
    }
    isLoadingUserPages.value = false;
  }
  //==============================Pick Media Files =========================================//

  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();

    if (mediaXFiles.isNotEmpty) {
      await checkFilesForVulgarity(mediaXFiles);
    }
  }

  Future<void> checkFilesForVulgarity(List<XFile> newFiles) async {
    debugPrint('🔥🔥🔥 NEW VERSION OF checkFilesForVulgarity RUNNING 🔥🔥🔥');

    isCheckingFiles.value = true;
    checkingStatus.value = 'Checking files for inappropriate content...';

    // Initialize checking states for all files
    fileCheckingStates.value = newFiles
        .map((file) => FileCheckingState(
              fileName: file.name,
              filePath: file.path,
              isChecking: true,
            ))
        .toList();

    List<String> removedFiles = [];

    for (int i = 0; i < newFiles.length; i++) {
      XFile file = newFiles[i];
      String filePath = file.path.toLowerCase();

      try {
        checkingStatus.value =
            'Checking ${i + 1}/${newFiles.length}: ${file.name}';

        ImageCheckerModel? checkerResponse;

        // Call appropriate checker based on file type
        if (filePath.endsWithAny(['.jpg', '.jpeg', '.png', '.gif', '.webp'])) {
          checkerResponse =
              await ImageCheckerService.checkImageForVulgarity(file);
        } else if (filePath
            .endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])) {
          checkerResponse =
              await ImageCheckerService.checkVideoForVulgarity(file);
        }

        if (checkerResponse != null) {
          debugPrint(
              'API Response for ${file.name}: sexual=${checkerResponse.sexual}, data=${checkerResponse.data}');
          if (checkerResponse.sexual == true) {
            removedFiles.add(file.name);
            fileCheckingStates[i].isChecking = false;
            fileCheckingStates[i].isFailed = true;
            fileCheckingStates.refresh();
            debugPrint('❌ File REJECTED (inappropriate content): ${file.name}');
          }
          else {
            xfiles.value.add(file);
            if (checkerResponse.data != null) {
              processedFileData.value.add(checkerResponse.data!);
              processedCommentFileData.value = checkerResponse.data!;
            }
            fileCheckingStates[i].isChecking = false;
            fileCheckingStates[i].isPassed = true;
            fileCheckingStates.refresh();
            xfiles.refresh();
            processedFileData.refresh();
            processedCommentFileData.refresh();
            debugPrint('✅ File ACCEPTED (appropriate content): ${file.name}');
          }
        } else {
          // API returned null - REJECT for safety
          removedFiles.add(file.name);
          fileCheckingStates[i].isChecking = false;
          fileCheckingStates[i].isFailed = true;
          fileCheckingStates.refresh();
          debugPrint('❌ File REJECTED (API failed): ${file.name}');
        }
      } catch (e) {
        // Error occurred - REJECT for safety
        removedFiles.add(file.name);
        fileCheckingStates[i].isChecking = false;
        fileCheckingStates[i].isFailed = true;
        fileCheckingStates.refresh();
        debugPrint('❌ File REJECTED (error): ${file.name} - $e');
      }

      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (removedFiles.isNotEmpty) {
      showRemovedFilesSnackbar(removedFiles);
    }

    debugPrint('✅ Final accepted files: ${xfiles.value.length}');
    debugPrint('📋 Processed file data: ${processedFileData.value}');
    debugPrint(
        '📋 Processed Comment file data: ${processedCommentFileData.value}');

    // Clear checking states after showing results
    await Future.delayed(const Duration(milliseconds: 800));
    fileCheckingStates.clear();

    isCheckingFiles.value = false;
    checkingStatus.value = '';
  }

  void showRemovedFilesSnackbar(List<String> removedFiles) {
    String message;
    if (removedFiles.length == 1) {
      message =
          '${removedFiles.first} was removed due to inappropriate content';
    } else {
      message =
          '${removedFiles.length} files were removed due to inappropriate content';
    }

    Get.snackbar(
      'Content Removed',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(10),
    );
  }

  void clearProcessedData() {
    processedFileData.clear();
    processedCommentFileData.value = '';
  }
  //==============================Post Reels Comment Delete =========================================//

  void reelsCommentDelete(
      String comment_id, String post_id, int postIndex, String key) async {
    ApiResponse apiResponse = await reelsRepository.deleteACommentFromReel(
        comment_id: comment_id, post_id: post_id, key: key);
    if (apiResponse.isSuccessful) {
      // updatePostList(post_id, postIndex);
      getReelCommentList(post_id);
    }
  }

  void reelsAdsCommentDelete(
      String comment_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await reelsRepository.deleteACommentFromReelAd(
        comment_id: comment_id, post_id: post_id);

    if (apiResponse.isSuccessful) {
      // updatePostList(post_id, postIndex);
      getReelCommentList(post_id);
    }
  }
  //==============================Post Reels Reply Comment Delete =========================================//

  void reelsCommentReplyDelete(
      String reply_id, String post_id, int postIndex, String key) async {
    ApiResponse apiResponse = await reelsRepository
        .deleteAReplyFromAReelComment(reply_id: reply_id, post_id: post_id, key : key);

    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
    }
  }

  void reelsAdsCommentReplyDelete(
      String reply_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await reelsRepository
        .deleteAReplyFromAReelCommentOnAd(reply_id: reply_id, post_id: post_id);

    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
    }
  }
  //==============================Url Launcher =========================================//

  void launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: const BrowserConfiguration(showTitle: true),
      );
    } else {
      throw 'Could not launch $urlString';
    }
  }
  //==============================Post Share Reels =========================================//

  Future<void> shareReelsOnNewsFeed(String reelsId, String key) async {
    ApiResponse apiResponse = await reelsRepository.shareReelsOnNewsFeed(
        reelsId: reelsId,
        reelsDescription: reelsDescriptionController.text.trim(),
        reelsPrivacy: (getReelsPostPrivacyValue(reelsPrivacy.value)), key: key);

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your Reels has been shared');
      homeController.refreshEdgeRankFeed();
    }
  }

  // =============================Call each reels view Coount api=====================================//
  void reelsViewClick(String reelsId) async {
    ApiResponse apiResponse =
        await reelsRepository.notifyServerOnReelView(reelsId: reelsId);

    if (apiResponse.isSuccessful) {
      debugPrint(
          '::::::::::::::::::::::::::::::::Reel Clicked::::::::::::::::::::::::');
    }
  }

  //==============================Get Reels Comment Reactions =========================================//

  void reelsCommentReaction({
    required String? reactionType,
    required String post_id,
    required String comment_id,
    required String userId,
  }) async {
    debugPrint('===================================reaction function  call');

    ApiResponse apiResponse = await reelsRepository.reactOnAReelComment(
        reactionType: reactionType,
        post_id: post_id,
        comment_id: comment_id,
        userId: userId);

    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
      // List<CommentModel> comments = await getSinglePostsComments(post_id);
      // postList.value[postIndex].comments = comments;
      // postList.refresh();
      // List <CommentReactionModel>   commentReactionList = await apiResponse.data
    }
  }
  //============================== Open Bottom Commet sheet =========================================//

  void openCommentComponentOfReels(
      {required String reelID, String? commentId}) {
    getReelCommentList(reelID);

    Get.bottomSheet(Obx(() => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0), // Adjust the radius value as needed
          topRight: Radius.circular(30.0), // Adjust the radius value as needed
        ),
        child: ReelsCommentComponent(
          reelsCommentList: reelsCommentModelList.value,
          reelsModel: ReelsModel(id: reelID),
          onTapViewReactions: () {},
          userModel: loginCredential.getUserData(),
          onTapSendReelsComment: () {},
          reelsCommentController: reelsCommentController,
          onTapReelsReplayComment: (
              {required String commentReplay,
              required String comment_id,
              required String file}) {},
          onSelectReelsCommentReplayReaction: (String reaction,
              String commentId, String commentRepliesId, String userId) {},
          onReelsCommentEdit: (ReelsCommentModel reelsCommentModel) {},
          onReelsCommentDelete: (ReelsCommentModel reelsCommentModel) {},
          onReelsCommentReplayEdit:
              (ReelsCommentReplyModel reelsCommentReplayModel) {},
          onReelsCommentReplayDelete: (String replyId, String postId, String key) {},
          onSelectReelsCommentReaction:
              (String reaction, ReelsCommentModel reelsCommentModel) {},
        ))));
  }

  //==============================Get Reels Reply Comment Reactions =========================================//

  void reelsReplyCommentReaction({
    required String? reactionType,
    required String post_id,
    required String comment_id,
    required String comment_reply_id,
    required String userId,
  }) async {
    debugPrint('===================================reaction function  call');

    ApiResponse apiResponse = await reelsRepository.reactOnAReplayOfReelComment(
        reactionType: reactionType,
        post_id: post_id,
        comment_id: comment_id,
        comment_reply_id: comment_reply_id,
        userId: userId);

    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
      // List<CommentModel> comments = await getSinglePostsComments(post_id);
      // postList.value[postIndex].comments = comments;
      // postList.refresh();
      // List <CommentReactionModel>   commentReactionList = await apiResponse.data
    }
  }

  // In ReelsController
  void updateReelInList(ReelsModel updatedReel) {
    final index =
        reelsModelList.value.indexWhere((reel) => reel.id == updatedReel.id);
    if (index != -1) {
      reelsModelList.value[index] = updatedReel;
      reelsModelList.refresh();
    } else {
      // Fixed: Insert at position 0 instead of using invalid index
      reelsModelList.value.insert(0, updatedReel);
      reelsModelList.refresh();
    }
  }

  Future<void> reInitRequiredData({String? reelId, int? skipLength}) async {
    try {
      isLoading.value = true;

      // Jump to first page
      if (reelsTabPageController.hasClients) {
        reelsTabPageController.jumpToPage(0);
      }

      // Clear old data
      reelsModelList.value.clear();
      reelsCampaignResultList.value.clear();
      reelsModelList.refresh();
      reelsCampaignResultList.refresh();

      // Fetch new data with await
      await fetchAllData(
          enableLoading: true, reelId: reelId, skipLength: skipLength);

      isLoading.value = false;
    } catch (error) {
      debugPrint('ERROR IN REEL PAGE CONTROLLER INIT: $error');
      isLoading.value = false;
    }
  }

  Future<void> getAndUpdateReelListWithSpecificReel({String? reelId}) async {
    if (reelId != null && reelId.isNotEmpty) {
      reelsModelList.value.clear();
      final response = await reelsRepository.getReelsByID(reelsID: reelId);
      reelsModelList.value.insertAll(0, response.data as List<ReelsModel>);
      fetchAllData();
      reelsModelList.refresh();
    }
  }

  Rx<ReelsModel> reelsItem = ReelsModel().obs;
  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reelsViewClick(reelsItem.value.id ?? '');
    });
  }

  @override
  void onInit() async {
    super.onInit();
    _apiCommunication = ApiCommunication();

    // Initialize controllers
    pageController = PageController();
    reelsTabPageController = PageController();
    reelsCommentController = TextEditingController();
    reelsCommentReplyController = TextEditingController();
    reelsDescriptionController = TextEditingController();
    reportDescription = TextEditingController();

    pageController.addListener(_scrollListener);
    reelsTabPageController.addListener(scrollListener2);

    reelsModelList.value.clear();
    reelsCampaignResultList.value.clear();

    // Read navigation arguments and trigger the appropriate fetch.
    // This was previously done synchronously inside ReelsView.build(),
    // which caused "setState() called during build" crashes because
    // fetchAllData / fetchReelsData mutate reactive .obs variables.
    final args = Get.arguments;
    final reelId = args != null ? args['reel_id'] : null;

    if (reelId != null && reelId is String && reelId.isNotEmpty) {
      specificReels.value = reelId;
      Log.d('Reel ID from arguments: $reelId');
      reelsModelList.value.clear();
      fetchReelsData();
    } else {
      fetchAllData();
    }

    debugPrint('Reels Max scroll');
  }

  Future<void> fetchReelsData() async {
    final reelId = specificReels.value;

    // Show loading indicator for specific reel
    isLoading.value = true;

    // Fetch specific reel first
    if (reelId.isNotEmpty) {
      final apiResponse = await reelsRepository.getReelsByID(reelsID: reelId);

      if (apiResponse.isSuccessful) {
        if (apiResponse.data != null && apiResponse.data is List) {
          List<dynamic> rawList = apiResponse.data as List;

          List<ReelsModel> reelsList = rawList.map((e) {
            if (e is ReelsModel) {
              return e;
            } else if (e is Map<String, dynamic>) {
              return ReelsModel.fromMap(e);
            } else {
              throw Exception(
                  'Unexpected data type in API response: ${e.runtimeType}');
            }
          }).toList();

          // Clear and replace the current list with the specific reel
          reelsModelList.value.clear();
          reelsModelList.value.addAll(reelsList);
          reelsModelList.refresh();
        } else {
          Log.e('Error: API response does not contain valid data');
        }
      } else {
        Log.e('Error: ${apiResponse.message}');
      }

      // After specific reel loads, load the other reels in the background
      fetchAllData(
          enableLoading: false); // Background loading for regular reels
    }
  }

// Fetch All Data
  Future<void> fetchAllData(
      {bool? enableLoading, String? reelId, int? skipLength}) async {
    isLoading.value = true;

    if (reelId != null && reelId.isNotEmpty) {
      // Specific reel requested — use legacy endpoint
      await getReels(
        enableLoading: enableLoading,
        reelId: reelId,
      );
    } else {
      // Use the active feed tab endpoint
      await fetchReelsForActiveTab();
    }

    await getReelsCampaignList(); // Merge campaigns after every 5 reels
    isLoading.value = false;
  }

  @override
  void onClose() {
    // Flush pending view tracks before closing
    _flushPendingViewTracks();

    _apiCommunication.endConnection();
    reelsModelList.value.clear();
    reelsTabPageController.removeListener(scrollListener2);
    reelsTabPageController.removeListener(_scrollListener);
    reelsTabPageController.dispose();
    // isFromTabView.value = true;
    specificReels.value = '';
    _preloadedReelIds.clear();
    _viewStartTimes.clear();
    _pendingViewTracks.clear();
    super.onClose();
  }

  Future<void> _scrollListener() async {
    if (pageController.position.pixels ==
        pageController.position.maxScrollExtent) {
      debugPrint('Reels Max scroll extents');
      debugPrint('PageController is running');
      getIndividualReels();
      getReelsCampaignList();
    }
  }

  Future<void> scrollListener2() async {
    debugPrint(
        'IS THIS PAGE CONTROLLER ATTACHED??? ${reelsTabPageController.hasClients}');
    debugPrint(
        'IS THIS PAGE CONTROLLER ATTACHED??? ${reelsTabPageController.positions.length}');

    if (reelsTabPageController.hasClients &&
        reelsTabPageController.position.pixels ==
            reelsTabPageController.position.maxScrollExtent) {
      if (isLoadingMore.value) return;
      if (!activeTabHasMore) return;
      debugPrint('Reels Max scroll extents');
      debugPrint('Tab PageController is running');
      isLoadingMore.value = true;
      await fetchReelsForActiveTab(loadMore: true);
      await getReelsCampaignList();
    }
  }
}
