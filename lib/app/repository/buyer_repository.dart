import 'package:image_picker/image_picker.dart';
import '../services/api_communication.dart';
import '../models/api_response.dart';

/// Repository for all Buyer Panel API calls.
/// Endpoints prefixed with `market-place/buyer/` and `market-place/order/`.
class BuyerRepository {
  final ApiCommunication _api = ApiCommunication();

  // ─── Dashboard ────────────────────────────────────────────
  Future<ApiResponse> getDashboardOverview() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/buyer/dashboard-overview',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getAccessStatus() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/access-status',
      responseDataKey: 'data',
    );
  }

  // ─── Orders ───────────────────────────────────────────────
  Future<ApiResponse> getOrderList({
    int limit = 20,
    int skip = 0,
    String? status,
    String? fromDate,
    String? toDate,
    int? lastTargetDay,
  }) async {
    final Map<String, dynamic> params = {
      'limit': limit,
      'skip': skip,
    };
    if (status != null && status.isNotEmpty) params['status'] = status;
    if (fromDate != null) params['from_date'] = fromDate;
    if (toDate != null) params['to_date'] = toDate;
    if (lastTargetDay != null) params['last_target_day'] = lastTargetDay;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/list-for-buyer',
      queryParameters: params,
    );
  }

  Future<ApiResponse> getOrderDetails({
    required String orderId,
    required String storeId,
  }) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/show-for-buyer/$orderId/$storeId',
    );
  }

  Future<ApiResponse> cancelOrder({
    required String orderId,
    required String storeId,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/buyer/cancel-order',
      requestData: {
        'order_id': orderId,
        'store_id': storeId,
      },
    );
  }

  // ─── Reviews ──────────────────────────────────────────────
  Future<ApiResponse> getAllReviews({int skip = 0, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/buyer/all-review',
      responseDataKey: 'data',
      queryParameters: {'skip': skip, 'limit': limit},
    );
  }

  Future<ApiResponse> saveProductReview({
    required String productId,
    required String orderId,
    required int rating,
    required String title,
    required String description,
    List<XFile>? mediaFiles,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/buyer/save-product-review',
      requestData: {
        'product_id': productId,
        'order_id': orderId,
        'rating': rating,
        'title': title,
        'description': description,
      },
      mediaXFiles: mediaFiles,
      fileKey: 'files',
    );
  }

  Future<ApiResponse> deleteReview({required String reviewId}) async {
    return await _api.doDeleteRequest(
      apiEndPoint: 'market-place/buyer/delete-review/$reviewId',
    );
  }

  // ─── Addresses ────────────────────────────────────────────
  Future<ApiResponse> getAddressList({int skip = 0, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/address-list',
      responseDataKey: 'data',
      queryParameters: {'skip': skip, 'limit': limit},
    );
  }

  Future<ApiResponse> getBillingAddressList({int skip = 0, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/billing-address-list',
      responseDataKey: 'data',
      queryParameters: {'skip': skip, 'limit': limit},
    );
  }

  Future<ApiResponse> deleteAddress({required String addressId}) async {
    return await _api.doDeleteRequest(
      apiEndPoint: 'market-place/buyer/delete-address/$addressId',
    );
  }

  Future<ApiResponse> deleteBillingAddress({required String addressId}) async {
    return await _api.doDeleteRequest(
      apiEndPoint: 'market-place/buyer/delete-billing-address/$addressId',
    );
  }

  // ─── Refunds ──────────────────────────────────────────────
  Future<ApiResponse> getRefundList({
    int skip = 0,
    int limit = 20,
    String? fromDate,
    String? toDate,
    int? lastTargetDay,
  }) async {
    final Map<String, dynamic> params = {
      'skip': skip,
      'limit': limit,
    };
    if (fromDate != null) params['from_date'] = fromDate;
    if (toDate != null) params['to_date'] = toDate;
    if (lastTargetDay != null) params['last_target_day'] = lastTargetDay;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/refund-list-for-buyer',
      queryParameters: params,
    );
  }

  Future<ApiResponse> getRefundDetails({required String refundId}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/refund-details/$refundId',
    );
  }

  Future<ApiResponse> saveRefund({
    required String orderSubDetailsId,
    required double deliveryCharge,
    String? note,
    required String refundDetailsJson,
    List<XFile>? mediaFiles,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/order/save-refund',
      requestData: {
        'order_sub_details_id': orderSubDetailsId,
        'delivery_charge': deliveryCharge,
        if (note != null) 'note': note,
        'refund_details': refundDetailsJson,
      },
      mediaXFiles: mediaFiles,
      fileKey: 'files',
    );
  }

  Future<ApiResponse> getRefundChat({required String refundId}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/get-refund-chat/$refundId',
      responseDataKey: 'results',
    );
  }

  Future<ApiResponse> sendRefundChat({
    required String refundId,
    required String text,
    List<XFile>? mediaFiles,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/order/refund-chat',
      requestData: {
        'refund_id': refundId,
        'text': text,
      },
      mediaXFiles: mediaFiles,
      fileKey: 'files',
    );
  }

  // ─── Complaints ───────────────────────────────────────────
  Future<ApiResponse> getComplaintList({int skip = 0, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/buyer/complaint-list',
      queryParameters: {'skip': skip, 'limit': limit},
    );
  }

  Future<ApiResponse> getComplaintDetails({required String complaintId}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/buyer/complaint-details/$complaintId',
    );
  }

  Future<ApiResponse> saveComplaint({
    required String name,
    required String email,
    required String storeId,
    required List<String> productIds,
    String? orderId,
    required String issueType,
    required String details,
    List<XFile>? mediaFiles,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/buyer/save-complaint',
      requestData: {
        'name': name,
        'email': email,
        'store_id': storeId,
        'product_id': productIds,
        if (orderId != null) 'order_id': orderId,
        'issue_type': issueType,
        'details': details,
      },
      mediaXFiles: mediaFiles,
      fileKey: 'files',
    );
  }

  Future<ApiResponse> deleteComplaint({required String complaintId}) async {
    return await _api.doDeleteRequest(
      apiEndPoint: 'market-place/buyer/delete-complaint/$complaintId',
    );
  }

  Future<ApiResponse> getComplaintTypeList() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/buyer/complaint-type-list',
    );
  }

  // ─── Alerts ───────────────────────────────────────────────
  Future<ApiResponse> getAlerts() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/buyer/alerts',
    );
  }

  // ─── Recent Activity ──────────────────────────────────────
  Future<ApiResponse> getRecentActivity({int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/buyer/recent-activity',
      queryParameters: {'limit': limit},
    );
  }
}
