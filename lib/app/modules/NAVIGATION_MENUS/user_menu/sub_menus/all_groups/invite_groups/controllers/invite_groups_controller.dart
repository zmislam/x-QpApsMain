import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../models/api_response.dart';
import '../models/all_invite_group_model.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/snackbar.dart';

class InviteGroupsController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  RxInt view = 0.obs;
  Rx<List<InviteGroupsModel>> invitedGroupList = Rx([]);
  RxBool isLoadingUserGroups = false.obs;
  int skip = 0;
  int limit = 10;
  RxInt pageCount = 0.obs;
  late ScrollController groupScrollController;

  //-------------------------------------- Get All Joined Groups ----------------------------//
  Future getAllInvitedGroups() async {
    isLoadingUserGroups.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint:
          'groups/invitation-join-request-list?type=invitation_list&skip=$skip&limit=$limit',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    if (apiResponse.isSuccessful) {
      pageCount.value = (apiResponse.data as Map<String, dynamic>)['totalCount'];
      List<InviteGroupsModel> newGroups =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((e) => InviteGroupsModel.fromMap(e))
              .toList();
      invitedGroupList.value.addAll(newGroups);
      invitedGroupList.refresh();
      // invitedGroupList.value = (apiResponse.data as List)
      //     .map(
      //       (e) => InviteGroupsModel.fromMap(e),
      //     )
      //     .toList();
    }
    isLoadingUserGroups.value = false;
  }

//-------------------------------------- Join Group Request ----------------------------//
  Future groupInvitationAcceptDeclineRequestPost(
      {String? invitationId,
      String? requestType,
      String? notificationIdArray,
      String? status}) async {
    isLoadingUserGroups.value = true;
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'groups/invitation-join-request-accept-decline',
        requestData: {
          'invitation_id': invitationId,
          'notification_id_arr': [notificationIdArray],
          'request_type': requestType ?? 'invite',
          'status': status
        });

    if (apiResponse.isSuccessful) {
      isLoadingUserGroups.value = false;
      invitedGroupList.value.clear();
      getAllInvitedGroups().whenComplete(() => showSuccessSnackkbar(
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
  //=========================================== For Scrolling List View

  Future<void> _scrollListener() async {
    if (groupScrollController.position.pixels ==
        groupScrollController.position.maxScrollExtent) {
      debugPrint('::::::::::::::Scroll');
      if (skip * limit < pageCount.value) {
        skip += 1;
        await getAllInvitedGroups();
      }
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    groupScrollController = ScrollController();
    getAllInvitedGroups();
    super.onInit();
  }

  @override
  void onReady() {
    groupScrollController.addListener(_scrollListener);
    super.onReady();
  }

  @override
  void onClose() {
    groupScrollController.dispose();
    super.onClose();
  }
}
