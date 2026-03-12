import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../marketplace_products/controllers/marketplace_controller.dart';
import '../models/wishlist_model.dart';

import '../../../../../repository/market_place_repository.dart';
import '../../../../../utils/snackbar.dart';

class MarketplaceWishlistController extends GetxController {
  final MarketPlaceRepository marketPlaceRepository = MarketPlaceRepository();
  final MarketplaceController marketplaceController =
      Get.find<MarketplaceController>();
  RxBool isLoadingWishlist = true.obs;
  Rx<List<WishlistItem>> wishedProductList = Rx([]);

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL WISHLIST PRODUCTS                                            ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> getWishlistProducts() async {
    isLoadingWishlist.value = true;
    final apiResponse = await marketPlaceRepository.getAllWishlist();
    isLoadingWishlist.value = false;
    if (apiResponse.isSuccessful) {
      wishedProductList.value = (apiResponse.data as List)
          .map((e) => WishlistItem.fromMap(e))
          .toList();
      debugPrint('Wished Product List: ${wishedProductList.value}');
    } else {
      wishedProductList.value = [];
      debugPrint('Error fetching wishlist products: ${apiResponse.message}');
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  DELETE  WISHLIST PRODUCT BY ID                                       ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> deleteWishlistProduct({required String productId}) async {
    final apiResponse =
        await marketPlaceRepository.deleteWishlistProduct(productId: productId);
    if (apiResponse.isSuccessful) {
      await marketplaceController.getWishListCount();
      await getWishlistProducts();
      wishedProductList.refresh();
      debugPrint('Product removed from wishlist successfully.');
      showSuccessSnackkbar(
          message: 'Product removed from wishlist successfully.');
    } else {
      debugPrint(
          'Error removing product from wishlist: ${apiResponse.message}');
      showErrorSnackkbar(
          message:
              'Error removing product from wishlist: ${apiResponse.message}');
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  ADD TO CART AND REMOVE FROM WISHLIST                                 ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  Future<void> addToCartAndRemoveFromWishlist(
      {required WishlistItem wishedProductItem}) async {
    try {
      final success = await marketplaceController.addToCartPost(
        productId: wishedProductItem.product?.id ?? '',
        productVariantId: wishedProductItem.productVariant?.id ?? '',
        storeId: wishedProductItem.store?.id ?? '',
        quantity: 1,
      );

      if (success) {
        await deleteWishlistProduct(
          productId: wishedProductItem.id ?? '',
        );
      } else {
        Get.snackbar('Error', 'Failed to add to cart');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to cart: ${e.toString()}');
    }
  }

  @override
  void onInit() {
    getWishlistProducts();
    super.onInit();
  }
}
