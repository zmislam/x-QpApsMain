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
      enableLoading: true,
      apiEndPoint: 'get-unseen-notification-count/$userId',
    );
    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  UPDATE NOTIFICATION SEEN STATUS ON CLICK                             ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> updateNotificationSeenStatus({required String notificationId}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'update-notification-seen-status/$notificationId',
    );
    return apiResponse;
  }
}
