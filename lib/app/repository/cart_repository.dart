import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../services/api_communication.dart';

class CartRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET CART DETAILS                                                     ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getCartDetails() async {
    ApiResponse apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/cart-list',
    );
    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ADD TO CART                                                          ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> addProductToOnlineCart({
    required String productId,
    required String? storeId,
    required String? productVariantId,
    required int? quantity,
  }) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'market-place/save-cart',
      requestData: {
        'product_id': productId,
        'store_id': storeId,
        'product_variant_id': productVariantId,
        'quantity': quantity ?? 0,
      },
    );
    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  UPDATE CART PRODUCT QUANTITY                                         ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> updateTheQuantityOfProductInCart({
    required String? cartId,
    required int? quantity,
  }) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'market-place/update-cart-quantity',
      enableLoading: false,
      requestData: {
        'cart_id': cartId,
        'quantity': quantity,
      },
    );
    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  REMOVE ITEM FROM CART                                                ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> removeProductFromOnlineCart({required String? cartId}) async {
    ApiResponse apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'market-place/delete-cart/$cartId',
    );
    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  APPLY COUPON ON A STORE | APPLIED ON THE SUB TOTAL                   ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> applyCouponOnAProductFrom({
    required String? storeId,
    required String? enteredCouponCode,
    required double? subTotal,
  }) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'market-place/store/coupon/validate-coupon',
      enableLoading: true,
      requestData: {
        'coupon_code': enteredCouponCode,
        'store_id': storeId,
        'sub_total_amount': subTotal,
      },
    );
    return apiResponse;
  }

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  PLACE ORDER FROM CART                                                ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> placeOrder({
    required Map<String, dynamic>? requestData,
  }) async {
    ApiResponse apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.DATA_RESPONSE,
      apiEndPoint: 'market-place/order/save',
      enableLoading: true,
      requestData: requestData,
    );
    return apiResponse;
  }
}
