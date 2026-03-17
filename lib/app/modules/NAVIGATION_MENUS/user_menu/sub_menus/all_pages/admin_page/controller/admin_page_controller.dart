import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../controllers/user_menu_controller.dart';
import '../admin_page_more_options_view/admin_page_videos.dart';
import '../admin_photos_albums_view/admin_page_photos_component.dart';
import '../components/about.dart';
import '../components/admin_feed_component.dart';
import '../components/admin_reels_component/admin_page_profile_reels_component.dart';
import '../../../profile/models/personal_reels_model.dart';

import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../data/post_local_data.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/comment_model.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../models/user.dart';
import '../../../../../../../models/video_campaign_model.dart';
import '../../../../../../../repository/page_repository.dart';
import '../../../../../../../repository/post_repository.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/image_utils.dart';
import '../../../../../../../utils/post_utlis.dart';
import '../../../../../../../utils/snackbar.dart';
import '../../page_profile/model/page_profile_model.dart';
import '../../pages/model/admin_moderator_model.dart';
import '../../pages/model/admin_page_make_admin_model.dart';
import '../../pages/model/invitation_model.dart';
import '../../pages/model/manage_page_model.dart';
import '../../pages/model/mypage_model.dart';
import '../../pages/model/page_friend_model.dart';
import '../../pages/model/transferownership_model.dart';
import '../model/admin_media_model.dart';
import '../model/admin_page_followers_model.dart';
import '../model/admin_page_video_model.dart';
import '../model/media_photo_model.dart';
import '../model/page_photos_model.dart';
import '../model/page_profile_picture_model.dart';

