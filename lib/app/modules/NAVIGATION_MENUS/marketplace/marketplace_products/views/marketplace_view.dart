import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../controllers/marketplace_controller.dart';
import '../models/all_product_model.dart';
import '../widgets/custom_search_for_marketplace.dart';
import '../widgets/filter_product_drawer_menu.dart';
import '../widgets/homepage_sections.dart';
import '../widgets/marketplace_app_bar.dart';
import '../widgets/product_grid_item.dart';

class MarketplaceView extends GetView<MarketplaceController> {
  const MarketplaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: MarketplaceAppBar(
        controller: controller,
      ),
      endDrawer: MarketplaceFilterDrawer(
        controller: controller,
        scaffoldKey: scaffoldKey,
      ),
      body: Column(
        children: [
          // ─── Search + Filter Row ─────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomSearchField(
                    showSuggestions: controller.showSuggestedProduct.value = true,
                    controller: controller,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.filter_list, color: Colors.grey, size: 20),
                        const SizedBox(width: 4),
                        Text('Filter'.tr, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Suggestions Overlay ─────────────────────────
          Obx(() {
            if (controller.isLoadingSuggestions.value && controller.searchController.text.isNotEmpty) {
              return Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
              );
            }
            if (controller.suggestedProductList.value.isNotEmpty &&
                controller.searchController.text.isNotEmpty) {
              return Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
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
                      final product = controller.suggestedProductList.value[index];
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                            title: Text(
                              product.productName ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              controller.searchController.text = product.productName ?? '';
                              controller.getMarketPlaceProduct();
                              controller.suggestedProductList.value.clear();
                            },
                          ),
                          Divider(color: Colors.grey.shade300, thickness: 1, height: 0),
                        ],
                      );
                    },
                  ),
                );
            }
            return const SizedBox.shrink();
          }),

          // ─── Category Chips ──────────────────────────────
          const SizedBox(height: 8),
          CategoryChipsSection(controller: controller),
          const SizedBox(height: 8),

          // ─── Scrollable Content ──────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoadingMarketplaceProduct.value &&
                  controller.productList.value.isEmpty &&
                  controller.isLoadingHomepage.value) {
                return const Center(child: GroupShimmerLoader());
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.searchController.text = '';
                  await Future.wait([
                    controller.getMarketPlaceProduct(forceRecallApi: true),
                    controller.loadHomepageSections(),
                  ]);
                },
                child: CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    // ─── New For You Carousel ────────────
                    SliverToBoxAdapter(
                      child: Obx(() {
                        final products = controller.newForYouList.toList();
                        return ProductCarouselSection(
                          title: 'New For You'.tr,
                          icon: '✨',
                          products: products,
                          controller: controller,
                        );
                      }),
                    ),

                    // ─── Flash Deals ─────────────────────
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (controller.flashDealsList.isEmpty) return const SizedBox.shrink();
                        // Convert flash deals to product cards
                        final dealProducts = controller.flashDealsList
                            .where((d) => d is Map)
                            .map((d) {
                              try {
                                return AllProducts.fromMap(d as Map<String, dynamic>);
                              } catch (_) {
                                return null;
                              }
                            })
                            .whereType<AllProducts>()
                            .toList();
                        return ProductCarouselSection(
                          title: 'Flash Deals'.tr,
                          icon: '⚡',
                          products: dealProducts,
                          controller: controller,
                        );
                      }),
                    ),

                    // ─── Featured Stores ─────────────────
                    SliverToBoxAdapter(
                      child: Obx(() {
                        final stores = controller.featuredStoresList.toList();
                        return FeaturedStoresSection(stores: stores);
                      }),
                    ),

                    // ─── Sponsored Products ──────────────
                    SliverToBoxAdapter(
                      child: Obx(() {
                        final products = controller.sponsoredProductList.toList();
                        return SponsoredCarouselSection(
                          products: products,
                          controller: controller,
                        );
                      }),
                    ),

                    // ─── Recently Visited ────────────────
                    SliverToBoxAdapter(
                      child: Obx(() {
                        final items = controller.recentlyVisitedList.toList();
                        return RecentlyVisitedSection(
                          items: items,
                          controller: controller,
                        );
                      }),
                    ),

                    // ─── Featured Products Header ────────
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (controller.featuredProductList.isEmpty && controller.productList.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SectionHeader(title: 'Today\'s Picks'.tr, icon: '📦'),
                        );
                      }),
                    ),

                    // ─── Product Grid (Today's Picks / All Products) ────
                    Obx(() {
                      final products = controller.productList.value;
                      if (products.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text('No product found!'.tr),
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 370,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == products.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                              }
                              final productItem = products[index];
                              return ProductGridItem(
                                onPressedAddToWishList: () {
                                  controller.addToWishlist(
                                    productId: '${productItem.id}',
                                    storeId: '${productItem.storeId}',
                                    productVariantId: '${productItem.productVariant?.first.id}',
                                  );
                                },
                                isWishListed: productItem.wishProduct ?? false,
                                productItem: productItem,
                                onPressedAddToCart: () {
                                  controller.addToCartPost(
                                    productId: productItem.id,
                                    storeId: productItem.storeId,
                                    productVariantId: productItem.productVariant?.first.id,
                                    quantity: 1,
                                  );
                                },
                              );
                            },
                            childCount: products.length + (controller.isLoadingMore.value ? 1 : 0),
                          ),
                        ),
                      );
                    }),

                    // Bottom spacing
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
