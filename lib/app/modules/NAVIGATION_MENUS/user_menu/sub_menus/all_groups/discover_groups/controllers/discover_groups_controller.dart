import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../data/login_creadential.dart';
import '../../../../../../../models/api_response.dart';
import '../models/all_group_model.dart';
import '../../../../../../../services/api_communication.dart';
import '../../../../../../../utils/snackbar.dart';

class DiscoverGroupsController extends GetxController {
  late final ApiCommunication _apiCommunication;
  late final LoginCredential loginCredential;
  RxInt view = 0.obs;
  Rx<List<AllGroupModel>> allGroupList = Rx([]);
  RxList<AllGroupModel> filteredGroupsList = <AllGroupModel>[].obs;

  Rx<List<AllGroupModel>> searchedGroupList = Rx([]);
  RxBool isLoadingUserGroups = false.obs;
  RxBool isJoinRequestSent = false.obs;
  Timer? debounce;
// int pageNo =1;
// int pageSize =5;
  int skip = 0;
  int limit = 10;
  int pageCount = 0;
  late ScrollController groupScrollController;

//==========================================Discover page search =============================//
  Future<void> getSearchGroup(String text) async {
    isLoadingUserGroups.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-discover-group?keyword=$text',
    );
    isLoadingUserGroups.value = false;

    if (apiResponse.isSuccessful) {
      searchedGroupList.value =
          (((apiResponse.data as Map<String, dynamic>)['data']) as List)
              .map((element) => AllGroupModel.fromMap(element))
              .toList();
      searchedGroupList.refresh();
    } else {
      debugPrint('Error');
    }
  }

  //-------------------------------------- All Groups ----------------------------//
  Future getAllGroups() async {
    isLoadingUserGroups.value = true;
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-all-group?skip=$skip&limit=$limit',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    if (apiResponse.isSuccessful) {
      pageCount = (apiResponse.data as Map<String, dynamic>)['totalCount'];
      // allGroupList.value = (((apiResponse.data as Map<String, dynamic>)['data'])as List)
      //     .map(
      //       (e) => AllGroupModel.fromMap(e),
      //     )
      //     .toList();

      List<AllGroupModel> newGroups =
          (((apiResponse.data as Map<String, dynamic>)['data']) as List)
              .map((e) => AllGroupModel.fromMap(e))
              .toList();

      allGroupList.value.addAll(newGroups);
      allGroupList.refresh();
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
      allGroupList.value.clear();
      getAllGroups().whenComplete(() => showSuccessSnackkbar(
          titile: 'Success', message: 'Join request sent successfully'));
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

  //=========================================== For Scrolling List View

  Future<void> _scrollListener() async {
    if (groupScrollController.position.pixels ==
        groupScrollController.position.maxScrollExtent) {
      debugPrint('::::::::::::::Scroll');
      if (skip * limit < pageCount) {
        skip += 1;
        await getAllGroups();
      }
    }
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();
    groupScrollController = ScrollController();
    getAllGroups();
    // groupScrollController.addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onReady() {
    groupScrollController.addListener(_scrollListener);
    super.onReady();
  }

  @override
  void onClose() {
    debounce?.cancel();
    groupScrollController.dispose();
    super.onClose();
  }
}
