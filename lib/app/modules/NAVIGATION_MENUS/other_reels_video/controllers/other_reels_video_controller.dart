import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../data/post_local_data.dart';
import '../../../../models/api_response.dart';
import '../../../../models/user.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/post_utlis.dart';
import '../../../../utils/snackbar.dart';
import '../../../shared/modules/create_post/models/fileCheckState.dart';
import '../../../shared/modules/create_post/models/imageCheckerModel.dart';
import '../../../shared/modules/create_post/service/imageCheckerService.dart';
import '../../home/controllers/home_controller.dart';
import '../../user_menu/sub_menus/all_pages/pages/model/report_model.dart';
import '../../reels/model/reels_campaign_model.dart';
import '../../reels/model/reels_comment_model.dart';
import '../../reels/model/reels_comment_reply_model.dart';
import '../../reels/model/reels_model.dart';

class OtherReelsVideoController extends GetxController {
  late ApiCommunication _apiCommunication;
  late TextEditingController reelsDescriptionController;

  LoginCredential loginCredential = LoginCredential();
  late UserModel userModel;

  RxString dropdownValue = reelsPrivacyList.first.obs;
  RxString reelsPrivacy = 'public'.obs;
  HomeController homeController = Get.find();

  Rx<Color> reactionColor = Colors.white.obs;
  Rx<List<XFile>> xfiles = Rx([]);

  Rx<List<ReelsModel>> reelsModelList = Rx([]);
  Rx<List<ReelsCampaignResults>> reelsCampaignResultList = Rx([]);
  Rx<List<ReelsCommentModel>> reelsCommentModelList = Rx([]);
  Rx<List<ReelsCommentReplyModel>> reelsCommentReplyModelList = Rx([]);
  Rx<List<PageReportModel>> pageReportList = Rx([]);
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;
  late TextEditingController reportDescription;

  RxString reelsCommentID = ''.obs;
  String reelsID = '';
  String username = '';
  RxString reelsCommentReplyID = ''.obs;
  RxString reelsPostID = ''.obs;
  RxBool isReply = false.obs;
  RxBool isLoadingUserPages = false.obs;
  bool _hasLoadedInitialData = false;

  var reelsCommentModl = ReelsCommentModel().obs;
  late TextEditingController reelsCommentController = TextEditingController();
  late TextEditingController reelsCommentReplyController =
      TextEditingController();

  RxBool isLoading = true.obs;
  RxBool isCommentLoading = true.obs;
  late PageController pageController;
  late PageController reelsTabPageController;
  RxBool isFromTabView = true.obs;
  final RxString checkingStatus = ''.obs;
  final RxBool isCheckingFiles = false.obs;
  final RxList<String> processedFileData = <String>[].obs;
  final processedCommentFileData = ''.obs;
  RxList<FileCheckingState> fileCheckingStates = <FileCheckingState>[].obs;

