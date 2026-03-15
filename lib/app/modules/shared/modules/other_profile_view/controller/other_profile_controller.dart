import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../models/chat/chat_model.dart';
import '../../../../../repository/chat_repository.dart';
import '../../../../tab_view/controllers/tab_view_controller.dart';
import '../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/personal_reels_model.dart';
import '../../../../../data/post_local_data.dart';
import '../../../../../enum/other_user_friend_follower_following.dart';
import '../../../../../models/follower_user_model.dart';
import '../../../../../models/following_user_model.dart';
import '../../../../NAVIGATION_MENUS/friend/model/people_may_you_khnow.dart';
import '../../../../../repository/post_repository.dart';
import '../../../../../utils/post_utlis.dart';
import '../../../../../utils/snackbar.dart';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../data/login_creadential.dart';
import '../../../../../models/api_response.dart';
import '../../../../../models/comment_model.dart';
import '../../../../../models/user.dart';
import '../../../../../models/friend.dart';
import '../../../../../models/post.dart';
import '../../../../../models/profile_model.dart';
import '../../../../../services/api_communication.dart';
import '../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/album_model.dart';
import '../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/photos_model.dart';
import '../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/profile_cover_albums_model.dart';
import '../../../../NAVIGATION_MENUS/user_menu/sub_menus/profile/models/story_model.dart';

class OthersProfileController extends GetxController {
  String? username;
  String? isFromReels;
  Rx<List<PhotoModel>> photoList = Rx([]);
  Rx<List<PhotoModel>> highlightPhotos = Rx([]); // First 6 photos for highlights
  Rx<List<ProfilrStoryModel>> storyList = Rx([]);
  Rx<List<VideoReel>> reelsList = Rx([]);
  Rx<List<ProfilPicturesemodel>> profilePicturesList = Rx([]);
  Rx<ProfileModel?> profileModel = Rx(null);
  Rx<List<AlbumModel>> albumsList = Rx([]);

  Rx<List<FriendModel>> friendList = Rx([]);
  late TextEditingController commentReplyController;
  RxString dropdownValue = privacyList.first.obs;
  RxString friendStatus = ''.obs;
  RxString connectedUserID = ''.obs;
  RxString respondToUserID = ''.obs;
  RxString followUnfollowStatus = ''.obs;
  Rx<bool> hasSentRequest = false.obs;
  Rx<bool> isFollowerResult = false.obs;
  Rx<bool> isLoadingUserRepost = false.obs;
  Rx<List<VideoReel>> repostList = Rx([]);

  final PostRepository postRepository = PostRepository();
  final ChatRepository chatRepository = ChatRepository();
  // Rx<List<SharedReelDetails>> sharedReelsList = Rx([]);

  int totalPageCount = 0;
  int pageNo = 1;
  final int pageSize = 10;
  RxBool isLoadingFriendList = true.obs;
  RxInt viewReelsTabNumber = 0.obs;
  RxBool isLoadingUserPhoto = true.obs;
  RxBool isLoadingUserSharedReels = true.obs;

  Rx<List<XFile>> xfiles = Rx([]);

  RxString searchKey = ''.obs;
  RxString unfriendId = ''.obs;
  Rx<List<FriendModel>> searchedFriendList = Rx([]);

  Rx<List<PeopleMayYouKnowModel>> peopleMayYouKnowList = Rx([]);
  TabViewController tabViewController = Get.find();

  RxBool friendRequestSent = false.obs;

  RxInt otherProfileWidgetViewNumber = 0.obs;
  RxInt otherProfileFriendsViewNumber = 0.obs;
  RxInt selectedProfileTab = 0.obs; // 0=All, 1=Reels, 2=Photos
  RxBool isLoadingNewsFeed = true.obs;
  RxBool isLoadingProfilePhoto = true.obs;

  /// Computed friend count from friendList
  int get friendCount => friendList.value.length;
  late ApiCommunication _apiCommunication;
  late UserModel currentUserModel;
  late TextEditingController commentController;
  RxString postPrivacy = 'public'.obs;
  late TextEditingController descriptionController;

