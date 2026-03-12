import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/user_id.dart';
import '../../../shared/modules/create_post/models/fileCheckState.dart';
import '../../../shared/modules/create_post/models/imageCheckerModel.dart';
import '../../../shared/modules/create_post/service/imageCheckerService.dart';
import '../../user_menu/sub_menus/all_pages/pages/model/allpages_model.dart';
import '../../../../repository/user_relationships_repository.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/constants/color.dart';
import '../../../../data/login_creadential.dart';
import '../../../../data/post_local_data.dart';
import '../../../../models/media_type_model.dart';
import '../../../../models/api_response.dart';
import '../../../../models/chat/chat_model.dart';
import '../../../../models/comment_model.dart';
import '../../../../models/merge_story.dart';
import '../../../../models/post.dart';
import '../../../../models/story.dart';
import '../../../../models/user.dart';
import '../../../../models/video_campaign_model.dart';
import '../../../../repository/page_repository.dart';
import '../../../../repository/post_repository.dart';
import '../../../../repository/story_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/post_utlis.dart';
import '../../../../utils/snackbar.dart';
import '../../friend/model/people_may_you_khnow.dart';
import '../../user_menu/sub_menus/all_pages/pages/model/report_model.dart';
import '../components/generate_random_indices.dart';

class HomeController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  //Repository
  final StoryRepository storyRepository = StoryRepository();
  final PostRepository postRepository = PostRepository();
  final PageRepository pageRepository = PageRepository();

  late TextEditingController descriptionController;

  RxBool isCommentReactionLoading = true.obs;
  RxBool isReplyReactionLoading = true.obs;
  RxInt storyCaroselInitialIndex = 0.obs;
  var currentAdIndex = 0.obs;

  RxString dropdownValue = privacyList.first.obs;
  RxString postPrivacy = 'public'.obs;

  Rx<List<XFile>> xfiles = Rx([]);
  Rx<List<VideoCampaignModel>> videoAdList = Rx([]);

  RxString commentsID = ''.obs;
  RxString postID = ''.obs;

  RxBool isLoadingNewsFeed = true.obs;
  RxBool isLoadingUserPages = true.obs;
  RxBool isLoadingStory = true.obs;
  Rx<List<PostModel>> postList = Rx([]);
  Rx<List<StoryModel>> storytList = Rx([]);
  Rx<List<StoryMergeModel>> storyMergeList = Rx([]);

  late ScrollController postScrollController;

  int pageNo = 1;
  final int pageSize = 20;
  int totalPageCount = 0;
  RxBool isNextPage = false.obs;
  late TextEditingController commentController;
  late TextEditingController commentReplyController;
  RxBool isReply = false.obs;
  RxBool isReplyOfReply = false.obs;
  RxBool isLoading = false.obs;
  Rx<List<MediaTypeModel>> imageFromNetwork = Rx([]);
  Rx<CommentModel> commentModel = CommentModel().obs;
  Rx<CommentReplay> commentReplyModel = CommentReplay().obs;
