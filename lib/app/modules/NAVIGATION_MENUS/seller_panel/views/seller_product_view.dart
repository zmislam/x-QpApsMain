import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../config/constants/app_assets.dart';
import '../../marketplace/marketplace_products/models/all_product_model.dart';
import '../components/seller_drawer_items.dart';
import '../../../../utils/custom_drawer.dart';
import '../controllers/seller_panel_dashboard_controller.dart';

class SellerProductView extends GetView<SellerPanelDashboardController> {
  const SellerProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchSellerProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Products List'.tr,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: const Icon(
                  Icons.menu,
                ),
              ),
            );
          })
        ],
      ),
      endDrawer: CustomDrawer(
        title: 'Seller Dashboard Menu'.tr,
        drawerItems: sellerDrawerItems,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Products List'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showFilterProductBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  icon: const Icon(Icons.tune, size: 16),
                  label: Text('Filters'.tr,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                if (value.isEmpty) {
                  controller.fetchSellerProducts(status: '');
                } else {
                  controller.fetchSellerProducts(status: '', keyword: value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search product...'.tr,
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Product List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingSellerDashboard.value &&
                  controller.productList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.productList.isEmpty) {
                return Center(
                  child: Text('No Products Found'.tr,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollControllerProduct,
                itemCount: controller.productList.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.productList.length) {
                    return controller.isLoadingSellerDashboard.value
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }

                  final product = controller.productList[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(AllProducts product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Info Row
              Row(
                children: [
                  Image.network(
                    (product.media?.first ?? '').formatedProductUrlLive,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        AppAssets.DEFAULT_IMAGE,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      product.productName ?? 'N/A',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        // Handle more options
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Image

                  const SizedBox(width: 10),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('SKU:'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              product.productVariant?.first.sku ?? 'N/A',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quanity:'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              product.totalStock.toString(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category:'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                product.categoryName ?? 'N/A',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Base Price:'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '  \$${product.productVariant?.first.mainPrice?.toStringAsFixed(2) ?? 'N/A'}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Selling Price:'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '  \$${product.productVariant?.first.sellPrice?.toStringAsFixed(2) ?? 'N/A'}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Product Status:'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              product.status?.capitalizeFirst ?? 'Published',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Boosted:'.tr,
                              style: Theme.of(Get.context!)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' ${product.totalStock != null && product.totalStock! > 0 ? 'Yes' : 'No'}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // More Options
                ],
              ),
              // Pricing Info
            ],
          ),
        ),
      ),
    );
  }

  void showFilterProductBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                // leading: const Icon(Icons.clear_all),
                title: Text('All Product'.tr),
                onTap: () {
                  _applyFilter('');
                  Get.back();
                },
              ),
              ListTile(
                // leading: const Icon(Icons.pending),
                title: Text('Published'.tr),
                onTap: () {
                  _applyFilter('published');
                  Get.back();
                },
              ),
              ListTile(
                // leading: const Icon(Icons.check_circle),
                title: Text('Draft'.tr),
                onTap: () {
                  _applyFilter('draft');
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(String status) {
    controller.fetchSellerProducts(status: status);
  }
}
