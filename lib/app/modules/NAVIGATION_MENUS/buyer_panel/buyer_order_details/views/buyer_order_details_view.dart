import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../config/constants/app_assets.dart';
import '../models/buyer_order_details_model.dart';
import '../controllers/buyer_order_details_controller.dart';
import 'buyer_order_activity_view.dart';
import '../widgets/review_bottomsheet.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../config/constants/color.dart';

class BuyerOrderDetailsView extends GetView<BuyerOrderDetailsController> {
  const BuyerOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBuyerOrderDetailsData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'.tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingBuyerDashboard.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.buyerOrderDetailsData.value?.storeList
                        ?.map((store) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.store?.name ?? 'Shop Name',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16.0),

                          // Display Product Cards for each product in the store
                          ...store.orderDetails?.map((product) {
                                controller.orderDetails.add(product);
                                store.subDetails?.status == 'delivered'
                                    ? controller.isDeliverd.value = true
                                    : controller.isDeliverd.value = false;
                                controller.orderSubDetailsId.value =
                                    store.subDetails?.id ?? '';
                                return ProductCard(
                                  orderId: product.orderId ?? '',
                                  productId: product.productId ?? '',
                                  status:
                                      store.subDetails?.status == 'delivered'
                                          ? true
                                          : false,
                                  productName:
                                      product.product?.productName ?? '',
                                  unitPrice:
                                      product.sellPrice?.toString() ?? '0.00',
                                  quantity: product.quantity?.toString() ?? '0',
                                  subTotal:
                                      (product.quantity! * product.sellPrice!)
                                          .toString(),
                                  imageUrl:
                                      (product.product?.media?.first ?? '')
                                          .formatedProductUrlLive,
                                );
                              }).toList() ??
                              [],
                          const SizedBox(height: 16.0),
                        ],
                      );
                    }).toList() ??
                    [],

                // Billing Address
                Text('Billing Address'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: BillingAddress(
                    address: controller.buyerOrderDetailsData.value?.address,
                    orderDate:
                        controller.buyerOrderDetailsData.value?.createdAt ?? '',
                  ),
                ),
                const SizedBox(height: 24.0),

                // Pricing Summary
                const PricingSummary(),
                const SizedBox(height: 24.0),

                // Return and Refund  Button
                // store.subDetails?.status == 'delivered'?
                controller.isDeliverd.value == true
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.BUYER_RETURN_REFUND_FORM,
                                arguments: {
                                  'orderId': controller.orderId,
                                  'storeId': controller.storeId,
                                  'orderSubDetailsId':
                                      controller.orderSubDetailsId.value,
                                  'orderDetails': controller.orderDetails
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('Return and Refund Request'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 24.0),

                // Order Activity
                Text('Order Activity'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                controller.orderTrackingDetails.value.data != null
                    ? OrderActivityList(
                        activities:
                            controller.orderTrackingDetails.value.data ?? [],
                      )
                    : Center(
                        child: Text('No Order Activity'.tr,
                          style: TextStyle(
                              color: PRIMARY_COLOR,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          );
        }
      }),
    );
  }
}

// Product Card Widget with dynamic data
class ProductCard extends StatelessWidget {
  final String productName;
  final String unitPrice;
  final String quantity;
  final String? attributes;
  final String subTotal;
  final String imageUrl;
  final bool? status;
  final String productId;
  final String orderId;

  const ProductCard(
      {super.key,
      required this.productName,
      required this.unitPrice,
      required this.quantity,
      this.attributes,
      required this.subTotal,
      required this.imageUrl,
      this.status,
      required this.productId,
      required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      AppAssets.DEFAULT_IMAGE,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Unit Price: \$$unitPrice'.tr),
                    Text('Quantity: $quantity'.tr),
                    // Text(attributes),
                    Text('Sub Total: \$$subTotal'.tr),
                    const SizedBox(height: 16.0),
                    status == true
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                showReviewBottomSheet(
                                    productId: productId, orderId: orderId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: PRIMARY_COLOR,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text('Submit Review'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Billing Address Widget with dynamic data
class BillingAddress extends StatelessWidget {
  final BuyersAddress? address;
  final String orderDate;

  const BillingAddress({super.key, this.address, required this.orderDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recipient Name: ${address?.recipientsName ?? 'No Name'}'),
          Text(
              'Address: ${address?.address ?? ''}, ${address?.city ?? ''}, ${address?.district ?? ''}'),
          Text(
              'Phone Number: ${address?.recipientsPhoneNumber ?? 'No Phone Number'}'),
          Text('Order Date: ${(orderDate.toFormatToReadableDate())}'.tr),
        ],
      ),
    );
  }
}

// Pricing Summary Widget
class PricingSummary extends StatelessWidget {
  const PricingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          buildSummaryRow('Total Product Price:', '\$3930'),
          buildSummaryRow('Total Shipping Charge:', '\$0.00'),
          buildSummaryRow('Total Discount:', '\$0.00'),
          buildSummaryRow('Total VAT:', '\$196.50'),
          const Divider(),
          buildSummaryRow('Total Payable:', '\$4126.50', isTotal: true),
        ],
      ),
    );
  }

  Widget buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
