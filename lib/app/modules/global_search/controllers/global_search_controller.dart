import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../repository/post_repository.dart';
import '../../../config/constants/api_constant.dart';
import '../../../data/login_creadential.dart';
import '../../../data/post_local_data.dart';
import '../../../models/api_response.dart';
import '../../../models/comment_model.dart';
import '../../../models/media.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';
import '../../../utils/post_utlis.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_communication.dart';
import '../../../config/constants/color.dart';
import '../../../utils/snackbar.dart';
import '../../NAVIGATION_MENUS/friend/model/search_people_model.dart';
import '../../NAVIGATION_MENUS/user_menu/sub_menus/all_groups/discover_groups/models/all_group_model.dart';
import '../../NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/allpages_model.dart';
import '../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/personal_reels_model.dart';

class GlobalSearchController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  RxInt tabIndex = 0.obs;
  Rx<List<SearchPeopleModel>> peopleList = Rx([]);
  Rx<List<PostModel>> postList = Rx([]);
  Rx<List<MediaModel>> photoList = Rx([]);
  Rx<List<MediaModel>> videoList = Rx([]);
  Rx<List<AllGroupModel>> allGroupList = Rx([]);
  Rx<List<AllPagesModel>> allPageList = Rx([]);
  Rx<List<VideoReel>> reelsList = Rx([]);
  RxBool isLoading = false.obs;
  RxBool isLoadingFeed = false.obs;
  RxBool isLoadingPhoto = false.obs;
  RxBool isLoadingVideo = false.obs;
  RxBool isLoadingGroup = false.obs;
  RxBool isLoadingPage = false.obs;
  RxBool isLoadingReels = false.obs;
  TextEditingController searchController = TextEditingController();
  late TextEditingController commentController;
  late TextEditingController commentReplyController;
  Rx<List<XFile>> xfiles = Rx([]);
  RxString dropdownValue = privacyList.first.obs;
  RxString postPrivacy = 'public'.obs;

  Future<void> getSearchPeople() async {
    isLoading.value = true;
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-user?search=${searchController.text}',
    );

    if (apiResponse.isSuccessful) {
      isLoading.value = false;
      peopleList.value.clear();
      peopleList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => SearchPeopleModel.fromMap(element))
              .toList();
      peopleList.refresh();
    } else {
      debugPrint('Error');
    }

    debugPrint('-friend controller---------------------------$apiResponse');
  }

  void sendFriendRequest({
    required int index,
    required String userId,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'send-friend-request',
        enableLoading: true,
        requestData: {
          'connected_user_id': userId,
        });

    if (apiResponse.isSuccessful) {
      peopleList.value[index].isFriendRequestSended = true;
      peopleList.refresh();

      debugPrint('');
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  void cancelFriendRequest({
    required int index,
    required String userId,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'cancel-friend-request',
        enableLoading: true,
        requestData: {
          ' requested_user_id ': userId,
        });

    if (apiResponse.isSuccessful) {
      peopleList.value[index].isFriendRequestSended = false;
      peopleList.refresh();

      debugPrint('');
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> getPhotos() async {
    isLoadingPhoto.value = true;
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-media?type=photo&search=${searchController.text}',
    );

    if (apiResponse.isSuccessful) {
      isLoadingPhoto.value = false;
      photoList.value.clear();
      photoList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => MediaModel.fromMap(element))
              .toList();
      photoList.refresh();
    } else {
      //Error Response
    }
  }

  Future<void> getGroups() async {
    isLoadingGroup.value = true;
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-group?search=${searchController.text}',
    );

    allGroupList.value.clear();

    if (apiResponse.isSuccessful) {
      isLoadingGroup.value = false;

      allGroupList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => AllGroupModel.fromMap(element))
              .toList();

      allGroupList.refresh();
      for (int i = 0; i < allGroupList.value.length; i++) {
        debugPrint('group length...............${allGroupList.value[i].groupName}');
      }
    } else {
      //Error Response
    }
  }

  Future<void> getPages() async {
    isLoadingPage.value = true;
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-page?search=${searchController.text}',
    );

    allPageList.value.clear();

    if (apiResponse.isSuccessful) {
      isLoadingPage.value = false;

      allPageList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => AllPagesModel.fromMap(element))
              .toList();

      allPageList.refresh();
      for (int i = 0; i < allPageList.value.length; i++) {
        debugPrint(
            'Page length...............${allPageList.value[i].pageName}');
      }
    } else {
      //Error Response
    }
  }

  Future<void> getReelsSearch() async {
    isLoadingReels.value = true;
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-reels?search=${searchController.text}',
    );

    allPageList.value.clear();

    if (apiResponse.isSuccessful) {
      isLoadingReels.value = false;

      reelsList.value =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => VideoReel.fromMap(element))
              .toList();

      reelsList.refresh();
      for (int i = 0; i < reelsList.value.length; i++) {
        debugPrint('Page length...............${reelsList.value[i].description}');
      }
    } else {
      //Error Response
    }
  }

  Future<void> getVideos() async {
    isLoadingVideo.value = true;
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-media?type=video&search=${searchController.text}',
    );

    if (apiResponse.isSuccessful) {
      isLoadingVideo.value = false;
      videoList.value.clear();
      videoList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => MediaModel.fromMap(element))
              .toList();
      videoList.refresh();
    } else {
      //Error Response
    }
  }

  Future<void> getPosts({String? text}) async {
    isLoadingFeed.value = true;
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-post?search=${searchController.text}',
    );

    if (apiResponse.isSuccessful) {
      isLoadingFeed.value = false;
      postList.value.clear();
      postList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => PostModel.fromMap(element))
              .toList();
      postList.refresh();
    } else {
      //Error Response
    }
  }

  Future<void> deletePost(String postId, int index) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'delete-post-by-id',
      requestData: {
        'postId': postId,
      },
    );

    debugPrint('api delete response.....${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your Post Has Been Deleted');
      postList.value.removeAt(index);
      postList.refresh();
    } else {
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> hidePost(int status, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'hide-unhide-post', requestData: {
      'status': status,
      'post_id': post_id,
    });

    if (apiResponse.isSuccessful) {
      postList.value.removeAt(postIndex);
      postList.refresh();
      Get.back();
    }
  }

  Future<void> bookmarkPost(String post_id, String postPrivacy) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'save-post-bookmark', requestData: {
      'post_privacy': postPrivacy,
      'post_id': post_id,
    });

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Post bookmark successfully');
    }
  }

