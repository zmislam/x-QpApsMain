import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../models/api_response.dart';
import '../../../../../../../models/post.dart';
import '../../../../../../../models/user.dart';
import '../models/group_all_group_admin_model.dart';
import '../models/group_all_group_members_model.dart';
import '../models/group_all_group_moderators_model.dart';
import '../../discover_groups/models/all_group_model.dart';
import '../../group_profile/controllers/group_profile_controller.dart';
import '../../../all_pages/pages/model/admin_moderator_model.dart';
import '../../../../../../../repository/page_repository.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/snackbar.dart';

class GroupSettingsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  late UserModel userModel;
  Timer? debounce;
  final GlobalKey<FormState> formKey = GlobalKey();

  var isSaveButtonEnabled = false.obs;
  var isFollowing = false.obs;
  Rx<AllGroupModel?> allGroupModel = Rx<AllGroupModel?>(null);
  //----------------------------- TextEditingController -----------------------------------//

  late TextEditingController groupNameController;

  late TextEditingController locationController;

  late TextEditingController descriptionController;
  RxString selectedGroupPrivacy = ''.obs;
  RxString selectedPostApprovalAuthority = ''.obs;

  //----------------------------- Model -----------------------------------//

  var allGroupMemberList = <GroupMembersModel>[].obs;
  var filteredMemberList = <GroupMembersModel>[].obs;
  var selectedGroupMemberList = <GroupMembersModel>[].obs;
  var selectedGroupMemberId = <GroupMembersModel>[].obs;
  var allAdminsList = <GroupAdminModel>[].obs;
  var allModeratorsList = <GroupModeratorDetails>[].obs;
  GroupAdminModel? adminDetails;
  GroupModeratorDetails? moderatorDetails;

  Rx<List<PostModel>> postList = Rx([]);
  Rx<List<PostModel>> pinnedPostList = Rx([]);
  Rx<List<AdminModeratorModel>> pageAdminModeratorList = Rx([]);
  Rx<String> updateUserRole = 'Admin'.obs;
  Rx<String> selectedUserRole = 'Admin'.obs;
  RxInt adminCount = 0.obs;
  RxInt moderatorCount = 0.obs;
  GroupProfileController groupProfileController = Get.find();
  // MyGroupsController myGroupsController = Get.find();
  Rx<List<AllGroupModel>> myGroupList = Rx([]);

  //----------------------------- Image files, Privacy, Page view -----------------------------------//
  Rx<List<XFile>> xfiles = Rx([]);

  RxString searchQuery = ''.obs;

  //----------------------------------Loading----------------------------------//

  RxBool isLoadingNewsFeed = true.obs;
  RxBool isLoadingUserGroups = true.obs;
  RxBool isCommentReactionLoading = true.obs;
  RxBool isReplyReactionLoading = true.obs;
  RxBool isLoadingUserPhoto = false.obs;
  RxBool isLoadingProfilePhoto = false.obs;
  RxBool isLoadingCoverPhoto = false.obs;
  RxBool isLoadingMediaPhoto = false.obs;
  RxBool isLoadingUserPages = false.obs;
  RxBool isLoadingUserVideo = false.obs;
  RxBool isLoadingFriendList = true.obs;

  //----------------------------------Page newsfeed----------------------------------//

  int pageNo = 1;
  final int pageSize = 10;
  int totalPageCount = 0;
  final PageRepository pageRepository = PageRepository();
  String? pageId;

  //---------------------------------------- EDIT ALBUM ----------------------------//

  // Future<void> editalbum(String albumId) async {
  //   final ApiResponse response = await _apiCommunication
  //       .doPostRequest(apiEndPoint: 'edit-album', requestData: {
  //     'album_id': albumId,
  //     'album_title': pageAlbumNameController.text,
  //     'privacy': (getPostPrivacyValue(dropdownValue.value)),
  //   });
  //   if (response.isSuccessful) {
  //     getPageAlbums(pageProfileModel.value?.pageDetails?.id ?? '');
  //     Get.back();
  //     showSuccessSnackkbar(message: 'Album updated successfully');
  //   } else {
  //     debugPrint('');
  //   }
  // }

  //------------------------------------------ Edit Group Info -------------------------//

  Future<void> editGroupInfo() async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'groups/edit-group/${allGroupModel.value?.id}',
      enableLoading: true,
      requestData: {
        'group_name': groupNameController.text,
        'group_description': descriptionController.text,
        'location': locationController.text,
        'group_privacy': selectedGroupPrivacy.value.toLowerCase(),
        'participant_approve_by':
            selectedPostApprovalAuthority.value.toLowerCase()
        //  'custom_link',
        //  'post_approve_by',
        //  'is_post_approve',
      },
    );
    if (response.isSuccessful) {
      // getPageDetails();
      GroupProfileController groupProfileController = Get.find();
      groupProfileController.fetchGroupDetails();

      Get.back();
      Get.back();

      showSuccessSnackkbar(message: 'Group Info updated successfully');
    } else {
      debugPrint('EROOROOROO');
    }
  }

  //====================== Get All My Groups ===============================================//
  Future getAllMyGroups() async {
    isLoadingUserGroups.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-my-groups-apps',
      responseDataKey: 'results',
    );

    if (apiResponse.isSuccessful) {
      myGroupList.value = (apiResponse.data as List)
          .map(
            (e) => AllGroupModel.fromMap(e),
          )
          .toList();
    }
    isLoadingUserGroups.value = false;
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
      getAllMyGroups();

      showSuccessSnackkbar(message: 'Group Deleted successfully');
    } else {
      debugPrint('EROOROOROO');
    }
  }

  //------------------------------------------- Friend List -------------------------//

  //------------------------------------------- Group Members List APi -------------------------//

  Future<void> getGroupMemberList() async {
    isLoadingUserPages.value = true;

    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-group-resource/${allGroupModel.value?.id}?type=member',
      responseDataKey: 'groupMembers',
    );

    if (apiResponse.isSuccessful) {
      var data = apiResponse.data;

      debugPrint('API Response Data: $data'); // Debug print

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        var membersData = data['data'];

        if (membersData is List) {
          selectedGroupMemberList.value = membersData
              .map<GroupMembersModel>(
                (e) => GroupMembersModel.fromMap(e as Map<String, dynamic>),
              )
              .toList();
        } else {
          debugPrint('Unexpected format for members data: $membersData');
          selectedGroupMemberList.value = [];
        }
      } else {
        debugPrint(
            'Data does not contain expected key "data" or is not a Map: $data');
        selectedGroupMemberList.value = [];
      }
    } else {
      debugPrint('API Response Error: ${apiResponse.message}');
      selectedGroupMemberList.value = [];
    }

    isLoadingUserPages.value = false;
  }

  //------------------------------------------- Group Admin List APi -------------------------//

  Future<void> getGroupAdminList() async {
    isLoadingUserPages.value = true;

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

    isLoadingUserPages.value = false;
  }

  //------------------------------------------- Group Moderator List APi -------------------------//

  Future<void> getGroupModeratorList() async {
    isLoadingUserPages.value = true;

    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint:
          'get-group-resource/${allGroupModel.value?.id}?type=moderator',
      responseDataKey: 'groupModerator',
    );

    if (apiResponse.isSuccessful) {
      var data = apiResponse.data as Map;
      if (data.containsKey('count')) {
        moderatorCount.value = data['count'];
      } else {
        moderatorCount.value = 0;
      }

      debugPrint('API Response Data: $data');
      debugPrint('Moderator Count: $moderatorCount');

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        var moderatorsData = data['data'];

        if (moderatorsData is List) {
          allModeratorsList.value = moderatorsData
              .map<GroupModeratorDetails>(
                (e) => GroupModeratorDetails.fromMap(e as Map<String, dynamic>),
              )
              .toList();
        } else {
          debugPrint('Unexpected format for moderator data: $moderatorsData');
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

    isLoadingUserPages.value = false;
  }

  //------------------------------------------- Filter Group  Members-------------------------//

  void _filterMembers(String query) {
    filteredMemberList.value = allGroupMemberList.where((member) {
      final fullName =
          '${member.groupMemberUserId?.firstName ?? ''} ${member.groupMemberUserId?.lastName ?? ''}'
              .toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();
  }

  void searchFriends(String query) {
    searchQuery.value = query;
  }

//====================================== Filter Members To Add As Admin / Moderator ==========================================//
  Future<void> _fetchAndFilterMembers(String query) async {
    // isLoading.value = true;

    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-group-resource/${allGroupModel.value?.id}?type=member',
      responseDataKey: 'groupMembers',
    );

    if (apiResponse.isSuccessful) {
      var data = apiResponse.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        var membersData = data['data'];
        if (membersData is List) {
          allGroupMemberList.value = membersData
              .map<GroupMembersModel>(
                (e) => GroupMembersModel.fromMap(e as Map<String, dynamic>),
              )
              .toList();
          _filterMembers(query);
        } else {
          debugPrint('Unexpected format for members data: $membersData');
          allGroupMemberList.value = [];
          filteredMemberList.value = [];
        }
      } else {
        debugPrint(
            'Data does not contain expected key "data" or is not a Map: $data');
        allGroupMemberList.value = [];
        filteredMemberList.value = [];
      }
    } else {
      debugPrint('API Response Error: ${apiResponse.message}');
      allGroupMemberList.value = [];
      filteredMemberList.value = [];
    }

    // isLoading.value = false;
  }

//========================= Add Admin Or Moderator ==================================//
  Future<void> addAdminOrModerator() async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint:
          'groups/edit-group-member/${selectedGroupMemberList.first.id}',
      requestData: {
        'role': selectedUserRole.value.toLowerCase(),
        'group_id': allGroupModel.value?.id ?? '',
        'group_member_user_id':
            selectedGroupMemberList.first.groupMemberUserId?.id,
      },
    );
    if (response.isSuccessful) {
      if (selectedGroupMemberList.isNotEmpty) {
        selectedGroupMemberList.refresh();
        getGroupAdminList();
        getGroupModeratorList();
        // groupProfileController.leaveFromGroupPatch();
        Get.back();

        showSuccessSnackkbar(
            message:
                '${selectedGroupMemberList.first.groupMemberUserId?.firstName?.capitalizeFirst} added as a ${selectedUserRole.value} ');
      } else {
        selectedGroupMemberList.refresh();
        getGroupAdminList();
        getGroupModeratorList();
        Get.back();
        showSuccessSnackkbar(message: 'Admin or moderator added');
      }
    } else {
      debugPrint('');
    }
  }

  Future<void> groupTransferOwnerShip() async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint:
          'groups/edit-group-member/${selectedGroupMemberList.first.id}',
      requestData: {
        'role': selectedUserRole.value.toLowerCase(),
        'group_id': allGroupModel.value?.id ?? '',
        'group_member_user_id':
            selectedGroupMemberList.first.groupMemberUserId?.id,
      },
    );
    if (response.isSuccessful) {
      if (selectedUserRole.value.capitalizeFirst == 'Admin' &&
          selectedGroupMemberList.isNotEmpty) {
        groupProfileController.leaveFromGroupPatch();
        Get.back();
        // Get.back();
        // showSuccessSnackkbar(message: 'Leaved From Group Successfully!');
      } else {
        selectedGroupMemberList.refresh();
        getGroupAdminList();
        getGroupModeratorList();
        Get.back();
        showSuccessSnackkbar(message: 'Admin or moderator added');
      }
    } else {
      debugPrint('');
    }
  }

  //----------------------------------------------Remove Admin or Moderaote
  Future<void> removeAdminOrModerator(
      {String? groupMemberId, String? groupMemberUserId, String? role}) async {
    final ApiResponse response = await _apiCommunication.doPatchRequest(
      apiEndPoint: 'groups/edit-group-member/$groupMemberId',
      requestData: {
        'role': role,
        'group_id': allGroupModel.value?.id ?? '',
        'group_member_user_id': groupMemberUserId,
      },
    );
    if (response.isSuccessful) {
      getGroupAdminList();
      getGroupModeratorList();

      showSuccessSnackkbar(message: 'Admin or moderator removed successfully');
    } else {
      debugPrint('');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    userModel = loginCredential.getUserData();
    // pageUserName = Get.arguments as String;
    allGroupModel = Get.arguments['group_model'];
    selectedUserRole.value = Get.arguments['group_role'];
    selectedGroupMemberList.clear();
    // getGroupMemberList();
    searchQuery.listen((query) {
      if (query.isNotEmpty) {
        _fetchAndFilterMembers(query);
      } else {
        filteredMemberList.value = [];
      }
    });
    getGroupAdminList();
    getGroupModeratorList();
    groupNameController =
        TextEditingController(text: allGroupModel.value?.groupName);
    descriptionController =
        TextEditingController(text: allGroupModel.value?.groupDescription);
    locationController =
        TextEditingController(text: allGroupModel.value?.location);
  }

  @override
  void onClose() {
    selectedGroupMemberList.clear();
    allGroupMemberList.value = [];
    debounce?.cancel();
    super.onClose();
    _apiCommunication.endConnection();
  }
}
