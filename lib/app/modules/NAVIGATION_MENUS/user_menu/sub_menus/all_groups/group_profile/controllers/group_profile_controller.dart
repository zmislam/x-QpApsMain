import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../data/post_local_data.dart';
import '../../../../../../../models/media_type_model.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/comment_model.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../models/user.dart';
import '../../../../../../../models/video_campaign_model.dart';
import '../../../../../../shared/modules/create_post/models/fileCheckState.dart';
import '../../../../../../shared/modules/create_post/models/imageCheckerModel.dart';
import '../../../../../../shared/modules/create_post/service/imageCheckerService.dart';
import '../../create_group/models/friend_list_model.dart';
import '../../group_admin/models/group_all_group_admin_model.dart';
import '../../group_admin/models/group_member_join_list_model.dart';
import '../models/group_album_model.dart';
import '../models/group_details_response_model.dart';
import '../models/group_file_list_model.dart';
import '../models/group_photo_model.dart';
import '../../discover_groups/controllers/discover_groups_controller.dart';
import '../../discover_groups/models/all_group_model.dart';
import '../../invite_groups/controllers/invite_groups_controller.dart';
import '../../joined_groups/controllers/joined_groups_controller.dart';
import '../../my_groups/controllers/my_groups_controller.dart';
import '../../../all_pages/pages/model/report_model.dart';
import '../../../profile/models/profile_cover_albums_model.dart';
import '../../../../../../../repository/post_repository.dart';
import '../../../../../../../routes/app_pages.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/post_utlis.dart';
import '../../../../../../../utils/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupProfileController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  final PostRepository postRepository = PostRepository();
  // DiscoverGroupsController groupsController = Get.find();

  late TextEditingController descriptionController;
  late TextEditingController reportDescription;
  Rx<List<FriendResultModel>> friendList = Rx([]);
  Rx<List<PageReportModel>> pageReportList = Rx([]);
  RxString selectedReportId = ''.obs;
  RxString selectedReportType = ''.obs;
  var currentAdIndex = 0.obs;

  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingProfilePhoto = false.obs;
  RxBool isLoadingUserPages = false.obs;
  Rx<List<GroupPhotoModel>> photoList = Rx([]);
  Rx<List<GroupProfileAlbumModel>> groupProfileAlbumList = Rx([]);
  // MyGroupsController myGroupsController = Get.find();

  Rx<List<FileItem>> fileItemsList = Rx([]);
  Rx<List<FriendResultModel>> selectedFriendList = Rx([]);

  RxBool isCommentReactionLoading = true.obs;
  RxBool isReplyReactionLoading = true.obs;
  RxBool updateCheckBox = true.obs;
  RxBool isGroupMember = true.obs;
  RxString groupRole = 'admin'.obs;
  RxInt storyCaroselInitialIndex = 0.obs;
  Rx<int> groupProfileWidgetViewNumber = 0.obs;
  Rx<List<PostModel>> postList = Rx([]);
  Rx<AllGroupModel?> allGroupModel = Rx<AllGroupModel?>(null);
  Rx<List<AllGroupModel>> myGroupList = Rx([]);
  Rx<List<GroupMemberRequestListModel>> memberRequestList = Rx([]);

  GroupDetailsModel? groupDetailsModel;
  late ScrollController postScrollController;
  RxString dropdownValue = privacyList.first.obs;
  RxString postPrivacy = 'public'.obs;
  String? groupId;
  String? groupType;
  RxInt? joinedGroupsCount;
  // GroupSettingsController groupSettingsController =Get.lazyPut(()=>GroupSettingsController());

  Rx<List<XFile>> xfiles = Rx([]);
  Rx<XFile?> coverPicXFile = Rx<XFile?>(null);

  RxString commentsID = ''.obs;
  RxString postID = ''.obs;

  RxBool isLoadingNewsFeed = true.obs;
  var allAdminsList = <GroupAdminModel>[].obs;
  RxInt adminCount = 0.obs;

  Rx<bool> isBackgroundColorPost = false.obs;

  int pageNo = 1;
  final int pageSize = 20;
  int totalPageCount = 0;
  RxBool isNextPage = false.obs;
  RxBool isLoadingUserGroups = false.obs;
  RxBool isJoinRequestSent = false.obs;
  RxBool isLoadingMemberRequest = false.obs;
  RxBool isExpandedGroupDescription = false.obs;
  late TextEditingController commentController;
  late TextEditingController commentReplyController;
  RxBool isReply = false.obs;
  Rx<List<MediaTypeModel>> imageFromNetwork = Rx([]);
  RxBool isLoading = false.obs;
  final RxString checkingStatus = ''.obs;
  final RxBool isCheckingFiles = false.obs;
  final RxList<String> processedFileData = <String>[].obs;
  final processedCommentFileData = ''.obs;
  RxList<FileCheckingState> fileCheckingStates = <FileCheckingState>[].obs;

  final count = 0.obs;

  Future<void> pickMediaFiles() async {
    isLoading.value = true;
    final ImagePicker picker = ImagePicker();
    xfiles.value = await picker.pickMultipleMedia();

    onTapCreatePost();
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

///////////////////////////Leave From Group///////////////////////////////////////
  Future<void> leaveFromGroupPatch() async {
    final apiResponse = await _apiCommunication.doPatchRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint:
          'group-member-status-change?group_id=$groupId&user_id=${userModel.id}&status=left',
    );

    if (apiResponse.isSuccessful) {
      // updateReactionLocally(
      //     index: index, postId: postModel.id ?? '', reaction: reaction);
      debugPrint(apiResponse.message);
      if (groupType == 'joinedGroup') {
        JoinedGroupsController joinedGroupsController = Get.find();
        joinedGroupsController.getAllJoinedGroups();
      } else if (groupType == 'myGroup') {
        MyGroupsController myGroupsController = Get.find();
        myGroupsController.getAllMyGroups();
      } else if (groupType == 'discoverGroup') {
        DiscoverGroupsController discoverGroupsController = Get.find();
        discoverGroupsController.getAllGroups();
      } else if (groupType == 'invitedGroup') {
        InviteGroupsController invitedGroupsController = Get.find();
        invitedGroupsController.getAllInvitedGroups();
      } else if (groupType == '') {
        fetchGroupDetails();
      }
      Get.back();
      showSuccessSnackkbar(
          message:
              'Leaved from ${allGroupModel.value?.groupName} successfully');
      // updatePostList(postModel.id ?? '', index);
    } else {
      debugPrint(apiResponse.message);
      showSuccessSnackkbar(
          message:
              'Leaved from ${allGroupModel.value?.groupName} failed');
    }
  }
