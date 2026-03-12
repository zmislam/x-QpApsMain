import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/date_time_extension.dart';
import '../components/seller_drawer_items.dart';
import '../../../../config/constants/color.dart';
import '../../../../utils/custom_drawer.dart';
import '../controllers/seller_panel_dashboard_controller.dart';
import '../../../../utils/color_func.dart';

class SellerPaymentView extends GetView<SellerPanelDashboardController> {
  const SellerPaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchSellerPayments();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Text('Payments'.tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
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
                  color: Colors.black,
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
      body: Obx(
        () => controller.isLoadingPayments.value &&
                controller.paymentList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      // Balance Overview
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildBalanceCard(
                              title: 'Pending Balance'.tr,
                              amount: controller.pendingBalance.value,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _buildBalanceCard(
                              title: 'Paid Balance'.tr,
                              amount: controller.paidBalance.value,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Recent Orders Header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Recent Orders'.tr,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Order List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.paymentList.length,
                        itemBuilder: (context, index) {
                          final payment = controller.paymentList[index];
                          final orderDetails = payment.orderDetails;
                          final subDetails = orderDetails?.orderSubDetails;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Order ID:'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        // const SizedBox(width: 10,),
                                        Text(
                                          (payment.invoiceNumber
                                                  ?.toFormatInvoiceNumber() ??
                                              ''),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: PRIMARY_COLOR),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    _buildOrderDetailRow('Product Quantity:',
                                        '${orderDetails?.quantity ?? 0}'),
                                    _buildOrderDetailRow('Order Amount:',
                                        '\$${subDetails?.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
                                    _buildOrderDetailRow('Time Remaining:',
                                        'Disbursement completed'),
                                    _buildOrderDetailRow(
                                      'Order Status:',
                                      subDetails?.status ?? '',
                                      valueColor:
                                          getStatusColor(subDetails?.status),
                                    ),
                                    _buildOrderDetailRow(
                                      'Payment Status:',
                                      subDetails?.paymentStatus ?? '',
                                      valueColor: getStatusColor(
                                          subDetails?.paymentStatus),
                                    ),
                                    _buildOrderDetailRow(
                                      'Time & Date:',
                                      (payment.createdAt.toFormatDateAndTime()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildBalanceCard(
      {required String title, required double amount, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text('\$${amount.toStringAsFixed(2)}'.tr,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: valueColor ?? Colors.black),
          ),
        ],
      ),
    );
  }

// Define a function to get a color based on the status
}