  late ScrollController postScrollController;

  Rx<List<PostModel>> postList = Rx([]);

  var followingController = ''.obs;
  Rx<List<FollowingUserModel>> followingList = Rx([]);
  Rx<List<FollowingUserModel>> searchFollowingList = Rx([]);
  RxBool isLoadingFollowingList = true.obs;
  RxBool isLoadingUserReels = true.obs;

  var followerController = ''.obs;
  Rx<List<FollowerUserModel>> followerList = Rx([]);
  Rx<List<FollowerUserModel>> searchFollowerList = Rx([]);
  RxBool isLoadingFollowerList = true.obs;
  RxString buttonview = 'Photos'.obs;
  RxInt view = 0.obs;

  var selectedCategory = FriendCategory.All.obs;

  // Add methods to filter friend list based on the selected category
  void filterByCategory(FriendCategory category) {
    selectedCategory.value = category;
    if (category.index == 0) {
      otherProfileFriendsViewNumber.value = 0;
    }
    if (category.index == 1) {
      otherProfileFriendsViewNumber.value = 1;
    }
    if (category.index == 2) {
      otherProfileFriendsViewNumber.value = 2;
      getOtherUserFollowingUserList();
    }
    if (category.index == 3) {
      otherProfileFriendsViewNumber.value = 3;
      getOtherUserFollowerUserList();
    }
    // Add your logic to filter the friend list based on the category
  }

// Get Widget Number
  void getWidgetNumber() {
    if (isFromReels == 'true') {
      otherProfileWidgetViewNumber.value = 2;
      getUserReels(username ?? '');
    } else {
      otherProfileWidgetViewNumber.value = 0;
    }
  }

  // ====================================================== Other Profile Info =========================================== //

  Future getOtherUserData() async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-other-user-info',
      requestData: {'username': username},
      responseDataKey: 'userInfo',
    );
    if (apiResponse.isSuccessful) {
      debugPrint('Response success');
      profileModel.value =
          ProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);

      debugPrint('Response success');
    }
  }

// is other user friend or not
  Future<void> isOtherUserFriendOrNot() async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'is-request-or-friend',
      requestData: {'id': profileModel.value?.id},
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );
    if (apiResponse.isSuccessful) {
      hasSentRequest.value =
          (apiResponse.data as Map<String, dynamic>)['hasSentRequest'];

      var data = apiResponse.data as Map<String, dynamic>;
      if (data['results'] != null) {
        unfriendId.value = data['results']['_id'];
        if (hasSentRequest.value == false) {
          friendStatus.value =
              ((apiResponse.data as Map<String, dynamic>)['results']
                          ['accept_reject_status']) ==
                      null
                  ? ''
                  : (apiResponse.data as Map<String, dynamic>)['results']
                      ['accept_reject_status'];

          connectedUserID.value =
              ((apiResponse.data as Map<String, dynamic>)['results']
                          ['connected_user_id']['_id']) ==
                      null
                  ? ''
                  : (apiResponse.data as Map<String, dynamic>)['results']
                      ['connected_user_id']['_id'];

          respondToUserID.value = ((apiResponse.data
                      as Map<String, dynamic>)['results']['_id']) ==
                  null
              ? ''
              : (apiResponse.data as Map<String, dynamic>)['results']['_id'];
        }
      }
    }
  }
  //============================================= Get Shared Reels ==================================================//
// Future getSharedReels() async {
//   isLoadingUserSharedReels.value = true;
//   debugPrint('==========================get Reels Start');

//   // Adjusted API request
//   ApiResponse apiResponse = await _apiCommunication.doGetRequest(
//     apiEndPoint: 'profile/share-reels-list/$username',
//     responseDataKey: 'data', // Ensure this matches the key where `reels` resides in your API response
//   );

//   debugPrint('==========================get Reels After api call');
//   if (apiResponse.isSuccessful) {
//     debugPrint('==========================get Reels Before Model');
//     debugPrint('Response success');

