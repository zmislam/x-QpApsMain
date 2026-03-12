// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/buyer_panel/buyer_refund_and_return/controllers/buyer_return_refund_controller.dart';
// import 'package:quantum_possibilities_flutter/app/utils/color.dart';

// class BuyerReturnRefundFormView extends GetView<BuyerReturnRefundController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       appBar: AppBar(
//         // backgroundColor: Colors.white,
//         leading: IconButton(
//             onPressed: () => Get.back(),
//             icon: const Icon(
//               Icons.arrow_back_ios_new_outlined,
//               color: Colors.black,
//             )),
//         title: Text('Returns & Refund Request'.tr,
//             style: TextStyle(color: Colors.black)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Order Number',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             TextFormField(
//               controller: controller.orderNumberController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 // hintText: '5836494Hd8'.tr,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Return items',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             Obx(() => DropdownButtonFormField<String>(
//                   hint: Text('Select Multi Products'.tr),
//                   value: controller.selectedProducts.isNotEmpty
//                       ? controller.selectedProducts.last
//                       : null, // Set the initial value to the last selected product
//                   items: controller.orderDetails.value
//                       .map((product) => product.productId)
//                       .toSet() // Remove duplicates by converting to a set
//                       .map((productId) {
//                     final productName = controller.orderDetails
//                         .firstWhere((product) => product.productId == productId)
//                         .product
//                         ?.productName;
//                     return DropdownMenuItem<String>(
//                       value: productId,
//                       child: Text(
//                         productName ?? '',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: controller.onProductSelected,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 15),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 )),

//             const SizedBox(height: 16),

//             Obx(() => Wrap(
//                   spacing: 8,
//                   children: controller.selectedProducts
//                       .map((productId) => Chip(
//                             label: Text(
//                               controller.orderDetails
//                                       .firstWhere((product) =>
//                                           product.productId == productId)
//                                       .product
//                                       ?.productName ??
//                                   '',
//                             ),
//                             onDeleted: () =>
//                                 controller.removeSelectedProduct(productId),
//                           ))
//                       .toList(),
//                 )),
//             const SizedBox(height: 16),
//             Text(
//               'Name of Return Product',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             // Dynamically generated fields for each selected product
//             Obx(() => Column(
//                   children: List.generate(controller.selectedProducts.length,
//                       (index) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextFormField(
//                           controller: controller.productControllers[index],
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           readOnly:
//                               true, // Make it read-only if the name shouldn't be changed
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Product Return Quantity',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14),
//                         ),
//                         const SizedBox(height: 8),
//                         TextFormField(
//                           controller: controller.quantityControllers[index],
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             hintText: 'Quantity'.tr,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             int enteredQuantity = int.tryParse(value) ?? 0;
//                             int maxQuantity =
//                                 controller.initialQuantities[index];

//                             if (enteredQuantity > maxQuantity) {
//                               // Show validation message and reset to max quantity
//                               controller.quantityControllers[index].text =
//                                   maxQuantity.toString();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                       'Quantity cannot exceed the available amount of $maxQuantity.'),
//                                   duration: const Duration(seconds: 2),
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Reason for Return',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14),
//                         ),
//                         const SizedBox(height: 8),
//                         DropdownButtonFormField<String>(
//                           hint: Text('Select Reason'.tr),
//                           items: controller.reasons.map((reason) {
//                             return DropdownMenuItem<String>(
//                               value: reason,
//                               child: Text(reason),
//                             );
//                           }).toList(),
//                           onChanged: controller.onReasonSelected,
//                           decoration: InputDecoration(
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 15),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Details',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14),
//                         ),
//                         const SizedBox(height: 8),
//                         TextFormField(
//                           controller: controller.detailsController[index],
//                           maxLines: 5,
//                           decoration: InputDecoration(
//                             hintText:
//                                 'Describe why you want to return this product',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     );
//                   }),
//                 )),
//             // Dynamically generated fields for each selected product

