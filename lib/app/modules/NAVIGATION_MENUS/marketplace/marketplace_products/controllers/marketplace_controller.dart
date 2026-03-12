import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../repository/market_place_repository.dart';

import '../../../../../models/product_brand.dart';
import '../../../../../repository/cart_repository.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../utils/snackbar.dart';
import '../models/all_product_model.dart';

class MarketplaceController extends GetxController {
  late ApiCommunication _apiCommunication;

  RxBool isLoadingMarketplaceProduct = true.obs;
  Rx<List<AllProducts>> productList = Rx([]);
  RxBool showSuggestedProduct = false.obs;
  Rx<List<ProductBrand>> brandList = Rx([]);
  TextEditingController searchController = TextEditingController();
  TextEditingController searchFilterController = TextEditingController();
  TextEditingController categorySearchController = TextEditingController();
  TextEditingController brandSearchController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  RxString categoryName = ''.obs;
  RxString brandName = ''.obs;
  RxString condition = 'Any'.obs;
  RxString productAvailability = 'Any'.obs;
  RxString sellerType = 'Any'.obs;
  RxBool isLoadingMore = false.obs;
  Rx<RangeValues> currentRangeValues = const RangeValues(0, 1000000000).obs;
  RxInt maxPrice = 1000000000.obs;
  final Duration debounceDuration = const Duration(milliseconds: 500);

  RxInt rating = 5.obs;

  RxString price = ''.obs;
  RxString pId = ''.obs;
  RxInt cartCount = 0.obs;
  RxInt wishProductCount = 0.obs;
  int skipCount = 0;
  int totalCount = 0;
  final int limit = 20;
  bool hasMoreData = true;

  final ScrollController scrollController = ScrollController();

  final MarketPlaceRepository marketPlaceRepository = MarketPlaceRepository();
  final CartRepository cartRepository = CartRepository();

  // // Additional properties for category and brand lists

  Future<void> getMarketPlaceProduct(
      {bool keywordOnly = false,
      bool categoryOnly = false,
      bool brandOnly = false,
      bool loadMore = false,
      bool? forceRecallApi}) async {
    if (loadMore) {
      if (!hasMoreData) return;
      isLoadingMore.value = true;
      skipCount += limit;
    } else {
      isLoadingMarketplaceProduct.value = true;
      skipCount = 0;
      hasMoreData = true;
    }

    // isLoadingMarketplaceProduct.value = true;

    // Define the base query parameters

    final Map<String, dynamic> queryParams = {
      'limit': limit.toString(),
      'skip': skipCount.toString(),
    };

    if (keywordOnly && categoryOnly && brandOnly) {
      queryParams['keyword'] = searchController.text;
      queryParams['category'] = categorySearchController.text;
      queryParams['brand'] = brandSearchController.text;
    } else if (keywordOnly && categoryOnly) {
      queryParams['keyword'] = searchController.text;
      queryParams['category'] = categorySearchController.text;
    } else if (keywordOnly && brandOnly) {
      queryParams['keyword'] = searchController.text;
      queryParams['brand'] = brandSearchController.text;
    } else if (categoryOnly && brandOnly) {
      queryParams['category'] = categorySearchController.text;
      queryParams['brand'] = brandSearchController.text;
    } else if (keywordOnly) {
      queryParams['keyword'] = searchController.text;
    } else if (categoryOnly) {
      queryParams['category'] = categorySearchController.text;
    } else if (brandOnly) {
      queryParams['brand'] = brandSearchController.text;
    } else {
      if (searchController.text.isNotEmpty) {
        queryParams['keyword'] = searchController.text;
      }
      if (categorySearchController.text.isNotEmpty) {
        queryParams['category'] = categorySearchController.text;
      }
      if (brandSearchController.text.isNotEmpty) {
        queryParams['brand'] = brandSearchController.text;
      }
      if (minPriceController.text.isNotEmpty) {
        queryParams['min_price'] = minPriceController.text;
      }
      if (maxPriceController.text.isNotEmpty) {
        queryParams['max_price'] = maxPriceController.text;
      }

      if (condition.value != 'Any') {
        queryParams['condition'] =
            condition.value == 'Brand New' ? 'brand_new' : 'used';
      }

      if (productAvailability.value == 'Any') {
        queryParams['isStockCheck'] = 'false';
      }
      if (productAvailability.value == 'In Stock') {
        queryParams['isStockCheck'] = 'true';
      }

      if (sellerType.value != 'Any') {
        queryParams['trusted_seller'] =
            sellerType.value == 'Verified Sellers' ? 'Yes' : 'No';
      }

      if (rating.value != 5) {
        queryParams['rating'] = rating.value.toString();
      }
    }

    final apiEndPoint = Uri(
      path: 'market-place/product/list',
      queryParameters: queryParams,
    ).toString();

    debugPrint('API endpoint: $apiEndPoint');

    final apiResponse = await marketPlaceRepository.getAllProductForMarketPlace(
      queryParameters: queryParams,
      forceRecallApi: forceRecallApi,
    );

    isLoadingMore.value = false;
    isLoadingMarketplaceProduct.value = false;

    if (apiResponse.isSuccessful) {
      final data = apiResponse.data as Map<String, dynamic>;
      if (data['totalCount'] != null) {
        totalCount = data['totalCount'];
      }
      if (data['maxPrice'] != null) {
        maxPrice.value = data['maxPrice'];
        currentRangeValues.value = RangeValues(0, maxPrice.value.toDouble());
        maxPriceController.text = maxPrice.value.toString();
        minPriceController.text = '0';
      }
      final fetchedProducts = (data['data'] as List<dynamic>)
          .map((element) => AllProducts.fromMap(element))
          .toList();
      if (!loadMore) {
        productList.value.clear();
      }
      productList.value.addAll(fetchedProducts);
      // Check if more data is available
      hasMoreData = totalCount > limit;
    } else {
      debugPrint('Failed to fetch products: ${apiResponse.message}');
    }
  }

