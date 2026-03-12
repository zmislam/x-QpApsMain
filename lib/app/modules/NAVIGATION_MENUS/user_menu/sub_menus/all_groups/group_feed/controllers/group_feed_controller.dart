import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../data/post_local_data.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/comment_model.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../models/user.dart';
import '../../../../../../../models/video_campaign_model.dart';
import '../../../../../../../repository/post_repository.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/post_utlis.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../create_group/models/friend_list_model.dart';
import '../../discover_groups/controllers/discover_groups_controller.dart';
import '../../discover_groups/models/all_group_model.dart';
import '../../group_profile/models/group_album_model.dart';
import '../../group_profile/models/group_file_list_model.dart';
import '../../group_profile/models/group_photo_model.dart';

class GroupFeedController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  final PostRepository postRepository = PostRepository();
  DiscoverGroupsController groupsController = Get.find();

  late TextEditingController descriptionController;
  Rx<List<FriendResultModel>> friendList = Rx([]);
  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingProfilePhoto = false.obs;
  Rx<List<GroupPhotoModel>> photoList = Rx([]);
  Rx<List<GroupProfileAlbumModel>> groupProfileAlbumList = Rx([]);
  var currentAdIndex = 0.obs;

  Rx<List<VideoCampaignModel>> videoAdList = Rx([]);
  Rx<List<FileItem>> fileItemsList = Rx([]);
  Rx<List<FriendResultModel>> selectedFriendList = Rx([]);

  RxBool isCommentReactionLoading = true.obs;
  RxBool isReplyReactionLoading = true.obs;
  RxBool updateCheckBox = true.obs;
  RxBool isGroupMember = true.obs;
  RxInt storyCaroselInitialIndex = 0.obs;
  Rx<int> groupProfileWidgetViewNumber = 0.obs;
  Rx<List<PostModel>> postList = Rx([]);
  AllGroupModel? allGroupModel;
  late ScrollController postScrollController;
  RxString dropdownValue = privacyList.first.obs;
  RxString postPrivacy = 'public'.obs;
  String? groupId;

  Rx<List<XFile>> xfiles = Rx([]);

  RxString commentsID = ''.obs;
  RxString postID = ''.obs;

  RxBool isLoadingNewsFeed = true.obs;

  int pageNo = 1;
  final int pageSize = 10;
  int totalPageCount = 0;
  RxBool isNextPage = false.obs;
  late TextEditingController commentController;
  late TextEditingController commentReplyController;
  RxBool isReply = false.obs;

  final count = 0.obs;

  //React on A Post
  Future<void> reactOnPost({
    required PostModel postModel,
    required String reaction,
    required String key,
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
      key: key
    );

    if (apiResponse.isSuccessful) {
      debugPrint('Reaction done ::::::::::::::$reaction');
    }
  }

///////////////////////////Leave From Group///////////////////////////////////////
  Future<void> leaveFromGroupPatch() async {
    final apiResponse = await _apiCommunication.doPatchRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint:
          'group-member-status-change?group_id=${allGroupModel?.id}&user_id=${userModel.id}&status=left',
    );

    if (apiResponse.isSuccessful) {
      // updateReactionLocally(
      //     index: index, postId: postModel.id ?? '', reaction: reaction);
      debugPrint(apiResponse.message);
      Get.back();
      showSuccessSnackkbar(
          message:
              'Leaved from ${allGroupModel?.groupName?.capitalizeFirst} successfully');
      // updatePostList(postModel.id ?? '', index);
    } else {
      debugPrint(apiResponse.message);
      showSuccessSnackkbar(
          message:
              'Leaved from ${allGroupModel?.groupName?.capitalizeFirst} failed');
    }
  }
//============================= Get Video Ads =========================================//

  Future<void> getVideoAds() async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await postRepository.getVideoAds();
    isLoadingNewsFeed.value = false;
    if (apiResponse.isSuccessful) {
      videoAdList.value = apiResponse.data as List<VideoCampaignModel>;
      // adsPostList.refresh(); // Refresh the ads list
      debugPrint('');
    } else {
      debugPrint('Unknown error in Video Ad');
    }
  }

//--------------------------------------  Friend List for Invitation in Group----------------------------//
  // Future<void> inviteFriendList() async {
  //   final ApiResponse apiResponse = await _apiCommunication.doPostFormRequest(
  //     apiEndPoint: 'friend-list-for-group-invitation',
  //     enableLoading: true,
  //     responseDataKey: 'results',
  //     requestData: {'group_id': allGroupModel?.id},
  //   );

  //   if (apiResponse.isSuccessful) {
  //     debugPrint(
  //         '::::::::::::::::::::::::My Friend List::::::${apiResponse.data}:::::::::::::::::::::::::');

  //     if (apiResponse.data != null && apiResponse.data is List) {
  //       friendList.value = (apiResponse.data as List)
  //           .map((e) => FriendListResult.fromMap(e))
  //           .toList();
  //     } else {
  //       debugPrint('Friend list data is null or not a list.');
  //       friendList.value = [];
  //     }
  //   } else {
  //     debugPrint(
  //         '"""""""""""""Friend List Error:::::::::${apiResponse.message}');
  //   }
  // }

