import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../friend/controllers/friend_controller.dart';
import '../../../../../../../../services/api_communication.dart';
import '../../../../../../../../utils/snackbar.dart';
import '../../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../../models/friend.dart';

class MyProfileFriendsController extends GetxController {
  RxBool isLoadingFriendList = true.obs;

  late ApiCommunication _apiCommunication;
  Rx<List<FriendModel>> friendList = Rx([]);
  Rx<List<FriendModel>> searchedFriendList = Rx([]);
  FriendModel? friendModel;

  FriendController friendController = Get.find();
  RxString searchKey = ''.obs;

  Future<void> getFriends() async {
    isLoadingFriendList.value = true;

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-friend',
    );

    if (apiResponse.isSuccessful) {
      friendList.value =
          (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((element) => FriendModel.fromJson(element))
              .toList();
      debugPrint(friendList.value.length.toString());
    } else {
      debugPrint('Error');
    }

    isLoadingFriendList.value = false;

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

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
      getFriends();
      friendList.refresh();

      showSuccessSnackkbar(titile: 'Success', message: 'Successfully Blocked');

      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> unfriendFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfriend-user',
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
      friendList.refresh();

      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

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

  @override
  void onClose() {}

  @override
  void onReady() {}

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    getFriends();
    super.onInit();
  }
}
