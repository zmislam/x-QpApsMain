import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/num.dart';
import '../controllers/marketplace_wishlist_controller.dart';
import '../components/wishlist_item_footer.dart';
import '../components/wishlist_item_tile.dart';
import '../models/wishlist_model.dart';

class MarketplaceWishlistView extends GetView<MarketplaceWishlistController> {
  const MarketplaceWishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getWishlistProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingWishlist.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.wishedProductList.value.isEmpty) {
          return  Center(child: Text('No products in wishlist'.tr));
        } else {
          return ListView.builder(
            itemCount: controller.wishedProductList.value.length,
            itemBuilder: (context, index) {
              WishlistItem wishedProductItem =
                  controller.wishedProductList.value[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    WishlistItemTile(wishedProductItem: wishedProductItem),
                    WishlistItemFooter(
                      wishedProductItem: wishedProductItem,
                      onDelete: () {
                        controller.deleteWishlistProduct(
                          productId: wishedProductItem.id ?? '',
                        );
                      },
                      onAddToCart:
                          wishedProductItem.productVariant?.stockStatus ==
                                  'In Stock' &&
                              wishedProductItem.isInCart == false
                              ? () async {
                                  controller.addToCartAndRemoveFromWishlist(
                                    wishedProductItem: wishedProductItem,
                                  );
                                }
                              : () {},
                    ),
                    20.h,
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
