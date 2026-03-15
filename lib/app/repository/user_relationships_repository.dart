import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../models/firend_request.dart';
import '../models/friend.dart';
import '../modules/NAVIGATION_MENUS/friend/model/people_may_you_khnow.dart';
import '../modules/NAVIGATION_MENUS/friend/model/search_people_model.dart';
import '../services/api_communication.dart';

class UserRelationshipRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃    SEARCH PEOPLE BY TEXT                                              ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getPeopleListByTextSearch({required String text}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-user?search=$text',
    );
    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: (apiResponse.data as Map<String, dynamic>)['result'] != null
              ? (((apiResponse.data as Map<String, dynamic>)['result']) as List)
                  .map((element) => SearchPeopleModel.fromMap(element))
                  .toList()
              : []);
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃    GET ALL SUGGESTED PEOPLE PAGE IGNITION                                ┃
  // !┃    THIS WILL REPLACE 3 APIS FROM THIS REPOSITORY                         ┃
  // ?┃    ADDING DATA FORCE FETCH OPTION FOR LATER USE IN CACHE                 ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllPeopleInSuggestionWitPageIgnition(
      {required int? skip, required int? limit, bool? forceFetchData}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'userlist',
      apiEndPoint: 'suggestion-list',
      queryParameters: {
        'skip': skip ?? 0,
        'limit': limit ?? 10,
      },
    );

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: apiResponse.data != null
              ? (apiResponse.data as List)
                  .map((element) => PeopleMayYouKnowModel.fromMap(element))
                  .toList()
              : []);
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃    GET ALL FRIENDS                                                       ┃
  // ?┃    ADDING DATA FORCE FETCH OPTION FOR LATER USE IN CACHE                 ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllFriends({bool? forceFetchData}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'search-friend',
    );
    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: (apiResponse.data as Map<String, dynamic>)['result'] != null
              ? (((apiResponse.data as Map<String, dynamic>)['result']) as List)
                  .map((element) => FriendModel.fromJson(element))
                  .toList()
              : []);
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃    GET ALL FRIEND PENDING REQUEST                                        ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllPendingFriendRequests(
      {required String username}) async {
    Completer<ApiResponse> completer = Completer();
    try {
      final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'friend-request-list',
        requestData: {
          'username': username,
        },
      );
      if (apiResponse.isSuccessful) {
        ApiResponse apiData = apiResponse.copyWith(
          pageCount:
              (apiResponse.data as Map<String, dynamic>)['friendCount'] ?? 0,
          data: ((apiResponse.data as Map<String, dynamic>)['results']
                      as List<dynamic>?)
                  ?.map((element) {
                // Ensure each element is a Map before converting to FriendRequestModel
                if (element is Map<String, dynamic>) {
                  return FriendRequestModel.fromMap(element);
                } else {
                  // Handle unexpected element type - you might want to log this
                  return FriendRequestModel(); // or some default value
                }
              }).toList() ??
              [],
        );
        completer.complete(apiData);
      } else {
        completer.complete(apiResponse);
      }
    } catch (error) {
      debugPrint('ERROR IN GETTING REQUESTS FRIEND');
      debugPrint('$error');
    }
    return completer.future;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃ GET PEOPLE YOU MAY KNOW                                               ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getPeopleYouMayKnow() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'userlist',
      apiEndPoint: 'suggestion-list',
    );

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: apiResponse.data != null
              ? (apiResponse.data as List)
                  .map((element) => PeopleMayYouKnowModel.fromMap(element))
                  .toList()
              : []);
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃ GET PEOPLE YOU MAY KNOW WITH LIMIT                                    ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getPeopleYouMayKnowWithLimit({required int limit}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: 'userlist',
      apiEndPoint: 'suggestion-list',
      queryParameters: {'limit': limit},
    );

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: apiResponse.data != null
              ? (apiResponse.data as List)
                  .map((element) => PeopleMayYouKnowModel.fromMap(element))
                  .take(limit)
                  .toList()
              : []);
    } else {
      return apiResponse;
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  SEND FRIEND REQUEST                                                   ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> sendFriendRequestToUser({required String userId}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'send-friend-request',
        enableLoading: true,
        requestData: {
          'connected_user_id': userId,
        });

    return apiResponse;
  }

  // @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // @┃  RESPOND TO FRIEND REQUEST                                             ┃
  // !┃  0 = REJECT                                                            ┃
  // $┃  1 = ACCEPT                                                            ┃
  // @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> respondToFriendRequest({
    required int action,
    required String requestId,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'friend-accept-friend-request',
        requestData: {'request_id': requestId, 'accept_reject_ind': action});

    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  BLOCK AN USER                                                         ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> blockAnUserByUserID({required String userId}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        responseDataKey: ApiConstant.FULL_RESPONSE,
        apiEndPoint: 'settings-privacy/block-user',
        requestData: {
          'block_user_id': userId,
        },
        enableLoading: true,
        errorMessage: 'block failed');

    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  UNFRIEND A FRIEND                                                     ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> unfriendAConnectedFriend({required String userId}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfriend-user',
      requestData: {
        'requestId': userId,
      },
      enableLoading: true,
      errorMessage: 'Unfriend failed',
    );

    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET FRIEND LIST (by username)                                         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getFriendList({required String username}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'friend-list',
      requestData: {'username': username},
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  CANCEL A SENT FRIEND REQUEST                                          ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> cancelFriendRequest({required String requestId}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'cancel-friend-request',
      requestData: {'request_id': requestId},
    );
    return apiResponse;
  }
}
