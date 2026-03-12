import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../repository/market_place_repository.dart';

import '../../../../../data/market_place_data.dart';
import '../../../../../models/api_response.dart';
import '../../../../../models/product_brand.dart';
import '../../../../../models/product_category.dart';
import '../../../../../services/api_communication.dart';
import '../../marketplace_products/controllers/marketplace_controller.dart';
import '../models/product_details_model.dart';
import '../models/product_review_model.dart';
import '../models/related_product_model.dart';

class ProductDetailsController extends GetxController {
  late ApiCommunication _apiCommunication;
  late MarketPlaceData _marketPlaceData;
  Rx<ReviewData?> reviewData = Rx<ReviewData?>(null);

  RxBool isLoadingMarketplaceProduct = true.obs;
  Rx<List<AllRelatedProducts>> relatedProductList = Rx([]);
  Rx<List<ProductDetails>> productDetailsList = Rx([]);
  Rx<List<ProductReviewDetails>> productReviewDetailsList = Rx([]);
  Rx<List<ProductData>> categoryList = Rx([]);
  Rx<List<ProductBrand>> brandList = Rx([]);
  TextEditingController searchController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  MarketplaceController marketPlaceController = Get.find();
  var tabTitles = <String>[].obs;
  var tabContents = <Widget>[].obs;
  RxString categoryName = ''.obs;
  RxString brandName = ''.obs;
  RxString price = ''.obs;
  RxString pId = ''.obs;
  final selectedProductVariantId = ''.obs;
  final selectedAttributes = <String, String>{}.obs;
  final RxString selectedColorId = ''.obs;
  RxDouble currentPrice = 0.0.obs;
  final RxInt productQuantity = 1.obs;
  final RxInt stock = 1.obs;

  final MarketPlaceRepository marketPlaceRepository = MarketPlaceRepository();

  //================================================= Get Product Variant Price ========================================//
  Future<void> fetchPriceBasedOnAttributes() async {
    try {
      String? selectedColorIdValue = selectedColorId.value;

      List<Map<String, String>> filters = selectedAttributes.entries
          .where((entry) => entry.key != 'Color')
          .map((entry) => {'name': entry.key, 'value': entry.value})
          .toList();

      Map<String, dynamic> requestData = {
        'color_id': selectedColorIdValue,
        'filter': filters,
      };

      //

      final ApiResponse response =
          await marketPlaceRepository.getProductPriceBasedOnAttributesById(
              productId: productDetailsList.value.first.id.toString(),
              requestData: requestData);

      if (response.isSuccessful) {
        var productVariant =
            (response.data as Map<String, dynamic>)['product_variant']?[0];
        stock.value = (response.data as Map<String, dynamic>)['product_variant']
            ?[0]['stock'];
        debugPrint('Product Variant Id ::::::::::::::::::::$productVariant');
        debugPrint('Stock Value ::::::::::::::::::::${stock.value}');
        double newPrice = productVariant?['sell_price']?.toDouble() ?? 0.0;
        currentPrice.value = newPrice;

        selectedProductVariantId.value = productVariant?['_id'] ?? '';
      } else {
        debugPrint('Failed to fetch price: ${response.message}');
      }
    } catch (e) {
      debugPrint('Error fetching price: $e');
    }
  }

  //===============================================Get All Related Product List ========================================//
  RxBool isLoadingRelatedProduct = true.obs;
  Future<void> getRelatedMarketPlaceProduct({String? productId}) async {
    productId = productId ?? pId.value;

    relatedProductList.refresh();

    debugPrint('Fetching related products for productId: $productId');

    isLoadingRelatedProduct.value = true;

    final apiResponse = await marketPlaceRepository
        .getRelatedMarketPlaceProductById(productId: productId);
    isLoadingRelatedProduct.value = false;

    if (apiResponse.isSuccessful) {
      relatedProductList.value
          .addAll(apiResponse.data as List<AllRelatedProducts>);

      relatedProductList.refresh();

      debugPrint(
          'Related products fetched: ${relatedProductList.value.length}');
    } else {
      debugPrint('Error fetching related products: ${apiResponse.message}');
    }
  }

  //===============================================Get Product details ========================================//
  Future<void> getProductDetails({String? productId}) async {
  WidgetsBinding.instance.addPostFrameCallback((_) {
      productDetailsList.value.clear();
      productDetailsList.refresh();
    });

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
      // debugPrint(
      //     'Stock Quantity:::::::::..........${productDetailsList.value.first.productVariant?.first.stock}');
    } else {
      debugPrint('Api Error..........${apiResponse.message}');
    }
  }

