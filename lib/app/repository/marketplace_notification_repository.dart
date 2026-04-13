import '../services/api_communication.dart';
import '../models/api_response.dart';
import '../config/constants/api_constant.dart';

/// Repository for marketplace-specific notification API calls.
/// Endpoints prefixed with `market-place/notifications`.
class MarketplaceNotificationRepository {
  final ApiCommunication _api = ApiCommunication();

  /// Fetch paginated marketplace notifications.
  /// [type] — optional filter: new_listing, price_drop, back_in_stock,
  ///   order_shipped, order_delivered, new_order, order_cancelled,
  ///   new_review, new_question, new_message, low_stock,
  ///   listing_approved, listing_rejected, payout_processed
  Future<ApiResponse> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'limit': limit,
    };
    if (type != null && type.isNotEmpty) params['type'] = type;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/notifications',
      queryParameters: params,
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
  }

  /// Mark specific notifications as read, or mark all as read.
  Future<ApiResponse> markRead({
    List<String>? notificationIds,
    bool markAll = false,
  }) async {
    final Map<String, dynamic> body = {};
    if (markAll) {
      body['mark_all'] = true;
    } else if (notificationIds != null && notificationIds.isNotEmpty) {
      body['notification_ids'] = notificationIds;
    }

    return await _api.doPostRequest(
      apiEndPoint: 'market-place/notifications/mark-read',
      requestData: body,
    );
  }

  /// Get unread notification count.
  Future<ApiResponse> getUnreadCount() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/notifications/unread-count',
      responseDataKey: 'data',
    );
  }
}
