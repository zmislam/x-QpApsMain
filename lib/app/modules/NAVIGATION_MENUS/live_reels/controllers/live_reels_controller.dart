import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';

import '../../../../components/animated_reaction/animated_reaction_widget.dart';
import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../data/post_local_data.dart';
import '../../../../models/api_response.dart';
import '../../../../models/comment_model.dart';
import '../../../../models/live/live_stream_reaction_model.dart';
import '../../../../models/live/live_stream_view_model.dart';
import '../../../../models/user.dart';
import '../../../../services/api_communication.dart';
import '../../../../services/socket_service.dart';
import '../../../../utils/snackbar.dart';
import '../../home/controllers/home_controller.dart';
import '../../reels/model/reels_campaign_model.dart';
import '../../reels/model/reels_comment_model.dart';
import '../../reels/model/reels_comment_reply_model.dart';
import '../../reels/model/reels_model.dart';
import '../../user_menu/sub_menus/all_pages/pages/model/report_model.dart';

class LiveReelsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late TextEditingController reelsDescriptionController;

  LoginCredential loginCredential = LoginCredential();
  late UserModel userModel;
  Rx<String> searchUsername = Rx('');
  late final TextEditingController commentController;
  late final FocusNode commentFocusNode;
  RxString dropdownValue = reelsPrivacyList.first.obs;
  RxString reelsPrivacy = 'public'.obs;
  HomeController homeController = Get.find();

  Rx<Color> reactionColor = Colors.white.obs;
  Rx<List<XFile>> xfiles = Rx([]);
  Rx<int> userVisibleCount = 8.obs;
  Rx<int> reactionCount = 0.obs;
  Rx<List<ReelsModel>> reelsModelList = Rx([]);
  Rx<List<ReelsCampaignResults>> reelsCampaignResultList = Rx([]);
  Rx<List<ReelsCommentModel>> reelsCommentModelList = Rx([]);
  Rx<List<ReelsCommentReplyModel>> reelsCommentReplyModelList = Rx([]);