//--------------------------------------  Is Joined Group Or Not(Get Group Details By Id)----------------------------//
  Future<void> groupMemberCheckPost() async {
    final ApiResponse apiResponse = await _apiCommunication.doPostFormRequest(
      apiEndPoint: 'get-group-details-by-id',
      enableLoading: true,
      responseDataKey: 'isMember',
      requestData: {'group_id': allGroupModel?.id},
    );

    if (apiResponse.isSuccessful) {
      debugPrint(
          '::::::::::::::::::::::::My Friend List::::::${apiResponse.data}:::::::::::::::::::::::::');

      if (apiResponse.data != null) {
        isGroupMember.value = (apiResponse.data as bool);
      } else {
        debugPrint('Error groupMemberCheckPost API');
      }
    } else {
      debugPrint(
          '"""""""""""""Group Member Error:::::::::${apiResponse.message}');
    }
  }

//-------------------------------------- Send Invitation to Friends in Group----------------------------//
  Future<void> sendFriendInvitation({String? userIdArr}) async {
    List<String> selectedFriendIds = selectedFriendList.value
        .map((friend) => friend.friend?.id)
        .where((id) => id != null)
        .cast<String>()
        .toList();
    debugPrint(
        ':::::::::::::::::My Selected Frineds:::$selectedFriendIds :::::::::::::::::::::::::::::::::::');
    final ApiResponse apiResponse = await _apiCommunication.doPostFormRequest(
      apiEndPoint: 'groups/send-group-invitation-join-request',
      enableLoading: true,
      requestData: {
        'group_id': allGroupModel?.id,
        'type': 'invite',
        'user_id_arr': selectedFriendIds
      },
    );

    if (apiResponse.isSuccessful) {
      debugPrint(
          '::::::::::::::::::::::::My Friend List::::::${apiResponse.data}:::::::::::::::::::::::::');
      Get.back();
      friendList.refresh();
      selectedFriendList.value = [];
    } else {
      debugPrint(
          '"""""""""""""Friend List Error:::::::::${apiResponse.message}');
    }
  }

  //////////////////////////////Update Post List//////////////////////////////////////////////////
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

  //////////////////////////////Get Group Files//////////////////////////////////////////////////
  Future<void> fetchGroupFiles() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'groups/get-group-files/${allGroupModel?.id}',
      responseDataKey: 'result',
    );
    if (apiResponse.isSuccessful) {
      if (apiResponse.data != null && apiResponse.data is List) {
        fileItemsList.value =
            (apiResponse.data as List).map((e) => FileItem.fromMap(e)).toList();
      } else {
        debugPrint('Group File list data is null or not a list.');
        // friendList.value = [];
      }
    }
  }

  //////////////////////////////Comment Delete//////////////////////////////////////////////////

  void commentDelete(String comment_id, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment',
        requestData: {
          'comment_id': comment_id,
          'post_id': post_id,
          'type': 'main_comment'
        });

    if (apiResponse.isSuccessful) {
      updatePostList(post_id, postIndex);
    }
  }
  //////////////////////////////Reply Delete//////////////////////////////////////////////////

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
  //////////////////////////////Comment On Post//////////////////////////////////////////////////

  Future commentOnPost(int index, PostModel postModel) async {
    debugPrint('Comment API Called============================');
    if (commentController.text.isNotEmpty || xfiles.value.isNotEmpty) {
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
            'key' : postModel.key,
          },
          fileKey: 'image_or_video',
          mediaXFiles: xfiles.value,
          responseDataKey: 'posts');

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
  //////////////////////////////Comment Reply//////////////////////////////////////////////////

  void commentReply({
    required String comment_id,
    required String replies_comment_name,
    required String post_id,
    required int postIndex,
    required String file,
  }) async {
    if (replies_comment_name.isNotEmpty || xfiles.value.isNotEmpty) {
      ApiResponse apiResponse = await _apiCommunication.doPostRequestNew(
          apiEndPoint: 'reply-comment-by-direct-post',
          enableLoading: true,
          requestData: {
            'comment_id': comment_id,
            'replies_user_id': userModel.id,
            'replies_comment_name': replies_comment_name,
            'post_id': post_id,
            'image_or_video': file,
          },
          fileKey: 'image_or_video');

      if (apiResponse.isSuccessful) {
        updatePostList(post_id, postIndex);
        commentReplyController.text = '';

        xfiles.value.clear();
      }
    } else {
      debugPrint('Can not do empty replay comment');
    }
  }
  //////////////////////////////Comment Reaction//////////////////////////////////////////////////

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
  //////////////////////////////Comment Reply Reaction//////////////////////////////////////////////////

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
  //////////////////////////////Get Single Post Comments//////////////////////////////////////////////////

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

  Future<void> pickFiles() async {
    debugPrint('=================X file Value start====================');

    final ImagePicker picker = ImagePicker();
    xfiles.value = await picker.pickMultipleMedia();

    debugPrint(
        '=================X file Value====================${xfiles.value}');
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
      Get.back();
      // getFriends();
      // friendList.refresh();

      showSuccessSnackkbar(message: 'Successfully blocked');
      debugPrint(
          '===============================================Block Successs');
    } else {
      showErrorSnackkbar(message: 'Error blocking');
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
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
        'key' : key
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

  //======================================================== Post Related Functions ===============================================//
  void onTapCreatePost() async {
    await Get.toNamed(Routes.CREATE_GROUP_POST, arguments: allGroupModel);
    pageNo = 1;
    totalPageCount = 0;
    postList.value.clear();
    getGroupFeedPosts();
  }

  void onTapEditPost(PostModel model) async {
    await Get.toNamed(Routes.EDIT_POST, arguments: model);
    postList.value.clear();
    getGroupFeedPosts();
  }

  Future<void> getGroupFeedPosts({bool? forceRecallAPI}) async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await postRepository.getGroupFeedPosts(
        pageNo: pageNo, pageSize: pageSize, forceRecallAPI: forceRecallAPI);

    if (apiResponse.isSuccessful) {
      isLoadingNewsFeed.value = false;
      totalPageCount = apiResponse.pageCount ?? 1;
      postList.value.addAll(apiResponse.data as List<PostModel>);
      postList.refresh();
    } else {
      debugPrint(
          '::::::::::::::::::::::::::::: Get Group Feed Post Error:::::::${apiResponse.message}');
      //Error Response
    }
  }

  ///==============================================Get Group All Photos and Vides=======================================================////
  Future getGroupPhotos() async {
    isLoadingUserPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-group-latest-image-video',
      requestData: {
        'group_id': allGroupModel?.id,
      },
      responseDataKey: 'images',
    );

    if (apiResponse.isSuccessful) {
      photoList.value = (apiResponse.data as List)
          .map(
            (e) => GroupPhotoModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPhoto.value = false;
  }

  Future getGroupAlbums() async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-groups-albums-images',
      requestData: {
        'group_id': allGroupModel?.id,
        'albums_id': 'cover_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      groupProfileAlbumList.value = (apiResponse.data as List)
          .map(
            (e) => GroupProfileAlbumModel.fromMap(e),
          )
          .toList();
    }
  }
  //=========================================== For Scrolling List View

  Future<void> _scrollListener() async {
    if (postScrollController.position.pixels ==
        postScrollController.position.maxScrollExtent) {
      debugPrint('Scroll::::::::::::::::::');
      if (pageNo != totalPageCount) {
        pageNo += 1;
        await getGroupFeedPosts();
      }
    }
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

  Future<void> bookmarkPost(
      String post_id, String postPrivacy, int index) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'save-post-bookmark', requestData: {
      'post_privacy': postPrivacy,
      'post_id': post_id,
    });

    postList.value[index].isBookMarked = true;
    postList.refresh();

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Post bookmark successfully');
    }
  }

  Future<void> removeBookmarkPost(String bookMarkId, int index) async {
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'remove-post-bookmark/$bookMarkId',
    );

    if (apiResponse.isSuccessful) {
      Get.back();
      postList.value[index].isBookMarked = false;
      postList.refresh();
      showSuccessSnackkbar(message: 'remove bookmark');
    }
  }

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
      pageNo = 1;
      totalPageCount = 0;
      postList.value.clear();
      getGroupFeedPosts();
    } else {}
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

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();
    postScrollController = ScrollController();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    await getVideoAds();
    // allGroupModel = Get.arguments;
    await getGroupFeedPosts();
    await groupMemberCheckPost();
    await getGroupPhotos();
    await getGroupAlbums();
    // fetchGroupFiles();

    commentController = TextEditingController();
    commentReplyController = TextEditingController();
    descriptionController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    postScrollController.addListener(_scrollListener);
    super.onReady();
  }

  void increment() => count.value++;
}