//     // Map the response to SharedReelsModel
//     sharedReelsList.value = (apiResponse.data as List)
//     .map((e) => SharedReelsModel.fromMap(e as Map<String, dynamic>?)?.reels)
//     .whereType<SharedReelDetails>()
//     .toList();

//     debugPrint('Mapped Shared Reels List: ${sharedReelsList.value}');
//     debugPrint('==========================get Reels After model');
//   } else {
//     debugPrint('API call failed with error: ${apiResponse.message}');
//   }

//   isLoadingUserSharedReels.value = false;
// }
  //======================================================== Reels Related Functions ===============================================//
  final RxInt currentSkip = 0.obs;
  final int limit = 10;
  final RxBool hasMoreReels = true.obs;
  Future getUserReels(String userName) async {
    // if (isLoadingUserReels.value || !hasMoreReels.value) return;

    isLoadingUserReels.value = true;
    debugPrint('==========================get Reels Start');

    try {
      ApiResponse apiResponse = await _apiCommunication.doGetRequest(
          apiEndPoint:
              'profile/reels/$userName?skip=${currentSkip.value}&limit=$limit',
          // requestData: {'username': '${loginCredential.getUserData().username}'},
          responseDataKey: 'results');

      debugPrint('==========================get Reels After api call');
      if (apiResponse.isSuccessful) {
        debugPrint('==========================get Reels Before Model');
        debugPrint('Response success');
        List<VideoReel> newReels = (apiResponse.data as List)
            .map((e) => VideoReel.fromMap(e))
            .toList();
        reelsList.value.addAll(newReels);
        // Check if there are more items to load
        if (newReels.length < limit) {
          hasMoreReels.value = false;
        } else {
          currentSkip.value += limit; // Increment skip for next call
        }
      }
    } catch (e) {
      debugPrint('Error loading reels: $e');
    } finally {
      isLoadingUserReels.value = false;
    }
  }

// Delete User Reels
  Future<void> deleteUserReels(String reelsId, String key) async {
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'reels/delete-own-user-reel/:$reelsId',
      requestData: {
        'key': key
      }
    );

    if (apiResponse.isSuccessful) {
      getUserReels(username ?? '');
      showSuccessSnackkbar(message: 'reel deleted successfully');
    }
  }

//============================= Albums And Photo related Functions===================================
  // Get Other User Albums
  Future getOtherAlbums() async {
    isLoadingUserPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-users-album/$username',
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      albumsList.value = (apiResponse.data as List)
          .map(
            (e) => AlbumModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPhoto.value = false;
  }

//Get Other User Photos
  Future getOtherPhotos() async {
    debugPrint('==========================get Photo Start');

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'get-users-latest-image',
        requestData: {'username': username},
        responseDataKey: 'images');

    debugPrint('==========================get Photo After api call');
    if (apiResponse.isSuccessful) {
      debugPrint('==========================get Photo Before Model');
      debugPrint('Response success');
      photoList.value = (apiResponse.data as List)
          .map(
            (e) => PhotoModel.fromMap(e),
          )
          .toList();
      // Populate highlights with first 6 photos
      highlightPhotos.value = photoList.value.take(6).toList();
      highlightPhotos.refresh();
      debugPrint('Response success');
      debugPrint('==========================get Photo After model');
    }
  }

//Get Othe User Profile Pictures
  Future getProfilePictures() async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-users-albums-images',
      requestData: {
        'username': username,
        'albums_id': 'profile_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      profilePicturesList.value = (apiResponse.data as List)
          .map(
            (e) => ProfilPicturesemodel.fromMap(e),
          )
          .toList();
    }
  }

// Get Other User Stories
  Future getOtherStories() async {
    debugPrint('==========================get Story Start');

    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'get-users-latest-story',
        requestData: {'username': username},
        responseDataKey: 'storylist');

    debugPrint('==========================get Story After api call');
    if (apiResponse.isSuccessful) {
      debugPrint('==========================get Story Before Model');
      debugPrint('Response success');
      storyList.value = (apiResponse.data as List)
          .map(
            (e) => ProfilrStoryModel.fromMap(e),
          )
          .toList();
      debugPrint('Response success');
      debugPrint('==========================get Story After model');
    }
  }

