import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/num.dart';
import '../widgets/product_details_main_view_widgets/add_to_cart_button.dart';
import '../widgets/product_details_main_view_widgets/product_images_section.dart';
import '../widgets/product_details_main_view_widgets/product_rating_widget.dart';
import '../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../models/related_product_model.dart';
import '../widgets/product_details_main_view_widgets/product_header_section.dart';
import '../widgets/product_details_main_view_widgets/store_info_widget.dart';
import '../widgets/product_details_main_view_widgets/variant_select_button.dart';
import '../widgets/product_details_tab_view.dart';
import '../controllers/product_details_controller.dart';
import '../widgets/product_details_main_view_widgets/related_products_item.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initializeApiCalling();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.grey,
            thickness: 2,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        title: Text('Product Details'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(
        () {
          if (controller.productDetailsList.value.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImagesSection(controller: controller),

                  10.h,
                  // ============================================================== Product Name ==============================================================
                  ProductHeaderInfo(
                    controller: controller,
                  ),
                  5.h,
                  // ==============================================================  Rating ==============================================================
                  ProductRatingWidget(controller: controller),

                  5.h,
                  // ==============================================================  Product Store Name ==============================================================
                  StoreInfoRow(controller: controller),
                  5.h,

                  // ==============================================================  Product Variant Name ==============================================================
                  ((controller.productDetailsList.value.first.productVariant?.isNotEmpty ??
                                  false) &&
                              controller.productDetailsList.value.first.productVariant
                                      ?.first.attribute !=
                                  null &&
                              controller.productDetailsList.value.first
                                  .productVariant!.first.attribute!.isNotEmpty) ||
                          ((controller.productDetailsList.value.first
                                      .productVariant?.isNotEmpty ??
                                  false) &&
                              controller.productDetailsList.value.first
                                      .productVariant!.first.color?.value !=
                                  null &&
                              controller
                                  .productDetailsList
                                  .value
                                  .first
                                  .productVariant!
                                  .first
                                  .color!
                                  .value!
                                  .isNotEmpty)
                      ? VariantSelectionButton(
                          controller: controller,
                        )
                      : const SizedBox.shrink(),

                  // ==============================================================  Add to Cart Button ==============================================================
                  AddToCartButton(controller: controller),

                  5.h,
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Divider(
                      height: 1.0,
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // ==============================================================  Product Details Tab ==============================================================
                  SizedBox(
                    height: 320,
                    child: ProductDetailsTabView(
                      controller: controller,
                    ),
                  ),

                  // ============================================================== Related Product ==============================================================

                  Obx(
                    () => controller.relatedProductList.value.isEmpty
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0, top: 20),
                              child: Text('Related Products'.tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            )),
                  ),
                  10.h,
                  Obx(
                    () => (controller.isLoadingRelatedProduct.value == true)
                        ? const Center(child: GroupShimmerLoader())
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  controller.relatedProductList.value.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 400,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                AllRelatedProducts relatedProduct =
                                    controller.relatedProductList.value[index];

                                return RelatedProductComponent(
                                  controller: controller,
                                  relatedProduct: relatedProduct,
                                );
                              },
                            ),
                          ),
                  ),
                  // // ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
