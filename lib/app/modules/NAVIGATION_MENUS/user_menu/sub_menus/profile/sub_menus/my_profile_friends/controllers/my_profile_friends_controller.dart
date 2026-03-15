import 'package:get/get.dart';

import '../../../../../../../../config/constants/api_constant.dart';
import '../../../../../../../../data/login_creadential.dart';
import '../../../../../../../../models/following_user_model.dart';
import '../../../../../../../../models/friend.dart';
import '../../../../../../../../services/api_communication.dart';
import '../../../../../../../../utils/snackbar.dart';
import '../models/things_in_common_model.dart';

class MyProfileFriendsController extends GetxController {
  late final ApiCommunication _api;
  final _loginCredential = LoginCredential();

  // ─── Tab index ───────────────────────────────────────────────────────
  final selectedTab = 0.obs;

  // ─── Friends tab ─────────────────────────────────────────────────────
  RxBool isLoadingFriendList = true.obs;
  Rx<List<FriendModel>> friendList = Rx([]);
  Rx<List<FriendModel>> searchedFriendList = Rx([]);
  RxString friendSearchKey = ''.obs;

  // ─── Friend requests (banner) ────────────────────────────────────────
  RxInt friendRequestCount = 0.obs;
  RxBool showRequestBanner = true.obs;

  // ─── Following tab ──────────────────────────────────────────────────
  RxBool isLoadingFollowing = true.obs;
  Rx<List<FollowingUserModel>> followingList = Rx([]);
  Rx<List<FollowingUserModel>> searchedFollowingList = Rx([]);
  RxString followingSearchKey = ''.obs;

  // ─── Things in common tab ───────────────────────────────────────────
  RxBool isLoadingThingsInCommon = true.obs;
  Rx<List<ThingsInCommonItem>> thingsInCommonList = Rx([]);

  // ═══════════════════════════════════════════════════════════════════════
  //  LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    _api = ApiCommunication();

    // Fetch friends immediately
    _fetchFriends();
    _fetchFriendRequestCount();
  }

  /// Called when a tab is selected — lazy-load data for that tab
  void onTabChanged(int index) {
    selectedTab.value = index;

    if (index == 1 && followingList.value.isEmpty && isLoadingFollowing.value) {
      _fetchFollowing();
    }
    if (index == 2 &&
        thingsInCommonList.value.isEmpty &&
        isLoadingThingsInCommon.value) {
      _fetchThingsInCommon();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DATA FETCHING — Friends
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _fetchFriends() async {
    isLoadingFriendList.value = true;
    try {
      final resp = await _api.doGetRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'search-friend',
      );
      if (resp.isSuccessful) {
        friendList.value =
            (((resp.data as Map<String, dynamic>)['result']) as List)
                .map((e) => FriendModel.fromJson(e))
                .toList();
      }
    } catch (e) {
      print('_fetchFriends error: $e');
    }
    isLoadingFriendList.value = false;
  }

  Future<void> _fetchFriendRequestCount() async {
    try {
      final username = _loginCredential.getUserData().username ?? '';
      final resp = await _api.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'friend-request-list',
        requestData: {'username': username},
      );
      if (resp.isSuccessful) {
        final data = resp.data as Map<String, dynamic>;
        friendRequestCount.value = data['friendRequestCount'] ?? 0;
      }
    } catch (e) {
      print('_fetchFriendRequestCount error: $e');
    }
  }

  void filterFriends(String key) {
    friendSearchKey.value = key;
    if (key.isNotEmpty) {
      searchedFriendList.value = friendList.value
          .where((m) =>
              (m.friend?.username ?? '')
                  .toLowerCase()
                  .contains(key.toLowerCase()) ||
              (m.friend?.firstName ?? '')
                  .toLowerCase()
                  .contains(key.toLowerCase()) ||
              (m.friend?.lastName ?? '')
                  .toLowerCase()
                  .contains(key.toLowerCase()))
          .toList();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DATA FETCHING — Following
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _fetchFollowing() async {
    isLoadingFollowing.value = true;
    try {
      final username = _loginCredential.getUserData().username ?? '';
      final resp = await _api.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'following-list',
        requestData: {'username': username},
      );
      if (resp.isSuccessful) {
        final data = resp.data as Map<String, dynamic>;
        final list = (data['result'] ?? data['results'] ?? []) as List;
        followingList.value =
            list.map((e) => FollowingUserModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('_fetchFollowing error: $e');
    }
    isLoadingFollowing.value = false;
  }

  void filterFollowing(String key) {
    followingSearchKey.value = key;
    if (key.isNotEmpty) {
      searchedFollowingList.value = followingList.value
          .where((m) =>
              (m.followerUserId?.username ?? '')
                  .toLowerCase()
                  .contains(key.toLowerCase()) ||
              (m.followerUserId?.firstName ?? '')
                  .toLowerCase()
                  .contains(key.toLowerCase()) ||
              (m.followerUserId?.lastName ?? '')
                  .toLowerCase()
                  .contains(key.toLowerCase()))
          .toList();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  DATA FETCHING — Things In Common
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _fetchThingsInCommon() async {
    isLoadingThingsInCommon.value = true;
    try {
      final resp = await _api.doGetRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'friends-things-in-common',
      );
      if (resp.isSuccessful) {
        final data = resp.data as Map<String, dynamic>;
        final parsed = ThingsInCommonResponse.fromJson(data);
        thingsInCommonList.value = parsed.results;
      }
    } catch (e) {
      print('_fetchThingsInCommon error: $e');
    }
    isLoadingThingsInCommon.value = false;
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  ACTIONS — Unfriend / Block / Unfollow
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> unfriendFriend(String requestId) async {
    final resp = await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfriend-user',
      requestData: {'requestId': requestId},
      enableLoading: true,
      errorMessage: 'Unfriend failed',
    );
    if (resp.isSuccessful) {
      _fetchFriends();
    }
  }

  Future<void> blockUser(String userId) async {
    final resp = await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'settings-privacy/block-user',
      requestData: {'block_user_id': userId},
      enableLoading: true,
      errorMessage: 'Block failed',
    );
    if (resp.isSuccessful) {
      _fetchFriends();
      showSuccessSnackkbar(titile: 'Success', message: 'Successfully Blocked');
    }
  }

  Future<void> unfollowUser(String requestId) async {
    final resp = await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfollow-user',
      requestData: {'requestId': requestId},
      enableLoading: true,
      errorMessage: 'Unfollow failed',
    );
    if (resp.isSuccessful) {
      _fetchFollowing();
    }
  }
}