// Filter Friends
  filterFriend(String key) {
    if (key.isNotEmpty) {
      searchKey.value = key;
      searchedFriendList.value = friendList.value
          .where((friendModel) =>
              friendModel.friend!.username
                  .toString()
                  .toLowerCase()
                  .contains(searchKey.value.toString().toLowerCase()) ||
              friendModel.friend!.firstName
                  .toString()
                  .toLowerCase()
                  .contains(searchKey.value.toString().toLowerCase()) ||
              friendModel.friend!.lastName
                  .toString()
                  .toLowerCase()
                  .contains(searchKey.value.toString().toLowerCase()))
          .toList();
      debugPrint('my friends: ${searchedFriendList.value}');
    } else {
      searchKey.value = '';
      debugPrint('friendList: ${friendList.value}');
    }
  }

  // ====================================================== Post related Function =========================================== //

  // Get Other User Posts
  Future<void> getPosts() async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await postRepository.getIndividualPosts(
      pageNo: pageNo,
      pageSize: pageSize,
      userName: username ?? '',
    );
    isLoadingNewsFeed.value = false;
    if (apiResponse.isSuccessful) {
      totalPageCount = apiResponse.pageCount ?? 1;
      postList.value.addAll(apiResponse.data as List<PostModel>);
      postList.refresh();
    } else {
      //Error Response
    }
  }

  // Get Other User React on A Post
  UserModel userModel = LoginCredential().getUserData();
  Future<void> reactOnPost({
    required PostModel postModel,
    required String reaction,
    required int index,
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
      key: postModel.key ?? '',
    );

    if (apiResponse.isSuccessful) {
      debugPrint('Reaction done ::::::::::::::$reaction');
    }
  }
  // Get Other User Share User Posts

  Future<void> shareUserPost(String sharePostId) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-share-post-with-caption',
        requestData: {
          'share_post_id': sharePostId,
          'description': descriptionController.text.toString(),
          'privacy': (getPostPrivacyValue(postPrivacy.value)),
        });

    debugPrint(
        'Update model status code.............${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your post has been shared');
      postList.value.clear();
      getPosts();
    } else {}
  }

// Update Post lists
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

  // ====================================================== Comment related Function =========================================== //
//Comment Reply
  void commentReply({
    required String comment_id,
    required String replies_comment_name,
    required String post_id,
    required int postIndex,
    required String file,
  }) async {
    debugPrint('reply function call');

    ApiResponse apiResponse = await _apiCommunication.doPostRequestNew(
        apiEndPoint: 'reply-comment-by-direct-post',
        enableLoading: true,
        requestData: {
          'comment_id': comment_id,
          'replies_user_id': currentUserModel.id,
          'replies_comment_name': replies_comment_name,
          'post_id': post_id,
          'image_or_video': file,
        },
        fileKey: 'image_or_video',);

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, postIndex);

      commentReplyController.text = '';

      xfiles.value.clear();
    }
  }

// comment reaction
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

  /// Reply comment reaction
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
          'user_id': currentUserModel.id,
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

// Get Single Post Comments
  Future<List<CommentModel>> getSinglePostsComments(String postID) async {
    isLoadingNewsFeed.value = true;

    Rx<List<CommentModel>> commentList = Rx([]);

    debugPrint(
        '==================get SinglePosts Comments=========Start==========================');

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-comments-direct-post/$postID',
    );
    isLoadingNewsFeed.value = false;

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

// Delete Comments
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

// Delete Replied Comments
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

//Comment on Post
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
          'key' : postModel.key ?? '',
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

