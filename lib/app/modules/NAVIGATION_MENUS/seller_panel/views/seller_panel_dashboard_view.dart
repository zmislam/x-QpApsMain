import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/constants/color.dart';
import '../../../../extension/date_time_extension.dart';
import '../../../../config/constants/app_assets.dart';
import '../../buyer_panel/buyer_dashboard/components/order_card_widgets.dart';
import '../components/seller_drawer_items.dart';
import '../../../../utils/custom_drawer.dart';
import '../components/seller_order_card_widgets.dart';
import '../controllers/seller_panel_dashboard_controller.dart';
import '../../../../utils/color_func.dart';

class SellerPanelDashboardView extends GetView<SellerPanelDashboardController> {
  const SellerPanelDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getSellerDashboardData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Dashboard'.tr,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Obx(
                () => controller.sellerOrderData.value != null
                    ? GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          buildStatCard(
                              context,
                              'Total Order',
                              '${controller.sellerOrderData.value?.totalOrders ?? 0}',
                              AppAssets.PENDING_ORDER_ICON),
                          buildStatCard(
                            context,
                            'Pending Order',
                            '${controller.sellerOrderData.value?.pendingCount ?? 0}',
                            AppAssets.ESCROW_ORDER_ICON,
                          ),
                          buildStatCard(
                            context,
                            'Processing Order',
                            '${controller.sellerOrderData.value?.processingCount ?? 0}',
                            AppAssets.COMPLETE_ORDER_ICON,
                          ),
                          buildStatCard(
                              context,
                              'Deleivered Order',
                              '${controller.sellerOrderData.value?.deliveredCount ?? 0}',
                              AppAssets.PAID_ORDER_ICON),
                          buildStatCard(
                              context,
                              'Refund Order',
                              '${controller.sellerOrderData.value?.refundCount ?? 0}',
                              AppAssets.REFUND_ORDER_ICON),
                          buildStatCard(
                              context,
                              'Canceled Order',
                              '${controller.sellerOrderData.value?.cancelOrder ?? 0}',
                              AppAssets.TOTAL_ORDER_ICON),
                        ],
                      )
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text('No Order Data Available'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Text('Recent Orders'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => controller.sellerOrderList.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: controller.sellerOrderList.value
                              .map((sellerOrderResult) {
                                String orderDate = (
                                    sellerOrderResult.createdAt?.toFormatDateAndTime()??'');

                                var statusProperties = getStatusProperties(
                                    sellerOrderResult.orderSubDetails?.status);

                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: buildSellerOrderCard(
                                        context: context,
                                        orderId: (
                                            sellerOrderResult.invoiceNumber.toFormatInvoiceNumber()),
                                        productName: sellerOrderResult
                                                .orderDetails
                                                ?.product
                                                ?.productName ??
                                            'No Product',
                                        orderAmount: sellerOrderResult
                                                .orderSubDetails?.totalAmount
                                                .toString() ??
                                            '0.00',
                                        status: statusProperties['displayText'],
                                        statusColor:
                                            statusProperties['statusColor'],
                                        boxColor: statusProperties['boxColor'],
                                        date: orderDate,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              })
                              .take(10)
                              .toList(),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text('No Orders'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 40,
              ),
              // const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