  List<T> _safeParseList<T>({
    required dynamic data,
    required T Function(Map<String, dynamic>) mapper,
    required String source,
  }) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(mapper)
          .toList(growable: true);
    }
    if (data is Map<String, dynamic>) {
      debugPrint('Expected a list from $source but got a map. Wrapping it.');
      return [mapper(data)];
    }
    debugPrint('Expected a list from $source but got $data');
    return <T>[];
  }

  void initializeFromArguments() {
    if (_hasLoadedInitialData) return;

    final args = Get.arguments as Map<String, dynamic>?;
    reelsID = args?['reelsID']?.toString() ?? '';
    username = args?['username']?.toString() ?? '';
    debugPrint('Reels ID from argument: $reelsID');

    reelsModelList.value.clear();
    reelsCampaignResultList.value.clear();

    if (reelsID.isNotEmpty) {
      getReelsById(reelsID);
      getReelCommentList(reelsID);
    }

    if (username.isNotEmpty) {
      getIndividualReels();
    } else {
      getReels();
    }

    getReelsCampaignList();
    _hasLoadedInitialData = true;
  }
  //==============================Get Reels All User =========================================//

  Future<void> getReels() async {
    isLoading.value = true;

    ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint:
          'reels/all-user-reels?limit=2&skip=${reelsModelList.value.length}&reels_id=$reelsID',
      responseDataKey: 'all_reels',
    );
    if (response.isSuccessful) {
      reelsModelList.value.addAll(_safeParseList<ReelsModel>(
          data: response.data,
          mapper: (e) => ReelsModel.fromMap(e),
          source: 'getReels'));
      isLoading.value = false;
      reelsModelList.refresh();
      debugPrint(reelsModelList.value.length.toString());
    }
  }
  //==============================Get Reels All User Individual=========================================//

  Future<void> getIndividualReels() async {
    isLoading.value = true;

    ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint:
          'all-user-reels?limit=2&skip=${reelsModelList.value.length}&username=$username',
      responseDataKey: 'all_reels',
    );
    if (response.isSuccessful) {
      reelsModelList.value.addAll(_safeParseList<ReelsModel>(
          data: response.data,
          mapper: (e) => ReelsModel.fromMap(e),
          source: 'getIndividualReels'));
      isLoading.value = false;
      reelsModelList.refresh();
      debugPrint(reelsModelList.value.length.toString());
    }
  }
  //==============================Get Reels Campaign List =========================================//

  Future<void> getReelsCampaignList() async {
    isCommentLoading.value = true;
    ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'campaign/get-reels-ads', responseDataKey: 'results');
    if (response.isSuccessful) {
      reelsCampaignResultList.value = _safeParseList<ReelsCampaignResults>(
          data: response.data,
          mapper: (e) => ReelsCampaignResults.fromMap(e),
          source: 'getReelsCampaignList');
      debugPrint(
          ':::::::::::::::::::Reels Campaign Result LIST: ${response.data}');
    } else {
      debugPrint('Error in getReelsCampaignList: ${response.message}');
    }
  }

  //==============================Get Reels By Id =========================================//
  Future<void> getReelsById(String reelsID) async {
    isLoading.value = true;

    ApiResponse response = await _apiCommunication.doGetRequest(
      // apiEndPoint: 'reels/get-single-reel/:reel_id',
      apiEndPoint: 'get-single-reel/$reelsID',
      responseDataKey: 'result',
    );
    if (response.isSuccessful) {
      reelsModelList.value.clear();
      final items = _safeParseList<ReelsModel>(
          data: response.data,
          mapper: (e) => ReelsModel.fromMap(e),
          source: 'getReelsById');

      reelsModelList.value.insertAll(0, items); // put new items first
      isLoading.value = false;
      reelsModelList.refresh();
      debugPrint(reelsModelList.value.length.toString());
    }
  }

// =============================Call each reels view Coount api=====================================//
  void reelsViewClick(String reelsId) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'post/reels-view', requestData: {
      'reels_id': reelsId,
    });

    if (apiResponse.isSuccessful) {
      debugPrint(
          '::::::::::::::::::::::::::::::::Reel Clicked & Viewed::::::::::::::::::::::::');
    }
  }

  //==============================Post Reels Like =========================================//

  void reelsLike(String postId, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'reels/save-reaction-reel-post',
        requestData: {
          'reaction_type': 'like',
          'post_id': postId,
          'post_single_item_id': null,
        });

    if (apiResponse.isSuccessful) {
      ReelsModel reelsModel =
          ReelsModel.fromMap(apiResponse.data as Map<String, dynamic>);
      reelsModelList.value[index] = reelsModel;
      reelsModelList.refresh();
    }
  }

  void reelsAdsLike(String postId, int index, String key) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'save-reaction-main-post', requestData: {
      'reaction_type': 'like',
      'post_id': postId,
      'post_single_item_id': null,
      'key': key,
    });

    if (apiResponse.isSuccessful) {
      getReelsCampaignList();
    }
  }
  //============================== Post Reels Comments =========================================//

  void reelsComments(
      String postId, String comment, int index, String file, String key) async {
    ApiResponse apiResponse = await ApiCommunication().doPostRequestNew(
        apiEndPoint: 'reels/save-user-comment-by-reel',
        requestData: {
          'user_id': loginCredential.getUserData().id,
          'post_id': postId,
          'comment_name': comment,
          'image_or_video': file,
          'key': key,
        },
        fileKey: 'image_or_video');

    if (apiResponse.isSuccessful) {
      reelsModelList.value[index].comment_count =
          (reelsModelList.value[index].comment_count ?? 0) + 1;
      reelsModelList.refresh();
      getReelCommentList(postId);
    }
  }

  void reelsAdsComments(
      String postId, String comment, int index, String key) async {
    ApiResponse apiResponse = await ApiCommunication().doPostRequestNew(
        apiEndPoint: 'reels/save-user-comment-by-post',
        requestData: {
          'user_id': loginCredential.getUserData().id,
          'post_id': postId,
          'comment_name': comment,
          'key': key,
        });

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
    ApiResponse apiResponse = await ApiCommunication().doPostRequestNew(
        apiEndPoint: 'reels/reply-comment-by-reel-post',
        requestData: {
          'comment_id': comment_id,
          'replies_user_id': replies_user_id,
          'replies_comment_name': replies_comment_name,
          'post_id': post_id,
          'image_or_video': file,
          'key': key,
        },
        fileKey: 'image_or_video');

    debugPrint(
        '=================Reels Comment reply uploader====================$apiResponse');
    if (apiResponse.isSuccessful) {
      debugPrint(
          '=================Reels Comment reply uploader if success====================$apiResponse');

      //  getReels();
      getReelCommentList(post_id);
      //  Get.back();
    } else {
      debugPrint(
          '=================Reels Comment reply uploader if fail====================$apiResponse');
    }
  }