class AdminPageController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  Timer? debounce;
  final GlobalKey<FormState> formKey = GlobalKey();
  String isFromPageReels = 'false';
  late TabController tabController;

  var isSaveButtonEnabled = false.obs;
  RxBool isFollowing = false.obs;
  RxBool isModerator = false.obs;
  MyPagesModel? myPagesModel;
  ManagePageModel? managePageModel;
  PageMakeAdminModel? pageMakeAdminModel;
  Rx<List<VideoCampaignModel>> videoAdList = Rx([]);
  RxInt currentAdIndex = 0.obs;
  RxInt viewReelsTabNumber = 0.obs;

  PostRepository postRepository = PostRepository();
  //----------------------------- TextEditingController -----------------------------------//

  late TextEditingController pageNameController;
  late TextEditingController bioController;
  late TextEditingController locationController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController whatsAppNumberController;
  late TextEditingController pageAlbumNameController;
  late TextEditingController descriptionController;
  late TextEditingController commentReplyController;
  late final TextEditingController commentController;

  //----------------------------- Model -----------------------------------//
  var selectedPageAdminList = RxList<PageMakeAdminModel>([]);
  var selectedPageAdminmoderatorList = RxList<PageMakeAdminModel>([]);
  var pageAdminList = RxList<PageMakeAdminModel>([]);
  var filteredFriendList = RxList<PageMakeAdminModel>([]);
  var filteredFriendsList = RxList<TransferOwnershipModel>([]);
  var selectedPageAdminsList = RxList<TransferOwnershipModel>([]);
  var selectedPageAdminmoderatorsList = RxList<TransferOwnershipModel>([]);

  Rx<List<PostModel>> postList = Rx([]);
  Rx<List<PostModel>> pinnedPostList = Rx([]);
  Rx<PageProfileModel?> pageProfileModel = Rx(null);

  Rx<List<Pagephotosmodel>> pagePhotosList = Rx([]);
  Rx<List<PageMediaPhotosModel>> pageMediaList = Rx([]);
  Rx<List<AdminPageProfilePictureModel>> profilePicturesList = Rx([]);
  Rx<List<AdminPageProfilePictureModel>> coverPhotosList = Rx([]);
  Rx<List<PageMediaModel>> mediaAlbumList = Rx([]);
  Rx<List<ManagePageModel>> managepagesList = Rx([]);
  // Rx<List<PageMakeAdminModel>> pageAdminList = Rx([]);
  // Rx<List<PageMakeAdminModel>> selectedPageAdminList = Rx([]);
  // Rx<List<PageMakeAdminModel>> filteredFriendList = Rx([]);
  Rx<List<AdminModeratorModel>> pageAdminModeratorList = Rx([]);
  Rx<List<TransferOwnershipModel>> pageTrandferAdminModeratorList = Rx([]);
  Rx<List<PageFriendmodel>> pageFriendList = Rx([]);
  Rx<List<PageFriendmodel>> selectedPagefriendList = Rx([]);
  Rx<List<String>> selectedUsernames = Rx([]);
  Rx<String> updateUserRole = 'admin'.obs;
  Rx<String> selectedUserRole = 'admin'.obs;
  Rx<List<PageInvitationModel>> pageInvitationList = Rx([]);
  Rx<List<PageInvitationModel>> selectedPageInvitationList = Rx([]);
  Rx<List<AdminPageFollowersModel>> pagefollowersList = Rx([]);
  Rx<List<AdminPageVideoModel>> pageVideoList = Rx([]);
  Rx<List<PageFriendmodel>> searchedFriendList = Rx([]);
  final selectedPageInvitationIds = <String>{}.obs; // Use a Set for uniqueness
  final RxList<Widget> widgetList = <Widget>[].obs;

  //----------------------------- Image files, Privacy, Page view -----------------------------------//
  Rx<List<XFile>> xfiles = Rx([]);
  RxString dropdownValue = privacyList.first.obs;
  RxString postPrivacy = 'public'.obs;
  RxInt viewNumber = 0.obs;
  RxInt albumTabIndex = 0.obs;
  RxInt view = 0.obs;
  RxString buttonview = 'Photos of you'.obs;
  String? pageUserName;
  RxString searchKey = ''.obs;

  //----------------------------------Loading----------------------------------//

  RxBool isLoadingNewsFeed = true.obs;
  RxBool isCommentReactionLoading = true.obs;
  RxBool isReplyReactionLoading = true.obs;
  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingProfilePhoto = false.obs;
  RxBool isLoadingCoverPhoto = false.obs;
  RxBool isLoadingMediaPhoto = false.obs;
  RxBool isLoadingUserPages = false.obs;
  RxBool isLoadingUserVideo = false.obs;
  RxBool isLoadingFriendList = true.obs;
  RxBool isLoadingAlbums = true.obs;

  //----------------------------------Page newsfeed----------------------------------//

  int pageNo = 1;
  final int pageSize = 10;
  int totalPageCount = 0;
  final PageRepository pageRepository = PageRepository();
  // String? pageId;

  //----------------------------------Page details--------------------------------//

  Future getPageDetails() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-page-details/$pageUserName',
      responseDataKey: 'data',
    );
    if (apiResponse.isSuccessful) {
      pageProfileModel.value =
          PageProfileModel.fromMap(apiResponse.data as Map<String, dynamic>);
      debugPrint('Response success');
    } else {
      debugPrint('Response failed');
    }
  }

  //-------------------------------------- Manage Pages ----------------------------//
  Future getManagePages() async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-my-pages-as-moderator',
      responseDataKey: 'myPages',
    );

    if (apiResponse.isSuccessful) {
      managepagesList.value = (apiResponse.data as List)
          .map(
            (e) => ManagePageModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPages.value = false;
  }
  //---------------------------------------PagePost-----------------------------------//

  Future<void> getPosts(String pageId) async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await pageRepository.getPosts(
      pageNo: pageNo,
      pageSize: pageSize,
      pageId: pageId,
      userRole: 'admin',
    );
    isLoadingNewsFeed.value = false;
    if (apiResponse.isSuccessful) {
      totalPageCount = apiResponse.pageCount ?? 1;
      List<PostModel> postListResponse = apiResponse.data as List<PostModel>;
      for (PostModel postModel in postListResponse) {
        if (postModel.pinPost == true) {
          pinnedPostList.value.add(postModel);
        } else {
          postList.value.add(postModel);
        }
      }
      pinnedPostList.refresh();
      postList.refresh();
    } else {}
  }

  //---------------------------------------Post create --------------------------------//

  void onTapPageCreatePost() async {
    await Get.toNamed(Routes.CREATE_PAGE_POST,
        arguments: pageProfileModel.value);
    pageNo = 1;
    totalPageCount = 0;
    postList.value.clear();
    pinnedPostList.value.clear();
    getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
  }

  //----------------------------------------  Edit post ---------------------------------------//
  void onTapEditPost(PostModel model) {
    // Get.toNamed(Routes.EDIT_POST, arguments: model);
    postList.value.clear();
    pinnedPostList.value.clear();
    getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
  }

  //---------------------------------------Post list --------------------------------//

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
      showSuccessSnackkbar(message: 'Already followed the page');
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

  //-------------------------------------- Followers List ----------------------------//

  Future getPageFollowers(String pageId) async {
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
  RxBool isLoadingVideoAds = true.obs;
  Future getVideos(String userName) async {
    isLoadingVideoAds.value = true;
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
    isLoadingVideoAds.value = false;
  }

  //--------------------------------------- DELETE Videos ----------------------------//

  Future<void> deletevideos(String mediaId, String key) async {
    final ApiResponse response = await _apiCommunication
        .doPostRequest(apiEndPoint: 'delete-post-media-by-id', requestData: {
      'media_id': mediaId,
      'key': key,
    });
    if (response.isSuccessful) {
      getVideos(pageProfileModel.value?.pageDetails?.pageUserName ?? '');
      Get.back();
      showSuccessSnackkbar(message: 'Video deleted successfully');
    } else {
      debugPrint('');
    }
  }

  //------------------------------------------- Albums -------------------------//

  Future getPageAlbums(String pageId) async {
    isLoadingAlbums.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-pages-album/$pageId',
      responseDataKey: 'results',
    );
    isLoadingAlbums.value = false;

    if (apiResponse.isSuccessful) {
      mediaAlbumList.value = (apiResponse.data as List)
          .map(
            (e) => PageMediaModel.fromMap(e),
          )
          .toList();
    }
  }

  //---------------------------------------- EDIT ALBUM ----------------------------//

  Future<void> editalbum(String albumId) async {
    final ApiResponse response = await _apiCommunication
        .doPostRequest(apiEndPoint: 'edit-album', requestData: {
      'album_id': albumId,
      'album_title': pageAlbumNameController.text,
      'privacy': (getPostPrivacyValue(dropdownValue.value)),
    });
    if (response.isSuccessful) {
      getPageAlbums(pageProfileModel.value?.pageDetails?.id ?? '');
      Get.back();
      showSuccessSnackkbar(message: 'Album updated successfully');
    } else {
      debugPrint('');
    }
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
  //--------------------------------------- CREATE ALBUM ----------------------------//

  Future<void> createAlbum(String pageId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-album',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'album_title': pageAlbumNameController.text,
        'privacy': (getPostPrivacyValue(dropdownValue.value)),
        'page_id': pageId
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      Get.back();
      getPageAlbums(pageProfileModel.value?.pageDetails?.id ?? '');
      showSuccessSnackkbar(message: 'Album created successfully');
    } else {
      debugPrint('');
    }
  }

  //--------------------------------------- SAVE PHOTOS ----------------------------//

  Future<void> savePhotos(String albumId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'description': descriptionController.text,
        'album_id': albumId,
        'Files': ''
      },
      mediaXFiles: xfiles.value,
    );
    if (response.isSuccessful) {
      getMediaPhotos(pageProfileModel.value?.pageDetails?.id ?? '');
      Get.back();
      showSuccessSnackkbar(message: 'Post submitted successfully');
    } else {
      debugPrint('');
    }
  }

  //-------------------------------------- DELETE ALBUM ----------------------------//

  Future<void> deleteAlbum(String albumId) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'delete-album',
      requestData: {
        'album_id': albumId,
      },
    );
    if (response.isSuccessful) {
      getPageAlbums(pageProfileModel.value?.pageDetails?.id ?? '');
      Get.back();
      showSuccessSnackkbar(message: 'Album Deleted successfully');
    } else {
      debugPrint('');
    }
  }

