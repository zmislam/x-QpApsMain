import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../repository/user_relationships_repository.dart';

import '../../../../config/constants/color.dart';
import '../../../../data/login_creadential.dart';
import '../../../../models/firend_request.dart';
import '../../../../models/friend.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/snackbar.dart';
import '../model/people_may_you_khnow.dart';
import '../model/search_people_model.dart';

class FriendController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential loginCredential;
  final ScrollController friendsScrollController = ScrollController();
  Rx<List<FriendRequestModel>> friendRequestList = Rx([]);
  Rx<List<FriendModel>> friendList = Rx([]);
  Rx<List<PeopleMayYouKnowModel>> peopleMayYouKnowList = Rx([]);
  Rx<List<SearchPeopleModel>> peopleList = Rx([]);

  RxBool isLoadingNewsFeed = true.obs;
  RxBool isFriendRequestLoading = true.obs;
  Rx<int> viewType = 1.obs; // 1= Friend Request View, 2 = My Connection View
  Rx<bool> isFriendVisible = false.obs;
  Rx<bool> isRequestVisible = true.obs;
  Rx<bool> isFriendRequestSended = false.obs;
  RxString searchPeople = ''.obs;
  var friendController = ''.obs;
  Timer? debounce;

  bool friendSearchHasReachedLimit = false;
  bool suggestedFriendsGetterApiOnCall = false;
  UserRelationshipRepository userRelationshipRepository =
      UserRelationshipRepository();

  void initialUpdateFriendsList(
      {required List<PeopleMayYouKnowModel> suggestedPeopleList}) {
    peopleMayYouKnowList.value = List.from(suggestedPeopleList);
    suggestedFriendsGetterApiOnCall = false;
    isLoadingNewsFeed.value = false;
    peopleMayYouKnowList.refresh();
  }

  //======================================================== GET Friend Related Functions ===============================================//
  Future<void> getSearchPeople(String text) async {
    isLoadingNewsFeed.value = true;

    final apiResponse =
        await userRelationshipRepository.getPeopleListByTextSearch(text: text);
    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      peopleList.value = List.from(apiResponse.data as List<SearchPeopleModel>);
      peopleList.refresh();
    } else {
      debugPrint('Error');
    }

    debugPrint('-friend controller---------------------------$apiResponse');
  }

  Future<void> getFriends({bool? forceFetchData}) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await userRelationshipRepository.getAllFriends();
    isLoadingNewsFeed.value = false;

    debugPrint('-friend controller---------------------------$apiResponse');

    if (apiResponse.isSuccessful) {
      friendList.value = List.from(apiResponse.data as List<FriendModel>);
      friendList.refresh();
    } else {
      debugPrint('Error');
    }

    debugPrint('-friend controller---------------------------$apiResponse');
  }

  Future<void> getFriendRequestes() async {
    // isLoadingNewsFeed.value = true;
    isFriendRequestLoading.value = true;
    friendRequestList.value.clear();

    final apiResponse =
        await userRelationshipRepository.getAllPendingFriendRequests(
      username: loginCredential.getUserData().username.toString(),
    );

    // isLoadingNewsFeed.value = false;
    isFriendRequestLoading.value = false;

    if (apiResponse.isSuccessful) {
      friendRequestList.value
          .addAll(apiResponse.data as List<FriendRequestModel>);

      friendRequestList.refresh();
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  RxBool isLoadingPeopleYouMayKnow = false.obs;
  Future<void> getPeopleMayYouKnow(
      {required int? skip, int? limit, bool? forceFetchData}) async {
    isLoadingPeopleYouMayKnow.value = true;
    suggestedFriendsGetterApiOnCall = true;

    try {
      final apiResponse = await userRelationshipRepository
          .getAllPeopleInSuggestionWitPageIgnition(
        skip: peopleMayYouKnowList.value.length,
        limit: limit ?? 10,
        forceFetchData: forceFetchData,
      );

      if (apiResponse.isSuccessful) {
        // Safe type conversion with error handling
        final rawData = apiResponse.data;

        if (rawData is! List) {
          debugPrint('Invalid response format - expected List');
          return;
        }

        final List<PeopleMayYouKnowModel> newPeople = [];

        for (final item in rawData) {
          try {
            if (item is Map<String, dynamic>) {
              newPeople.add(PeopleMayYouKnowModel.fromMap(item));
            } else if (item is PeopleMayYouKnowModel) {
              newPeople.add(item);
            } else {
              debugPrint('Skipping invalid item type: ${item.runtimeType}');
            }
          } catch (e) {
            debugPrint('Error converting item: $e');
          }
        }

        // Existing duplicate check logic
        final existingIds = peopleMayYouKnowList.value
            .map((p) => p.id)
            .where((id) => id != null)
            .toSet();

        final uniqueNewPeople = newPeople
            .where((newPerson) =>
                newPerson.id != null && !existingIds.contains(newPerson.id))
            .toList();

        if (uniqueNewPeople.isEmpty) {
          friendSearchHasReachedLimit = true;
        } else {
          peopleMayYouKnowList.value.addAll(uniqueNewPeople);
        }

        peopleMayYouKnowList.refresh();
      } else {
        debugPrint('API Error: ${apiResponse.message}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getPeopleMayYouKnow: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      suggestedFriendsGetterApiOnCall = false;
      isLoadingPeopleYouMayKnow.value = false;
    }
  }

  //======================================================== Action on Friend Related Functions ===============================================//

  Future<void> blockFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse =
        await userRelationshipRepository.blockAnUserByUserID(userId: userId);

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      getFriends();
      Get.snackbar('Success', 'Successfully Blocked',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: PRIMARY_COLOR);
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  Future<void> unfriendFriends(String userId) async {
    debugPrint('===============================================Block Start');

    final apiResponse = await userRelationshipRepository
        .unfriendAConnectedFriend(userId: userId);

    debugPrint(
        '===============================================Block API Call End');

    if (apiResponse.isSuccessful) {
      getFriends();
      // friendList.refresh();

      Get.snackbar('Success', 'Successfully Unfriend',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: PRIMARY_COLOR);
      Get.back();
      debugPrint(
          '===============================================Block Successs');
    } else {
      debugPrint('===============================================Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  void sendFriendRequest({
    required int index,
    required String userId,
  }) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await userRelationshipRepository
        .sendFriendRequestToUser(userId: userId);
    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
      // ┃  Action on success                                                    ┃
      // ┃  THIS FUNCTION IS RESPONSIBLE FOR HANDLING THE ACTION ON              ┃
      // ┃  PEOPLE YOU MAY KNOW                                                  ┃
      // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

      peopleMayYouKnowList.value.removeAt(index);
      peopleMayYouKnowList.refresh();

      debugPrint('');
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  // !┃  0 = REJECT
  // $┃  1 = ACCEPT

  void actionOnFriendRequest({
    required int action,
    required String requestId,
  }) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await userRelationshipRepository.respondToFriendRequest(
        action: action, requestId: requestId);
    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      getFriendRequestes();
      getFriends(forceFetchData: true);
      showSuccessSnackkbar(message: 'Friend request accepted successfully');
    } else {
      debugPrint('Error');
    }

    debugPrint('-post-home controller---------------------------$apiResponse');
  }

  //======================================Scroll Listener for friend Suggestion Pagination=======================================//
  void _scrollListener() {
    if (friendsScrollController.position.pixels >=
        friendsScrollController.position.maxScrollExtent - 200 &&
        !friendSearchHasReachedLimit &&
        !suggestedFriendsGetterApiOnCall) {
      getPeopleMayYouKnow(skip: peopleMayYouKnowList.value.length);
    }
  }
  //=========================================================================================================================================================================//

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();

    //! API CALL COMMENTED OUT ----------------------
    // getFriendRequestes();
    // getPeopleMayYouKnow(skip: 0, limit: 12);
    // getFriends();

    friendsScrollController.addListener(_scrollListener);

    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();

    debounce?.cancel();

    super.onClose();
  }
}