//live variables
  // ============================ Socket Variables =============================
  late SocketService socketService;
  Rx<List<CommentModel>> liveCommentList = Rx([]);

  RxString reelsCommentID = ''.obs;
  String reelsID = '';
  int reelIndex = 0;
  String username = '';
  RxString reelsCommentReplyID = ''.obs;
  RxString reelsPostID = ''.obs;
  RxBool isReply = false.obs;
  RxBool isLoadingUserPages = false.obs;
  // RxBool myLike = false.obs;

  var reelsCommentModl = ReelsCommentModel().obs;
  late TextEditingController reelsCommentController = TextEditingController();
  late TextEditingController reelsCommentReplyController = TextEditingController();
  Rx<List<PageReportModel>> pageReportList = Rx([]);
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;
  late TextEditingController reportDescription;

  RxBool isLoading = true.obs;
  RxBool isCommentLoading = true.obs;
  late PageController pageController;
  late PageController liveReelsTabPageController;
  RxBool isFromTabView = true.obs;
  late final ScrollController scrollController;
  Rx<bool> isLiveEnd = false.obs;

  Rx<bool> isFollow = false.obs;

  // ========================= follow user in live stream ======================
  void followUserInLiveStream({required String userId}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(apiEndPoint: 'follower-unfollow-request', requestData: {
      'follower_user_id': userId,
      'follow_unfollow_status': 1,
    });

    if (apiResponse.isSuccessful) {
      isFollow.value = true;
    } else {
      isFollow.value = false;
    }
  }

  // ============================ update value according to post model =========
  void updateReelsModelValue({required int countReaction, required int countLiveStreamViewer, required bool isFollowing}) {
    reactionCount.value = countReaction;
    liveStreamViewerCount.value = countLiveStreamViewer;
    isFollow.value = isFollowing;
  }

  // ============================= set live count ==============================

  //============================== Get Reels All User =========================================//

  Future<void> getLiveReels() async {
    ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'stream/get-live-list-reels?limit=2&skip=${reelsModelList.value.length}',
      responseDataKey: 'data',
    );

    if (response.isSuccessful) {
      // ADD THESE DEBUG PRINTS
      debugPrint('📦 RAW API RESPONSE:');
      for (var item in (response.data as List)) {
        debugPrint('  Reel ID: ${item['_id']}');
        debugPrint('  URL field: ${item['url']}');
        debugPrint('  Video field: ${item['video']}');
        debugPrint('  Stream URL: ${item['stream_url']}'); // Try different field names
        debugPrint('---');
      }

      reelsModelList.value.addAll(
          (response.data as List).map((e) => ReelsModel.fromMap(e)).toList()
      );

      // PRINT WHAT WE ACTUALLY STORED
      debugPrint('📋 STORED REELS:');
      for (var reel in reelsModelList.value) {
        debugPrint('  Reel ID: ${reel.id}');
        debugPrint('  URL: ${reel.url}');
      }

      isLoading.value = false;
      reelsModelList.refresh();
    }
  }

  //============================== Get comments for each Reel when at view =========================================//

  Future<void> getAllCommentsByReel({required String reelId}) async {
    isLoading.value = true;

    ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'stream/get-live-reels-comments/$reelId',
    );

    if (response.isSuccessful) {
      List<ReelsCommentModel> comments = (response.data as List).map((e) => ReelsCommentModel.fromMap(e)).toList();

      reelsModelList.value[reelIndex] = reelsModelList.value[reelIndex].copyWith(comments: comments);

      isLoading.value = false;
      reelsModelList.refresh(); // Ensure GetX detects the update
    }
  }

  //==============================Get Reels Campaign List =========================================//

  Future<void> getReelsCampaignList() async {
    isCommentLoading.value = true;
    ApiResponse response = await _apiCommunication.doGetRequest(apiEndPoint: 'campaign/get-reels-ads', responseDataKey: 'results');
    if (response.isSuccessful) {
      reelsCampaignResultList.value = (response.data as List).map((e) => ReelsCampaignResults.fromMap(e)).toList();
      debugPrint(':::::::::::::::::::Reels Campaign Result LIST: ${response.data}');
    } else {
      debugPrint('Error in getReelsCampaignList: ${response.message}');
    }
  }