  void loadMoreProducts() async {
    if (hasMoreData && !isLoadingMarketplaceProduct.value) {
      await getMarketPlaceProduct(loadMore: true);
    }
  }

//=================================================Get Suggested Products ========================================//
// In MarketplaceController
  Rx<List<AllProducts>> suggestedProductList = Rx([]);
  Future<void> getSuggestedProducts() async {
    final apiResponse = await marketPlaceRepository.getAllProductSuggestionList(
      queryParameters: {
        'search': searchController.text,
      },
    );

    if (apiResponse.isSuccessful) {
      final data = apiResponse.data as List<dynamic>;
      suggestedProductList.value = data
          .map((item) => AllProducts.fromMap(item))
          .toList()
          .cast<AllProducts>();
    } else {
      debugPrint('Failed to fetch suggested products: ${apiResponse.message}');
    }
  }
  //=================================================Add To Cart ========================================//

  Future<bool> addToCartPost(
      {String? productId,
      String? storeId,
      String? productVariantId,
      int? quantity}) async {
    productId == null ? productId = pId.value : productId = productId;
    final apiResponse = await cartRepository.addProductToOnlineCart(
        productId: productId,
        storeId: storeId,
        productVariantId: productVariantId,
        quantity: quantity);

    debugPrint('api delete response.....${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      cartCount.value += 1;

      showSuccessSnackkbar(message: 'Added to cart successfully'.tr);
      return true;
    } else {
      showErrorSnackkbar(message: 'Sorry! This product is out of stock'.tr);
      return false;
    }
  }