//--------------------------------------- Report ----------------------------//
  Future getReports() async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-report-type',
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      pageReportList.value = (apiResponse.data as List)
          .map(
            (e) => PageReportModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPages.value = false;
  }

  //========================================Repost================================//
  void reelsRepost(String reelId, String key) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'reels/save-reels-re-post', requestData: {
      'reelsId': reelId,
      'key': key,
    });

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: apiResponse.message ?? '');
    } else {
      showErrorSnackkbar(message: apiResponse.message ?? '');
    }
  }

  //============================= Report on Posts =========================================//

  Future<void> reportAPost(
      {required String post_id,
      required String report_type,
      required String description,
      required String report_type_id}) async {
    debugPrint('=================Report Start==========================');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'save-post-report',
      enableLoading: true,
      requestData: {
        'reel_id': post_id,
        'report_type': report_type,
        'report_type_id': report_type_id,
        'description': description,
      },
    );

    debugPrint(
        '=================Report Api call end==========================');
    debugPrint(
        '=================Report Api status Code ${apiResponse.message}==========================');
    debugPrint(
        '=================Report Api success ${apiResponse.isSuccessful}==========================');

    if (apiResponse.isSuccessful) {
      debugPrint(
          '=================Report Successful==========================');

      Get.back();
      Get.back();
      showSuccessSnackkbar(message: 'Post reported successfully');
    } else {}
  }

  void reelsAdsCommentsReply({
    required String comment_id,
    required String replies_user_id,
    required String replies_comment_name,
    required String post_id,
    required String file,
  }) async {
    ApiResponse apiResponse = await ApiCommunication().doPostRequestNew(
      apiEndPoint: 'reply-comment-by-direct-post',
      requestData: {
        'comment_id': comment_id,
        'replies_user_id': replies_user_id,
        'replies_comment_name': replies_comment_name,
        'post_id': post_id,
        'image_or_video': file,
      },
      fileKey: 'image_or_video',
    );
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
    ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'get-all-comments-direct-reel/$reelsId',
        responseDataKey: 'comments');
    if (response.isSuccessful) {
      reelsCommentModelList.value = _safeParseList<ReelsCommentModel>(
          data: response.data,
          mapper: (e) => ReelsCommentModel.fromMap(e),
          source: 'getReelCommentList');
      debugPrint(':::::::::::::::::::COMMENT MODEL LIST: ${response.data}');
    }
  }

  Future<void> getReelAdsCommentList(String reelsAdId) async {
    isCommentLoading.value = true;
    ApiResponse response = await _apiCommunication.doGetRequest(
        apiEndPoint: 'campaign/get-reels-ads-comments/$reelsAdId',
        responseDataKey: 'comments');
    if (response.isSuccessful) {
      reelsCommentModelList.value = _safeParseList<ReelsCommentModel>(
          data: response.data,
          mapper: (e) => ReelsCommentModel.fromMap(e),
          source: 'getReelAdsCommentList');
      debugPrint(':::::::::::::::::::COMMENT MODEL LIST: ${response.data}');
    }
  }

  //-------------------------------------- follow-page ----------------------------//

  Future<void> followPage(String pageId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'follow-page',
      requestData: {
        'follow_unfollow_status': '',
        'like_unlike_status': '',
        'page_id': pageId,
        'user_id': '',
      },
    );
    if (response.isSuccessful) {
      showSuccessSnackkbar(message: 'Page Followed Successfully');
    } else {
      debugPrint('');
    }
  }

