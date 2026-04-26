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

  // ─── Friend Requests ─────────────────────────────────────
  Rx<List<FriendRequestModel>> friendRequestList = Rx([]);
  RxBool isFriendRequestLoading = true.obs;
  RxInt friendRequestCount = 0.obs;

  // ─── Search Friends (old) ────────────────────────────────
  Rx<List<FriendModel>> friendList = Rx([]);
  Rx<List<SearchPeopleModel>> peopleList = Rx([]);
  RxBool isLoadingNewsFeed = true.obs;
  RxString searchPeople = ''.obs;
  var friendController = ''.obs;
  Timer? debounce;

  // ─── Suggestions / People You May Know ───────────────────
  Rx<List<PeopleMayYouKnowModel>> peopleMayYouKnowList = Rx([]);
  RxBool isLoadingPeopleYouMayKnow = false.obs;
  bool friendSearchHasReachedLimit = false;
  bool suggestedFriendsGetterApiOnCall = false;

  // ─── Full Friend List (Your Friends page) ────────────────
  Rx<List<FriendModel>> fullFriendList = Rx([]);
  RxBool isLoadingFullFriendList = false.obs;
  RxString friendSearchQuery = ''.obs;
  RxInt totalFriendCount = 0.obs;

  // ─── View State ──────────────────────────────────────────
  Rx<int> viewType = 1.obs; // 1= Friend Request View, 2 = My Connection View
  Rx<bool> isFriendVisible = false.obs;
  Rx<bool> isRequestVisible = true.obs;
  Rx<bool> isFriendRequestSended = false.obs;

  UserRelationshipRepository userRelationshipRepository =
      UserRelationshipRepository();

  // ─── Filtered Friend List (search) ───────────────────────
  List<FriendModel> get filteredFriendList {
    if (friendSearchQuery.value.isEmpty) {
      return fullFriendList.value;
    }
    final query = friendSearchQuery.value.toLowerCase();
    return fullFriendList.value.where((friend) {
      final fullName = friend.fullName?.toLowerCase() ?? '';
      final firstName = friend.friend?.firstName?.toLowerCase() ?? '';
      final lastName = friend.friend?.lastName?.toLowerCase() ?? '';
      final username = friend.friend?.username?.toLowerCase() ?? '';
      return fullName.contains(query) ||
          firstName.contains(query) ||
          lastName.contains(query) ||
          username.contains(query);
    }).toList();
  }

  void initialUpdateFriendsList(
      {required List<PeopleMayYouKnowModel> suggestedPeopleList}) {
    peopleMayYouKnowList.value = List.from(suggestedPeopleList);
    suggestedFriendsGetterApiOnCall = false;
    isLoadingNewsFeed.value = false;
    peopleMayYouKnowList.refresh();
  }

  // ════════════════════════════════════════════════════════════
  //  GET — Friend Related Functions
  // ════════════════════════════════════════════════════════════

  List<FriendModel> _parseFriendModels(List<dynamic> rawItems) {
    return rawItems
        .whereType<Map>()
        .map((item) => FriendModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

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
  }

  Future<void> getFriends({bool? forceFetchData}) async {
    isLoadingNewsFeed.value = true;

    final apiResponse = await userRelationshipRepository.getAllFriends();
    isLoadingNewsFeed.value = false;

    if (apiResponse.isSuccessful) {
      friendList.value = List.from(apiResponse.data as List<FriendModel>);
      friendList.refresh();
    } else {
      debugPrint('Error');
    }
  }

  Future<void> getFriendRequestes() async {
    isFriendRequestLoading.value = true;
    friendRequestList.value.clear();

    final apiResponse =
        await userRelationshipRepository.getAllPendingFriendRequests(
      username: loginCredential.getUserData().username.toString(),
    );

    isFriendRequestLoading.value = false;

    if (apiResponse.isSuccessful) {
      friendRequestList.value
          .addAll(apiResponse.data as List<FriendRequestModel>);
      friendRequestCount.value = friendRequestList.value.length;
      friendRequestList.refresh();
    } else {
      debugPrint('Error');
    }
  }

  Future<void> getFullFriendList() async {
    isLoadingFullFriendList.value = true;

    try {
      final apiResponse = await userRelationshipRepository.getFriendList(
        username: loginCredential.getUserData().username.toString(),
      );

      if (apiResponse.isSuccessful) {
        final data = apiResponse.data;
        if (data is Map<String, dynamic>) {
          // Parse results array
          final results = data['results'] as List? ?? [];
          fullFriendList.value = _parseFriendModels(results);
          totalFriendCount.value =
              data['friendCount'] as int? ?? fullFriendList.value.length;
        } else if (data is List) {
          fullFriendList.value = _parseFriendModels(data);
          totalFriendCount.value = fullFriendList.value.length;
        }
        fullFriendList.refresh();
      } else {
        debugPrint('Error loading friend list');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getFullFriendList: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      isLoadingFullFriendList.value = false;
    }
  }

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

        // Duplicate check
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

  // ════════════════════════════════════════════════════════════
  //  ACTION — Friend Related Functions
  // ════════════════════════════════════════════════════════════

  Future<void> blockFriends(String userId) async {
    final apiResponse =
        await userRelationshipRepository.blockAnUserByUserID(userId: userId);

    if (apiResponse.isSuccessful) {
      // Remove from fullFriendList locally
      fullFriendList.value
          .removeWhere((f) => f.friend?.id == userId || f.id == userId);
      fullFriendList.refresh();
      totalFriendCount.value = fullFriendList.value.length;

      getFriends();
      Get.snackbar('Success', 'Successfully Blocked',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: PRIMARY_COLOR);
    } else {
      debugPrint('Error blocking user');
    }
  }

  Future<void> unfriendFriends(String userId) async {
    final apiResponse = await userRelationshipRepository
        .unfriendAConnectedFriend(userId: userId);

    if (apiResponse.isSuccessful) {
      // Remove from fullFriendList locally
      fullFriendList.value
          .removeWhere((f) => f.friend?.id == userId || f.id == userId);
      fullFriendList.refresh();
      totalFriendCount.value = fullFriendList.value.length;

      // Also remove from friendList
      friendList.value
          .removeWhere((f) => f.friend?.id == userId || f.id == userId);
      friendList.refresh();

      Get.snackbar('Success', 'Successfully Unfriended',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: PRIMARY_COLOR);
    } else {
      debugPrint('Error unfriending user');
    }
  }

  void sendFriendRequest({
    required int index,
    required String userId,
  }) async {
    final apiResponse = await userRelationshipRepository
        .sendFriendRequestToUser(userId: userId);

    if (apiResponse.isSuccessful) {
      peopleMayYouKnowList.value.removeAt(index);
      peopleMayYouKnowList.refresh();
      showSuccessSnackkbar(message: 'Friend request sent');
    } else {
      debugPrint('Error sending friend request');
    }
  }

  /// Cancel a sent friend request
  Future<void> cancelSentFriendRequest({required String requestId}) async {
    final apiResponse = await userRelationshipRepository.cancelFriendRequest(
        requestId: requestId);

    if (apiResponse.isSuccessful) {
      showSuccessSnackkbar(message: 'Friend request cancelled');
    } else {
      debugPrint('Error cancelling friend request');
    }
  }

  // !  0 = REJECT
  // $  1 = ACCEPT
  void actionOnFriendRequest({
    required int action,
    required String requestId,
  }) async {
    final apiResponse = await userRelationshipRepository.respondToFriendRequest(
        action: action, requestId: requestId);

    if (apiResponse.isSuccessful) {
      // Remove from request list locally
      friendRequestList.value.removeWhere((r) => r.id == requestId);
      friendRequestCount.value = friendRequestList.value.length;
      friendRequestList.refresh();

      if (action == 1) {
        // Accepted — reload friends list
        getFullFriendList();
        getFriends(forceFetchData: true);
        showSuccessSnackkbar(message: 'Friend request accepted');
      } else {
        showSuccessSnackkbar(message: 'Friend request declined');
      }
    } else {
      debugPrint('Error responding to friend request');
    }
  }

  /// Remove a suggestion from the list locally
  void removeSuggestion(int index) {
    if (index >= 0 && index < peopleMayYouKnowList.value.length) {
      peopleMayYouKnowList.value.removeAt(index);
      peopleMayYouKnowList.refresh();
    }
  }

  /// Refresh all friend data
  Future<void> refreshAll() async {
    friendSearchHasReachedLimit = false;
    peopleMayYouKnowList.value.clear();
    friendRequestList.value.clear();
    fullFriendList.value.clear();
    friendList.value.clear();

    await Future.wait([
      getFriendRequestes(),
      getPeopleMayYouKnow(skip: 0, limit: 12),
      getFullFriendList(),
      getFriends(),
    ]);
  }

  // ════════════════════════════════════════════════════════════
  //  Scroll Listener — Suggestion Pagination
  // ════════════════════════════════════════════════════════════
  void _scrollListener() {
    if (friendsScrollController.position.pixels >=
            friendsScrollController.position.maxScrollExtent - 200 &&
        !friendSearchHasReachedLimit &&
        !suggestedFriendsGetterApiOnCall) {
      getPeopleMayYouKnow(skip: peopleMayYouKnowList.value.length);
    }
  }

  // ════════════════════════════════════════════════════════════
  //  Lifecycle
  // ════════════════════════════════════════════════════════════
  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    loginCredential = LoginCredential();

    getFriendRequestes();
    getPeopleMayYouKnow(skip: 0, limit: 12);
    getFullFriendList();

    friendsScrollController.addListener(_scrollListener);

    super.onInit();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    debounce?.cancel();
    friendsScrollController.removeListener(_scrollListener);
    super.onClose();
  }
}
