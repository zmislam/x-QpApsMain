import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/num.dart';
import '../../../../../components/shimmer_loaders/group_shimmer_loader.dart';
import '../../../../../config/constants/app_assets.dart';
import '../../../../../extension/date_time_extension.dart';
import '../models/store_products_model.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../config/constants/color.dart';
import '../controllers/store_products_controller.dart';
import '../widgets/store_details_main_view_widgets/store_product_image_section.dart';
import '../widgets/store_details_main_view_widgets/store_product_price_section.dart';
import '../widgets/store_details_main_view_widgets/store_product_rating.dart';

class StoreProductsView extends GetView<StoreProductsController> {
  const StoreProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getStoreBaseProduct(storeId: controller.pId.value);
    return SafeArea(
        child: Scaffold(
            // backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              // backgroundColor: Colors.white,
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
                    color: Colors.black,
                  )),
              title: Obx(
                () => Text(
                  controller.storeDetails.value?.name?.capitalizeFirst ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            body: Obx(() {
              if (controller.storeDetails.value == null) {
                return const Center(child: GroupShimmerLoader());
              } else {
                return SingleChildScrollView(
                  // physics: const ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Obx(() =>
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                controller.storeDetails.value?.products?.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: 400,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              StoreProductsDetails? storeProductsDetails =
                                  controller
                                      .storeDetails.value?.products?[index];

                              return InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.PRODUCT_DETAILS,
                                      arguments: storeProductsDetails?.id);
                                  // controller
                                  //     .getProductDetails(
                                  //         productId: storeProductsDetails?.id);
                                },
                                child: Container(
                                  height: Get.height,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color:
                                            Colors.grey.withValues(alpha: 0.5)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Product Image
                                        StoreProductImageSection(
                                          controller: controller,
                                          storeProductsDetails:
                                              storeProductsDetails,
                                        ),
                                        5.h,

                                        // Product Name
                                        Text(
                                          storeProductsDetails?.productName ??
                                              '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),

                                        // Rating and Reviews
                                        StoreProductRatingWidget(
                                            storeProductsDetails:
                                                storeProductsDetails),
                                        const SizedBox(height: 3),

                                        // Specifications
                                        SizedBox(
                                          height: 60,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      (storeProductsDetails
                                                              ?.specification
                                                              ?.length ??
                                                          0);
                                                  i++)
                                                if (i < 3)
                                                  Text('\u2022 ${storeProductsDetails?.specification![i].label}: ${storeProductsDetails?.specification![i].value}'.tr,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        // Pricing
                                        storeProductsDetails?.productVariants !=
                                                    null &&
                                                storeProductsDetails!
                                                    .productVariants!.isNotEmpty
                                            ? StoreProductPriceWidget(
                                                storeProductsDetails:
                                                    storeProductsDetails)
                                            : const SizedBox(height: 20),

                                        // Add to Cart Button
                                        const Spacer(),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: storeProductsDetails
                                                              ?.productVariants !=
                                                          null &&
                                                      storeProductsDetails
                                                              ?.totalStock !=
                                                          0
                                                  ? PRIMARY_COLOR
                                                  : Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (storeProductsDetails
                                                      ?.totalStock !=
                                                  0) {
                                                controller
                                                    .productDetailsController
                                                    .marketPlaceController
                                                    .addToCartPost(
                                                  productId:
                                                      storeProductsDetails?.id,
                                                  storeId: controller
                                                      .storeDetails.value?.id,
                                                  productVariantId:
                                                      storeProductsDetails
                                                          ?.productVariants
                                                          ?.first
                                                          .id,
                                                  quantity: 1,
                                                );
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                storeProductsDetails
                                                            ?.totalStock !=
                                                        0
                                                    ? Image.asset(
                                                        AppAssets
                                                            .CART_NAVBAR_ICON,
                                                        height: 20,
                                                        width: 20,
                                                        color: Colors.white,
                                                      )
                                                    : const SizedBox.shrink(),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  storeProductsDetails
                                                              ?.totalStock ==
                                                          0
                                                      ? 'Out of Stock'
                                                      : 'Add to Cart',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      // ),
                      // ),
                    ],
                  ),
                );
              }
            })));
  }

  String productUploadTimeText(String dateTime) {
    DateTime postDateTime = DateTime.parse(dateTime).toLocal();
    DateTime currentDatetime = DateTime.now();
    int millisecondsDifference = currentDatetime.millisecondsSinceEpoch -
        postDateTime.millisecondsSinceEpoch;
    int minutesDifference =
        (millisecondsDifference / Duration.millisecondsPerMinute).truncate();

    if (minutesDifference < 1) {
      return 'a few sec ago';
    } else if (minutesDifference < 30) {
      return '$minutesDifference minutes ago';
    } else if (DateUtils.isSameDay(postDateTime, currentDatetime)) {
      return 'Today at ${postTimeFormat.format(postDateTime)}';
    } else {
      return productDateTimeFormat.format(postDateTime);
    }
  }
}
