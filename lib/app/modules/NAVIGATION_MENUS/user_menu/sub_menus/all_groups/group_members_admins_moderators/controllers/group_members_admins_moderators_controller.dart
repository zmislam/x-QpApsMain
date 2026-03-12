import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../config/constants/api_constant.dart';
import '../models/all_group_members_admins_moderators_model.dart';
import '../../discover_groups/models/all_group_model.dart';
import '../../../../../../../services/api_communication.dart';

class GroupMembersAdminsModeratorsController extends GetxController {
  RxBool isLoadingGroupMembers = true.obs;

  late ApiCommunication _apiCommunication;
  Rx<List<GroupMemberList>> groupMemberList = Rx([]);
  Rx<AllGroupModel?> allGroupModel = Rx<AllGroupModel?>(null);

  Future<void> getGroupMembers() async {
    isLoadingGroupMembers.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-group-resource/${allGroupModel.value?.id}?type=member',
    );

    if (apiResponse.isSuccessful) {
      final groupMembers =
          (apiResponse.data as Map<String, dynamic>)['groupMembers'];

      if (groupMembers != null && groupMembers is Map<String, dynamic>) {
        final data = groupMembers['data'];
        if (data != null && data is List) {
          groupMemberList.value =
              data.map((element) => GroupMemberList.fromMap(element)).toList();
        } else {
          groupMemberList.value = [];
          debugPrint('Data is null or not a list');
        }
      } else {
        groupMemberList.value = [];
        debugPrint('GroupMembers is null or not a map');
      }
    } else {
      debugPrint('Error: ${apiResponse.message}');
    }

    isLoadingGroupMembers.value = false;

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  @override
  void onClose() {}

  @override
  void onReady() {}

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    allGroupModel = Get.arguments;
    getGroupMembers();
    super.onInit();
  }
}