// ============================= post react ==================================
  Future<void> reactOnPost({
    required String reelsId,
    required String reaction,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'stream/save-stream-post-reaction',
      requestData: {
        'reaction_type': reaction,
        // 'user_id': postModel.user_id?.id,
        'reels_id': reelsId,
        'post_single_item_id': null,
      },
    );

    if (apiResponse.isSuccessful) {
      debugPrint('success: ${apiResponse.message}');
      _addReaction(reaction);
    } else {
      debugPrint('error: ${apiResponse.message}');
    }
  }

  // ========================== animated reaction ==============================

  final Rx<List<ReactionWidget>> reactions = Rx([]);
  void _addReaction(String reaction) {
    reactions.value.add(
      ReactionWidget(
        key: UniqueKey(),
        onComplete: () {
          reactions.value.removeWhere((reaction) => reaction.key == reaction.key);
        },
        selectedReaction: reaction,
      ),
    );
    reactions.refresh();
  }

  Rx<int> liveStreamViewerCount = 0.obs;

  // ============================= Viewer listener =============================
  Rx<LiveStreamViewModel?> liveStreamViewer = Rx(null);
  void addViewerListener() {
    socketService.viewerListenReelsStreamController.stream.listen((data) {
      liveStreamViewer.value = data;
      liveStreamViewerCount.value = (data.viewers?.length ?? 0);
    });
  }

  // ============================= stop live stream listener ===================
  void _stopLiveStreamListener() {
    socketService.stopListenStreamController.stream.listen((bool value) {
      isLiveEnd.value = value;
    });
  }

  // ============================= reaction listener ===========================
  void streamReactionListener() {
    socketService.streamReactionStreamController.stream.listen((LiveStreamReactionModel streamReactionModel) {
      _addReaction(streamReactionModel.reaction_type ?? 'like');

      if (streamReactionModel.post_id == streamReactionModel.reels_id) {
        reactionCount.value++;
      }

      reactionCount.value++;
    });
  }

  // ============================= comment listener ============================
  void _addCommentListener() {
    socketService.reelsCommentListenStreamController.stream.listen((ReelsCommentModel commentModel) {
      // Adding if condition for stopping comments of one stream to be visible on all Live stream : BY RAYHAN

      debugPrint('COMMENT INFO: ${commentModel.post_id}');
      debugPrint('COMMENT INFO ACTIVE REEL: $reelsID');

      if (reelsID.compareTo(commentModel.post_id.toString()) == 0) {
        reelsModelList.value.elementAt(reelIndex).comments?.add(commentModel);

        reelsModelList.refresh();
        update();
      }
    });
  }

  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;
      await getLiveReels();
      await getReelsCampaignList();
    } catch (e) {
      debugPrint('Error fetching live reels data: $e');
    } finally {
      isLoading.value = false;
    }
  }


  // ============================== send live stream comment ===================
  void sendLiveStreamComment({String? reelsId}) async {
    Map<String, dynamic> requestData = {
      'reels_id': reelsId,
      'comment_name': commentController.text.trim(),
    };

    if (commentController.text.trim().isNotEmpty) {
      ApiResponse response = await _apiCommunication.doPostRequest(apiEndPoint: 'stream/save-user-comment-in-stream', requestData: requestData);

      if (response.isSuccessful) {
        commentController.clear();
        // Get.back();
        //await getAllLiveComments();
      } else {
        commentController.clear();
        // Get.back();
        showErrorSnackkbar(message: 'Please Try Again');
      }
    } else {}
  }

  // ============================= Screen Fix ===============================

  void hideAllOverlay() {
    // Set system UI to be fully immersive and stay that way
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [], // Keep all overlays hidden
    );
  }

  void showAllOverlay() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  // ============================= Init functions ===============================

  @override
  void onInit() async {
    hideAllOverlay();
    _apiCommunication = ApiCommunication();
    socketService = Get.find<SocketService>();
    commentController = TextEditingController();
    commentFocusNode = FocusNode();
    userModel = loginCredential.getUserData();
    scrollController = ScrollController();
    pageController = PageController();

    // Initialize listeners
    addViewerListener();
    _addCommentListener();
    streamReactionListener();
    _stopLiveStreamListener();

    liveReelsTabPageController = PageController();
    reelsCommentController = TextEditingController();
    reelsCommentReplyController = TextEditingController();
    reelsDescriptionController = TextEditingController();
    reportDescription = TextEditingController();
    liveReelsTabPageController.addListener(_scrollListener2);
    reelsModelList.value.clear();
    reelsCampaignResultList.value.clear();
    await fetchAllData();
    if (reelsModelList.value.isNotEmpty) {
      reelsID = reelsModelList.value.first.id ?? '';
      reelIndex = 0;
      await getAllCommentsByReel(reelId: reelsID);
      socketService.emitStartLiveReelStreamView(
          reelsID,
          LoginCredential().getUserData().id ?? '');
    }

    debugPrint('LiveReelsController initialized with ${reelsModelList.value.length} reels');
    super.onInit();
  }

  @override
  void onClose() {
    showAllOverlay();
    _apiCommunication.endConnection();
    reelsModelList.value.clear();
    liveReelsTabPageController.removeListener(_scrollListener2);
    liveReelsTabPageController.dispose();
    scrollController.dispose();
    // isFromTabView.value = true;
    socketService.emitStopLiveStreamReelViewing(reelsID, LoginCredential().getUserData().id ?? '');

    super.onClose();
  }

  Future<void> _scrollListener2() async {
    if (liveReelsTabPageController.position.pixels == liveReelsTabPageController.position.maxScrollExtent) {
      debugPrint('Reels Max scroll extents');
      debugPrint('Tab PageController is running');

      getLiveReels();
      getReelsCampaignList();
      // getReelsCampaignList();
    }
  }
}