//React on A Post
  PostRepository postRepository = PostRepository();
  Future<void> reactOnPost({
    required PostModel postModel,
    required String reaction,
    required int index,
    required String key,
  }) async {
    applyOptimisticReaction(
      post: postModel,
      userId: userModel.id ?? '',
      reactionType: reaction,
      userDetails: {
        '_id': userModel.id,
        'first_name': userModel.first_name,
        'last_name': userModel.last_name,
        'username': userModel.username,
        'profile_pic': userModel.profile_pic,
      },
    );
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

  // Future<void> shareUserPost(String sharePostId) async {
  //   ApiResponse apiResponse = await _apiCommunication.doPostRequest(
  //       apiEndPoint: 'save-share-post-with-caption',
  //       requestData: {
  //         'share_post_id': sharePostId,
  //         'description': descriptionController.text.toString(),
  //         'privacy': (getPostPrivacyValue(postPrivacy.value)),
  //       });
  //
  //   debugPrint(
  //       'Update model status code.............${apiResponse.statusCode}');
  //
  //   if (apiResponse.isSuccessful) {
  //     showSuccessSnackkbar(message: 'Your post has been shared');
  //     postList.value.clear();
  //     getPosts();
  //   } else {}
  // }

//======================================================== Comment Related Functions ===============================================//

  Future<List<CommentModel>> getSinglePostsComments(String postID) async {
    isLoading.value = true;

    Rx<List<CommentModel>> commentList = Rx([]);
    debugPrint(
        '==================get SinglePosts Comments=========Start==========================');

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-comments-direct-post/$postID',
    );
    isLoading.value = false;

    debugPrint('ivalid user code$apiResponse');

    debugPrint(
        '==================get SinglePosts Comments=========Api Call done==========================');

    if (apiResponse.isSuccessful) {
      debugPrint(
          '==================get SinglePosts Comments=========${apiResponse.data}==========================');

      commentList.value.addAll(
          (((apiResponse.data as Map<String, dynamic>)['comments']) as List)
              .map((element) => CommentModel.fromMap(element))
              .toList());

      debugPrint(
          '===================get SinglePosts Commentsn=================${commentList.value}===');

      commentList.refresh();
      return commentList.value;
    } else {
      return [];
    }
  }

  Future<void> blockFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'settings-privacy/block-user',
        requestData: {
          'block_user_id': userId,
        },
        enableLoading: false,
        errorMessage: 'block failed');

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      // getFriends();
      // friendList.refresh();

      Get.snackbar('Success', 'Successfully Blocked',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: PRIMARY_COLOR);
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future commentOnPost(int index, PostModel postModel) async {
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-user-comment-by-post',
        isFormData: true,
        enableLoading: true,
        requestData: {
          'user_id': postModel.user_id?.id,
          'post_id': postModel.id,
          'comment_name': commentController.text,
          'link': null,
          'link_title': null,
          'link_description': null,
          'link_image': null,
          'key': postModel.key,
        },
        fileKey: 'image_or_video',
        mediaXFiles: xfiles.value);

    if (apiResponse.isSuccessful) {
      if (postList.value[index].comments != null) {
        // postList.value[index].comments!.add(
        //     CommentModel.fromMap(apiResponse.data as Map<String, dynamic>));
        // postList.refresh();
        updatePostList(postModel.id ?? '', index);
        commentController.clear();
        debugPrint('Hello');
        xfiles.value.clear();
      }
    } else {
      debugPrint('Failure');
    }
  }

  void commentReply({
    required String comment_id,
    required String replies_comment_name,
    required String post_id,
    required int postIndex,
    required String file,
  }) async {
    debugPrint('reply function call');

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'reply-comment-by-direct-post',
        enableLoading: true,
        isFormData: true,
        requestData: {
          'comment_id': comment_id, //"663a15f5001ab86d881e81e7",
          'replies_user_id': userModel.id, //"6545c99d858780bf50dfc1eb",
          'replies_comment_name': replies_comment_name, //"123123",
          'post_id': post_id, //"6639e808a45d87b49746a3f0"
          'image_or_video': file.isEmpty ? null : file,
        },
        fileKey: 'image_or_video',
    );

    if (apiResponse.isSuccessful) {
      // List<CommentModel> comments = await getSinglePostsComments(post_id);
      // postList.value[postIndex].comments = comments;
      // postList.refresh();
      updatePostList(post_id, postIndex);

      commentReplyController.text = '';

      xfiles.value.clear();
    }
  }

  void commentReaction({
    required int postIndex,
    required String reaction_type,
    required String post_id,
    required String comment_id,
  }) async {
    debugPrint('===================================reaction function  call');

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-comment-reaction-of-direct-post',
        requestData: {
          'reaction_type': reaction_type,
          'post_id': post_id,
          'comment_id': comment_id
        });

    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      postList.value[postIndex].comments = comments;
      postList.refresh();
    }
  }

  void commentReplyReaction(
    int postIndex,
    String reaction_type,
    String post_id,
    String comment_id,
    String comment_replies_id,
  ) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-comment-reaction-of-direct-post',
        requestData: {
          'reaction_type': reaction_type,
          'user_id': userModel.id,
          'post_id': post_id,
          'comment_id': comment_id,
          'comment_replies_id': comment_replies_id,
        });

    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      postList.value[postIndex].comments = comments;
      postList.refresh();
    }
  }

  void commentDelete(String comment_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment',
        requestData: {
          'comment_id': comment_id,
          'post_id': post_id,
          'type': 'main_comment'
        });

    if (apiResponse.isSuccessful) {
      List<CommentModel> comments = await getSinglePostsComments(post_id);
      postList.value[postIndex].comments = comments;
      postList.refresh();
    }
  }

  void replyDelete(String reply_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment',
        requestData: {
          'comment_id': reply_id,
          'post_id': post_id,
          'type': 'reply_comment'
        });

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, postIndex);
    }
  }

  Future<void> pickFiles() async {
    debugPrint('=================X file Value start====================');

    final ImagePicker picker = ImagePicker();
    xfiles.value = await picker.pickMultipleMedia();

    debugPrint(
        '=================X file Value====================${xfiles.value}');
  }

  Future<void> onTapCreatePhotoComment(String userId, String postId, String key) async {
    debugPrint('===================Photo comment Start=====================');

    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-user-comment-by-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'user_id': userId, //postModel.user_id?.id,
        'post_id': postId, //postModel.id,
        'comment_name': commentController.text,
        'image_or_video': null,
        'link': null,
        'link_title': null,
        'link_description': null,
        'link_image': null,
        'key': key,
      },
      mediaXFiles: xfiles.value,
    );

    if (response.isSuccessful) {
      debugPrint(
          '===================Photo comment ${response.statusCode}=====================');
    } else {
      debugPrint('');
    }
  }

  void onTapEditPost(PostModel model) async {
    await Get.toNamed(Routes.EDIT_POST, arguments: model);
    postList.value.clear();
    getPosts();
  }

  // Future joinGroupRequestPost({String? groupId, String? type, String? userIdArray,int? index}) async {
  //
  //   ApiResponse apiResponse = await _apiCommunication.doPostRequest(
  //       apiEndPoint: 'groups/send-group-invitation-join-request',
  //       requestData: {
  //         'group_id':groupId,
  //         'type': type??'join',
  //         'user_id_arr':[userIdArray]
  //       }
  //   );
  //
  //   if (apiResponse.isSuccessful) {
  //     // getAllGroups().whenComplete(()=>
  //     //
  //     //     showSnackkbar(titile: 'Success', message: 'Join request sent successfully')
  //     // );
  //
  //     showSnackkbar(titile: 'Success', message: 'Join request sent successfully');
  //
  //     allGroupList.value[index!].joinedGroupsCount = 1;
  //     allGroupList.refresh();
  //
  //
  //
  //     debugPrint('::::::::::::::Join Group response SUCCESSSSS: ${apiResponse.message}::::::::::::::::::::::::');
  //
  //   }
  //   else{
  //     debugPrint('::::::::::::::Join Group response FAILEDDDDD: ${apiResponse.message}::::::::::::::::::::::::');
  //
  //   }
  // }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    commentController = TextEditingController();
    commentReplyController = TextEditingController();
    super.onInit();
  }
}