//--------------------------------------- DELETE PHOTOS ----------------------------//

  Future<void> deletePhotos(String mediaId, String key) async {
    final ApiResponse response = await _apiCommunication
        .doPostRequest(apiEndPoint: 'delete-post-media-by-id', requestData: {
      'media_id': mediaId,
      'media': 'posts',
      'key' : key
    });
    if (response.isSuccessful) {
      getGroupAlbums();
      // getGroupCoverPhotos();
      // getProfilePictures();
      // getMediaPhotos(mediaId);

      ProfilPicturesemodel;

      // Get.back();
      showSuccessSnackkbar(message: 'Photo deleted successfully');
    } else {
      debugPrint('');
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
        'post_id': post_id,
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

//-------------------------------------- Join Group Request ----------------------------//
  Future joinGroupRequestPost(
      {String? groupId, String? type, String? userIdArray}) async {
    isLoadingUserGroups.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'groups/send-group-invitation-join-request',
        requestData: {
          'group_id': groupId,
          'type': type ?? 'join',
          'user_id_arr': [userIdArray]
        });

    if (apiResponse.isSuccessful) {
      isLoadingUserGroups.value = false;
      // getAllGroups().whenComplete(()=> showSnackkbar(titile: 'Success', message: 'Join request sent successfully'));
      isJoinRequestSent.value = true;

      debugPrint(
          '::::::::::::::Join Group response SUCCESSSSS: ${apiResponse.message}::::::::::::::::::::::::');
      // allGroupList.value = (apiResponse.data as List)
      //     .map(
      //       (e) => AllGroupModel.fromMap(e),
      //     )
      //     .toList();
    } else {
      debugPrint(
          '::::::::::::::Join Group response FAILEDDDDD: ${apiResponse.message}::::::::::::::::::::::::');
    }
  }
//------------------------------------------- Group Admin List APi -------------------------//

  Future<void> getGroupAdminList() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-group-resource/${allGroupModel.value?.id}?type=admin',
      responseDataKey: 'groupAdmins',
    );

    if (apiResponse.isSuccessful) {
      var data = apiResponse.data as Map;
      if (data.containsKey('count')) {
        adminCount.value = data['count'];
      } else {
        adminCount.value = 0;
      }

      debugPrint('API Response Data: $data'); // Debug print
      debugPrint('Admin Count: $adminCount');

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        var adminsData = data['data'];

        if (adminsData is List) {
          allAdminsList.value = adminsData
              .map<GroupAdminModel>(
                (e) => GroupAdminModel.fromMap(e as Map<String, dynamic>),
              )
              .toList();
        } else {
          debugPrint('Unexpected format for admons data: $adminsData');
          allAdminsList.value = [];
        }
      } else {
        debugPrint(
            'Data does not contain expected key "data" or is not a Map: $data');
        allAdminsList.value = [];
      }
    } else {
      debugPrint('API Response Error: ${apiResponse.message}');
      allAdminsList.value = [];
    }
  }

