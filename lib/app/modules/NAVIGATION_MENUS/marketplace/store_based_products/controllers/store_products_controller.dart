import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../repository/market_place_repository.dart';

import '../../../../../services/api_communication.dart';
import '../../marketplace_products/controllers/marketplace_controller.dart';
import '../../product_details/controllers/product_details_controller.dart';
import '../../product_details/models/product_details_model.dart';
import '../../product_details/models/product_review_model.dart';
import '../models/store_products_model.dart';

class StoreProductsController extends GetxController {
  late ApiCommunication _apiCommunication;
  Rx<StoreDetailsModel?> storeDetails = Rx<StoreDetailsModel?>(null);
  ProductDetailsController productDetailsController = Get.find();
  Rx<List<ProductReviewDetails>> productReviewDetailsList = Rx([]);
  Rx<List<ProductDetails>> productDetailsList = Rx([]);

  final MarketPlaceRepository marketPlaceRepository = MarketPlaceRepository();
  final MarketplaceController marketplaceController =
      Get.find<MarketplaceController>();
  RxBool isLoadingMarketplaceProduct = true.obs;

  RxString pId = ''.obs;
  final selectedProductVariantId = ''.obs;

  RxDouble currentPrice = 0.0.obs;
  final RxInt productQuantity = 1.obs;
  final RxInt stock = 1.obs;

  //===============================================Get All Related Product List ========================================//

  Future<void> getStoreBaseProduct({String? storeId}) async {
    storeId = storeId ?? pId.value;

     WidgetsBinding.instance.addPostFrameCallback((_) {
      storeDetails.value = null;
    });
    debugPrint('Fetching store details for storeId: $storeId');

    isLoadingMarketplaceProduct.value = true;

    final apiResponse =
        await marketPlaceRepository.getAllProductsByStoreId(storeId: storeId);

    isLoadingMarketplaceProduct.value = false;

    if (apiResponse.isSuccessful) {
      storeDetails.value = StoreDetailsModel.fromMap(
        apiResponse.data as Map<String, dynamic>,
      );

      debugPrint('Store details fetched successfully.');
    } else {
      debugPrint('Error fetching store details: ${apiResponse.message}');
    }
  }

//===============================================Get Product details ========================================//
  Future<void> getProductDetails({String? productId}) async {
    productDetailsList.value.clear();
    productDetailsList.refresh();

    productId == null ? productId = pId.value : productId = productId;

    debugPrint('market call..........');

    isLoadingMarketplaceProduct.value = true;
    update();

    final apiResponse =
        await marketPlaceRepository.getProductDetailsById(productId: productId);
    isLoadingMarketplaceProduct.value = false;
    update();

    debugPrint('product Details call..........${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      productDetailsList.value = [
        ProductDetails.fromMap(apiResponse.data as Map<String, dynamic>)
      ];

      debugPrint(
          'status code from market list..........${productDetailsList.value}');
      debugPrint(
          'Stock Quantity:::::::::..........${productDetailsList.value.first.productVariant?.first.stock}');
    } else {
      debugPrint('Api Error..........${apiResponse.message}');
    }
  }

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();

    pId.value = Get.arguments;
    getStoreBaseProduct(storeId: pId.value);

    // getProductDetails(productId: pId.value);
    // getProductReviews(productId: pId.value);

    super.onInit();
  }
  // @override
  // void onReady() {
  //   pId.value= Get.arguments;
  //  getProductDetails(productId: pId.value);
  //   super.onReady();
  // }
}
