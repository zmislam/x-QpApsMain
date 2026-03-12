import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../models/api_response.dart';
import '../../discover_groups/models/all_group_model.dart';
import '../../../../../../../services/api_communication.dart';

class JoinedGroupsController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  late final ScrollController groupScrollController;
  RxInt view = 0.obs;
  Rx<List<AllGroupModel>> joinedGroupList = Rx([]);
  RxBool isLoadingUserGroups = false.obs;
  int pageNo = 1;
  int pageSize = 10;
  RxInt pageCount = 0.obs;

  //-------------------------------------- Get All Joined Groups ----------------------------//
  Future getAllJoinedGroups() async {
    isLoadingUserGroups.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint:
          'get-all-joined-group-apps?pageNo=$pageNo&pageSize=$pageSize',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    if (apiResponse.isSuccessful) {
      pageCount.value = (apiResponse.data as Map<String, dynamic>)['totalCount'];
      List<AllGroupModel> newGroups =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((e) => AllGroupModel.fromMap(e))
              .toList();

      joinedGroupList.value.addAll(newGroups);
      // joinedGroupList.refresh();
      // joinedGroupList.value = (apiResponse.data as List)
      //     .map(
      //       (e) => AllGroupModel.fromMap(e),
      //     )
      //     .toList();
    }
    isLoadingUserGroups.value = false;
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
  //=========================================== For Scrolling List View

  Future<void> _scrollListener() async {
    if (groupScrollController.position.pixels ==
        groupScrollController.position.maxScrollExtent) {
      debugPrint('::::::::::::::Scroll');
      if (pageNo * pageSize < pageCount.value) {
        pageNo += 1;
        await getAllJoinedGroups();
      }
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    groupScrollController = ScrollController();
    getAllJoinedGroups();
    super.onInit();
  }

  @override
  void onReady() {
    groupScrollController.addListener(_scrollListener);
    super.onClose();
  }

  @override
  void onClose() {
    groupScrollController.dispose();
    super.onClose();
  }
}