//--------------------------------------  Friend List for Invitation in Group----------------------------//
  Future<void> inviteFriendList() async {
    final ApiResponse apiResponse = await _apiCommunication.doPostFormRequest(
      apiEndPoint: 'friend-list-for-group-invitation-app',
      enableLoading: true,
      responseDataKey: 'result',
      requestData: {'group_id': groupId},
    );

    if (apiResponse.isSuccessful) {
      debugPrint(
          '::::::::::::::::::::::::My Friend List::::::${apiResponse.data}:::::::::::::::::::::::::');

      if (apiResponse.data != null && apiResponse.data is List) {
        friendList.value = (apiResponse.data as List)
            .map((e) => FriendResultModel.fromMap(e))
            .toList();
      } else {
        debugPrint('Friend list data is null or not a list.');
        friendList.value = [];
      }
    } else {
      debugPrint(
          '"""""""""""""Friend List Error:::::::::${apiResponse.message}');
    }
  }
//=========================================Get Member Join Request List API===============================================//

  Future getGroupMemberJoinRequest() async {
    isLoadingMemberRequest.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint:
          'groups/invitation-join-request-list?type=join_request_list&group_id=$groupId',
      responseDataKey: 'result',
    );

    if (apiResponse.isSuccessful) {
      memberRequestList.value = (apiResponse.data as List)
          .map(
            (e) => GroupMemberRequestListModel.fromMap(e),
          )
          .toList();
    }
    isLoadingMemberRequest.value = false;
  }
//--------------------------------------  Is Joined Group Or Not(Get Group Details By Id)----------------------------//
  // Future<void> groupMemberCheckPost() async {
  //   final ApiResponse apiResponse = await _apiCommunication.doPostFormRequest(
  //     apiEndPoint: 'get-group-details-by-id',
  //     enableLoading: true,
  //     responseDataKey: 'isMember',
  //     requestData: {'group_id': allGroupModel?.id},
  //   );

  //   if (apiResponse.isSuccessful) {
  //     debugPrint(
  //         '::::::::::::::::::::::::My Friend List::::::${apiResponse.data}:::::::::::::::::::::::::');

  //     if (apiResponse.data != null) {
  //       isGroupMember.value = (apiResponse.data as bool);
  //     } else {
  //       debugPrint('Error groupMemberCheckPost API');
  //     }
  //   } else {
  //     debugPrint(
  //         '"""""""""""""Group Member Error:::::::::${apiResponse.message}');
  //   }
  // }