  //=================================================Add To Wishlist ========================================//
  RxString wishListType = ''.obs;
  Future<bool> addToWishlist({
    required String productId,
    required String storeId,
    required String productVariantId,
  }) async {
    final apiResponse =
        await marketPlaceRepository.postAddToWishlist(requestData: {
      'product_id': productId,
      'store_id': storeId,
      'product_variant_id': productVariantId,
    });

    debugPrint('api wishlist response.....${apiResponse.statusCode}');

    if (apiResponse.isSuccessful) {
      // wishProductCount.value += 1;
      wishListType.value = (apiResponse.data as Map)['type'];
      debugPrint(
          'wishListType.value ::::::::::::::::::::::${wishListType.value}');
      await getWishListCount();
      // await getMarketPlaceProduct(forceRecallApi: true);
      productList.value.where((element) {
        if (element.id == productId) {
          element.wishProduct = !(element.wishProduct ?? false);
        }
        return true;
      }).toList();
      productList.refresh();

      wishListType.value == 'add'
          ? showSuccessSnackkbar(message: 'Added to wishlist successfully'.tr)
          : showSuccessSnackkbar(message: 'Removed from wishlist successfully'.tr);
      return true;
    } else {
      showErrorSnackkbar(message: 'Sorry! somthing went wrong'.tr);
      return false;
    }
  }

  // =============================== Get Wishlist Count =================================
  Future<void> getWishListCount() async {
    final response = await marketPlaceRepository.getWishlistCount();

    if (response.isSuccessful) {
      wishProductCount.value = (response.data as int);
    } else {}
  }

//===========================================Decrement Cart Count=================================//
  void decrementCartCount() {
    if (cartCount.value > 0) {
      cartCount.value--;
    }
  }

//===========================================Decrement Wished Prduct Count=================================//
  void decrementWishedProductCount() {
    if (wishProductCount.value > 0) {
      wishProductCount.value--;
    }
  }

  void debounce(void Function() callback) {
    Future.delayed(debounceDuration, callback);
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();

    //! API CALL COMMENTED OUT ----------------------
    // getMarketPlaceProduct();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        loadMoreProducts();
      }
    });

    // Listener for searchController
    searchController.addListener(() {
      debounce(() {
        // if (searchController.text.isNotEmpty ||
        //     categorySearchController.text.isNotEmpty ||
        //     brandSearchController.text.isNotEmpty) {
        //   getMarketPlaceProduct(
        //     keywordOnly: searchController.text.isNotEmpty,
        //     categoryOnly: categorySearchController.text.isNotEmpty,
        //     brandOnly: brandSearchController.text.isNotEmpty,
        //   );
        // }
        debugPrint('searchController:::::::::: ${searchController.text}');
        if (searchController.text.isNotEmpty &&
            showSuggestedProduct.value == true) {
          getSuggestedProducts();
        } else {
          suggestedProductList.value.clear();
          getMarketPlaceProduct();
        }

        //  else {
        //   getMarketPlaceProduct(); // Fetch all products when all are empty
        // }
      });
    });
    // searchController.addListener(() {
    //   debounce(() {
    //     if (searchController.text.isNotEmpty) {
    //       getSuggestedProducts();
    //     } else {
    //       suggestedProductList.value.clear();
    //     }
    //   });
    // });
    // Listener for categorySearchController
    categorySearchController.addListener(() {
      debounce(() {
        if (searchController.text.isNotEmpty ||
            categorySearchController.text.isNotEmpty ||
            brandSearchController.text.isNotEmpty) {
          getMarketPlaceProduct(
            keywordOnly: searchController.text.isNotEmpty,
            categoryOnly: categorySearchController.text.isNotEmpty,
            brandOnly: brandSearchController.text.isNotEmpty,
          );
        } else {
          getMarketPlaceProduct();
        }
      });
    });

    // Listener for brandSearchController
    brandSearchController.addListener(() {
      debounce(() {
        if (searchController.text.isNotEmpty ||
            categorySearchController.text.isNotEmpty ||
            brandSearchController.text.isNotEmpty) {
          getMarketPlaceProduct(
            keywordOnly: searchController.text.isNotEmpty,
            categoryOnly: categorySearchController.text.isNotEmpty,
            brandOnly: brandSearchController.text.isNotEmpty,
          );
        } else {
          getMarketPlaceProduct();
        }
      });
    });

    getWishListCount();
    super.onInit();
  }

  @override
  void onReady() {
    pId.value = Get.arguments ?? '';
    //  getProductDetails(productId: pId.value);
    super.onReady();
  }
}
