import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/utils/logger/logger.dart';
import '../../../../../home/controllers/home_controller.dart';
import '../component/page_about.dart';
import '../component/page_feed_component.dart';
import '../component/page_more_options/pages_videos_view.dart';
import '../component/page_photos_component.dart';
import '../component/page_reels_all_components/page_main_reels_component.dart';
import '../../../profile/models/personal_reels_model.dart';
import '../../../../../../../models/video_campaign_model.dart';

import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../data/post_local_data.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/comment_model.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../models/user.dart';
import '../../../../../../../repository/page_repository.dart';
import '../../../../../../../repository/post_repository.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/post_utlis.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../../profile/models/album_model.dart';
import '../../admin_page/model/admin_media_model.dart';
import '../../admin_page/model/admin_page_followers_model.dart';
import '../../admin_page/model/admin_page_video_model.dart';
import '../../admin_page/model/media_photo_model.dart';
import '../../admin_page/model/page_photos_model.dart';
import '../../admin_page/model/page_profile_picture_model.dart';
import '../../pages/model/allpages_model.dart';
import '../../pages/model/invitation_model.dart';
import '../../pages/model/page_friend_model.dart';
import '../../pages/model/report_model.dart';
import '../model/page_profile_model.dart';

class PageProfileController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  RxBool isLoadingProfilePhoto = true.obs;
  RxInt viewReelsTabNumber = 0.obs;
  final RxList<Widget> widgetList = <Widget>[].obs;
  // RxBool isLoadingProfilePhoto = false.obs;
  RxBool isLoadingCoverPhoto = false.obs;
  RxBool isLoadingMediaPhoto = false.obs;
  String isFromPageReels = 'false';
  HomeController homeController = Get.find();
  Rx<PageProfileModel?> pageProfileModel = Rx(null);
  Rx<List<AlbumModel>> albumsList = Rx([]);
  Rx<List<PageInvitationModel>> pageInvitationList = Rx([]);
  Rx<List<PageFriendmodel>> pageFriendList = Rx([]);
  Rx<List<PageFriendmodel>> selectedPagefriendList = Rx([]);
  Rx<List<PageInvitationModel>> selectedPageInvitationList = Rx([]);
  final selectedPageInvitationIds = <String>{}.obs; // Use a Set for uniqueness
  late TabController tabController;

  String? pageUserName;
  PageReportModel? pageReportModel;
  final PostRepository postRepository = PostRepository();
  Rx<List<VideoCampaignModel>> videoAdList = Rx([]);
  Timer? debounce;
  // String? pageId;
  RxInt viewNumber = 0.obs;
  RxInt currentAdIndex = 0.obs;
  Rx<List<PostModel>> postList = Rx([]);
  Rx<List<PostModel>> pinnedPostList = Rx([]);
  RxString postPrivacy = 'public'.obs;
  RxString dropdownValue = privacyList.first.obs;
  AllPagesModel? allPagesModel;
  RxBool isFollowing = false.obs;
  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingUserVideo = false.obs;
  RxBool isLoadingUserPages = false.obs;
  RxBool isLoadingFriendList = false.obs;
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;

  Rx<List<PageReportModel>> pageReportList = Rx([]);

  RxInt view = 0.obs;
  RxString buttonview = 'Photos of you'.obs;

  late UserModel userModel;

  Rx<List<AdminPageFollowersModel>> pagefollowersList = Rx([]);
  Rx<List<PageMediaPhotosModel>> pageMediaList = Rx([]);
  Rx<List<Pagephotosmodel>> pagePhotosList = Rx([]);
  Rx<List<AdminPageProfilePictureModel>> profilePicturesList = Rx([]);
  Rx<List<AdminPageProfilePictureModel>> coverPhotosList = Rx([]);
  Rx<List<AdminPageVideoModel>> pageVideoList = Rx([]);
  bool _hasLoadedInitial = false;
  bool _isBootstrapping = false;
  String? _loadedForPage;

  Rx<List<PageMediaModel>> mediaAlbumList = Rx([]);

  late TextEditingController commentController;
  late TextEditingController commentReplyController;
  late TextEditingController descriptionController;
  Rx<List<XFile>> xfiles = Rx([]);

  RxBool isLoadingNewsFeed = false.obs;
  int pageNo = 1;
  final int pageSize = 10;
  int totalPageCount = 0;
  final PageRepository pageRepository = PageRepository();

  final count = 0.obs;

  Future<void> initiateAllAPiCall({bool force = false}) async {
    if (_isBootstrapping) return;
    // Prevent rebuild-triggered wipes; only refresh when forced or page changes.
    if (!force &&
        _hasLoadedInitial &&
        _loadedForPage == pageUserName &&
        postList.value.isNotEmpty) {
      return;
    }

    _isBootstrapping = true;
    _hasLoadedInitial = true;
    _loadedForPage = pageUserName;
    pageNo = 1;
    totalPageCount = 0;
    clearPageProfileLists();

    try {
      await getPageDetails();
      await getVideos(pageUserName ?? '');
      await getVideoAds();
      await getPageUserReels(pageUserName: pageUserName ?? '');
      await getPagePhotos(pageUserName ?? '');
      await getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
    } finally {
      _isBootstrapping = false;
    }
  }

  Future getPageDetails() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-page-details/$pageUserName',
      responseDataKey: 'data',
    );
    if (apiResponse.isSuccessful) {
      pageProfileModel.value =
          PageProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);
      await getPagePosts(pageProfileModel.value?.pageDetails?.id ?? '',
          reset: true);
      debugPrint('Response success');
    } else {
      debugPrint('Response failed');
    }
  }
  //---------------------------------------PagePost-----------------------------------//

  Future<void> getPosts(String pageId) async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await pageRepository.getPosts(
      pageNo: pageNo,
      pageSize: pageSize,
      pageId: pageId,
      userRole: '',
    );

    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      totalPageCount = apiResponse.pageCount ?? 1;

      List<PostModel> postListResponse = apiResponse.data as List<PostModel>;

      for (PostModel postModel in postListResponse) {
        bool isPinned = postModel.pinPost == true;

        // prevent duplicate post
        bool alreadyExists = (isPinned ? pinnedPostList : postList)
            .value
            .any((post) => post.id == postModel.id); // or post._id

        if (!alreadyExists) {
          if (isPinned) {
            pinnedPostList.value.add(postModel);
          } else {
            postList.value.add(postModel);
          }
        }
      }

      pinnedPostList.refresh();
      postList.refresh();
    }
  }

  //-------------------------------------------photos-------------------------//
  Future getPagePhotos(String pageUserName) async {
    isLoadingUserPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-pages-latest-image-video',
      requestData: {
        'username': pageUserName,
      },
      responseDataKey: 'posts',
    );

    if (apiResponse.isSuccessful) {
      pagePhotosList.value = (apiResponse.data as List<dynamic>)
          .map(
            (e) => Pagephotosmodel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPhoto.value = false;
  }

  //------------------------------------------- Videos -------------------------//
  Future getVideos(String userName) async {
    isLoadingUserVideo.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-pages-latest-image-video',
      requestData: {
        'username': userName,
      },
      responseDataKey: 'videos',
    );

    if (apiResponse.isSuccessful) {
      pageVideoList.value = (apiResponse.data as List)
          .map(
            (e) => AdminPageVideoModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserVideo.value = false;
  }

  //======================================================== Repost Related Functions ===============================================//
  final RxInt currentRepostSkip = 0.obs;
  final int repostLimit = 10;
  final RxBool hasMoreRepostedReels = true.obs;
  Rx<bool> isLoadingUserRepost = false.obs;
  Rx<List<VideoReel>> repostList = Rx([]);
  Future getOtherRepostVideo({required String pageUserName}) async {
    if (isLoadingUserRepost.value || !hasMoreRepostedReels.value) return;

    isLoadingUserRepost.value = true;
    try {
      ApiResponse apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint:
            'get-reels-re-post-list/$pageUserName?skip=$currentRepostSkip&limit=$repostLimit',
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

  //======================================================== Reels Related Functions ===============================================//
  final RxInt currentSkip = 0.obs;
  final int limit = 10;
  final RxBool hasMoreReels = true.obs;
  final RxBool isLoadingUserReels = false.obs;
  Rx<List<VideoReel>> reelsList = Rx([]);
//===================== Page User Reels===================================//
  Future getPageUserReels({required String pageUserName}) async {
    // if (isLoadingUserReels.value || !hasMoreReels.value) return;

    isLoadingUserReels.value = true;
    debugPrint('==========================get Reels Start');

    try {
      ApiResponse apiResponse = await _apiCommunication.doGetRequest(
          apiEndPoint:
              'profile/reels/$pageUserName?skip=${currentSkip.value}&limit=$limit',
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

  //=============================Get widget Number================================//
  // RxInt pageProfileWidgetViewNumber = 0.obs;

  void getWidgetNumber({required String pageUserName}) {
    if (isFromPageReels == 'true') {
      viewNumber.value = 3;
      tabController.animateTo(3);
      getPageUserReels(pageUserName: pageUserName);
    } else {
      viewNumber.value = 0;
    }
  }
//=====================================Get Albums=======================================//

  Future getAlbums() async {
    isLoadingUserPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-users-album/${userModel.username}',
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

  //------------------------------------------- Pages Invites -------------------------//
  RxString keyword = ''.obs;
  Future getPagesInvites(String pageId, String searchKeyword) async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'friend-list-page-invitation',
      requestData: {'page_id': pageId, 'search': searchKeyword},
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      pageInvitationList.value = (apiResponse.data as List)
          .map(
            (e) => PageInvitationModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPages.value = false;
  }
  //-------------------------------------- Followers List ----------------------------//

  Future getPageFollowers(String pageId) async {
    pagefollowersList.value.clear();

    isLoadingMediaPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-all-followers',
      requestData: {'page_id': pageId},
      responseDataKey: 'data',
    );
    isLoadingMediaPhoto.value = false;

    if (apiResponse.isSuccessful) {
      pagefollowersList.value = (apiResponse.data as List)
          .map(
            (e) => AdminPageFollowersModel.fromMap(e),
          )
          .toList();
    }
  }

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
  //---------------------------------------PagePost-----------------------------------//
  Future<void> getPagePosts(String pageId, {bool reset = false}) async {
    if (isLoadingNewsFeed.value) return;
    if (reset) {
      pageNo = 1;
      totalPageCount = 0;
      postList.value.clear();
    }

    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      requestData: {'page_id': pageId, 'role': ''},
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-pages-posts?pageNo=$pageNo&pageSize=$pageSize',
    );

    debugPrint('=============Other Post response==================$apiResponse');

    if (apiResponse.isSuccessful) {
      final data = apiResponse.data as Map<String, dynamic>;

      int totalPostCount = data['totalPosts'];
      totalPageCount = (totalPostCount / pageSize).ceil();
      if (totalPageCount == 0) {
        totalPageCount = 1;
      }

      postList.value.addAll(
        (data['posts'] as List).map((e) => PostModel.fromMap(e)).toList(),
      );

      postList.refresh();
    } else {
      debugPrint(apiResponse.message ?? 'Error');
    }

    isLoadingNewsFeed.value = false;
  }

  //------------------------------- PROFILE PICTURES ----------------------------//

  Future getProfilePictures(String pageId) async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-pages-albums-images',
      requestData: {'page_id': pageId, 'albums_id': 'profile_picture'},
      responseDataKey: 'data',
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      profilePicturesList.value = (apiResponse.data as List)
          .map(
            (e) => AdminPageProfilePictureModel.fromMap(e),
          )
          .toList();
    }
  }

  //----------------------------------- COVER PHOTOS ----------------------------//
  Future getCoverPhotos(String pageId) async {
    isLoadingCoverPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-pages-albums-images',
      requestData: {
        // 'username': userModel.username,
        'page_id': pageId,
        'albums_id': 'cover_picture',
      },
      responseDataKey: 'data',
    );
    isLoadingCoverPhoto.value = false;

    if (apiResponse.isSuccessful) {
      coverPhotosList.value = (apiResponse.data as List)
          .map(
            (e) => AdminPageProfilePictureModel.fromMap(e),
          )
          .toList();
    }
  }
  //------------------------------------------- Albums -------------------------//

  Future getPageAlbums(String pageId) async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-pages-album/$pageId',
      responseDataKey: 'results',
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      mediaAlbumList.value = (apiResponse.data as List)
          .map(
            (e) => PageMediaModel.fromMap(e),
          )
          .toList();
    }
  }
  //-------------------------------------- MEDIA PHOTOS ----------------------------//

  Future getMediaPhotos(String pageId) async {
    isLoadingMediaPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-album-details/$pageId',
      responseDataKey: 'results',
    );
    isLoadingMediaPhoto.value = false;

    if (apiResponse.isSuccessful) {
      pageMediaList.value = (apiResponse.data as List)
          .map(
            (e) => PageMediaPhotosModel.fromMap(e),
          )
          .toList();
    }
  }