//-------------------------------------- Fetch Group Details API----------------------------//

  Future<void> fetchGroupDetails() async {
    final ApiResponse apiResponse = await _apiCommunication.doPostFormRequest(
      apiEndPoint: 'get-group-details-by-id',
      enableLoading: true,
      responseDataKey: ApiConstant.FULL_RESPONSE,
      requestData: {'group_id': groupId},
    );

    if (apiResponse.isSuccessful) {
      debugPrint(
          '::::::::::::::::::::::::Group Details::::::${apiResponse.data}:::::::::::::::::::::::::');

      if (apiResponse.data != null &&
          apiResponse.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseData =
            apiResponse.data as Map<String, dynamic>;

        GroupDetailsResponse groupDetailsResponse =
            GroupDetailsResponse.fromMap(responseData);

        if (groupDetailsResponse.groupDetailsModel != null) {
          allGroupModel.value = convertGroupIdToAllGroupModel(
              groupDetailsResponse.groupDetailsModel?.groupIdModel ??
                  GroupIdModel());
          // groupRole.value = '';
          isGroupMember.value = groupDetailsResponse.isMember ?? false;
          groupRole.value =
              groupDetailsResponse.groupDetailsModel?.role ?? 'admin';
        } else {
          debugPrint('Error fetching group details: groupDetailsModel is null');
        }
      } else {
        debugPrint('Error fetching group details: Invalid data format');
      }
    } else {
      debugPrint('Group Details API Error: ${apiResponse.message}');
    }
  }

  AllGroupModel convertGroupIdToAllGroupModel(GroupIdModel? groupIdModel) {
    return AllGroupModel(
      id: groupIdModel?.id ?? '',
      groupCoverPic: groupIdModel?.groupCoverPic ?? '',
      groupDescription: groupIdModel?.groupDescription ?? '',
      groupName: groupIdModel?.groupName ?? '',
      groupPrivacy: groupIdModel?.groupPrivacy ?? '',
      location: groupIdModel?.location ?? '',
      postApproveBy: groupIdModel?.postApproveBy ?? 'admin',
      joinedGroupsCount: groupIdModel?.joinedGroupsCount ?? 0,
    );
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
        'group_id': groupId,
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

//-------------------------------------- Join Group Request ----------------------------//
  Future groupMemberAcceptDeclinePost(
      {String? invitationId,
      String? requestType,
      String? notificationIdArray,
      String? status}) async {
    isLoadingUserGroups.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'groups/invitation-join-request-accept-decline',
        requestData: {
          'invitation_id': invitationId,
          // 'notification_id_arr':[notificationIdArray],
          'request_type': 'join',
          'status': status
        });

    if (apiResponse.isSuccessful) {
      isLoadingUserGroups.value = false;
      getGroupMemberJoinRequest().whenComplete(() => showSuccessSnackkbar(
          titile: 'Success', message: 'Request ${status}ed successfully'));

      debugPrint(
          '::::::::::::::Group Invitation SUCCESSSSS: ${apiResponse.data}::::::::::::::::::::::::');
      // allGroupList.value = (apiResponse.data as List)
      //     .map(
      //       (e) => AllGroupModel.fromMap(e),
      //     )
      //     .toList();
    } else {
      debugPrint(
          '::::::::::::::Group Invitation  response FAILEDDDDD: ${apiResponse.data}::::::::::::::::::::::::');
    }
  }

//--------------------------------------Group File Delete ----------------------------//
  Future deleteGroupFilesPost({String? mediaId, String? key}) async {
    isLoadingUserGroups.value = true;
    ApiResponse apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'delete-post-media-by-id', requestData: {
      'media_id': mediaId,
      'key' : key,
    });

    if (apiResponse.isSuccessful) {
      isLoadingUserGroups.value = false;

      debugPrint(
          '::::::::::::::Group Invitation SUCCESSSSS: ${apiResponse.data}::::::::::::::::::::::::');
      fetchGroupFiles();
      // allGroupList.value = (apiResponse.data as List)
      //     .map(
      //       (e) => AllGroupModel.fromMap(e),
      //     )
      //     .toList();
    } else {
      debugPrint(
          '::::::::::::::Group Invitation  response FAILEDDDDD: ${apiResponse.data}::::::::::::::::::::::::');
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
      apiEndPoint: 'groups/get-group-files/$groupId',
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
          fileKey: 'image_or_video',);

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
    List<XFile> mediaXFiles = await picker.pickMultipleMedia();

    if (mediaXFiles.isNotEmpty) {
      processedFileData.clear();
      processedCommentFileData.value = '';
      xfiles.value.clear();

      await checkFilesForVulgarity(mediaXFiles);
    }

    debugPrint(
        '=================X file Value====================${xfiles.value}');
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

  //========================================= Change Cover Pictuure==================================//
  Future<void> changeCoverPicture() async {
    debugPrint('=================X file Value start====================');

    final ImagePicker picker = ImagePicker();
    coverPicXFile.value = await picker.pickImage(source: ImageSource.gallery);

    if (coverPicXFile.value == null) {
      debugPrint('No picture selected. API will not be called.');
      // showErrorSnackkbar(message: 'No picture selected.');
      return;
    }

    final List<XFile> mediaFiles = [
      if (coverPicXFile.value != null) coverPicXFile.value!
    ];

    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'change-group-cover-pic',
      isFormData: true,
      enableLoading: true,
      fileKey: 'group_cover_pic',
      requestData: {
        'groupId': groupId, //postModel.user_id?.id,
      },
      mediaXFiles: mediaFiles,
    );

    if (response.isSuccessful) {
      fetchGroupDetails();
      postList.value.clear();
      postList.refresh();
      pageNo = 1;
      getGroupPosts();
      getGroupPhotos();

      debugPrint(
          '===================Group Cover Pic Upload Status ${response.statusCode}=====================');
      showSuccessSnackkbar(message: 'Group Cover Pic Uploaded Successfully!');
    } else {
      debugPrint('Failed to upload Group Cover Pic');
    }

    debugPrint(
        '=================X file Value====================${coverPicXFile.value}');
  }
  //------------------------------------------ Delete Group -------------------------//

  Future<void> deleteGroup() async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'groups/delete-group/${allGroupModel.value?.id}',
      enableLoading: true,
      requestData: {},
    );
    if (response.isSuccessful) {
      // getPageDetails();

      Get.back();
      Get.back();
      // myGroupsController.getAllMyGroups();
      // getAllMyGroups();

      showSuccessSnackkbar(message: 'Group Deleted successfully');
    } else {
      debugPrint('EROOROOROO');
    }
  }

