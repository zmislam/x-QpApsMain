import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../enum/live_post_type_enum.dart';
import '../../../models/comment_model.dart';
import '../../../utils/snackbar.dart';
import 'package:rtmp_broadcaster/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../config/constants/api_constant.dart';
import '../../../data/login_creadential.dart';
import '../../../models/api_response.dart';
import '../../../models/live/live_stream_view_model.dart';
import '../../../models/live/user_live_stream_model.dart';
import '../../../models/post.dart';
import '../../../services/api_communication.dart';
import '../../../services/socket_service.dart';

class LiveStreamController extends GetxController with WidgetsBindingObserver {
  final SocketService socketService;

  LiveStreamController({required this.socketService});

  // ========================== arguments ======================================
  Rx<UserLiveStreamModel?> userLiveModel = Rx(null);
  String finalFileName = '';
  String url_core = '';
  RxBool isBottomWidgetOpen = false.obs;

  // ========================== API CALL REQUIRED ================================

  late final LoginCredential loginCredential;
  final ApiCommunication _apiCommunication = ApiCommunication();
  Rx<List<CommentModel>> liveCommentList = Rx([]);
  Rx<LiveStreamController?> liveAudience = Rx(null);

  // ========================== Calculate Screen Size ================================
  void calculateScreenSize() {
    final screenSize = Size(Get.size.width, Get.size.height);
    final cameraAspectRatio = cameraController!.value.aspectRatio;
    final screenAspectRatio = screenSize.width / screenSize.height;

    // Calculate the scale needed for the camera to fill the entire screen
    // This ensures the camera preview covers the full screen area
    if (cameraAspectRatio > screenAspectRatio) {
      // When camera is wider than screen, match heights and allow width to overflow
      scale.value = screenSize.height / (screenSize.width / cameraAspectRatio);
    } else {
      // When screen is wider than camera, match widths and allow height to overflow
      scale.value = screenSize.width / (screenSize.height * cameraAspectRatio);
    }

    debugPrint(
        '-----------------------SCALE ***** SCALE-------------------------------');
    debugPrint(
        '-----------------------${scale.value}-------------------------------');
    debugPrint(
        '-----------------------SCALE ***** SCALE-------------------------------');

    // Fine-tune the scale with a correction factor
    // This can be adjusted based on testing across devices
    const correctionFactor = 0.95; // Target scale / Current scale
    scale.value *= correctionFactor;

    debugPrint('Screen Size: $screenSize');
    debugPrint('Screen Aspect Ratio: $screenAspectRatio');
    debugPrint('Camera Aspect Ratio: $cameraAspectRatio');
    debugPrint('Calculated Scale: ${scale.value}');
  }

// Initialize scale with your target value
  RxDouble scale = 1.42.obs;

  // ========================== Post Model setup for share ================================
  PostModel postModelForTimeLine = PostModel();
  PostModel postModelForReels = PostModel();
  RxString streamUrl = ''.obs;

  // ========================== field variables ================================
  late TextEditingController commentController;
  late FocusNode commentFocusNode;
  late final ScrollController scrollController;

  // ========================== camera variables ===============================
  List<CameraDescription> cameras = <CameraDescription>[];

  // ========================== variables ======================================
  RxInt liveJoiningUser = 0.obs;
  Rx<String> shareCount = '20'.obs;
  bool liveStreamStarted = false;

  // ========================== Subscribe to live audience count ==============================

  LiveStreamViewModel liveStreamViewModelForTimeLine = LiveStreamViewModel();
  LiveStreamViewModel liveStreamViewModelForReels = LiveStreamViewModel();

  // ========================== vars for video streaming ==============================

  CameraController? cameraController;
  String? url;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  bool useOpenGL = true;

  bool get isStreaming => cameraController?.value.isStreamingVideoRtmp ?? false;
  bool isVisible = true;

  RxBool isInitDone = false.obs;

  Rx<bool?> get isControllerInitialized =>
      cameraController?.value.isInitialized.obs ?? false.obs;

  bool get isStreamingVideoRtmp =>
      cameraController?.value.isStreamingVideoRtmp ?? false;

  bool get isStreamingPaused =>
      cameraController?.value.isStreamingPaused ?? false;

  // ==========================  camera Switch ==============================

  RxInt cameraIndex = 0.obs;
  bool cameraSwitchOngoing = false;