//------------------------------------------- Upload Page Profile Picture ---------------------------------//

  Future<void> uploadPageProfilePicture(String pageId) async {
    final XFile? xFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (xFile != null) {
      File? file = await cropImage(File(xFile.path));
      // xfiles.value.clear();
      // xfiles.value.add(xFile);
      if (file != null) {
        final ApiResponse response = await _apiCommunication.doPostRequest(
            apiEndPoint: 'change-pages-profile-pic',
            enableLoading: true,
            mediaFiles: [file],
            fileKey: 'profile_pic',
            isFormData: true,
            requestData: {
              'page_id': pageId,
            });
        if (response.isSuccessful) {
          await getPageDetails();
          UserMenuController userMenuController =
              Get.find<UserMenuController>();
          UserModel userModel = UserModel(
              profile_pic: pageProfileModel.value?.pageDetails?.profilePic,
              first_name: pageProfileModel.value?.pageDetails?.pageName,
              pageUserName: pageProfileModel.value?.pageDetails?.pageUserName,
              page_id: pageProfileModel.value?.pageDetails?.id);
          loginCredential.saveUserData(userModel);
          userMenuController.profileImage.value =
              loginCredential.getUserData().profile_pic ?? '';
          userMenuController.profileName.value =
              loginCredential.getUserData().first_name ?? '';
          debugPrint(
              'Profile Name:::::::::::::::::::::::::${userMenuController.profileName.value}');
          postList.value.clear();

          await getPosts(pageId);
          postList.refresh();
        } else {
          debugPrint('');
        }
      }
    } else {
      debugPrint('');
    }
  }

  //------------------------------------------- Upload Page Cover Picture -------------------------//
  Future<void> uploadPageCoverPicture(String pageId) async {
    final XFile? xFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (xFile != null) {
      File? file = await cropImage(File(xFile.path));
      if (file != null) {
        final ApiResponse response = await _apiCommunication.doPostRequest(
            apiEndPoint: 'change-pages-cover-pic',
            enableLoading: true,
            mediaFiles: [file],
            fileKey: 'cover_pic',
            isFormData: true,
            requestData: {
              'page_id': pageId,
            });
        if (response.isSuccessful) {
          await getPageDetails();
          postList.value.clear();
          await getPosts(pageId);
          postList.refresh();
          showSuccessSnackkbar(message: 'Post submitted successfully');
        } else {
          debugPrint('');
        }
      }
    } else {
      debugPrint('');
    }
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

  void searchFriends(String query) {
    if (query.isEmpty) {
      filteredFriendList.value = pageAdminList;
    } else {
      filteredFriendList.value = pageAdminList
          .where((friend) =>
              friend.fullName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  //------------------------------------------- Remove Page Admin -------------------------//
  // Future removePageAdmin(String pageId) async {
  //   ApiResponse apiResponse = await _apiCommunication
  //       .doPostRequest(apiEndPoint: 'remove-page-admin', requestData: {
  //     '_id': pageId,
  //   });
  //   if (apiResponse.isSuccessful) {
  //     Get.back();
  //     getPageAdmin(myPagesModel?.id ?? '');
  //     showSuccessSnackkbar(message: 'Page Admin Removed Successfully');
  //   }
  // }

  Future removePageAdmin(String pageId) async {
    if (pageAdminModeratorList.value.length == 1) {
      Get.back();
      showErrorSnackkbar(message: 'Make at least one admin');
      return;
    }

    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'remove-page-admin', requestData: {
      '_id': pageId,
    });

    if (apiResponse.isSuccessful) {
      Get.back();
      getPageAdmin(pageProfileModel.value?.pageDetails?.id ?? '');
      showSuccessSnackkbar(message: 'Page Admin Removed Successfully');
    }
  }

  //------------------------------------------- Make Page Admin -------------------------//

  Future makePageAdmin(String pageUserName, String userId) async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'make-page-admin-app',
      requestData: {
        'page_user_name': pageUserName,
        'user_id': [userId],
        'user_role': selectedUserRole.value.toLowerCase(),
      },
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      getPageAdmin(pageProfileModel.value?.pageDetails?.id ?? '');
      Get.back();

      showSuccessSnackkbar(message: 'Page Admin Updated Successfully');
    }
  }
  //------------------------------------------- Make Page Admin -------------------------//

  Future editRole(String userId, String pageId, String userRole) async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'change-page-role',
      requestData: {
        '_id': userId,
        'user_role': updateUserRole.value,
      },
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      Get.back();
      showSuccessSnackkbar(message: 'Page role update Successfully');
    }
  }