//=============================== Create Photo Comment ============================//
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
    await Get.toNamed(Routes.CREATE_GROUP_POST, arguments: {
      'group_id': allGroupModel.value,
      'media_files': xfiles.value,
      'processed_file_data': processedFileData,
    });
    pageNo = 1;
    totalPageCount = 0;
    postList.value.clear();
    getGroupPosts();
  }
//=============================== Edit Post ============================//

  void onTapEditPost(PostModel model) async {
    await Get.toNamed(Routes.EDIT_POST, arguments: model);
    postList.value.clear();
    getGroupPosts();
  }

  Future<void> getGroupPosts() async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await postRepository.getGroupPosts(
      groupId: groupId ?? '',
      pageNo: pageNo,
      pageSize: pageSize,
    );
    if (apiResponse.isSuccessful) {
      isLoadingNewsFeed.value = false;

      totalPageCount = apiResponse.pageCount ?? 1;
      postList.value.addAll(apiResponse.data as List<PostModel>);
      postList.refresh();
    } else {
      debugPrint(
          '::::::::::::::::::::::::::::: Get Group Post Error:::::::${apiResponse.message}');
      //Error Response
    }
  }
//============================= Get Video Ads =========================================//

  Rx<List<VideoCampaignModel>> videoAdList =
      Rx([]); // Store ads posts separately

  Future<void> getVideoAds() async {
    isLoadingNewsFeed.value = true;

    final ApiResponse apiResponse = await postRepository.getVideoAds();
    isLoadingNewsFeed.value = false;
    if (apiResponse.isSuccessful) {
      videoAdList.value = apiResponse.data
          as List<VideoCampaignModel>; // Store the ads separately
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

  ///==============================================Get Group All Photos and Vides=======================================================////
  Future getGroupPhotos() async {
    isLoadingUserPhoto.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'get-group-latest-image-video',
      requestData: {
        'group_id': groupId,
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
        'group_id': groupId,
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
      if (pageNo != totalPageCount) {
        pageNo += 1;
        await getGroupPosts();
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
      getGroupPosts();
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

  //======================Block User================================//
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
      // friendList.refresh();
      // Get.back();
      // Get.back();
      showSuccessSnackkbar(message: 'Successfully blocked');
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();
    postScrollController = ScrollController();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    groupId = Get.arguments['id'];
    groupType = Get.arguments['group_type'];
    debugPrint('groupId.value: $groupId');
    debugPrint('groupType.value: $groupType');
    // joinedGroupsCount?.value =Get.arguments;
    await fetchGroupDetails();
    // allGroupModel = Get.arguments;
    await getVideoAds();

    await getGroupPosts();
    await fetchGroupFiles();
    // groupMemberCheckPost();
    await getGroupPhotos();
    await getGroupAlbums();
    // fetchGroupFiles();
    // getGroupAdminList();

    commentController = TextEditingController();
    commentReplyController = TextEditingController();
    descriptionController = TextEditingController();
    reportDescription = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    postScrollController.addListener(_scrollListener);
    super.onReady();
  }

  void increment() => count.value++;
}
