import '../config/constants/api_constant.dart';
import '../services/api_communication.dart';

import '../models/api_response.dart';
import '../models/notification.dart';

class NotificationRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL NOTIFICATIONS WITH PAGE INITIATION                           ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllNotifications({required int skip, required String userId, required int limit}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: skip == 0, // Show loading only for the first page
      apiEndPoint: 'get-all-user-specific-notifications/$userId?skip=$skip&limit=$limit',
    );
    List<NotificationModel> notificationList = [];
    if (apiResponse.isSuccessful) {
      notificationList = ((apiResponse.data as Map<String, dynamic>)['data'] as List).map((element) => NotificationModel.fromMap(element)).toList();
      ApiResponse apiResponseToPass = apiResponse.copyWith(
        data: notificationList,
        // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
        // $┃  USING PAGE COUNT AS TOTAL COUNT FROM API IN THE CALLER FUNCTION      ┃
        // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
        pageCount: (apiResponse.data as Map<String, dynamic>)['totalCount'] ?? 0,
      );
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET UNSEEN NOTIFICATION COMMENT COUNT                                ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getUnseenCommentCount({required String userId}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      enableLoading: false,
      apiEndPoint: 'get-unseen-notification-count/$userId',
    );
    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  UPDATE NOTIFICATION SEEN STATUS ON CLICK                             ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> updateNotificationSeenStatus({required String notificationId, String? status}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'update-notification-seen-status/$notificationId',
      requestData: status != null ? {'status': status} : null,
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  MARK ALL NOTIFICATIONS AS READ                                       ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> markAllAsRead({required String userId}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: false,
      apiEndPoint: 'seen-all-user-specific-notifications/$userId',
    );
    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  DELETE A NOTIFICATION                                                ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> deleteNotification({required String notificationId}) async {
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'delete-notification/$notificationId',
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  TURN OFF NOTIFICATION FOR A POST                                     ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> turnOffPostNotification({required String postId, required bool status}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'turn-off-notification-post',
      requestData: {'post_id': postId, 'status': status},
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  ACCEPT / REJECT FRIEND REQUEST                                       ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> respondToFriendRequest({required String requestId, required int action}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'friend-accept-friend-request',
      requestData: {'request_id': requestId, 'accept_reject_ind': action},
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  ACCEPT / DECLINE GROUP INVITATION                                    ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> respondToGroupInvitation({required String groupId, required String action}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'invitation-join-request-accept-decline',
      requestData: {'group_id': groupId, 'action': action},
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  ACCEPT / DECLINE PAGE INVITATION                                     ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> acceptPageInvitation({required String pageId}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'accept-invitation',
      requestData: {'page_id': pageId},
    );
    return apiResponse;
  }

  Future<ApiResponse> declinePageInvitation({required String pageId}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'declined-invitation',
      requestData: {'page_id': pageId},
    );
    return apiResponse;
  }
}