//============================= Get Video Ads =========================================//
  RxBool isLoadingVideoAds = true.obs;
  Future<void> getVideoAds() async {
    isLoadingVideoAds.value = true;

    final ApiResponse apiResponse = await postRepository.getVideoAds();

    if (apiResponse.isSuccessful) {
      videoAdList.value = apiResponse.data as List<VideoCampaignModel>;
      // adsPostList.refresh(); // Refresh the ads list
      debugPrint('');
      isLoadingVideoAds.value = false;
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

  Future sendFriendInvitation(
    String pageId,
  ) async {
    isLoadingFriendList.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'send-page-invitation-from-apps',
      requestData: {
        'page_id': pageId,
        'user_id_arr': selectedPageInvitationList.value
            .map((model) => model.friend?.id)
            .toList()
      },
    );

    if (apiResponse.isSuccessful) {
      Get.back();

      showSuccessSnackkbar(message: 'page Invitation Send successfully');
    }
    isLoadingUserPages.value = false;
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
      showSuccessSnackkbar(message: 'followed this pages successfully');
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

  Future<void> pinAndUnpinPost(int status, String post_id, int index) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'change-pin-post-status', requestData: {
      'post_id': post_id,
      'pin_post': status,
    });

    if (apiResponse.isSuccessful) {
      // if (status == 0) {
      //   pinnedPostList.value.removeAt(index);
      //   pinnedPostList.refresh();
      // }
      pinnedPostList.value.clear();
      postList.value.clear();
      totalPageCount = 0;
      pageNo = 1;
      Get.back();

      showSuccessSnackkbar(message: apiResponse.message.toString());
    }
  }

  Future<void> deletePost(String postId, String key) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'delete-post-by-id',
      requestData: {
        'postId': postId,
        'key': key,
      },
    );
    isLoadingNewsFeed.value = false;

    debugPrint('api delete response.....${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Your Post Has Been Deleted');
      Get.back();
    } else {
      // showErrorSnackkbar(message: apiResponse.errorMessage ?? 'Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
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

  Future commentOnPost(int index, PostModel postModel) async {
    final ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-user-comment-by-post',
        isFormData: true,
        enableLoading: true,
        requestData: {
          'user_id': postModel.page_id,
          'post_id': postModel.id,
          'comment_name': commentController.text,
          'link': null,
          'link_title': null,
          'link_description': null,
          'link_image': null,
          'key' : postModel.key
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

  Future<void> pickFiles() async {
    debugPrint('=================X file Value start====================');

    final ImagePicker picker = ImagePicker();
    xfiles.value = await picker.pickMultipleMedia();

    debugPrint(
        '=================X file Value====================${xfiles.value}');
  }

  // String getCategory(String category) {
  //   if (category == null) {
  //     return '';
  //   }

  //   if (category is List) {
  //     return (category as List).map((item) => item.toString()).join(', ');
  //   } else if (category is String) {
  //     return category;
  //   } else {
  //     return category.toString();
  //   }
  // }

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
          'user_id': pageProfileModel.value?.pageDetails?.id,
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
          'comment_id': comment_id, //"663a15f5001ab86d881e81e7",
          'replies_user_id': pageProfileModel
              .value?.pageDetails?.id, //"6545c99d858780bf50dfc1eb",
          'replies_comment_name': replies_comment_name, //"123123",
          'post_id': post_id, //"6639e808a45d87b49746a3f0"
          'image_or_video': file,
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
    } else {}
  }

  Future<void> reportAPost(
      {required String page_id,
      required String report_type,
      required String description,
      required String report_type_id}) async {
    debugPrint('=================Report Start==========================');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'save-post-report',
      enableLoading: true,
      requestData: {
        'page_id': page_id,
        'report_type': report_type,
        'description': description,
        'report_type_id': report_type_id,
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

  void clearPageProfileLists() {
    pagefollowersList.value.clear();
    pageMediaList.value.clear();
    pageVideoList.value.clear();
    profilePicturesList.value.clear();
    coverPhotosList.value.clear();
    mediaAlbumList.value.clear();
    pagePhotosList.value.clear();
    postList.value.clear();
    pinnedPostList.value.clear();
  }
  //=========================================== For Scrolling List View

  late ScrollController postScrollController = ScrollController();

  Future<void> _scrollListener() async {
    if (!isLoadingNewsFeed.value &&
        postScrollController.position.pixels >=
            postScrollController.position.maxScrollExtent - 100) {
      if (pageNo < totalPageCount) {
        pageNo++;
        await getPagePosts(pageProfileModel.value?.pageDetails?.id ?? '');
      }
    }
  }


  @override
  void onReady() {
    postScrollController.addListener(_scrollListener);

    super.onReady();
  }

  @override
  void onInit() async {
    super.onInit();
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    postScrollController = ScrollController();
    widgetList.value = [
      PageFeedComponent(controller: this),
      PageAboutComponent(controller: this),
      PagePhotosComponent(controller: this),
      PageProfileReelsComponent(controller: this),
      PageVideosView(controller: this),
    ];

    // tabController = TabController(length: widgetList.length + 1, vsync: this);

    pageUserName = '${Get.arguments[0]}';
    isFromPageReels = '${Get.arguments[1]}';

    // pageId =Get.arguments as String;
    userModel = loginCredential.getUserData();
    commentController = TextEditingController();
    commentReplyController = TextEditingController();
    descriptionController = TextEditingController();
    // await initiateAllAPiCall();
    await getPosts(pageProfileModel.value?.pageDetails?.id ?? '');

  }

  @override
  void onClose() {
    super.onClose();
    _apiCommunication.endConnection();
    debounce?.cancel();
  }

  void increment() => count.value++;
}
