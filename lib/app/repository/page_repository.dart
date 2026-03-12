import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../models/page_model.dart';
import '../models/post.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/allpages_model.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/invites_page_model.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/manage_page_model.dart';
import '../modules/NAVIGATION_MENUS/user_menu/sub_menus/all_pages/pages/model/mypage_model.dart';
import '../services/api_communication.dart';
import '../utils/snackbar.dart';

class PageRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  Future<ApiResponse> getPosts({
    required int pageNo,
    required int pageSize,
    required String pageId,
    required String userRole,
  }) async {
    List<PostModel> postList = [];
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-pages-posts?pageNo=$pageNo&pageSize=$pageSize',
      requestData: {
        'page_id': pageId,
        'user_role': userRole,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );

    if (apiResponse.isSuccessful) {
      int pageCount = (apiResponse.data as Map<String, dynamic>)['pageCount'];
      postList = (((apiResponse.data as Map<String, dynamic>)['posts']) as List)
          .map((element) => PostModel.fromMap(element))
          .toList();
      ApiResponse apiResponseToPass =
          apiResponse.copyWith(pageCount: pageCount, data: postList);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  CREATE PAGE                                                          ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> createPage({
    required String pageName,
    required String pageBio,
    required String selectedCategory,
    required String onCLocationChanged,
    required String zipCode,
    required String pageDescription,
    required XFile profileFiles,
    required XFile coverFiles,
  }) async {
    final apiResponse = await _apiCommunication.doPostFormRequest(
      apiEndPoint: 'create-pages',
      isFormData: true,
      enableLoading: true,
      fileKeys: ['profilePic', 'coverPic'],
      requestData: {
        'name': pageName,
        'bio': pageBio,
        'category': selectedCategory,
        'location': [onCLocationChanged],
        'zip_code': zipCode,
        'privacy': 'public',
        'description': pageDescription,
      },
      mediaXFiles: [profileFiles, coverFiles],
    );

    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET MY OWN PAGES                                                     ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getMyPages(
      {required int skip, int? limit, bool? forceFetch}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-my-pages?skip=$skip&limit=$limit',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: true,
      forceRecallAPI: forceFetch,
      timeToLiveInSeconds: 60 * 60,
    );

    if (apiResponse.isSuccessful) {
      ApiResponse apiResponseToPass = apiResponse.copyWith(
          data:
              (((apiResponse.data as Map<String, dynamic>)['myPages']) as List)
                  .map((e) => MyPagesModel.fromMap(e))
                  .toList(),

          //@ Using total page count in page count for page ignition

          pageCount: (apiResponse.data as Map<String, dynamic>)['totalCount']);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET SUGGESTED PAGES                                                  ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getSuggestedPages() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-all-pages',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
    List<PageModel> pageList = [];
    if (apiResponse.isSuccessful) {
      pageList = (((apiResponse.data as Map<String, dynamic>)['data']) as List)
          .map((e) => PageModel.fromMap(e))
          .toList();
      ApiResponse apiResponseToPass = apiResponse.copyWith(data: pageList);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL PAGES                                                        ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllPages(
      {required int skip, required int limit}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-all-pages?skip=$skip&limit=$limit',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    if (apiResponse.isSuccessful) {
      ApiResponse apiResponseToPass = apiResponse.copyWith(
          data: (((apiResponse.data as Map<String, dynamic>)['data']) as List)
              .map((e) => AllPagesModel.fromMap(e))
              .toList(),
          //@ Using total page count in page count for page ignition
          pageCount: (apiResponse.data as Map<String, dynamic>)['totalCount']);

      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET FOLLOWED PAGES                                                       ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getFollowedPages(
      {required int skip, required int limit, bool? forceFetch}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint: 'get-followed-pages?skip=$skip&limit=$limit',
        responseDataKey: ApiConstant.FULL_RESPONSE,
        enableCache: true,
        timeToLiveInSeconds: 60 * 60,
        forceRecallAPI: forceFetch);

    if (apiResponse.isSuccessful) {
      ApiResponse apiResponseToPass = apiResponse.copyWith(
          data: (((apiResponse.data as Map<String, dynamic>)['data']) as List)
              .map((e) => AllPagesModel.fromMap(e))
              .toList(),
          //@ Using total page count in page count for page ignition
          pageCount: (apiResponse.data as Map<String, dynamic>)['totalCount']);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET INVITES                                                          ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getInvites(
      {required int skip, required int limit}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'invited-page?skip=$skip&limit=$limit',
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );

    if (apiResponse.isSuccessful) {
      ApiResponse apiResponseToPass = apiResponse.copyWith(
          data: (((apiResponse.data as Map<String, dynamic>)['result']) as List)
              .map((e) => InvitesPageModel.fromMap(e))
              .toList(),
          //@ Using total page count in page count for page ignition
          pageCount: (apiResponse.data as Map<String, dynamic>)['totalCount']);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET PAGE INVITES                                                     ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getPageInvitesByID({required String pageId}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'friend-list-page-invitation',
      requestData: {
        'page_id': pageId,
      },
      responseDataKey: 'results',
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET PAGES MANAGED MY ME                                              ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllMyManagedPages() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-my-pages-as-moderator',
      responseDataKey: 'myPages',
    );

    if (apiResponse.isSuccessful) {
      ApiResponse apiResponseToPass = apiResponse.copyWith(
        data: (apiResponse.data as List)
            .map(
              (e) => ManagePageModel.fromMap(e),
            )
            .toList(),
      );
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET PAGE DETAILS BY NAME                                              ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getPageDetailsByName({required String? name}) async {
    Completer<ApiResponse> completer = Completer();
    try {
      debugPrint('Page name: $name');
      final apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint: 'get-page-details/$name',
        responseDataKey: ApiConstant.DATA_RESPONSE,
      );
      completer.complete(apiResponse);
    } catch (error) {
      debugPrint('ERROR ON  :::: get-page-details ');
      debugPrint('$error');
    }
    return completer.future;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  SEARCH PAGE BY TEXT                                                   ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> searchPageByText({required String text}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-pages?search=$text',
    );

    if (apiResponse.isSuccessful) {
      ApiResponse apiResponseToPass = apiResponse.copyWith(
        data: (((apiResponse.data as Map<String, dynamic>)['data']) as List)
            .map((e) => AllPagesModel.fromMap(e))
            .toList(),
      );
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ACTION ON PAGE INVITE                                                 ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> actionOnPageInvite(
      {required String invitationId, required bool acceptInvite}) async {
    String acceptEndPoint = 'accept-invitation';
    String declineEndPoint = 'declined-invitation';

    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: acceptInvite ? acceptEndPoint : declineEndPoint,
      requestData: {
        'invitation_id': invitationId,
      },
    );
    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ACTION ON PAGE FOLLOW                                                 ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> followPage(String pageId) async {
    final Completer<ApiResponse> completer = Completer();

    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'follow-page',
      responseDataKey: ApiConstant.FULL_RESPONSE,
      requestData: {
        'follow_unfollow_status': '',
        'like_unlike_status': '',
        'page_id': pageId,
        'user_id': '',
      },
    );
    if (response.isSuccessful) {
      completer.complete(response);
      showSuccessSnackkbar(message: 'followed this pages successfully');
    } else {
      debugPrint('Issue');
      completer.completeError('error');
    }

    return completer.future;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  SEND PAGE FOLLOW INVITE TO FRIENDS                                    ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> sendPageFollowInviteToFriends({
    required String pageId,
    required List<String?> userIds,
  }) async {
    final Completer<ApiResponse> completer = Completer();

    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'send-page-invitation-from-apps',
      requestData: {'page_id': pageId, 'user_id_arr': userIds},
    );
    if (response.isSuccessful) {
      completer.complete(response);
      showSuccessSnackkbar(message: 'followed this pages successfully');
    } else {
      debugPrint('Issue');
      completer.completeError('error');
    }

    return completer.future;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  ACTION ON PAGE UNFOLLOW                                               ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> unfollowPage({required String pageId}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'unfollow-page',
      requestData: {
        'page_id': pageId,
      },
    );
    return apiResponse;
  }
}