  Future<void> switchCamera() async {
    if (cameraController == null || !isInitDone.value || cameraSwitchOngoing) {
      return;
    }

    cameraSwitchOngoing = true;

    // ? Store current streaming state
    bool wasStreaming = isStreaming;

    // ! Stop streaming if active
    if (wasStreaming) {
      await stopVideoStreaming();
    }

    // ? Toggle camera index
    cameraIndex.value = cameraIndex.value == 0 ? 1 : 0;

    // ! Dispose current controller
    await cameraController?.dispose();

    // ? Initialize new camera
    cameraController = CameraController(
      cameras[cameraIndex.value],
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      androidUseOpenGL: useOpenGL,
      streamingPreset: ResolutionPreset.medium,
    );

    // ? Set up listener
    cameraController!.addListener(() async {
      if (cameraController != null) {
        if (cameraController!.value.hasError) {
          await stopVideoStreaming();
        } else {
          try {
            final Map<dynamic, dynamic> event =
                cameraController!.value.event as Map<dynamic, dynamic>;
            debugPrint('Event $event');
            final String eventType = event['eventType'] as String;
            if (isVisible && isStreaming && eventType == 'rtmp_retry') {
              showErrorSnackkbar(
                  message:
                      'Bad path received, endpoint in use. Please end the session and retry again',
                  titile: 'Stream Connection Failed');
              stopVideoStreaming();
            }
          } catch (e) {
            debugPrint('$e');
          }
        }
      }
    });

    try {
      // ? Initialize new camera
      await cameraController!.initialize();
      isInitDone.value = true;
      calculateScreenSize();

      // ? Restart streaming if it was active before
      if (wasStreaming) {
        await startVideoStreaming();
        cameraSwitchOngoing = false;
      }
    } on CameraException catch (e) {
      _showCameraException(e);
      cameraSwitchOngoing = false;
    }
  }

  // ========================== initialize camera ==============================

  Future<void> initializeCamera() async {
    // Init stream video file name
    finalFileName =
        'stream_${loginCredential.getUserData().username}_${DateTime.now().millisecondsSinceEpoch}.mp4';
    url_core =
        '${loginCredential.getUserData().id}${DateTime.now().millisecondsSinceEpoch}';

    // Init Camara Controller....
    cameras = await availableCameras();
    debugPrint('CAMERA----');
    debugPrint('$cameras');

    if (cameraController != null) {
      await stopVideoStreaming();
      await cameraController?.dispose();
    }
    cameraController = CameraController(
      // cameras[userLiveModel.value?.cameraIndex ?? 0],
      cameras[cameraIndex.value],
      ResolutionPreset.medium,
      enableAudio: enableAudio,
      androidUseOpenGL: useOpenGL,
      streamingPreset: ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    cameraController!.addListener(() async {
      if (cameraController != null) {
        if (cameraController!.value.hasError) {
          await stopVideoStreaming();
        } else {
          try {
            final Map<dynamic, dynamic> event =
                cameraController!.value.event as Map<dynamic, dynamic>;
            debugPrint('Event $event');
            final String eventType = event['eventType'] as String;
            if (isVisible && isStreaming && eventType == 'rtmp_retry') {
              showErrorSnackkbar(
                  message:
                      'Bad path received, endpoint in use. Please end the session and retry again',
                  titile: 'Stream Connection Failed');
              stopVideoStreaming();
            }
          } catch (e) {
            debugPrint('$e');
          }
        }
      }
    });

    try {
      await cameraController!.initialize();
      isInitDone.value = true;
      calculateScreenSize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  // ========================= screen overlay utils ============================
  void screenOverlayUtils() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    hideAllOverlay();
  }

  void hideAllOverlay() {
    // Set system UI to be fully immersive and stay that way
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [], // Keep all overlays hidden
    );
  }

  void showAllOverlay() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  // ============================= viewer count listener ============================
  Rx<LiveStreamViewModel?> listViewModel = Rx(null);

  addListenerForViewerCount() {
    socketService.viewerListenStreamController.stream.listen(
      (event) {
        debugPrint('Live Stream Viewer ${postModelForTimeLine.id}');
        if (postModelForTimeLine.id == event.postId) {
          listViewModel.value = event;
        }
      },
    );
    socketService.viewerListenReelsStreamController.stream.listen(
      (event) {
        debugPrint('Live Reels Viewer${postModelForReels.id}');
        if (postModelForReels.id == event.reelsId) {
          listViewModel.value = event;
        }
      },
    );
  }

  // ============================= comment listener ============================
  void _addCommentListener() {
    socketService.commentListenStreamController.stream
        .listen((CommentModel commentModel) {
      debugPrint(postModelForReels.id.toString());
      debugPrint(postModelForTimeLine.id.toString());
      if (commentModel.post_id
                  .toString()
                  .compareTo(postModelForReels.id.toString()) ==
              0 ||
          commentModel.post_id
                  .toString()
                  .compareTo(postModelForTimeLine.id.toString()) ==
              0) {
        if (!liveCommentList.value.contains(commentModel)) {
          liveCommentList.value.insert(0, commentModel);
        }
        liveCommentList.refresh();
      }
    });
  }

// ============================== send live stream comment ===================
  void sendLiveStreamComment({String? reelsId, String? postId}) async {
    Map<String, dynamic> requestData = {
      'comment_name': commentController.text.trim(),
    };

    if (userLiveModel.value!.livePostTypeEnum == LivePostTypeEnum.ON_BOTH) {
      requestData['post_id'] = postId;
      requestData['reels_id'] = reelsId;
    } else if (userLiveModel.value!.livePostTypeEnum ==
        LivePostTypeEnum.ON_REELS) {
      requestData['reels_id'] = reelsId;
    } else if (userLiveModel.value!.livePostTypeEnum ==
        LivePostTypeEnum.ON_TIMELINE) {
      requestData['post_id'] = postId;
    }

    if (commentController.text.trim().isNotEmpty) {
      ApiResponse response = await _apiCommunication.doPostRequest(
          apiEndPoint: 'stream/save-user-comment-in-stream',
          requestData: requestData);

      if (response.isSuccessful) {
        commentController.clear();
        // Get.back();
        // await getAllLiveComments();
      } else {
        commentController.clear();
        // Get.back();
        showErrorSnackkbar(message: 'Please Try again');
      }
    } else {}
  }

  // ============================ get all live stream comment ==================
  Future<void> getAllLiveComments() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint:
            'get-all-comments-direct-post/${postModelForTimeLine.id ?? ''}',
        responseDataKey: 'comments');