//------------------------------------------- transferPageAdmin -------------------------//

  Future getPageTranferAdminList() async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'pages/transfer-ownership/$pageUserName',
      // requestData: {'username': '${loginCredential.getUserData(p).username}'},
      responseDataKey: 'data',
    );

    if (apiResponse.isSuccessful) {
      pageTrandferAdminModeratorList.value = (apiResponse.data as List)
          .map(
            (e) => TransferOwnershipModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPages.value = false;
  }

  Future transferPageAdmin(String pageUserName, String transferUserId) async {
    isLoadingProfilePhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'transfer-page-ownership',
      requestData: {
        'page_user_name': pageUserName,
        'transfer_user_id': transferUserId,
      },
    );
    isLoadingProfilePhoto.value = false;

    if (apiResponse.isSuccessful) {
      Get.back();
      Get.back();
      Get.back();
      Get.back();
      Get.back();

      selectedPageAdminList.clear();

      showSuccessSnackkbar(
          message: 'Page Transfer Ownership Updated Successfully');
    }
  }

  Future getPageAdmin(String pageId) async {
    isLoadingMediaPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-page-admins',
      requestData: {'page_id': pageId},
      responseDataKey: 'data',
    );
    isLoadingMediaPhoto.value = false;

    if (apiResponse.isSuccessful) {
      pageAdminModeratorList.value = (apiResponse.data as List)
          .map(
            (e) => AdminModeratorModel.fromMap(e),
          )
          .toList();
    }
    print("Page Admins: ${pageAdminModeratorList.value}");
  }

  //--------------------------------------- pin And UnpinPost --------------------------------//

  Future<void> pinAndUnpinPost(int status, String post_id, int index) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'change-pin-post-status', requestData: {
      'post_id': post_id,
      'pin_post': status,
    });

    if (apiResponse.isSuccessful) {
      if (status == 0) {
        pinnedPostList.value.removeAt(index);
        pinnedPostList.refresh();
      }
      pinnedPostList.value.clear();
      postList.value.clear();
      totalPageCount = 0;
      pageNo = 1;
      getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
      Get.back();

      showSuccessSnackkbar(message: apiResponse.message.toString());
    }
  }
  //---------------------------------------Post reaction --------------------------------//

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
      key: key,
    );

    if (apiResponse.isSuccessful) {
      debugPrint('Reaction done ::::::::::::::$reaction');
    }
  }
  //--------------------------------------- Share post--------------------------------//

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
      getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
    } else {}
  }

  //------------------------------------------- Delete page -------------------------//

  Future<void> deletePage(String pageId) async {
    final ApiResponse response = await _apiCommunication
        .doPostRequest(apiEndPoint: 'delete-page', requestData: {
      '_id': pageId,
    });
    if (response.isSuccessful) {
      pageProfileModel;
      Get.back();
      Get.back();
      Get.back();
      pageRepository.getMyPages(skip: 0, limit: 10, forceFetch: true);
      showSuccessSnackkbar(message: 'Page deleted successfully');
    } else {
      debugPrint('');
    }
  }
  //------------------------------------------ Edit page -------------------------//

  Future<void> editPage(String pageId) async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'pages/edit-page/$pageId',
      enableLoading: true,
      requestData: {
        'bio': bioController.text,
        'email': emailController.text,
        'description': descriptionController.text,
        'location': [locationController.text],
        'name': pageNameController.text,
        'phone_number': phoneNumberController.text,
        'website': websiteController.text,
        'whatsapp_number': whatsAppNumberController.text,
      },
    );
    if (response.isSuccessful) {
      getPageDetails();
      Get.back();
      Get.back();

      showSuccessSnackkbar(message: 'Pages updated successfully');
    } else {
      debugPrint('');
    }
  }

  //------------------------------------------- Friend List -------------------------//
  filterFriend(String key) {
    if (key.isNotEmpty) {
      searchKey.value = key;
      searchedFriendList.value = pageFriendList.value
          .where((pageFriendmodel) =>
              pageFriendmodel.userId
                  .toString()
                  .toLowerCase()
                  .contains(searchKey.value.toString().toLowerCase()) ||
              pageFriendmodel.userId!.firstName
                  .toString()
                  .toLowerCase()
                  .contains(searchKey.value.toString().toLowerCase()) ||
              pageFriendmodel.userId!.lastName
                  .toString()
                  .toLowerCase()
                  .contains(searchKey.value.toString().toLowerCase()))
          .toList();
      debugPrint('my friends: ${searchedFriendList.value}');
    } else {
      searchKey.value = '';
      debugPrint('friendList: ${pageFriendList.value}');
    }
  }

  Future getPageAdminList() async {
    isLoadingUserPages.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'friend-list-for-make-page-admin-app/$pageUserName',
      // requestData: {'username': '${loginCredential.getUserData(p).username}'},
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      pageAdminList.value = (apiResponse.data as List)
          .map(
            (e) => PageMakeAdminModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserPages.value = false;
  }

  //------------------------------------------- Delete photos -------------------------//

  Future<void> deletePhotos(String mediaId, String key) async {
    final ApiResponse response = await _apiCommunication
        .doPostRequest(apiEndPoint: 'delete-post-media-by-id', requestData: {
      'media_id': mediaId,
      'key': key,
    });
    if (response.isSuccessful) {
      Get.back();
      getMediaPhotos(myPagesModel?.id ?? '');
      showSuccessSnackkbar(message: 'Photo deleted successfully');
    } else {
      debugPrint('');
    }
  }

  //--------------------------------------- Hide post ----------------------------//

  Future<void> hidePost(int status, String post_id, int postIndex) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'hide-unhide-post', requestData: {
      'status': status,
      'post_id': post_id,
    });

    if (apiResponse.isSuccessful) {
      getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
      postList.value.removeAt(postIndex);
      postList.refresh();
      Get.back();
    }
  }

  //--------------------------------------- Bookmark Post ----------------------------//

  Future<void> bookmarkPost(String post_id, String postPrivacy) async {
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'save-post-bookmark', requestData: {
      'post_privacy': postPrivacy,
      'post_id': post_id,
    });

    if (apiResponse.isSuccessful) {
      Get.back();

      showSuccessSnackkbar(message: 'Post bookmark successfully');
      getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
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

//--------------------------------------- Delete Post ----------------------------//
  Future<void> deletePost(String postId, String key) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'delete-post-by-id',
      enableLoading: true,
      requestData: {
        'postId': postId,
        'key': key,
      },
    );

    isLoadingNewsFeed.value = false;

    debugPrint('api delete response.....${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      postList.value.removeWhere(
          (element) => element.id.toString().compareTo(postId) == 0);
      pinnedPostList.value.removeWhere(
          (element) => element.id.toString().compareTo(postId) == 0);

      showSuccessSnackkbar(message: 'Your Post Has Been Deleted');
    } else {
      showErrorSnackkbar(message: 'Please try again');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  //-------------------------------------- PICK FILES ----------------------------//

  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();
    xfiles.value.addAll(mediaXFiles);
    xfiles.refresh();
  }

  //======================================================== Comment Related Functions ===============================================//

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