//             Text(
//               'Product Photo/Video Upload',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Obx(() => GestureDetector(
//                   onTap: () {
//                     controller.pickImages();
//                   },
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: DottedBorder(
//                       borderType: BorderType.RRect,
//                       radius: const Radius.circular(8),
//                       padding: const EdgeInsets.all(16),
//                       dashPattern: const [10, 5],
//                       color: PRIMARY_COLOR,
//                       child: controller.selectedImages.isEmpty
//                           ? Center(
//                               child: Column(
//                                 children: [
//                                   Image.asset(
//                                     'assets/icon/group_profile/file_upload.png',
//                                     height: 50,
//                                     width: 50,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Upload Photo/video Here',
//                                     style: TextStyle(color: Colors.black54),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       controller.pickImages();
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: PRIMARY_COLOR,
//                                       foregroundColor: Colors.white,
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 20, vertical: 15),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       elevation: 5,
//                                     ),
//                                     child: Text(
//                                       'Browse files',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )
//                           : SizedBox(
//                               height:
//                                   100, // Set height for the horizontal image list
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: controller.selectedImages.length,
//                                 itemBuilder: (context, index) {
//                                   return Stack(
//                                     children: [
//                                       Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             horizontal: 8),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.file(
//                                             controller.selectedImages[index],
//                                             width: 100,
//                                             height: 100,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 4,
//                                         right: 10,
//                                         child: GestureDetector(
//                                           onTap: () =>
//                                               controller.removeImage(index),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.black54,
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: const Icon(
//                                               Icons.close,
//                                               color: Colors.white,
//                                               size: 20,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//                     ),
//                   ),
//                 )),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Obx(() => Checkbox(
//                       value: controller.isConfirmed.value,
//                       onChanged: (value) => controller.isConfirmed(value),
//                     )),
//                 const Expanded(
//                   child: Text(
//                     'I confirm that the product is eligible for return as per the return policy',
//                     style: TextStyle(color: Colors.black87),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed:
//                 // controller.isConfirmed.value
//                 //     ?
//                      () {
//                         // Gather refund details for each selected product

//                         for (int index = 0;
//                             index < controller.selectedProducts.length;
//                             index++) {
//                           String productId = controller.selectedProducts[index];
//                           final selectedProduct =
//                               controller.orderDetails.firstWhere(
//                             (product) => product.productId == productId,
//                           );

//                           controller.refundDetails.add({
//                             'product_id': selectedProduct.productId,
//                             'variant_id': selectedProduct.variantId ??
//                                 '', // Use correct field if variant_id is present
//                             'refund_quantity': int.tryParse(controller
//                                     .quantityControllers[index].text) ??
//                                 0,
//                             'sell_price': selectedProduct.sellPrice ?? 0.0,
//                             'refund_note':
//                                 controller.detailsController[index].text,
//                           });
//                         }

//                         // Call submitRefundRequest with gathered data
//                         controller.submitRefundRequestAPI(
//                           refundDescription: controller.refundDetails,
//                           imageFiles: controller.selectedImages,
//                         );
//                       }
//                     // : null,
//                     ,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'Submit Request',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/config/constants/color.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/buyer_panel/buyer_refund_and_return/controllers/buyer_return_refund_controller.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/buyer_panel/buyer_refund_and_return/models/refund_details.dart';
// import 'package:flutter_multiselect/flutter_multiselect.dart';

class BuyerReturnRefundFormView extends GetView<BuyerReturnRefundController> {
  const BuyerReturnRefundFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
        title: Text('Returns & Refund Request'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Number'.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.orderNumberController,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Return items'.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Obx(() => DropdownButtonFormField<String>(
                  hint: Text(
                    controller.selectedProducts.isNotEmpty
                        ? '${controller.selectedProducts.length} item(s) selected'
                        : 'Select Multi Products',
                  ),
                  // Set value to null so it doesn't show the last selected item
                  value: null,
                  items: controller.orderDetails.value
                      .map((product) => product.productId)
                      .toSet()
                      .map((productId) {
                    final productName = controller.orderDetails.value
                        .firstWhere((product) => product.productId == productId)
                        .product
                        ?.productName;
                    return DropdownMenuItem<String>(
                      value: productId,
                      child: SizedBox(
                        width: 300, // Set a max width for the text
                        child: FittedBox(
                          fit: BoxFit.fitWidth, // Scale text down to fit
                          child: Text(
                            productName ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (selectedProductId) {
                    if (selectedProductId != null) {
                      controller.onProductSelected(selectedProductId);
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),

            const SizedBox(height: 16),

            Obx(() => Wrap(
                  spacing: 8,
                  children: controller.selectedProducts
                      .map((productId) => Chip(
                            label: Text(
                              controller.orderDetails.value
                                      .firstWhere((product) =>
                                          product.productId == productId)
                                      .product
                                      ?.productName ??
                                  '',
                              style: TextStyle(color: PRIMARY_COLOR),
                            ),
                            backgroundColor: Theme.of(context).cardTheme.color,
                            padding: const EdgeInsets.all(0),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () =>
                                controller.removeSelectedProduct(productId),
                            side: BorderSide.none,
                          ))
                      .toList(),
                )),
            const SizedBox(height: 16),
            Text('Name of Return Product'.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            // Dynamically generated fields for each selected product
            Obx(() => Column(
                  children: List.generate(controller.selectedProducts.length,
                      (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller.productControllers[index],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        Text('Product Return Quantity'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.quantityControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Quantity'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            int enteredQuantity = int.tryParse(value) ?? 0;
                            int maxQuantity =
                                controller.initialQuantities[index];

                            if (enteredQuantity > maxQuantity) {
                              controller.quantityControllers[index].text =
                                  maxQuantity.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Quantity cannot exceed the available amount of $maxQuantity.'.tr),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Text('Details'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.detailsController[index],
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Describe why you want to return this product'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                )),
            Text('Product Photo/Video Upload'.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
                  onTap: () {
                    controller.pickImages();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: DottedBorder(
                      options: RectDottedBorderOptions(
                        color: PRIMARY_COLOR,
                        strokeWidth: 2,
                        dashPattern: const [8, 4],
                      ),
                      child: controller.selectedImages.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/icon/group_profile/file_upload.png',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Upload Photo/video Here'.tr,
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.pickImages();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: PRIMARY_COLOR,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: Text('Browse files'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            controller.selectedImages[index],
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () =>
                                              controller.removeImage(index),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Row(
              children: [
                Obx(() => Checkbox(
                      value: controller.isConfirmed.value,
                      onChanged: (value) =>
                          controller.isConfirmed.value = value ?? false,
                      checkColor: Colors.white,
                      fillColor: const WidgetStatePropertyAll(PRIMARY_COLOR),
                    )),
                Expanded(
                  child: Text('I confirm that the product is eligible for return as per the return policy'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isConfirmed.value
                        ? () {
                            List<RefundDetails> refundDetailsList = [];

                            for (int index = 0;
                                index < controller.selectedProducts.length;
                                index++) {
                              String productId =
                                  controller.selectedProducts[index];
                              final selectedProduct =
                                  controller.orderDetails.value.firstWhere(
                                (product) => product.productId == productId,
                              );

                              refundDetailsList.add(
                                RefundDetails(
                                  productId: selectedProduct.productId,
                                  variantId: selectedProduct.variantId,
                                  refundQuantity: int.tryParse(controller
                                          .quantityControllers[index].text) ??
                                      0,
                                  sellPrice: selectedProduct.sellPrice ?? 0.0,
                                  refundNote:
                                      controller.detailsController[index].text,
                                ),
                              );
                            }

                            controller.submitRefundRequestAPI(
                              refundDetailsList: refundDetailsList,
                              imageFiles: controller.selectedImages,
                            );
                          }
                        : null, // Disable button when checkbox is unchecked
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Submit Request'.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
