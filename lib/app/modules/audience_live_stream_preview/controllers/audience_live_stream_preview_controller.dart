import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/login_creadential.dart';

import '../../../components/animated_reaction/animated_reaction_widget.dart';
import '../../../config/constants/api_constant.dart';
import '../../../models/api_response.dart';
import '../../../models/comment_model.dart';
import '../../../models/live/live_stream_reaction_model.dart';
import '../../../models/live/live_stream_view_model.dart';
import '../../../models/post.dart';
import '../../../services/api_communication.dart';
import '../../../services/socket_service.dart';
import '../../../utils/snackbar.dart';

class AudienceLiveStreamPreviewController extends GetxController {
  // ============================ arguments ====================================
  Rx<PostModel?> postModel = Rx(null);

  // ============================ API Calling Variables ========================
  late final ApiCommunication _apiCommunication;
  Rx<bool> isLoading = false.obs;
  Rx<List<CommentModel>> liveCommentList = Rx([]);

  // ============================ Socket Variables =============================
  late SocketService socketService;

  // ============================= UI Variables ================================
  late final ScrollController scrollController;
  late final TextEditingController commentController;
  late final FocusNode commentFocusNode;

  Rx<bool> isLiveEnd = false.obs;
  Rx<int> reactionCount = 0.obs;
  Rx<bool> isFollow = false.obs;

  // ========================= follow user in live stream ======================
  void followUserInLiveStream() async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(apiEndPoint: 'follower-unfollow-request', requestData: {
      'follower_user_id': postModel.value?.user_id?.id ?? '',
      'follow_unfollow_status': 1,
    });

    if (apiResponse.isSuccessful) {
      isFollow.value = true;
    } else {
      isFollow.value = false;
    }
  }

  // ============================ update value according to post model =========
  void updatePostModelValue() {
    reactionCount.value = postModel.value?.reactionCount ?? 0;
    liveStreamViewerCount.value = postModel.value?.view_count ?? 0;
    isFollow.value = postModel.value?.user_id?.isFollowing ?? false;
  }

  // ============================ fetch all data ===============================
  void fetchAllData() async {
    isLoading.value = true;
    getAllLiveComments();
    isLoading.value = false;
  }

  // ============================ get all live stream comment ==================
  Future<void> getAllLiveComments() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(apiEndPoint: 'get-all-comments-direct-post/${postModel.value?.id ?? ''}', responseDataKey: 'comments');

    if (apiResponse.isSuccessful) {
      liveCommentList.value = (apiResponse.data as List).map((e) => CommentModel.fromMap(e)).toList().reversed.toList();
      liveCommentList.refresh();
    } else {
      debugPrint(apiResponse.data.toString());
    }
  }

  // ============================== send live stream comment ===================
  void sendLiveStreamComment() async {
    Map<String, dynamic> requestData = {
      'post_id': postModel.value?.id ?? '',
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
        showErrorSnackkbar(message: 'Please try again');
      }
    } else {}
  }

  // ============================= comment listener ============================
  void _addCommentListener() {
    socketService.commentListenStreamController.stream.listen((CommentModel commentModel) {
      // Adding if condition for stopping comments of one stream to be visible on all Live stream : BY RAYHAN
      if (postModel.value?.id.toString().compareTo(commentModel.post_id.toString()) == 0) {
        liveCommentList.value.insert(0, commentModel);
        liveCommentList.refresh();
      }
    });
  }

  // ============================= Viewer listener =============================
  Rx<int> liveStreamViewerCount = 0.obs;
  Rx<LiveStreamViewModel?> liveStreamViewer = Rx(null);
  void addViewerListener() {
    socketService.viewerListenStreamController.stream.listen((data) {
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
  void _streamReactionListener() {
    socketService.streamReactionStreamController.stream.listen((LiveStreamReactionModel streamReactionModel) {
      _addReaction(streamReactionModel.reaction_type ?? 'like');

      reactionCount.value++;
    });
  }

  // ============================= post react ==================================
  Future<void> reactOnPost({
    required PostModel postModel,
    required String reaction,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'stream/save-stream-post-reaction',
      requestData: {
        'reaction_type': reaction,
        'user_id': postModel.user_id?.id,
        'post_id': postModel.id,
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

  // ============================= onInit method ===============================
  @override
  void onInit() {
    super.onInit();
    hideAllOverlay();
    socketService = Get.find<SocketService>();
    _apiCommunication = ApiCommunication();
    postModel.value = Get.arguments;
    liveStreamViewerCount.value = postModel.value?.view_count ?? 0;
    scrollController = ScrollController();
    commentController = TextEditingController();
    commentFocusNode = FocusNode();
    socketService.emitStartLiveStreamView(postModel.value?.id ?? '', LoginCredential().getUserData().id ?? '');
    addViewerListener();
    updatePostModelValue();
    fetchAllData();
    _addCommentListener();
    _stopLiveStreamListener();
    _streamReactionListener();
  }

  // ============================ onClose Metod ================================
  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    commentController.dispose();
    showAllOverlay();
    socketService.emitStopLiveStreamViewing(postModel.value?.id ?? '', LoginCredential().getUserData().id ?? '');
  }
}
