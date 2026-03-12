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

  Future<ApiResponse> deleteWishlistProduct({required productId}) async {
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint:
          'market-place/wishlist/remove-wishlist/$productId',
    );
    return apiResponse;
  }
}
