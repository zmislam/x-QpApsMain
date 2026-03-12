import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../extension/string/string_image_path.dart';
import '../../../../../../config/constants/app_assets.dart';
import '../../controllers/product_details_controller.dart';
import '../../../../../../config/constants/color.dart';

void showProductVariantBottomSheet() {
  final ProductDetailsController controller =
      Get.put(ProductDetailsController());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.productDetailsList.value.isNotEmpty) {
      var firstVariant =
          controller.productDetailsList.value.first.productVariant?.first;
      if (firstVariant != null) {
        for (var attribute in firstVariant.attribute ?? []) {
          if (attribute.name != null && attribute.value != null) {
            controller.selectedAttributes
                .putIfAbsent(attribute.name!, () => attribute.value!);
          }
        }

        if (firstVariant.color != null && firstVariant.color!.name != null) {
          controller.selectedAttributes['Color'] = firstVariant.color!.name!;
          controller.selectedColorId.value = firstVariant.colorId ?? '';
        }

        controller.fetchPriceBasedOnAttributes();
      }
    }
  });

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16.0),
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.75, // Set max height to 75% of screen height
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Obx(() {
          if (controller.productDetailsList.value.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, RxList<String>> groupedAttributes = {};
          RxList<Map<String, dynamic>> colorAttributes =
              <Map<String, dynamic>>[].obs;
          Set<String> uniqueColorNames = {};
          Set<String> uniqueColorHexes = {};

          for (var variant
              in controller.productDetailsList.value.first.productVariant ??
                  []) {
            for (var attribute in variant.attribute ?? []) {
              if (attribute.name != null && attribute.value != null) {
                groupedAttributes
                    .putIfAbsent(attribute.name!, () => <String>[].obs)
                    .addIf(
                        !groupedAttributes[attribute.name!]!
                            .contains(attribute.value!),
                        attribute.value!);
              }
            }

            if (variant.color?.name != null && variant.color?.value != null) {
              if (!uniqueColorNames.contains(variant.color!.name!) &&
                  !uniqueColorHexes.contains(variant.color!.value!)) {
                uniqueColorNames.add(variant.color!.name!);
                uniqueColorHexes.add(variant.color!.value!);
                colorAttributes.add({
                  'name': variant.color!.name!,
                  'colorHex': variant.color!.value!,
                  'id': variant.colorId ?? ''
                });
              }
            }
          }

          String selectedAttributesString = controller
              .selectedAttributes.entries
              .where((entry) => entry.key != 'Color')
              .map((entry) => '${entry.key.capitalizeFirst}: ${entry.value}')
              .join(', ');

          if (controller.selectedAttributes.containsKey('Color')) {
            selectedAttributesString +=
                ', Color: ${controller.selectedAttributes['Color']}';
          }

          // Calculate total price
          double totalPrice =
              controller.currentPrice.value * controller.productQuantity.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: PRIMARY_COLOR, width: 2.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        (controller
                                .productDetailsList.value.first.media?.first ??
                            '').formatedProductUrlLive,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 50);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('QP ${totalPrice.toStringAsFixed(2)}'.tr,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          selectedAttributesString.isNotEmpty
                              ? selectedAttributesString
                              : 'No Variant Selected',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Image.asset(
                        AppAssets.CLOSE_ICON,
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 1, color: Color(0x5C3C3C43)),
              const SizedBox(height: 16),

              ...groupedAttributes.entries.map((entry) {
                String attributeName = entry.key;
                RxList<String> attributeValues = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${attributeName.capitalize.toString().toUpperCase()} :'.tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: attributeValues.map((value) {
                        return ChoiceChip(
                          label: Text(
                            value,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller
                                          .selectedAttributes[attributeName] ==
                                      value
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                          selected:
                              controller.selectedAttributes[attributeName] ==
                                  value,
                          onSelected: (isSelected) {
                            if (isSelected) {
                              controller.selectedAttributes[attributeName] =
                                  value;
                              controller.fetchPriceBasedOnAttributes();
                            }
                          },
                          selectedColor: PRIMARY_COLOR,
                          // backgroundColor: Colors.white,
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
              if (colorAttributes.isNotEmpty) ...[
                Text('Color:'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: colorAttributes.map((color) {
                    bool isSelected =
                        controller.selectedAttributes['Color'] == color['name'];

                    return ChoiceChip(
                      avatar: CircleAvatar(
                        backgroundColor: Color(int.parse(
                            '0xFF${color['colorHex'].toString().replaceAll('#', '')}')),
                      ),
                      label: Text(
                        color['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Color(int.parse(
                                  '0xFF${color['colorHex'].toString().replaceAll('#', '')}'))
                              : Colors.grey,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (isSelected) {
                        if (isSelected) {
                          controller.selectedAttributes['Color'] =
                              color['name'];
                          controller.selectedColorId.value = color['id'];
                          controller.fetchPriceBasedOnAttributes();
                        }
                      },
                      checkmarkColor: Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? Color(int.parse(
                                '0xFF${color['colorHex'].toString().replaceAll('#', '')}'))
                            : Colors.grey,
                      ),
                      selectedColor:
                          isSelected ? Colors.transparent : PRIMARY_COLOR,
                      // backgroundColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              Text('Quanity:'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),

              // Quantity Counter
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: PRIMARY_COLOR),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.productQuantity.value > 1) {
                          controller.productQuantity.value--;
                        }
                      },
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: PRIMARY_COLOR,
                        child: Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('${controller.productQuantity.value}'.tr,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if (controller.productQuantity.value <
                            controller.stock.value) {
                          controller.productQuantity.value++;
                        }
                      },
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: PRIMARY_COLOR,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    if (controller.stock.value != 0) {
                      controller.marketPlaceController.addToCartPost(
                        productId: controller.productDetailsList.value.first.id,
                        storeId:
                            controller.productDetailsList.value.first.storeId,
                        productVariantId:
                            controller.selectedProductVariantId.value,
                        quantity: controller.productQuantity.value,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.stock.value != 0
                        ? PRIMARY_COLOR
                        : Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: controller.stock.value != 0
                            ? PRIMARY_COLOR
                            : Colors.deepOrange,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.stock.value != 0
                          ? Image.asset(
                              AppAssets.CART_NAVBAR_ICON,
                              height: 30,
                              width: 30,
                              color: Colors.white,
                            )
                          : const SizedBox(),
                      controller.stock.value != 0
                          ? const SizedBox(width: 10)
                          : const SizedBox(),
                      Text(
                        controller.stock.value != 0
                            ? 'Add to Cart'
                            : 'Out of Stock',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    ),
    isScrollControlled: true,
  );
}
