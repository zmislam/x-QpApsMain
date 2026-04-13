import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../modules/NAVIGATION_MENUS/marketplace/product_details/models/related_product_model.dart';
import '../services/api_communication.dart';

class MarketPlaceRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL PRODUCT FOR THE MAIN MARKET PLACE                            ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllProductForMarketPlace(
      {bool? forceRecallApi,
      required Map<String, dynamic>? queryParameters}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'market-place/product/list',
      queryParameters: queryParameters,
      enableCache: true,
      timeToLiveInSeconds: 3600 * 5,
      forceRecallAPI: forceRecallApi,
    );
    return apiResponse;
  }
  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL PRODUCT SUGGESTION LIST                                      ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllProductSuggestionList(
      {bool? forceRecallApi,
      required Map<String, dynamic>? queryParameters}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/product/get-product-name',
      queryParameters: queryParameters,
      enableCache: true,
      timeToLiveInSeconds: 3600 * 5,
      forceRecallAPI: forceRecallApi,
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET PRODUCT DETAILS                                                  ┃
  // *┃  APPLICABLE FOR ALL PLACES                                            ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getProductDetailsById({required String productId}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/product/show-details/$productId',
      enableCache: true,
      timeToLiveInSeconds: 300,
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET PRODUCT REVIEWS                                                  ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getProductReviewById({required String productId}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/product/review-list/$productId',
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET RELATED MARKET PLACE PRODUCT                                     ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getRelatedMarketPlaceProductById(
      {required String productId}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/get-related-product/$productId',
      enableCache: true,
      timeToLiveInSeconds: 600,
    );
    return apiResponse.copyWith(
      data: (apiResponse.data as List)
          .map(
            (e) => AllRelatedProducts.fromMap(e),
          )
          .toList(),
    );
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  FETCH PRICES BASED ON ATTRIBUTES || COLOR & OTHER FILTERS            ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getProductPriceBasedOnAttributesById(
      {required String productId,
      required Map<String, dynamic>? requestData}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/get-product-price-by-attributes/$productId',
      requestData: requestData,
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET STORE BASED PRODUCT BY STORE ID                                  ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllProductsByStoreId({required String storeId}) async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/get-store-products/$storeId',
    );
    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  POST ADD TO WISHLIST      ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> postAddToWishlist(
      {required Map<String, dynamic>? requestData}) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/wishlist/add-to-wishlist',
      requestData: requestData,
      responseDataKey: ApiConstant.FULL_RESPONSE,
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL WISHLIST                            ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllWishlist() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/wishlist/get-wishlist',
    );
    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET  WISHLIST COUNT                         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getWishlistCount() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/wishlist/get-wishlist-count',
    );
    return apiResponse;
  }
  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  DELETE  WISHLIST COUNT                         ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> deleteWishlistProduct({required String productId}) async {
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint:
          'market-place/wishlist/remove-wishlist/$productId',
    );
    return apiResponse;
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃  HOMEPAGE SECTION APIs                                                 ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getNewForYou() async {
    return await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/new-for-you',
      enableCache: true,
      timeToLiveInSeconds: 300,
    );
  }

  Future<ApiResponse> getFeaturedProducts() async {
    return await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/featured',
      enableCache: true,
      timeToLiveInSeconds: 600,
    );
  }

  Future<ApiResponse> getFlashDeals() async {
    return await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/flash-deals',
      enableCache: true,
      timeToLiveInSeconds: 120,
    );
  }

  Future<ApiResponse> getFeaturedStores() async {
    return await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/featured-stores',
      enableCache: true,
      timeToLiveInSeconds: 600,
    );
  }

  Future<ApiResponse> getCategoryTree() async {
    return await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/categories-tree',
      enableCache: true,
      timeToLiveInSeconds: 3600,
    );
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃  PRODUCT VIEW/SHARE TRACKING                                           ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> incrementProductViewCount({required String productId}) async {
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/product/view/$productId',
    );
  }

  Future<ApiResponse> incrementProductShareCount({required String productId}) async {
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/product/share/$productId',
    );
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃  STORE FOLLOW TOGGLE                                                   ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> toggleStoreFollow({required String storeId}) async {
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/store/follow',
      requestData: {'store_id': storeId},
    );
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃  GET FOLLOWING STORES LIST                                              ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getFollowingStores() async {
    return await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/buyer/following',
    );
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃  PRODUCT Q&A                                                           ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getProductQuestions({required String productId}) async {
    return await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/product/questions/$productId',
    );
  }

  Future<ApiResponse> askProductQuestion({
    required String productId,
    required String question,
  }) async {
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/product/ask-question',
      requestData: {'product_id': productId, 'question': question},
    );
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃  QUICK MESSAGE TO SELLER                                               ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> sendQuickMessage({
    required String productId,
    required String message,
  }) async {
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/product/quick-message',
      requestData: {'product_id': productId, 'message': message},
    );
  }

  // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ┃  STORE REVIEWS                                                         ┃
  // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getStoreReviews({
    required String storeId,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiCommunication.doGetRequest(
      apiEndPoint: 'market-place/store/reviews/$storeId',
      responseDataKey: 'data',
      queryParameters: {'page': page, 'limit': limit},
    );
  }

  Future<ApiResponse> submitStoreReview({
    required String storeId,
    required int overallRating,
    int? shippingRating,
    int? communicationRating,
    int? accuracyRating,
    String? reviewText,
    String? orderId,
  }) async {
    final data = <String, dynamic>{
      'store_id': storeId,
      'overall_rating': overallRating,
    };
    if (shippingRating != null) data['shipping_rating'] = shippingRating;
    if (communicationRating != null) {
      data['communication_rating'] = communicationRating;
    }
    if (accuracyRating != null) data['accuracy_rating'] = accuracyRating;
    if (reviewText != null && reviewText.isNotEmpty) {
      data['review_text'] = reviewText;
    }
    if (orderId != null && orderId.isNotEmpty) data['order_id'] = orderId;
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/store/submit-review',
      requestData: data,
    );
  }

  // ─── Sponsored Products ───────────────────────────────────
  Future<ApiResponse> getSponsoredProducts({int limit = 10}) async {
    return await _apiCommunication.doGetRequest(
      apiEndPoint: 'market-place/sponsored',
      queryParameters: {'limit': limit},
      enableCache: true,
      timeToLiveInSeconds: 120,
    );
  }

  // ─── Beacon / Tracking ────────────────────────────────────
  Future<ApiResponse> trackPromotionClick({
    required String promotionId,
  }) async {
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/promotion/track-click',
      requestData: {'promotion_id': promotionId},
    );
  }

  Future<ApiResponse> sendBeaconEvent({
    required String promotionId,
    required String eventType,
    String? productId,
  }) async {
    final data = <String, dynamic>{
      'promotion_id': promotionId,
      'event_type': eventType,
    };
    if (productId != null) data['product_id'] = productId;
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/promotion/beacon',
      requestData: data,
    );
  }

  Future<ApiResponse> sendBeaconBatch({
    required List<Map<String, dynamic>> events,
  }) async {
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'market-place/promotion/beacon/batch',
      requestData: {'events': events},
    );
  }
}