//================================================= Get Product Review details ========================================//
  Future<void> getProductReviews({String? productId}) async {
    productId = pId.value;

    debugPrint('market call..........');

    isLoadingMarketplaceProduct.value = true;
    update();

    // Making the API call
    final apiResponse =
        await marketPlaceRepository.getProductReviewById(productId: productId);

    isLoadingMarketplaceProduct.value = false;
    update();

    debugPrint('product Details call..........${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      reviewData.value =
          ReviewData.fromMap(apiResponse.data as Map<String, dynamic>);

      productReviewDetailsList.value.addAll(reviewData.value?.review ?? []);

      debugPrint(
          'Product review list..........${productReviewDetailsList.value.length}');
    } else {
      debugPrint('Api Error..........${apiResponse.message}');
    }
  }

//=================================================Add To Cart ========================================//

  // Future<void> addToCartPost(
  //     {String? productId,
  //     String? storeId,
  //     String? productVariantId,
  //     int? quantity}) async {
  //   productId = pId.value;
  //   final apiResponse = await _apiCommunication.doPostRequest(
  //     responseDataKey: ApiConstant.FULL_RESPONSE,
  //     apiEndPoint: 'market-place/save-cart',
  //     requestData: {
  //       'product_id': productId,
  //       'store_id': storeId,
  //       'product_variant_id': productVariantId,
  //       'quantity': quantity,
  //     },
  //   );

  //   debugPrint('api delete response.....${apiResponse.statusCode}');

  //   if (apiResponse.isSuccessful) {
  //     showSuccessSnackkbar(message: 'Added to cart successfully');
  //   } else {
  //     showErrorSnackkbar(message: 'Sorry! Product is out of stock');
  //   }

  //   debugPrint('-post-home controller---------------------------$apiResponse');
  // }
  // Future<void> addToCartForRelatedPost(
  //     {String? productId,
  //     String? storeId,
  //     String? productVariantId,
  //     int? quantity}) async {
  //   final apiResponse = await _apiCommunication.doPostRequest(
  //     responseDataKey: ApiConstant.FULL_RESPONSE,
  //     apiEndPoint: 'market-place/save-cart',
  //     requestData: {
  //       'product_id': productId,
  //       'store_id': storeId,
  //       'product_variant_id': productVariantId,
  //       'quantity': quantity,
  //     },
  //   );

  //   debugPrint('api delete response.....${apiResponse.statusCode}');

  //   if (apiResponse.isSuccessful) {
  //     showSuccessSnackkbar(message: 'Added to cart successfully');
  //   } else {
  //     showErrorSnackkbar(message: 'Sorry! Product is out of stock');
  //   }

  //   debugPrint('-post-home controller---------------------------$apiResponse');
  // }

  void incrementQuantity() {
    if (stock.value != 0 && stock.value >= productQuantity.value) {
      productQuantity.value++;
    }
  }

  void decrementQuantity() {
    if (productQuantity.value > 1) {
      productQuantity.value--;
    }
  }

  //=================================================Initialize Product Calling for details and others ========================================//
  void initializeApiCalling() async {
    if (Get.arguments != null) {
      pId.value = Get.arguments;
      // productDetailsList.value.clear();
      // productReviewDetailsList.value.clear();
      // relatedProductList.value.clear();
      await getProductDetails(productId: pId.value);
       getRelatedMarketPlaceProduct(productId: pId.value);
      await getProductReviews(productId: pId.value);
    } else {
      debugPrint('No arguments passed to the controller.');
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (searchController.text.isNotEmpty) {
      searchController.clear();
    }
    if (maxPriceController.text.isNotEmpty) {
      maxPriceController.clear();
    }
    if (minPriceController.text.isNotEmpty) {
      minPriceController.clear();
    }
  }

  @override
  void onInit() async {
    _apiCommunication = ApiCommunication();

    pId.value = Get.arguments;
    getRelatedMarketPlaceProduct(productId: pId.value);

    getProductDetails(productId: pId.value);
    getProductReviews(productId: pId.value);

    super.onInit();
  }
  // @override
  // void onReady() {
  //   pId.value= Get.arguments;
  //  getProductDetails(productId: pId.value);
  //   super.onReady();
  // }
}