//---------------------------------------- Comment post ---------------------------------------//

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

  //---------------------------------------- Comment reply ---------------------------------------//

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
          'replies_user_id': userModel.id, //"6545c99d858780bf50dfc1eb",
          'replies_comment_name': replies_comment_name, //"123123",
          'post_id': post_id, //"6639e808a45d87b49746a3f0"
          'image_or_video': file,
        },
        fileKey: 'image_or_video',);

    if (apiResponse.isSuccessful) {
      // List<CommentModel> comments = await getSinglePostsComments(post_id);
      // postList.value[postIndex].comments = comments;
      // postList.refresh();
      updatePostList(post_id, postIndex);

      commentReplyController.text = '';

      xfiles.value.clear();
    }
  }

  //---------------------------------------- Comment reaction ---------------------------------------//

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

  //---------------------------------------- Comment reply reaction ---------------------------------------//

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

  //---------------------------------------- Comment delete ---------------------------------------//

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

  //----------------------------------------  Reply delete ---------------------------------------//

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
  // Video ad Index Dynamic

  void updateAdIndex() {
    if (videoAdList.value.isNotEmpty) {
      currentAdIndex.value =
          (currentAdIndex.value + 1) % videoAdList.value.length;
    }
  }

//==========================Initialize All Text Editing Controllers==========================//
  void initAllTextEditingController() {
    pageNameController = TextEditingController();
    bioController = TextEditingController();
    locationController = TextEditingController();
    emailController = TextEditingController();
    websiteController = TextEditingController();
    whatsAppNumberController = TextEditingController();
    phoneNumberController = TextEditingController();
    pageAlbumNameController = TextEditingController();
    descriptionController = TextEditingController();
    descriptionController = TextEditingController();
    commentController = TextEditingController();
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
      // tabController is assigned by the view's initState,
      // so defer animateTo to the next frame to avoid LateInitializationError
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          tabController.animateTo(3);
        } catch (_) {}
      });
      getPageUserReels(pageUserName: pageUserName);
    } else {
      viewNumber.value = 0;
    }
  }
  //=========================================== For Scrolling List View

  late ScrollController postScrollController = ScrollController();

  Future<void> _scrollListener() async {
    // debugPrint(
    //     'scroll postion pixels:::::::${postScrollController.position.pixels}');
    // debugPrint(
    //     'scroll postion MaxScroll:::::::${postScrollController.position.maxScrollExtent * 0.8}');

    if (postScrollController.position.pixels <=
        postScrollController.position.maxScrollExtent - 100) {
      if (pageNo <= totalPageCount) {
        pageNo += 1;
        await getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    postScrollController = ScrollController();
    // tabController = TabController(
    //   length: widgetList.length,
    //   vsync: this,
    // );
    userModel = loginCredential.getUserData();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;
      pageUserName = args['pageUserName'] ?? Get.arguments as String;
      isFromPageReels = args['isFromPageReels'] ?? 'false';
    } else if (Get.arguments != null) {
      pageUserName = Get.arguments as String;
      isFromPageReels = 'false';
    } else {
      pageUserName = '';
      isFromPageReels = 'false';
    }

    await getPageDetails();
    await getVideoAds();
    await getPosts(pageProfileModel.value?.pageDetails?.id ?? '');
    await getPageAdmin(myPagesModel?.id ?? '');
    initAllTextEditingController();
    getWidgetNumber(pageUserName: pageUserName ?? '');
    widgetList.value = [
      AdminFeedComponent(controller: this),
      AboutComponent(controller: this),
      AdminPagePhotosComponent(controller: this),
      AdminPageProfileReelsComponent(controller: this),
      AdminPageVideosView(controller: this),
    ];
    postScrollController.addListener(_scrollListener);

    // tabController.addListener(() {
    //   if (tabController.indexIsChanging) return;
    //   viewNumber.value = tabController.index;
    // });
    // editPage(pageProfileModel.value?.pageDetails?.id ?? '');
  }

  @override
  void onReady() {
    postScrollController.addListener(_scrollListener);
    super.onReady();
  }

  @override
  void onClose() {
    debounce?.cancel();
    super.onClose();
    _apiCommunication.endConnection();
  }
}