// over rided method on refresh
  @override
  Future<void> refresh() async {
    clearProfileLists();
    pageNo = 1;
    totalPageCount = 0;
    currentSkip.value = 0;
    hasMoreReels.value = true;
    currentRepostSkip.value = 0;
    hasMoreRepostedReels.value = true;
    await getOtherUserData();
    await getFriends();
    await isOtherUserFriendOrNot();
    await isOtherUserFollowerOrNot();
    await getPosts();
    await getOtherPhotos();
    await getProfilePictures();
  }

  // ====================================================== Friend, Follower, Following , Block related Function =========================================== //

  Future<void> getFriends() async {
    isLoadingFriendList.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-friend?username=$username',
    );
    isLoadingFriendList.value = false;

    debugPrint('-friend controller---------------------------$apiResponse');

    if (apiResponse.isSuccessful) {
      friendList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => FriendModel.fromJson(element))
              .toList();
      friendList.refresh();
    } else {
      debugPrint('Error');
    }

    debugPrint('-friend controller---------------------------$apiResponse');
  }

// get Other user friends
  Future<void> getOtherUserFriends() async {
    isLoadingFriendList.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      requestData: {'username': username},
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'friend-list',
    );
    isLoadingFriendList.value = false;

    debugPrint('-friend controller---------------------------$apiResponse');

    if (apiResponse.isSuccessful) {
      friendList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => FriendModel.fromJson(element))
              .toList();
      friendList.refresh();
    } else {
      debugPrint('Error');
    }

    debugPrint('-friend controller---------------------------$apiResponse');
  }

  ///================================================================ Send And Cancel Friend Request=====================================//
  //send friend request
  void sendFriendRequest({
    // required int index,
    required String userId,
  }) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'send-friend-request',
        enableLoading: true,
        requestData: {
          'connected_user_id': userId,
        });
    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      isOtherUserFriendOrNot();
      debugPrint('');
    } else {}

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

//cancel friend request
  void cancelFriendRequest({
    // required int index,
    required String userId,
  }) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'cancel-friend-request',
        enableLoading: true,
        requestData: {
          'requested_user_id': userId,
        });
    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      isOtherUserFriendOrNot();
      debugPrint('');
    } else {}

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  //Accept or cancel friend request
  void actionOnFriendRequest({
    required int action, // 0 = reject, 1 = accpet
    required String requestId,
  }) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'friend-accept-friend-request',
        requestData: {'request_id': requestId, 'accept_reject_ind': action});
    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      if (action == 0) friendStatus.value = '';
      isOtherUserFriendOrNot();
      // getFriendRequestes();
      // getFriends();
      // showSuccessSnackkbar(message: 'Friend request canceled successfully');
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

// scroll listener function
  void _scrollListener() async {
    if (postScrollController.position.pixels ==
        postScrollController.position.maxScrollExtent) {
      if (pageNo <= totalPageCount) {
        pageNo += 1;
        await getPosts();
      }
    }
  }

//==================block friend==============//
  Future<void> blockFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'settings-privacy/block-user',
        requestData: {
          'block_user_id': userId,
        },
        enableLoading: true,
        errorMessage: 'block failed');

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      // getFriends();
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  //Other User Follower List ApI
  Future<void> getOtherUserFollowerUserList() async {
    isLoadingFollowerList.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'follower-list',
      requestData: {'username': username},
    );
    isLoadingFollowerList.value = false;

    if (apiResponse.isSuccessful) {
      followerList.value =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => FollowerUserModel.fromJson(element))
              .toList();
      debugPrint(followingList.value.length.toString());
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  ///Other user following list api
  Future<void> getOtherUserFollowingUserList() async {
    isLoadingFollowingList.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'following-list',
      requestData: {'username': username},
    );
    isLoadingFollowingList.value = false;

    if (apiResponse.isSuccessful) {
      followingList.value =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => FollowingUserModel.fromJson(element))
              .toList();
      debugPrint(followingList.value.length.toString());
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