//pepople you may know
  Rx<List<PeopleMayYouKnowModel>> peopleMayYouKnowList = Rx([]);
  // Suggested Page
  Rx<List<AllPagesModel>> suggestedPageList = Rx([]);

  RxList<int> randomIndices = <int>[].obs;
  RxList<int> randomIndicesForSuggestedPages = <int>[].obs;
  RandomIndexGenerator randomNumberGenertor = RandomIndexGenerator();
  Rx<List<PageReportModel>> pageReportList = Rx([]);
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;
  late TextEditingController reportDescription;

  Rx<List<ChatModel>> messengerUserList = Rx([]);
  Rx<int> userVisibleCount = 8.obs;

  final RxString checkingStatus = ''.obs;
  final RxBool isCheckingFiles = false.obs;
  final RxList<String> processedFileData = <String>[].obs;
  final processedCommentFileData = ''.obs;
  RxList<FileCheckingState> fileCheckingStates = <FileCheckingState>[].obs;

  UserRelationshipRepository userRelationshipRepository =
      UserRelationshipRepository();

  // =============================== fetch messenger user list data =================================
  Future<void> getMessengerUserData() async {
    ApiResponse response = await _apiCommunication.doGetRequest(
      apiEndPoint: 'chats/for-app?chat_type=friends',
    );

    if (response.isSuccessful) {
      messengerUserList.value =
          (response.data as List).map((e) => ChatModel.fromMap(e)).toList();
      messengerUserList.refresh();
    } else {}
  }

  Rx<bool> isSend = false.obs;

  Future<void> sendMessage(ChatModel userData, String url) async {
    isSend.value = true;

    Map<String, dynamic> requestData = <String, dynamic>{
      'app_name': 'apps',
    };

    requestData.addAll({'content': url});

    for (ChatModel chatModel in messengerUserList.value) {
      if ((chatModel.id == userData.id) && chatModel.isSelected == true) {
        ApiResponse response = await _apiCommunication.doPostRequest(
          isFormData: true,
          apiEndPoint: 'messages/${chatModel.id ?? ''}',
          requestData: requestData,
        );
        if (response.isSuccessful) {
          chatModel.isSelected = false;
          Get.back();
        }
        break;
      }
    }

    isSend.value = false;
  }

  Future<void> sendMutipleMessage(String url) async {
    isSend.value = true;

    Map<String, dynamic> requestData = <String, dynamic>{
      'app_name': 'apps',
    };

    requestData.addAll({'content': url});

    for (ChatModel chatModel in messengerUserList.value) {
      if (chatModel.isSelected == true) {
        ApiResponse response = await _apiCommunication.doPostRequest(
          isFormData: true,
          apiEndPoint: 'messages/${chatModel.id ?? ''}',
          requestData: requestData,
        );
        if (response.isSuccessful) {
          chatModel.isSelected = false;
          Get.back();
        }
      }
    }

    isSend.value = false;
  }

  RxBool showPeople = true.obs;

  void generateRandomIndicesForPosts() {
    // Ensure postList is not empty before generating indices
    if (postList.value.isNotEmpty) {
      // postList.value.clear();
      randomIndices.assignAll(randomNumberGenertor.generateRandomIndices(
          postList.value.length, 10));
      randomIndicesForSuggestedPages.assignAll(randomNumberGenertor
          .generateRandomIndices(postList.value.length, 10));
    }
  }

  //============================= Pick Media Files =========================================//

  Future<void> pickMediaFiles() async {
    isLoading.value = true;
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();

    if (mediaXFiles.isNotEmpty) {
      processedFileData.clear();
      processedCommentFileData.value = '';
      xfiles.value.clear();

      await checkFilesForVulgarity(mediaXFiles);
    }
    onTapCreatePost();
  }

  Future<void> checkFilesForVulgarity(List<XFile> newFiles) async {  debugPrint('🔥🔥🔥 NEW VERSION OF checkFilesForVulgarity RUNNING 🔥🔥🔥');

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
        checkingStatus.value = 'Checking ${i + 1}/${newFiles.length}: ${file.name}';

        ImageCheckerModel? checkerResponse;

        // Call appropriate checker based on file type
        if (filePath.endsWithAny(['.jpg', '.jpeg', '.png', '.gif', '.webp'])) {
          checkerResponse = await ImageCheckerService.checkImageForVulgarity(file);
        } else if (filePath.endsWithAny(['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'])) {
          checkerResponse = await ImageCheckerService.checkVideoForVulgarity(file);
        }

        if (checkerResponse != null) {
          debugPrint('API Response for ${file.name}: sexual=${checkerResponse.sexual}, data=${checkerResponse.data}');

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
    debugPrint('📋 Processed Comment file data: ${processedCommentFileData.value}');

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

//===========================Get People May YouKnow==================================//
  RxBool isLoadingPeopleYouMayKnow = false.obs;
  Future<List<PeopleMayYouKnowModel>> getPeopleMayYouKnow() async {
    isLoadingPeopleYouMayKnow.value = true;

    final apiResponse = await userRelationshipRepository
        .getAllPeopleInSuggestionWitPageIgnition(limit: 12, skip: 0);

    if (apiResponse.isSuccessful) {
      peopleMayYouKnowList.value =
          (apiResponse.data as List<PeopleMayYouKnowModel>);

      peopleMayYouKnowList.refresh();
      isLoadingPeopleYouMayKnow.value = false;
    } else {
      debugPrint('Error');
    }
    return peopleMayYouKnowList.value;
  }

  //================================Send Freind Request ===============================//
  RxBool isLoadingSendRequest = false.obs;

  void sendFriendRequest({
    required int index,
    required String userId,
  }) async {
    isLoadingSendRequest.value = true;

    final apiResponse = await userRelationshipRepository
        .sendFriendRequestToUser(userId: userId);
    isLoadingSendRequest.value = false;

    if (apiResponse.isSuccessful) {
      //Action on success
      peopleMayYouKnowList.value.removeAt(index);
      peopleMayYouKnowList.refresh();

      debugPrint('');
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> blockFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse =
        await userRelationshipRepository.blockAnUserByUserID(userId: userId);

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      Get.snackbar('Success', 'Successfully Blocked',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: PRIMARY_COLOR);
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  //======================================================== Post Related Functions ===============================================//
  RxBool isLoadingCreatePost = false.obs;
  void onTapCreatePost() async {
    await Get.toNamed(Routes.CREAT_POST, arguments: {
      // 'group_id': allGroupModel.value,
      'media_files': xfiles.value,
      'processed_file_data': processedFileData.value,
    });
    isLoadingCreatePost.value = true;
    pageNo = 1;
    totalPageCount = 0;
    postList.value.clear();
    getPosts(forceRecallAPI: true);
    isLoadingCreatePost.value = false;
  }

  void onTapEditPost(PostModel model) async {
    await Get.toNamed(Routes.EDIT_POST, arguments: model);
    postList.value.clear();
    await getPosts(forceRecallAPI: true);
    postList.refresh();
    // pageNo = 1;
  }
//============================= Get Posts =========================================//

  Future<void> getPosts({bool? forceRecallAPI}) async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await postRepository.getPosts(
      pageNo: pageNo,
      pageSize: pageSize,
      forceRecallAPI: forceRecallAPI,
    );

    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      totalPageCount = apiResponse.pageCount ?? 1;

      List<PostModel> fetchedPosts = apiResponse.data as List<PostModel>;

      // Step 1: Create a Set of existing post IDs
      Set<String?> existingPostIds =
          postList.value.map((post) => post.id).toSet();

      // Step 2: Filter out duplicates
      List<PostModel> uniqueFetchedPosts = fetchedPosts
          .where((post) => !existingPostIds.contains(post.id))
          .toList();

      // Step 3: Insert ads after every 5 posts
      List<PostModel> mergedPosts = [];
      int adIndex = 0;
      for (int i = 0; i < uniqueFetchedPosts.length; i++) {
        mergedPosts.add(uniqueFetchedPosts[i]);

        if ((i + 1) % 5 == 0 && adIndex < adsPostList.value.length) {
          mergedPosts.add(adsPostList.value[adIndex]);
          adIndex++;
        }
      }

      // Step 4: Add only new unique + ads posts to the list
      postList.value.addAll(mergedPosts);

      postList.refresh();
      generateRandomIndicesForPosts();
    } else {
      // Handle error response
    }
  }

//============================= Get Ads Posts =========================================//
  RxBool isLoadingAdPosts = false.obs;
  Rx<List<PostModel>> adsPostList = Rx([]); // Store ads posts separately

  Future<void> getAdsPagePosts() async {
    isLoadingAdPosts.value = true;

    final ApiResponse apiResponse = await postRepository.getAdsPagePosts(
      pageNo: pageNo,
      pageSize: pageSize,
    );
    isLoadingAdPosts.value = false;
    if (apiResponse.isSuccessful) {
      adsPostList.value.addAll(
          apiResponse.data as List<PostModel>); // Store the ads separately
      adsPostList.refresh(); // Refresh the ads list
    } else {
      // Handle Error
    }
  }

//============================= Get Video Ads =========================================//
  RxBool isLoadingVideoAds = false.obs;
  Future<void> getVideoAds() async {
    isLoadingVideoAds.value = true;

    final ApiResponse apiResponse = await postRepository.getVideoAds();
    isLoadingVideoAds.value = false;
    if (apiResponse.isSuccessful) {
      videoAdList.value = apiResponse.data as List<VideoCampaignModel>;
      // adsPostList.refresh(); // Refresh the ads list
      debugPrint('');
    } else {
      debugPrint('Unknown error in Video Ad');
    }
  }

// Video ad Index Dynamic

  void updateAdIndex() {
    if (videoAdList.value.isNotEmpty) {
      currentAdIndex.value =
          (currentAdIndex.value + 1) % videoAdList.value.length;
    }
  }
  // Future<void> getAdsPagePosts() async {
  //   isLoadingNewsFeed.value = true;

  //   final ApiResponse apiResponse = await postRepository.getAdsPagePosts(
  //     pageNo: pageNo,
  //     pageSize: pageSize,
  //   );
  //   isLoadingNewsFeed.value = false;
  //   if (apiResponse.isSuccessful) {
  //     // totalPageCount = apiResponse.pageCount ?? 1;
  //     postList.value.addAll(apiResponse.data as List<PostModel>);

  //     postList.refresh();
  //     generateRandomIndicesForPosts();
  //     // getPeopleMayYouKnow();
  //   } else {
  //     //Error Response
  //   }
  // }
//============================= React on Posts =========================================//

  Future<void> reactOnPost({
    required PostModel postModel,
    required String reaction,
    required String key,
    required int index,
  }) async {
    ReactionModel? reactionModel = postModel.reactionTypeCountsByPost
        ?.firstWhereOrNull((model) => (model.user_id == userModel.id));
    postModel.reactionTypeCountsByPost?.remove(reactionModel);
    if (reactionModel?.reaction_type != reaction) {
      postModel.reactionTypeCountsByPost?.add(ReactionModel.fromMap({
        'count': 1,
        'post_id': postModel.id,
        'reaction_type': reaction,
        'user_id': userModel.id,
        'user_details': {
          '_id': userModel.id,
          'first_name': userModel.first_name,
          'last_name': userModel.last_name,
          'username': userModel.username,
          'profile_pic': userModel.profile_pic,
        }
      }));
    }

    postModel.reactionCount = postModel.reactionTypeCountsByPost?.length ?? 0;
    postList.refresh();
    final apiResponse = await postRepository.reactOnPost(
      postModel: postModel,
      reaction: reaction,
      key: key,
    );

    if (apiResponse.isSuccessful) {
      debugPrint('Reaction done ::::::::::::::$reaction');
    }
  }
//============================= Report on Posts =========================================//

  Future<void> reportAPost({
    required String post_id,
    required String report_type,
    required String description,
    required String report_type_id,
  }) async {
    debugPrint('=================Report Start==========================');

    final apiResponse = await postRepository.reportAPost(
        post_id: post_id,
        report_type: report_type,
        description: description,
        report_type_id: report_type_id);

    debugPrint(
        '=================Report Api call end==========================');
    debugPrint(
        '=================Report Api status Code ${apiResponse.message}==========================');
    debugPrint(
        '=================Report Api success ${apiResponse.isSuccessful}==========================');

    if (apiResponse.isSuccessful) {
      debugPrint(
          '=================Report Successful==========================');

      // TODO: FIX THIS NAVIGATION ...
      Get.back();
      Get.back();
      Get.back();
      reportDescription.clear();

      showSuccessSnackkbar(message: 'Post reported successfully');
    } else {}
  }

//============================= Update Posts =========================================//
  Future<void> updatePostList(String postId, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'view-single-main-post-with-comments/$postId',
      responseDataKey: 'post',
    );
    if (apiResponse.isSuccessful) {
      List<PostModel> postmodelList =
          (apiResponse.data as List).map((e) => PostModel.fromMap(e)).toList();
      postList.value[index] = postmodelList.first;
      postList.refresh();
    }
  }
//============================= Hide Posts =========================================//

  Future<void> hidePost(int status, String post_id, int postIndex) async {
    ApiResponse apiResponse = await postRepository.hidePost(
      status: status,
      post_id: post_id,
    );

    if (apiResponse.isSuccessful) {
      postList.value.removeAt(postIndex);
      postList.refresh();
      Get.back();
    }
  }
//============================= Bookmark Posts =========================================//

  Future<void> bookmarkPost(
      String post_id, String postPrivacy, int index) async {
    ApiResponse apiResponse = await postRepository.bookMarkAPost(
      post_id: post_id,
      postPrivacy: postPrivacy,
    );

    updatePostList(post_id, index);
    postList.refresh();

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Post bookmark successfully');
    }
  }
