import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../controllers/marketplace_controller.dart';
import '../models/all_product_model.dart';
import '../widgets/custom_search_for_marketplace.dart';
import '../widgets/filter_product_drawer_menu.dart';
import '../widgets/product_grid_item.dart';

class MarketplaceView extends GetView<MarketplaceController> {
  const MarketplaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      // ======================= end drawer section ============================
      endDrawer: MarketplaceFilterDrawer(
        controller: controller,
        scaffoldKey: scaffoldKey,
      ),
      // ======================= body section ==================================
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 5.0,
              ),
              // ======================= search bar section =========================
              Expanded(
                flex: 2,
                child: CustomSearchField(
                  showSuggestions: controller.showSuggestedProduct.value = true,
                  controller: controller,
                ),
                //  TextFormField(
                //   controller: controller.searchController,
                //   decoration: InputDecoration(
                //     suffixIcon: IconButton(
                //             icon: const Icon(Icons.clear),
                //             onPressed: () {
                //               controller.searchController.clear();
                //               controller.getMarketPlaceProduct();
                //               controller.suggestedProductList.value.clear();
                //             },
                //           ),

                //     focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10.0),
                //         borderSide: const BorderSide(color: PRIMARY_COLOR)),
                //     enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10.0),
                //         borderSide: BorderSide(
                //             color: Colors.grey.withValues(alpha:0.3))),
                //     contentPadding: const EdgeInsets.symmetric(vertical: 2),
                //     hintText: 'Search on marketplace'.tr,
                //     prefixIcon: const Padding(
                //       padding: EdgeInsets.only(left: 8.0),
                //       child: Icon(
                //         Icons.search,
                //         color: Colors.grey,
                //       ),
                //     ),
                //     border: InputBorder.none,
                //   ),
                //   onChanged: (searchTextValue) {
                //     controller.debounce(() {
                //       if (searchTextValue.isNotEmpty) {
                //         // Call suggestions API
                //         controller.getSuggestedProducts();
                //       } else {
                //         // Clear suggestions when search is empty
                //         controller.suggestedProductList.value.clear();
                //         controller.getMarketPlaceProduct();
                //       }

                //       // // Existing product search logic
                //       // if (searchTextValue.length > 1) {
                //       //   controller.getMarketPlaceProduct();
                //       // } else if (searchTextValue.isEmpty) {
                //       //   controller.getMarketPlaceProduct();
                //       // }
                //     });
                //   },
                //   onFieldSubmitted: (value) {
                //     controller.getMarketPlaceProduct();
                //   },
                // ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Container(
                    height: 48,
                    width: 20,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Filter'.tr,
                            style: TextStyle(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
            ],
          ),
          // Suggestions List
          Obx(() => (controller.suggestedProductList.value.isNotEmpty &&
                  controller.searchController.text.isNotEmpty)
              ? Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10), // Adjust height as needed
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.suggestedProductList.value.length,
                    itemBuilder: (context, index) {
                      final product =
                          controller.suggestedProductList.value[index];
                      return Column(
                        children: [
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            style: ListTileStyle.list,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            title: Text(
                              product.productName ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              // When suggestion is tapped
                              controller.searchController.text =
                                  product.productName ?? '';
                              controller.getMarketPlaceProduct();
                              controller.suggestedProductList.value.clear();
                            },
                          ),
                          Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                            height: 0,
                          ),
                        ],
                      );
                    },
                  ),
                )
              : const SizedBox.shrink()),
          const SizedBox(height: 15),
          //* ================================================================= Product Gridview =================================================================
          Expanded(
            child: Obx(
              () => (controller.isLoadingMarketplaceProduct.value == true)
                  ? const Center(child: GroupShimmerLoader())
                  : controller.productList.value.isEmpty
                      ? Center(
                          child: Text('No product found !'.tr),
                        )
                      : Obx(
                          () => RefreshIndicator(
                            onRefresh: () async {
                              await controller.getMarketPlaceProduct(
                                  forceRecallApi: true);
                              controller.searchController.text = '';
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: GridView.builder(
                                  controller: controller.scrollController,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 370,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          crossAxisCount: 2),
                                  itemCount: controller
                                          .productList.value.length +
                                      (controller.isLoadingMore.value ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        controller.productList.value.length) {
                                      return const Center(
                                          child: GroupShimmerLoader());
                                    }
                                    AllProducts productItem =
                                        controller.productList.value[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: ProductGridItem(
                                        onPressedAddToWishList: () {
                                          controller.addToWishlist(
                                              productId: '${productItem.id}',
                                              storeId: '${productItem.storeId}',
                                              productVariantId:
                                                  '${productItem.productVariant?.first.id}');
                                        },
                                        isWishListed:
                                            productItem.wishProduct ?? false,
                                        productItem: productItem,
                                        onPressedAddToCart: () {
                                          controller.addToCartPost(
                                            productId: productItem.id,
                                            storeId: productItem.storeId,
                                            productVariantId: productItem
                                                .productVariant?.first.id,
                                            quantity: 1,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  // ),
                                  ),
                            ),
                          ),
                        ),
            ),
          )
        ],
      ),
    );
  }
}