//=================================unfollow==========================//
  Future<void> unfollow(String pageId) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfollow-page',
      requestData: {
        'page_id': pageId,
      },
    );

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Unfollowed this pages successfully');
    } else {}
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

          // ✅ CHECK: If sexual is true, REJECT the file
          if (checkerResponse.sexual == true) {
            removedFiles.add(file.name);
            fileCheckingStates[i].isChecking = false;
            fileCheckingStates[i].isFailed = true;
            fileCheckingStates.refresh();
            debugPrint('❌ File REJECTED (inappropriate content): ${file.name}');
          }
          // ✅ If sexual is false, ACCEPT the file
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
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'reels/delete-single-comment-reel',
        requestData: {
          'comment_id': comment_id,
          'post_id': post_id,
          'type': 'main_comment',
          'key': key,
        });

    if (apiResponse.isSuccessful) {
      // updatePostList(post_id, postIndex);
      getReelCommentList(post_id);
    }
  }

  void reelsAdsCommentDelete(
      String comment_id, String post_id, int postIndex, String key) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'reels/delete-single-comment',
        requestData: {
          'comment_id': comment_id,
          'post_id': post_id,
          'type': 'main_comment',
          'key': key
        });

    if (apiResponse.isSuccessful) {
      // updatePostList(post_id, postIndex);
      getReelCommentList(post_id);
    }
  }
  //==============================Post Reels Reply Comment Delete =========================================//

  void reelsCommentReplyDelete(
      String reply_id, String post_id, int postIndex, String key) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'reels/delete-single-comment-reel',
        requestData: {
          'comment_id': reply_id,
          'post_id': post_id,
          'type': 'reply_comment',
          'key': key,
        });

    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
    }
  }

  void reelsAdsCommentReplyDelete(
      String reply_id, String post_id, int postIndex, String key) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'reels/delete-single-comment',
        requestData: {
          'comment_id': reply_id,
          'post_id': post_id,
          'type': 'reply_comment',
          'key': key,
        });

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
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'reels/save-share-reels', requestData: {
      'description': reelsDescriptionController.text,
      'reels_privacy': (getReelsPostPrivacyValue(reelsPrivacy.value)),
      'share_reels_id': reelsId,
      'key': key
    });

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your Reels has been shared');
      homeController.refreshEdgeRankFeed();
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

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-comment-reaction-of-reel-post',
        requestData: {
          'reaction_type': reactionType,
          'post_id': post_id,
          'comment_id': comment_id,
          'user_id': userId
        });

    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
      // List<CommentModel> comments = await getSinglePostsComments(post_id);
      // postList.value[postIndex].comments = comments;
      // postList.refresh();
      // List <CommentReactionModel>   commentReactionList = await apiResponse.data
    }
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

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-comment-reaction-of-reel-post',
        requestData: {
          'reaction_type': reactionType,
          'post_id': post_id,
          'comment_id': comment_id,
          'comment_replies_id': comment_reply_id,
          'user_id': userId
        });

    if (apiResponse.isSuccessful) {
      getReelCommentList(post_id);
      // List<CommentModel> comments = await getSinglePostsComments(post_id);
      // postList.value[postIndex].comments = comments;
      // postList.refresh();
      // List <CommentReactionModel>   commentReactionList = await apiResponse.data
    }
  }

//============================= Delete Reels ===============================//
  Future deleteReels(String reelId, String key) async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
        apiEndPoint: 'reels/delete-own-user-reel/:$reelId',
        requestData: {
          'key': key,
        });

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Reels Deleted Successfully');
      // getReels();
    }
    isLoadingUserPages.value = false;
  }

  Rx<ReelsModel> reelsItem = ReelsModel().obs;
  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    userModel = loginCredential.getUserData();

    pageController = PageController();
    // reelsTabPageController = PageController();
    reelsCommentController = TextEditingController();
    reelsCommentReplyController = TextEditingController();
    reelsDescriptionController = TextEditingController();
    reportDescription = TextEditingController();
    pageController.addListener(_scrollListener);
    // reelsTabPageController.addListener(_scrollListener2);

    initializeFromArguments();

    // getReels();
    // getReelsCampaignList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reelsViewClick(reelsItem.value.id ?? '');
    });
    debugPrint('Reels Max scroll ');
    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    reelsModelList.value.clear();
    // isFromTabView.value = true;

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
  // Future<void> _scrollListener2() async {

  //   if (reelsTabPageController.position.pixels ==
  //       reelsTabPageController.position.maxScrollExtent) {
  //     debugPrint('Reels Max scroll extents');
  //     debugPrint('Tab PageController is running');
  //       getReels();
  //     getReelsCampaignList();
  //     // getReelsCampaignList();
  //   }
  // }
}