//============================= Remove Bookmarks Posts =========================================//

  Future<void> removeBookmarkPost(
      String post_id, String bookMarkId, int index) async {
    ApiResponse apiResponse = await postRepository.unBookmarkAPost(
        post_id: post_id, bookMarkId: bookMarkId);

    if (apiResponse.isSuccessful) {
      Get.back();
      updatePostList(post_id, index);
      postList.refresh();
      showSuccessSnackkbar(message: 'remove bookmark');
    }
  }

  //======================================================== Comment Related Functions ===============================================//
  RxBool isLoadingPostComment = false.obs;
  Future<List<CommentModel>> getSinglePostsComments(String postID) async {
    isLoadingPostComment.value = true;

    Rx<List<CommentModel>> commentList = Rx([]);

    debugPrint(
        '==================get SinglePosts Comments=========Start==========================');

    final apiResponse =
        await postRepository.getAllCommentsOfAPost(postID: postID);
    isLoadingPostComment.value = false;

    debugPrint('invalid user code$apiResponse');

    debugPrint(
        '==================get SinglePosts Comments=========Api Call done==========================');

    if (apiResponse.isSuccessful) {
      debugPrint(
          '==================get SinglePosts Comments=========${apiResponse.data}==========================');

      commentList.value.addAll(apiResponse.data as List<CommentModel>);

      debugPrint(
          '===================get SinglePosts Commentsn=================${commentList.value}===');

      commentList.refresh();
      return commentList.value;
    } else {
      return [];
    }
  }

  Future<void> commentOnPost(int index, PostModel postModel) async {
    debugPrint('Comment API Called============================');
    if (commentController.text.isNotEmpty || xfiles.value.isNotEmpty) {
      final List<XFile> media = List.from(xfiles.value);
      final String comment = commentController.text.trim();

      commentController.clear();
      commentController.clearComposing();
      xfiles.value.clear();
      xfiles.refresh();

      final ApiResponse apiResponse = await postRepository.sendCommentOnAPost(
          postModel: postModel, comment: comment, processedFileData: processedCommentFileData.value);

      if (apiResponse.isSuccessful) {
        if (postList.value[index].comments != null) {
          updatePostList(postModel.id ?? '', index);
          commentController.clear();
          debugPrint('Hello');
          xfiles.value.clear();
        }
      } else {
        debugPrint('Failure');
      }
    } else {
      debugPrint('Can not do empty comment');
    }
  }

  Future<void> commentReply({
    required String comment_id,
    required String replies_comment_name,
    required String post_id,
    required int postIndex,
    required String file,
  }) async {
    if (replies_comment_name.isNotEmpty || file.isNotEmpty) {
      ApiResponse apiResponse = await postRepository.replyOnCommentOfAPost(
        comment_id: comment_id,
        replies_comment_name: replies_comment_name,
        post_id: post_id,
        replyUserID: userModel.id ?? '',
        files: processedCommentFileData.value,
      );

      if (apiResponse.isSuccessful) {
        updatePostList(post_id, postIndex);
        commentReplyController.text = '';

        xfiles.value.clear();
      }
    } else {
      debugPrint('Can not do empty replay comment');
    }
  }

  Future<void> commentReaction({
    required int postIndex,
    required String reaction_type,
    required String post_id,
    required String comment_id,
  }) async {
    debugPrint('⚡ Instant reaction triggered');

    final post = postList.value[postIndex];
    final comments = post.comments ?? [];

    final commentIndex = comments.indexWhere((c) => c.id == comment_id);
    if (commentIndex != -1) {
      final comment = comments[commentIndex];

      // ====== Find current user's reaction ======
      final currentUserId = userModel.id; // adjust if stored differently
      List<CommentReaction> updatedReactions =
      List<CommentReaction>.from(comment.comment_reactions ?? []);

      final existingIndex = updatedReactions
          .indexWhere((r) => r.user_id == currentUserId);

      if (existingIndex != -1) {
        // 🟢 Toggle / Update existing reaction
        if (updatedReactions[existingIndex].reaction_type == reaction_type) {
          // same reaction tapped → remove it
          updatedReactions.removeAt(existingIndex);
        } else {
          // change reaction type
          updatedReactions[existingIndex] = updatedReactions[existingIndex]
              .copyWith(reaction_type: reaction_type);
        }
      } else {
        // 🟢 Add new reaction
        updatedReactions.add(CommentReaction(
          user_id: UserIdModel(id: currentUserId).toString(),
          reaction_type: reaction_type,
        ));
      }

      // ====== Update UI instantly ======
      final updatedComment =
      comment.copyWith(comment_reactions: updatedReactions);
      comments[commentIndex] = updatedComment;
      post.comments = List<CommentModel>.from(comments);
      postList.value[postIndex] = post;
      postList.refresh();

      // ====== API Sync in background ======
      final apiResponse = await postRepository.reactOnComment(
        reaction_type: reaction_type,
        post_id: post_id,
        comment_id: comment_id,
      );

      if (!apiResponse.isSuccessful) {
        debugPrint('⚠️ Failed to sync comment reaction, consider reverting');
      } else {
        // Optional: fetch updated comments from backend to stay synced
        final updatedComments = await getSinglePostsComments(post_id);
        postList.value[postIndex].comments = updatedComments;
        postList.refresh();
      }
    }
  }



  Future<void> commentReplyReaction(
    int postIndex,
    String reaction_type,
    String post_id,
    String comment_id,
    String comment_replies_id,
  ) async {
    ApiResponse apiResponse = await postRepository.replyOnCommentWithReaction(
        reaction_type: reaction_type,
        post_id: post_id,
        comment_id: comment_id,
        comment_replies_id: comment_replies_id,
        userId: userModel.id ?? '');

    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      postList.value[postIndex].comments = comments;
      postList.refresh();
    }
  }

  void commentDelete(String comment_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await postRepository.deleteCommentFromAPost(
        comment_id: comment_id, post_id: post_id);

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, postIndex);
    }
  }

  void replyDelete(String reply_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await postRepository.deleteCommentReplyFromAPost(
        reply_id: reply_id, post_id: post_id);

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, postIndex);
    }
  }

  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();

    if (mediaXFiles.isNotEmpty) {
      await checkFilesForVulgarity(mediaXFiles);
    }
  }

  Future<void> onTapCreatePhotoComment(String userId, String postId, String key) async {
    debugPrint('===================Photo comment Start=====================');

    final ApiResponse response = await postRepository.createPhotoComment(
        userId: userId,
        postId: postId,
        comment: commentController.text.trim(),
        files: xfiles.value, key: key);

    if (response.isSuccessful) {
      debugPrint(
          '===================Photo comment ${response.statusCode}=====================');
    } else {
      debugPrint('');
    }
  }

  // ============================= Get User Data =========================================//
  Rx<ProfileModel?> profileModel = Rx<ProfileModel?>(null);
  Future getUserData() async {
    isLoading.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-user-info',
      requestData: {'username': '${loginCredential.getUserData().username}'},
      responseDataKey: 'userInfo',
    );
    if (apiResponse.isSuccessful) {
      debugPrint('Response success ${apiResponse.data as Map<String, dynamic>}');
      profileModel.value =
          ProfileModel .fromMap(apiResponse.data as Map<String, dynamic>);
      isLoading.value = false;
    } else {
      debugPrint('Response failed');
      isLoading.value = false;
    }
  }


  //======================================================== Story Related Functions ===============================================//

  void onTapCreateStory() {
    Get.toNamed(Routes.CREATE_STORY);
  }

  Future<void> getAllStory({bool? forceRecallAPI}) async {
    isLoadingStory.value = true;
    storyMergeList.value =
        await storyRepository.getAllStory(forceRecallAPI: forceRecallAPI);
    isLoadingStory.value = false;
  }

  void storyViewed(String storyId) async {
    bool isSuccessful = await storyRepository.storyViewed(
      userId: userModel.id ?? '',
      storyId: storyId,
    );
    if (isSuccessful) {
      debugPrint('Story Viewed Successfully');
    } else {
      debugPrint('Something went wrong on story view');
    }
  }

  void doReactionOnStory(String storyId, String reactionType) async {
    bool isSuccessful = await storyRepository.doReactionOnStory(
      userId: userModel.id ?? '',
      storyId: storyId,
      reactionType: reactionType,
    );
    if (isSuccessful) {
      debugPrint('Reacted onStory recation Successfully');
    } else {
      debugPrint('Something went wrong on story view');
    }
  }

  void deleteStory(String storyId) async {
    bool isSuccessful = await storyRepository.deleteStory(storyId);
    if (isSuccessful) {
      debugPrint('Reacted onStory recation Successfully');
      Get.back();
      Get.back();
      await getAllStory(forceRecallAPI: true);
    } else {
      debugPrint('Something went wrong on story view');
    }
  }

  //=========================================== For Scrolling List View

  Future<void> _scrollListener() async {
    if (postScrollController.position.pixels ==
        postScrollController.position.maxScrollExtent) {
      if (pageNo != totalPageCount) {
        pageNo += 1;
        await getPosts();
      }
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
  /////////////////////////////////////////////////////////////////////

  Future<void> shareUserPost(String sharePostId) async {
    ApiResponse apiResponse = await postRepository.shareUserPost(
        sharePostId: sharePostId,
        description: descriptionController.text.trim(),
        postTag: getPostPrivacyValue(postPrivacy.value));

    debugPrint(
        'Update model status code.............${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your post has been shared');
      pageNo = 1;
      totalPageCount = 0;
      postList.value.clear();
      getPosts(forceRecallAPI: true);
    } else {}
  }

  void sharePost(String text) {
    Share.share(text);
  }

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

  Future<List<AllPagesModel>> getSuggestedPages() async {
    suggestedPageList.value.clear();

    // ! CHANGE WITH ALERT >>>>>>>>>>>>>>>>>>>
    // ! CHANGING THE SEPARATION OF SUGGESTED PAGES GETTING OPERATION
    // ! NOW WE WILL BE COLLECTING THE FIRST BATCH AT ONCE
    // ApiResponse response = await pageRepository.getSuggestedPages();

    // @ SKIP == 0 && LIMIT == 12 is required
    ApiResponse response = await pageRepository.getAllPages(skip: 0, limit: 22);

    if (response.isSuccessful) {
      suggestedPageList.value = response.data as List<AllPagesModel>;
      suggestedPageList.refresh();
    }
    return suggestedPageList.value;
  }

  Future<void> followPage({required String pageId}) async {
    ApiResponse apiResponse = await pageRepository.followPage(pageId);

    if (apiResponse.isSuccessful) {
      //Action on success

      getSuggestedPages();

      debugPrint('');
    } else {
      debugPrint('Error');
    }

    // Todo: Action clear
  }

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();
    postScrollController = ScrollController();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    commentController = TextEditingController();
    commentReplyController = TextEditingController();
    descriptionController = TextEditingController();
    reportDescription = TextEditingController();
    generateRandomIndicesForPosts();
    await getUserData();
    // await getStories();
    super.onInit();
  }

  @override
  void onReady() {
    postScrollController.addListener(_scrollListener);
    super.onReady();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    reportDescription.clear();

    super.onClose();
  }
}