    if (apiResponse.isSuccessful) {
      liveCommentList.value = (apiResponse.data as List)
          .map((e) => CommentModel.fromMap(e))
          .toList();
      liveCommentList.refresh();
    } else {
      debugPrint(apiResponse.data.toString());
    }
  }

  // ========================== live share =====================================
  void liveShare() {}

  // ========================== send message ===================================
  void sendMessage() {}

  // ========================== send comment ===================================
  void sendComment(String comment) {
    if (comment.trim().isNotEmpty) {
      commentController.clear();
      Get.back();
    }
  }

  // ================================== Control Variables ======================

  // ========================== live session end ===============================
  void endLiveSession() {
    endVideoStream();
    showAllOverlay();
  }

  bool firstVideoChunkInserted = false;
  late File localVideoFile;

// ========================== Chunk the videos ===============================

  @override
  void onInit() {
    super.onInit();
    WakelockPlus.enable();

    loginCredential = LoginCredential();
    commentController = TextEditingController();
    scrollController = ScrollController();
    commentFocusNode = FocusNode();
    userLiveModel.value = Get.arguments;
    cameraIndex.value = userLiveModel.value?.cameraIndex ?? 0;
    screenOverlayUtils();
    WidgetsBinding.instance.addObserver(this);

    callWithAsync();

    addListenerForViewerCount();
    _addCommentListener();
  }

  Future<void> callWithAsync() async {
    await initializeCamera().then(
      (value) async {
        await liveStreamPostSendStart().then(
          (value) {
            startVideoStreaming();
          },
        );
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    // cameraController!.dispose();
    showAllOverlay();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !isControllerInitialized.value!) {
      return;
    }
    if (state == AppLifecycleState.paused) {
      isVisible = false;
      if (isStreaming) {
        await pauseVideoStreaming();
      }
    } else if (state == AppLifecycleState.resumed) {
      isVisible = true;
      if (cameraController != null) {
        if (isStreaming) {
          await resumeVideoStreaming();
        } else {
          // startVideoStreaming();
        }
      }
    } else if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      endLiveSession();
    }
  }

  // ========================== video stream functions ===============================

  Future<String?> startVideoStreaming() async {
    WakelockPlus.enable();
    if (cameraController == null) {
      return null;
    }

    if (!isInitDone.value) {
      return null;
    }

    if (cameraController?.value.isStreamingVideoRtmp ?? false) {
      return null;
    }

    try {
      url = streamUrl.value;

      debugPrint('STREAM URL');
      debugPrint('$url');
      await cameraController!.startVideoStreaming(url!);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return url;
  }

  Future<void> stopVideoStreaming() async {
    debugPrint(
        '***************************************************************');
    debugPrint(
        '********************THE STREAM HAS ENDED***********************');
    debugPrint(
        '***************************************************************');

    if (cameraController == null || !isInitDone.value) {
      return;
    }

    if (!isStreamingVideoRtmp) {
      return;
    }

    try {
      await cameraController!.stopVideoStreaming();
    } on CameraException catch (e) {
      debugPrint('VIDEO STREAM STOP LOGIC ERROR');
      _showCameraException(e);
      return;
    }
  }

  Future<void> pauseVideoStreaming() async {
    if (!isStreamingVideoRtmp) {
      return;
    }

    try {
      await cameraController!.pauseVideoStreaming();
    } on CameraException catch (e) {
      debugPrint('VIDEO STREAM PAUSE LOGIC ERROR');
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoStreaming() async {
    if (!isStreamingVideoRtmp) {
      return;
    }

    try {
      await cameraController!.resumeVideoStreaming();
    } on CameraException catch (e) {
      _showCameraException(e);
      debugPrint('VIDEO STREAM RESUME LOGIC ERROR');
      rethrow;
    }
  }

  // Camera exception

  void _showCameraException(CameraException e) {
    showErrorSnackkbar(
        titile: e.code, message: e.description ?? 'No description found');
  }

  void endVideoStream() {
    debugPrint(
        '-----------------------Ending the stream-------------------------------');
    debugPrint(
        '--------------------------- SCALE ${scale.value} ------------------------------------');
    debugPrint(
        '--------------------------- CALLED ------------------------------------');
    try {
      stopVideoStreaming();
      String outputFileName = 'compress_$finalFileName';

      Map<String, dynamic> dataMap = {
        'filename': finalFileName,
        'newFilename': outputFileName,
        'type': LivePostTypeEnumValueMap[userLiveModel.value!.livePostTypeEnum],
      };

      if (userLiveModel.value!.livePostTypeEnum ==
          LivePostTypeEnum.ON_TIMELINE) {
        dataMap['post_id'] = postModelForTimeLine.id;
        dataMap['streamKey'] = postModelForTimeLine.url;
      } else if (userLiveModel.value!.livePostTypeEnum ==
          LivePostTypeEnum.ON_REELS) {
        dataMap['reels_id'] = postModelForReels.id;
        dataMap['streamKey'] = postModelForReels.url;
      } else if (userLiveModel.value!.livePostTypeEnum ==
          LivePostTypeEnum.ON_BOTH) {
        dataMap['post_id'] = postModelForTimeLine.id;
        dataMap['reels_id'] = postModelForReels.id;
        dataMap['streamKey'] = postModelForTimeLine.url;
      }

      debugPrint(
          '**************************************************************');
      debugPrint(dataMap.toString());
      debugPrint(
          '**************************************************************');

      socketService.socket.emit('mobileEndstream', dataMap);

      // Allow screen off
      WakelockPlus.disable();

      // Live Stream API call end..... Update..
      liveStreamEnd(outputFileName: outputFileName);
    } catch (error) {
      debugPrint('Error -------------------------------------------------');
      debugPrint(error.toString());
    }
  }

  // ============================================= API CALLS FOR START AND STOP for timeline_post ================================================

  Future<void> startTheLiveStreamOnPosts() async {
    Map<String, dynamic> data = {
      'description': userLiveModel.value?.description.toString(),
      'post_type': 'live',
      'post_privacy': (userLiveModel.value!.privacy == null ||
              userLiveModel.value!.privacy.toString().isEmpty)
          ? 'public'
          : userLiveModel.value?.privacy.toString(),
      'filename': finalFileName,
    };

    if (userLiveModel.value!.livePostTypeEnum == LivePostTypeEnum.ON_BOTH) {
      data['url'] = url_core;
    }

    final ApiResponse response = await _apiCommunication.doPostRequest(
        apiEndPoint: 'stream/save-live-stream',
        enableLoading: false,
        responseDataKey: ApiConstant.FULL_RESPONSE,
        requestData: data);

    if (response.isSuccessful) {
      postModelForTimeLine.id =
          (response.data as Map<String, dynamic>)['data']['_id'];
      postModelForTimeLine.url =
          (response.data as Map<String, dynamic>)['data']['url'] ?? '';
      streamUrl.value =
          ApiConstant.RTMP_BASE_URL + postModelForTimeLine.url.toString();

      debugPrint(
          '************************* STREAM URL FOR VIEW FOR TIMELINE *********************');
      debugPrint(streamUrl.value);
      debugPrint(
          '************************* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ *********************');

      liveStreamViewModelForTimeLine.postId = postModelForTimeLine.id;
    } else {
      debugPrint('Cant go live now. Check issue...');
    }
  }

  Future<void> endTheLiveStreamOnPosts(
      {required String id, required String outputFileName}) async {
    // final ApiResponse response = await _apiCommunication.doPatchRequest(apiEndPoint: 'stream/update-post-type/$id', enableLoading: true, responseDataKey: ApiConstant.FULL_RESPONSE, requestData: {
    //   'post_type': 'timeline_post',
    //   'fileName': outputFileName,
    // });
    //
    // if (response.isSuccessful) {
    // } else {
    //   debugPrint('Error in Ending the live stream..');
    // }
  }

  // ============================================= API CALLS FOR START AND STOP for reels ================================================

  Future<void> startTheLiveStreamOnReels() async {
    Map<String, dynamic> data = {
      'description': userLiveModel.value?.description.toString(),
      'post_type': 'live',
      'post_privacy': (userLiveModel.value!.privacy == null ||
              userLiveModel.value!.privacy.toString().isEmpty)
          ? 'public'
          : userLiveModel.value?.privacy.toString(),
      'filename': finalFileName,
    };

    if (userLiveModel.value!.livePostTypeEnum == LivePostTypeEnum.ON_BOTH) {
      data['url'] = url_core;
    }

    final ApiResponse response = await _apiCommunication.doPostRequest(
        apiEndPoint: 'stream/save-live-stream-for-reels',
        enableLoading: false,
        responseDataKey: ApiConstant.FULL_RESPONSE,
        requestData: data);

    if (response.isSuccessful) {
      postModelForReels.id =
          (response.data as Map<String, dynamic>)['data']['_id'];
      if (((response.data as Map<String, dynamic>)['data']
              as Map<String, dynamic>)
          .containsKey('url')) {
        postModelForReels.url =
            (response.data as Map<String, dynamic>)['data']['url'] ?? '';
        if (streamUrl.value.isEmpty &&
            postModelForReels.url.toString().isNotEmpty) {
          streamUrl.value =
              ApiConstant.RTMP_BASE_URL + postModelForReels.url.toString();
        }
      }
      liveStreamViewModelForReels.postId = postModelForTimeLine.id;

      debugPrint(
          '************************* STREAM URL FOR VIEW FOR REELS *********************');
      debugPrint(streamUrl.value);
      debugPrint(
          '************************* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ *********************');
    } else {
      debugPrint('Cant go live now. Check issue...');
    }
  }

  Future<void> endTheLiveStreamOnReels(
      {required String id, required String outputFileName}) async {
    // final ApiResponse response = await _apiCommunication.doPatchRequest(
    //     apiEndPoint: 'stream/update-reels-type/$id',
    //     enableLoading: true,
    //     responseDataKey: ApiConstant.FULL_RESPONSE,
    //     requestData: {
    //   'post_type': 'reels',
    //   'fileName': finalFileName,
    // });
    //
    // if (response.isSuccessful) {
    //   // showSuccessSnackkbar(message: 'Profile Switched Successful');
    // } else {
    //   debugPrint('Error in Ending the live stream..');
    // }
  }

// ============================================= API CALLS FOR START AND STOP SWITCH CASE ================================================

  Future<void> liveStreamPostSendStart() async {
    switch (userLiveModel.value!.livePostTypeEnum) {
      case LivePostTypeEnum.ON_TIMELINE:
        await startTheLiveStreamOnPosts();
        break;
      case LivePostTypeEnum.ON_REELS:
        await startTheLiveStreamOnReels();
        break;
      case LivePostTypeEnum.ON_BOTH:
        await startTheLiveStreamOnPosts();
        await startTheLiveStreamOnReels();
        break;
    }
  }

  Future<void> liveStreamEnd({required String outputFileName}) async {
    switch (userLiveModel.value!.livePostTypeEnum) {
      case LivePostTypeEnum.ON_TIMELINE:
        await endTheLiveStreamOnPosts(
            id: postModelForTimeLine.id == null
                ? '0'
                : postModelForTimeLine.id.toString(),
            outputFileName: outputFileName);
        break;
      case LivePostTypeEnum.ON_REELS:
        await endTheLiveStreamOnReels(
            id: postModelForReels.id == null
                ? '0'
                : postModelForReels.id.toString(),
            outputFileName: outputFileName);
        break;
      case LivePostTypeEnum.ON_BOTH:
        await endTheLiveStreamOnPosts(
            id: postModelForTimeLine.id == null
                ? '0'
                : postModelForTimeLine.id.toString(),
            outputFileName: outputFileName);
        await endTheLiveStreamOnReels(
            id: postModelForReels.id == null
                ? '0'
                : postModelForReels.id.toString(),
            outputFileName: outputFileName);
        break;
    }
  }
}