//=================================unfollow==========================//
  Future<void> unfollowFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfollow-user',
      requestData: {
        'requestId': userId,
      },
      enableLoading: true,
      errorMessage: 'Unfriend failed',
    );

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      getFriends();
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  ///Followe unfollow request
  Future<void> followUnfollowOtherUser() async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'follower-unfollow-request',
      requestData: {
        'follower_user_id': profileModel.value?.id,
        'follow_unfollow_status': followUnfollowStatus.value
      },
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );
    if (apiResponse.isSuccessful) {
      isOtherUserFollowerOrNot();
      debugPrint(
          '==================Follow Unfollow Result: ${apiResponse.message}=====================');
    } else {
      debugPrint(
          '==================Follow Unfollow Failed: ${apiResponse.message}=====================');
    }
  }

  ///Other user is follower or not
  Future<void> isOtherUserFollowerOrNot() async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'is-follower',
      requestData: {'requested_user_id': profileModel.value?.id},
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: true,
    );
    if (apiResponse.isSuccessful) {
      isFollowerResult.value =
          (apiResponse.data as Map<String, dynamic>)['results'];
    }
  }

//======================================================== Repost Related Functions ===============================================//
  final RxInt currentRepostSkip = 0.obs;
  final int repostLimit = 10;
  final RxBool hasMoreRepostedReels = true.obs;
  Future getOtherRepostVideo() async {
    if (isLoadingUserRepost.value || !hasMoreRepostedReels.value) return;

    isLoadingUserRepost.value = true;
    try {
      ApiResponse apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint:
            'get-reels-re-post-list/$username?skip=$currentRepostSkip&limit=$repostLimit',
        responseDataKey: 'results',
      );

      if (apiResponse.isSuccessful) {
        List<VideoReel> newRepostedReels = (apiResponse.data as List)
            .map((e) => VideoReel.fromMap(e))
            .toList();
        repostList.value.addAll(newRepostedReels);
        // Check if there are more items to load
        if (newRepostedReels.length < repostLimit) {
          hasMoreRepostedReels.value = false;
        } else {
          currentRepostSkip.value +=
              repostLimit; // Increment skip for next call
        }
      }
    } catch (e) {
      debugPrint('Error loading reposted reels: $e');
    } finally {
      isLoadingUserRepost.value = false;
    }
  }

//=================================unfriend=====================//
  Future<void> unfriendFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfriend-user',
      requestData: {
        'requestId': unfriendId.value,
      },
      enableLoading: true,
      errorMessage: 'Unfriend failed',
    );

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      // getFriends();
      friendStatus.value = '';
      await isOtherUserFriendOrNot();
      // friendList.refresh();

      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

// clear profile lists method
  void clearProfileLists() {
    photoList.value.clear();
    storyList.value.clear();
    reelsList.value.clear();
    profilePicturesList.value.clear();
    albumsList.value.clear();
    postList.value.clear();
  }

//============================= Chat Related Functions===========================
  Rx<ChatModel> individualChatDetails = ChatModel().obs;
  Future<void> getIndividualChatDetails({required String userId}) async {
    ApiResponse apiResponse =
        await chatRepository.getIndividualChatDetails(userId: userId);

    if (apiResponse.isSuccessful) {
      final rawData = apiResponse.data;
      if (rawData != null && rawData is Map<String, dynamic>) {
        final data = rawData['data'];
        if (data != null && data is Map<String, dynamic>) {
          individualChatDetails.value = ChatModel.fromMap(data);
        }
      }
    }
  }

  @override
  void onReady() {
    postScrollController.addListener(_scrollListener);
    super.onReady();
  }

  @override
  Future<void> onInit() async {
    _apiCommunication = ApiCommunication();
    commentController = TextEditingController();
    currentUserModel = LoginCredential().getUserData();
    commentReplyController = TextEditingController();
    descriptionController = TextEditingController();
    postScrollController = ScrollController();
    username = '${Get.arguments['username']}';
    isFromReels = '${Get.arguments['isFromReels']}';
    clearProfileLists();
    await getOtherUserData();
    getWidgetNumber();

    await getFriends();
    // await getOtherUserFriends();
    await isOtherUserFriendOrNot();
    await isOtherUserFollowerOrNot();
    await getPosts();
    await getOtherPhotos(); // Preload photos for highlights
    await getProfilePictures();

    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
  }
}
    // controller.pageUserName = '${Get.arguments['pageUserName']}';
    // controller.isFromReels = '${Get.arguments['isFromPageReels']}';