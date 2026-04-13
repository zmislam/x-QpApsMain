import 'package:image_picker/image_picker.dart';
import '../services/api_communication.dart';
import '../models/api_response.dart';

/// Repository for all Seller Panel API calls.
/// Endpoints prefixed with `market-place/seller/`, `market-place/product/`,
/// `market-place/order/`, and store CRUD on `market-place/`.
class SellerRepository {
  final ApiCommunication _api = ApiCommunication();

  // ─── Dashboard ────────────────────────────────────────────
  Future<ApiResponse> getDashboardOverview() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/seller/dashboard-overview',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getListingsByStatus({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/seller/listings-by-status',
      responseDataKey: 'data',
      queryParameters: {
        'status': status,
        'page': page,
        'limit': limit,
      },
    );
  }

  Future<ApiResponse> getMyPerformance() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/seller/my-performance',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getInventoryAlerts() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/seller/inventory-alerts',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getSellerInsights({String period = '30d'}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/seller/insights',
      responseDataKey: 'data',
      queryParameters: {'period': period},
    );
  }

  // ─── Reviews ──────────────────────────────────────────────
  Future<ApiResponse> getProductReviews({required String productId}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/product/review-list/$productId',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> replyToReview({
    required String productId,
    required String reviewId,
    required String reply,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/seller/review-reply',
      requestData: {
        'product_id': productId,
        'review_id': reviewId,
        'reply': reply,
      },
    );
  }

  // ─── Attributes ───────────────────────────────────────────
  Future<ApiResponse> getAttributes({int skip = 0, int limit = 50, String? keyword}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/attribute-list',
      responseDataKey: 'data',
      queryParameters: {'skip': skip, 'limit': limit, if (keyword != null) 'keyword': keyword},
    );
  }

  Future<ApiResponse> saveAttribute({required String name, required Map<String, String> value, bool isRequired = false}) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/save-attribute',
      requestData: {'name': name, 'value': value, 'is_required': isRequired},
    );
  }

  Future<ApiResponse> updateAttribute({required String attributeId, required String name, required Map<String, String> value}) async {
    return await _api.doPatchRequest(
      apiEndPoint: 'market-place/update-attribute/$attributeId',
      requestData: {'name': name, 'value': value},
    );
  }

  Future<ApiResponse> deleteAttribute({required String attributeId}) async {
    return await _api.doDeleteRequest(
      apiEndPoint: 'market-place/delete-attribute/$attributeId',
    );
  }

  // ─── Colors ──────────────────────────────────────────────
  Future<ApiResponse> getColors({int skip = 0, int limit = 50, String? keyword}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/get-color-list',
      responseDataKey: 'data',
      queryParameters: {'skip': skip, 'limit': limit, if (keyword != null) 'keyword': keyword},
    );
  }

  Future<ApiResponse> saveColor({required String name, required String value}) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/save-color',
      requestData: {'name': name, 'value': value},
    );
  }

  Future<ApiResponse> updateColor({required String colorId, required String name, required String value}) async {
    return await _api.doPatchRequest(
      apiEndPoint: 'market-place/update-color/$colorId',
      requestData: {'name': name, 'value': value},
    );
  }

  Future<ApiResponse> deleteColor({required String colorId}) async {
    return await _api.doDeleteRequest(
      apiEndPoint: 'market-place/delete-color/$colorId',
    );
  }

  // ─── Products ─────────────────────────────────────────────
  Future<ApiResponse> getMyProducts({
    int skip = 0,
    int limit = 10,
    String? keyword,
    String? category,
    String? brand,
    String? status,
  }) async {
    final Map<String, dynamic> params = {
      'skip': skip,
      'limit': limit,
    };
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (brand != null && brand.isNotEmpty) params['brand'] = brand;
    if (status != null && status.isNotEmpty) params['status'] = status;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/get-my-products',
      queryParameters: params,
    );
  }

  Future<ApiResponse> getProductDetailsForSeller({
    required String productId,
  }) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/product/show-details-for-seller/$productId',
    );
  }

  Future<ApiResponse> saveProduct({
    required Map<String, dynamic> productData,
    List<XFile>? productImages,
    List<XFile>? variantImages,
  }) async {
    // Product save uses multipart with two file fields: 'files' + 'variant_images'
    // ApiCommunication supports one fileKey, so we send product images as 'files'
    // and variant images need to be handled separately or combined.
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/product/save',
      requestData: productData,
      mediaXFiles: productImages,
      fileKey: 'files',
      isFormData: true,
    );
  }

  Future<ApiResponse> updateProduct({
    required String productId,
    required Map<String, dynamic> productData,
    List<XFile>? productImages,
  }) async {
    return await _api.doPatchRequest(
      apiEndPoint: 'market-place/product/update/$productId',
      requestData: productData,
      mediaXFiles: productImages,
      fileKey: 'files',
      isFormData: true,
    );
  }

  Future<ApiResponse> toggleProductStatus({
    required String productId,
    required String status,
  }) async {
    return await _api.doPatchRequest(
      apiEndPoint: 'market-place/product/toggle-status/$productId',
      requestData: {'status': status},
    );
  }

  Future<ApiResponse> deleteProduct({required String productId}) async {
    return await _api.doDeleteRequest(
      apiEndPoint: 'market-place/product/$productId',
    );
  }

  // ─── Categories & Brands ─────────────────────────────────
  Future<ApiResponse> getCategories({String? keyword}) async {
    final Map<String, dynamic> params = {};
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/categories',
      responseDataKey: 'data',
      queryParameters: params,
    );
  }

  Future<ApiResponse> getBrands() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/get-all-brand',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getAttributeList() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/attribute-list',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getColorList() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/get-color-list',
      responseDataKey: 'data',
    );
  }

  // ─── Stores ───────────────────────────────────────────────
  Future<ApiResponse> getMyStores({
    int skip = 0,
    int limit = 10,
    String? keyword,
  }) async {
    final Map<String, dynamic> params = {
      'skip': skip,
      'limit': limit,
    };
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/get-all-store',
      queryParameters: params,
    );
  }

  Future<ApiResponse> saveStore({
    required Map<String, dynamic> storeData,
    XFile? storeImage,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/save-store',
      requestData: storeData,
      mediaXFiles: storeImage != null ? [storeImage] : null,
      fileKey: 'image',
      isFormData: true,
    );
  }

  Future<ApiResponse> updateStore({
    required String storeId,
    required Map<String, dynamic> storeData,
    XFile? storeImage,
  }) async {
    return await _api.doPatchRequest(
      apiEndPoint: 'market-place/update-store/$storeId',
      requestData: storeData,
      mediaXFiles: storeImage != null ? [storeImage] : null,
      fileKey: 'image',
      isFormData: true,
    );
  }

  Future<ApiResponse> deleteStore({required String storeId}) async {
    return await _api.doDeleteRequest(
      apiEndPoint: 'market-place/delete-store/$storeId',
    );
  }

  // ─── Orders ───────────────────────────────────────────────
  Future<ApiResponse> getOrderListForSeller({
    int skip = 0,
    int limit = 20,
    String? storeId,
    String? status,
    String? keyword,
    String? fromDate,
    String? toDate,
  }) async {
    final Map<String, dynamic> params = {
      'skip': skip,
      'limit': limit,
    };
    if (storeId != null && storeId.isNotEmpty) params['store_id'] = storeId;
    if (status != null && status.isNotEmpty) params['status'] = status;
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (fromDate != null) params['from_date'] = fromDate;
    if (toDate != null) params['to_date'] = toDate;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/list-for-seller',
      queryParameters: params,
    );
  }

  Future<ApiResponse> getOrderDetailsForSeller({
    required String orderId,
  }) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/show-for-seller/$orderId',
    );
  }

  Future<ApiResponse> acceptOrder({
    required String orderId,
    required String storeId,
    required String status,
    String? rejectNote,
  }) async {
    final data = <String, dynamic>{
      'order_id': orderId,
      'store_id': storeId,
      'status': status, // "accepted" or "canceled"
    };
    if (rejectNote != null && rejectNote.isNotEmpty) {
      data['reject_note'] = rejectNote;
    }

    return await _api.doPostRequest(
      apiEndPoint: 'market-place/seller/accept-order',
      requestData: data,
    );
  }

  // ─── Payments & Payouts ───────────────────────────────────
  Future<ApiResponse> getPaymentList({
    int skip = 0,
    int limit = 10,
    String? status,
  }) async {
    final Map<String, dynamic> params = {
      'skip': skip,
      'limit': limit,
    };
    if (status != null && status.isNotEmpty) params['status'] = status;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/seller/payment-list',
      queryParameters: params,
    );
  }

  Future<ApiResponse> transferToWallet({
    required double totalAmount,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/seller/transfer-to-wallet',
      requestData: {
        'total_amount': totalAmount,
      },
    );
  }

  // ─── Stock Management ────────────────────────────────────
  Future<ApiResponse> getStockByVariant({
    required String productId,
  }) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/product/variant-stocks/$productId',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> updateStocks({
    required String productId,
    required List<Map<String, dynamic>> variants,
  }) async {
    return await _api.doPatchRequest(
      apiEndPoint: 'market-place/product/update-stock/$productId',
      requestData: {'variants': variants},
    );
  }

  Future<ApiResponse> getStockHistoryList({
    int skip = 0,
    int limit = 20,
    String? keyword,
    String? fromDate,
    String? toDate,
  }) async {
    final Map<String, dynamic> params = {
      'skip': skip,
      'limit': limit,
    };
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (fromDate != null) params['from_date'] = fromDate;
    if (toDate != null) params['to_date'] = toDate;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/product/stock-history-list',
      queryParameters: params,
    );
  }

  Future<ApiResponse> setStockThreshold({
    required String variantId,
    required int threshold,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/seller/set-stock-threshold',
      requestData: {
        'variant_id': variantId,
        'threshold': threshold,
      },
    );
  }

  // ─── Order Tracking ───────────────────────────────────────
  Future<ApiResponse> updateTrackingNumber({
    required String orderId,
    required String storeId,
    required String trackingNumber,
    required String courierSlug,
  }) async {
    return await _api.doPutRequest(
      apiEndPoint: 'market-place/order/seller-update-tracking-number',
      requestData: {
        'order_id': orderId,
        'store_id': storeId,
        'tracking_number': trackingNumber,
        'courier_slug': courierSlug,
      },
    );
  }

  Future<ApiResponse> getTrackingNumber({
    required String orderId,
    required String storeId,
  }) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/tracking-number/$orderId/$storeId',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getTrackingDetails({
    required String orderId,
    required String storeId,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/order/tracking-details',
      requestData: {
        'order_id': orderId,
        'store_id': storeId,
      },
    );
  }

  // ─── Returns & Refunds ────────────────────────────────────
  Future<ApiResponse> getRefundListForSeller({
    int skip = 0,
    int limit = 20,
    String? storeId,
    String? fromDate,
    String? toDate,
  }) async {
    final Map<String, dynamic> params = {
      'skip': skip,
      'limit': limit,
    };
    if (storeId != null && storeId.isNotEmpty) params['store_id'] = storeId;
    if (fromDate != null) params['from_date'] = fromDate;
    if (toDate != null) params['to_date'] = toDate;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/refund-list-for-seller',
      queryParameters: params,
    );
  }

  Future<ApiResponse> getRefundDetailsForSeller({
    required String refundId,
  }) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/order/refund-details-for-seller/$refundId',
    );
  }

  Future<ApiResponse> acceptOrDeclineRefund({
    required String refundId,
    required String status,
    String? rejectNote,
  }) async {
    final data = <String, dynamic>{
      'refund_id': refundId,
      'status': status,
    };
    if (rejectNote != null && rejectNote.isNotEmpty) {
      data['reject_note'] = rejectNote;
    }
    return await _api.doPutRequest(
      apiEndPoint: 'market-place/seller/accept-cancel-refund',
      requestData: data,
    );
  }

  Future<ApiResponse> updateRefundStatus({
    required String refundId,
    required String status,
    double? amount,
  }) async {
    final data = <String, dynamic>{
      'refund_id': refundId,
      'status': status,
    };
    if (amount != null) data['amount'] = amount;
    return await _api.doPutRequest(
      apiEndPoint: 'market-place/seller/update-refund-status',
      requestData: data,
    );
  }

  // ─── Coupons ──────────────────────────────────────────────
  Future<ApiResponse> getCouponList({
    required String storeId,
    int skip = 0,
    int limit = 20,
    String? keyword,
    String? discountType,
    String? status,
  }) async {
    final Map<String, dynamic> params = {
      'skip': skip,
      'limit': limit,
    };
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (discountType != null && discountType.isNotEmpty) {
      params['discount_type'] = discountType;
    }
    if (status != null && status.isNotEmpty) params['status'] = status;

    return await _api.doGetRequest(
      apiEndPoint: 'market-place/store/coupon/list/$storeId',
      queryParameters: params,
    );
  }

  Future<ApiResponse> createCoupon({
    required Map<String, dynamic> couponData,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/store/coupon/save',
      requestData: couponData,
    );
  }

  Future<ApiResponse> updateCoupon({
    required String couponId,
    required Map<String, dynamic> couponData,
  }) async {
    return await _api.doPatchRequest(
      apiEndPoint: 'market-place/store/coupon/update/$couponId',
      requestData: couponData,
    );
  }

  // ─── Seller Verification ─────────────────────────────────
  Future<ApiResponse> submitVerification({
    required Map<String, dynamic> verificationData,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/seller/submit-verification',
      requestData: verificationData,
    );
  }

  Future<ApiResponse> getVerificationStatus() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/seller/verification-status',
      responseDataKey: 'data',
    );
  }

  // ─── Promotions ──────────────────────────────────────────
  Future<ApiResponse> getMyPromotions({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    String ep = 'market-place/promotion/my-promotions?page=$page&limit=$limit';
    if (status != null && status.isNotEmpty) ep += '&status=$status';
    return await _api.doGetRequest(
      apiEndPoint: ep,
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getPromotionDetail({required String promotionId}) async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/promotion/$promotionId',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getPromotionAnalytics({
    required String promotionId,
    String? start,
    String? end,
  }) async {
    String ep = 'market-place/promotion/$promotionId/analytics';
    final params = <String>[];
    if (start != null) params.add('start=$start');
    if (end != null) params.add('end=$end');
    if (params.isNotEmpty) ep += '?${params.join('&')}';
    return await _api.doGetRequest(
      apiEndPoint: ep,
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getPromotionConfig() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/promotion/config',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> createPromotion({
    required Map<String, dynamic> promotionData,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/promotion/create',
      requestData: promotionData,
    );
  }

  Future<ApiResponse> submitPromotion({required String promotionId}) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/promotion/submit/$promotionId',
      requestData: {},
    );
  }

  Future<ApiResponse> pausePromotion({required String promotionId}) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/promotion/pause/$promotionId',
      requestData: {},
    );
  }

  Future<ApiResponse> resumePromotion({required String promotionId}) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/promotion/resume/$promotionId',
      requestData: {},
    );
  }

  Future<ApiResponse> cancelPromotion({required String promotionId}) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/promotion/cancel/$promotionId',
      requestData: {},
    );
  }

  Future<ApiResponse> estimatePromotionCost({
    required String promotionType,
    required int durationDays,
    int? dailyBudgetCents,
  }) async {
    final data = <String, dynamic>{
      'promotion_type': promotionType,
      'duration_days': durationDays,
    };
    if (dailyBudgetCents != null) {
      data['daily_budget_cents'] = dailyBudgetCents;
    }
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/promotion/estimate',
      requestData: data,
    );
  }

  // ─── Flash Sales ─────────────────────────────────────────
  Future<ApiResponse> createFlashSale({
    required Map<String, dynamic> flashSaleData,
  }) async {
    return await _api.doPostRequest(
      apiEndPoint: 'market-place/flash-sale/create',
      requestData: flashSaleData,
    );
  }

  Future<ApiResponse> getMyFlashSales() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/flash-sale/my-sales',
      responseDataKey: 'data',
    );
  }

  Future<ApiResponse> getActiveFlashSales() async {
    return await _api.doGetRequest(
      apiEndPoint: 'market-place/flash-sale/active',
      responseDataKey: 'data',
    );
  }
}
