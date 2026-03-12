import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/marketplace_controller.dart';

import '../../../../../components/button.dart';
import '../../../../../config/constants/color.dart';
import 'custom_search_for_marketplace.dart';

class MarketplaceFilterDrawer extends StatelessWidget {
  final MarketplaceController controller;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MarketplaceFilterDrawer({
    Key? key,
    required this.controller,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text('Marketplace'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                //===========================================Reset Button=================================//
                PrimaryButton(
                  verticalPadding: 1,
                  horizontalPadding: 3,
                  fontSize: 12,
                  onPressed: () {
                    controller.searchController.clear();
                    controller.suggestedProductList.value.clear();
                    controller.categorySearchController.clear();
                    controller.brandSearchController.clear();
                    controller.minPriceController.clear();
                    controller.maxPriceController.clear();
                    controller.condition.value = 'Any';
                    controller.sellerType.value = 'Any';
                    controller.rating.value = 5;
                    // Call getMarketPlaceProduct() without filters
                    controller.getMarketPlaceProduct();
                  },
                  text: 'Reset'.tr,
                ),
              ],
            ),
            const SizedBox(height: 10),
            //=========================================Only Search Section===================================//
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: Container(
            //     height: 45,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.grey.withValues(alpha:0.3)),
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //     child: TextFormField(
            //       key: const Key('searchField'),
            //       controller: controller.searchController,
            //       decoration: const InputDecoration(
            //         contentPadding: EdgeInsets.symmetric(vertical: 3),
            //         hintText: 'Search'.tr,
            //         prefixIcon: Icon(Icons.search, color: Colors.grey),
            //         border: InputBorder.none,
            //       ),
            //                 onChanged: (searchTextValue) {
            //             controller.debounce(() {
            //               if (searchTextValue.isNotEmpty) {
            //                 // Call suggestions API
            //                 controller.getMarketPlaceProduct();
            //               } else {
            //                 // Clear suggestions when search is empty
            //                 controller.suggestedProductList.value.clear();
            //                 controller.getMarketPlaceProduct();
            //               }

            //               // // Existing product search logic
            //               // if (searchTextValue.length > 1) {
            //               //   controller.getMarketPlaceProduct();
            //               // } else if (searchTextValue.isEmpty) {
            //               //   controller.getMarketPlaceProduct();
            //               // }
            //             });
            //           },
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: CustomSearchField(
                  showSuggestions: controller.showSuggestedProduct.value =
                      false,
                  controller: controller,
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            //=========================================Category Search Section===================================//

             Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('Category Search'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: controller.categorySearchController,
                  decoration: InputDecoration(
                      hintText: 'Category Search'.tr,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 3)),
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            //=========================================Brand Search Section===================================//

             Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('Brand Search'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: controller.brandSearchController,
                  decoration:  InputDecoration(
                      hintText: 'Search Brands'.tr,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 3)),
                ),
              ),
            ),
            // Price Range Section
            ExpansionTile(
              title: Text('Price range'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              initiallyExpanded: false,
              children: [
                Obx(
                  () => Column(
                    children: [
                      RangeSlider(
                        values: controller.currentRangeValues.value,
                        min: 0,
                        max: controller.maxPrice.value.toDouble(),
                        divisions: 1000,
                        inactiveColor: COLOR_PEST,
                        activeColor: PRIMARY_COLOR,
                        onChanged: (RangeValues values) {
                          controller.currentRangeValues.value = values;
                          controller.minPriceController.text =
                              values.start.toInt().toString();
                          controller.maxPriceController.text =
                              values.end.toInt().toString();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Min'.tr,
                                    style: TextStyle(fontSize: 16)),
                                TextFormField(
                                  controller: controller.minPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                              .withValues(alpha: 0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: PRIMARY_COLOR),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 5),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    final startValue =
                                        double.tryParse(value) ?? 0;
                                    final endValue =
                                        controller.currentRangeValues.value.end;
                                    if (startValue <= endValue) {
                                      controller.currentRangeValues.value =
                                          RangeValues(startValue, endValue);
                                    } else {
                                      controller.minPriceController.text =
                                          endValue.toString();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Max'.tr,
                                    style: TextStyle(fontSize: 16)),
                                TextFormField(
                                  controller: controller.maxPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                              .withValues(alpha: 0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: PRIMARY_COLOR),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 5),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    final endValue = double.tryParse(value) ??
                                        controller.maxPrice.value.toDouble();
                                    final startValue = controller
                                        .currentRangeValues.value.start;
                                    if (startValue <= endValue) {
                                      controller.currentRangeValues.value =
                                          RangeValues(startValue, endValue);
                                    } else {
                                      controller.maxPriceController.text =
                                          startValue.toString();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.getMarketPlaceProduct();
                              scaffoldKey.currentState!.closeEndDrawer();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Apply'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
            // =============================================================Seller Type Section=========================================//
            Obx(() => ExpansionTile(
                  title: Text('Seller Type'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  initiallyExpanded: false,
                  children: [
                    RadioListTile<String>(
                      value: 'Any',
                      groupValue: controller.sellerType.value,
                      onChanged: (value) {
                        controller.sellerType.value = value!;
                        controller.getMarketPlaceProduct();
                      },
                      title: Text('Any'.tr),
                      activeColor: PRIMARY_COLOR,
                    ),
                    RadioListTile<String>(
                      value: 'Verified Sellers',
                      groupValue: controller.sellerType.value,
                      onChanged: (value) {
                        controller.sellerType.value = value!;
                        controller.getMarketPlaceProduct();
                      },
                      title: Text('Verified Sellers'.tr),
                      activeColor: PRIMARY_COLOR,
                    ),
                    RadioListTile<String>(
                      value: 'Basic Sellers',
                      groupValue: controller.sellerType.value,
                      onChanged: (value) {
                        controller.sellerType.value = value!;
                        controller.getMarketPlaceProduct();
                      },
                      title: Text('Basic Sellers'.tr),
                      activeColor: PRIMARY_COLOR,
                    ),
                  ],
                )),
            // =============================================================Availability Type Section=========================================//
            Obx(() => ExpansionTile(
                  title: Text('Availability'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  initiallyExpanded: false,
                  children: [
                    RadioListTile<String>(
                      value: 'Any',
                      groupValue: controller.productAvailability.value,
                      onChanged: (value) {
                        controller.productAvailability.value = value!;
                        controller.getMarketPlaceProduct();
                      },
                      title: Text('Any'.tr),
                      activeColor: PRIMARY_COLOR,
                    ),
                    RadioListTile<String>(
                      value: 'In Stock',
                      groupValue: controller.productAvailability.value,
                      onChanged: (value) {
                        controller.productAvailability.value = value!;
                        controller.getMarketPlaceProduct();
                      },
                      title: Text('In Stock'.tr),
                      activeColor: PRIMARY_COLOR,
                    ),
                  ],
                )),
            // Condition Section
            Obx(() => ExpansionTile(
                  title: Text('Condition'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  initiallyExpanded: false,
                  children: [
                    RadioListTile<String>(
                      value: 'Any',
                      groupValue: controller.condition.value,
                      onChanged: (value) {
                        controller.condition.value = value!;
                        controller.getMarketPlaceProduct();
                      },
                      title: Text('Any'.tr),
                      activeColor: PRIMARY_COLOR,
                    ),
                    RadioListTile<String>(
                      value: 'Brand New',
                      groupValue: controller.condition.value,
                      onChanged: (value) {
                        controller.condition.value = value!;
                        controller.getMarketPlaceProduct();
                      },
                      title: Text('Brand New'.tr),
                      activeColor: PRIMARY_COLOR,
                    ),
                    RadioListTile<String>(
                      value: 'Used Items',
                      groupValue: controller.condition.value,
                      onChanged: (value) {
                        controller.condition.value = value!;
                        controller.getMarketPlaceProduct();
                      },
                      title: Text('Used Items'.tr),
                      activeColor: PRIMARY_COLOR,
                    ),
                  ],
                )),
            // Review Section
            Obx(
              () => ExpansionTile(
                title: Text('Review'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                initiallyExpanded: false,
                children: List.generate(5, (index) {
                  int rating = 5 - index;
                  return RadioListTile<int>(
                    activeColor: PRIMARY_COLOR,
                    value: rating,
                    groupValue: controller.rating.value,
                    onChanged: (int? value) {
                      controller.rating.value = value!;
                      controller.getMarketPlaceProduct();
                    },
                    title: Row(
                      children: List.generate(
                        rating,
                        (starIndex) => const Icon(Icons.star,
                            color: Colors.orange, size: 20),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
