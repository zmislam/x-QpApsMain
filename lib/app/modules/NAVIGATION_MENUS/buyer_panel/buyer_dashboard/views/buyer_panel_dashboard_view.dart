import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../config/constants/app_assets.dart';
import '../components/order_card_widgets.dart';
import '../controllers/buyer_panel_dashboard_controller.dart';
import '../../../../../utils/custom_drawer.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../utils/color_func.dart';

class BuyerPanelDashboardView extends GetView<BuyerPanelDashboardController> {
  const BuyerPanelDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBuyerOrderData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Dashboard'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
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
        title: 'Buyer Dashboard Menu'.tr,
        drawerItems: [
          DrawerItem(
            iconPath: AppAssets.DASHBOARD_ICON,
            title: 'Dashboard'.tr,
            onTap: () {
              Get.back();
              Get.toNamed(Routes.BUYER_DASHBOARD);
            },
          ),
          DrawerItem(
            iconPath: AppAssets.ORDER_ICON,
            title: 'Order'.tr,
            onTap: () {
              Get.toNamed(Routes.BUYER_ORDER_LIST);
            },
          ),
          DrawerItem(
            iconPath: AppAssets.REVIEW_LIST_ICON,
            title: 'Review List'.tr,
            onTap: () {
              Get.toNamed(Routes.BUYER_REVIEW);
            },
          ),
          DrawerItem(
            iconPath: AppAssets.COMPLAIN_LIST_ICON,
            title: 'Complain List'.tr,
            onTap: () {
              Get.toNamed(Routes.BUYER_COMPLAINT);
            },
          ),
          DrawerItem(
            iconPath: AppAssets.COMPLAIN_LIST_ICON,
            title: 'Refund Details List'.tr,
            onTap: () {
              Get.toNamed(Routes.BUYER_RETURN_REFUND_LIST);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Obx(
                () => controller.buyerOrderData.value != null
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
                              'Pending Order',
                              '${controller.buyerOrderData.value?.pendingOrders ?? 0}',
                              AppAssets.PENDING_ORDER_ICON),
                          buildStatCard(
                            context,
                            'In Escrow',
                            '\$${controller.buyerOrderData.value?.qpInEscrow?.toStringAsFixed(2) ?? 0.00}',
                            AppAssets.ESCROW_ORDER_ICON,
                          ),
                          buildStatCard(
                            context,
                            'Complete Order',
                            '${controller.buyerOrderData.value?.completeOrder ?? 0}',
                            AppAssets.COMPLETE_ORDER_ICON,
                          ),
                          buildStatCard(
                              context,
                              'Paid Order',
                              '\$${controller.buyerOrderData.value?.paidBalance ?? 0.00}',
                              AppAssets.PAID_ORDER_ICON),
                          buildStatCard(
                              context,
                              'Refund Balance',
                              '\$${controller.buyerOrderData.value?.refundBalance?.toStringAsFixed(2) ?? 0.00}',
                              AppAssets.REFUND_ORDER_ICON),
                          buildStatCard(
                              context,
                              'Total Order',
                              '${controller.buyerOrderData.value?.totalOrders ?? 0}',
                              AppAssets.TOTAL_ORDER_ICON),
                        ],
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text('No Order Data Available'.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
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
                () => controller.buyerOrderList.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: controller.buyerOrderList.value
                              .map((buyerOrderResult) {
                                String quantities = buyerOrderResult
                                        .orderDetails
                                        ?.map((details) =>
                                            details.quantity?.toString() ?? '0')
                                        .length
                                        .toString() ??
                                    '0';
                                String orderDate = (buyerOrderResult.createdAt
                                        ?.toFormatToReadableDate() ??
                                    '');

                                var statusProperties = getStatusProperties(
                                    buyerOrderResult.orderSubDetails?.status);

                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.BUYER_ORDER_DETAILS,
                                            arguments: {
                                              'orderId': buyerOrderResult.id,
                                              'storeId': buyerOrderResult
                                                  .orderSubDetails?.store?.id,
                                            });
                                      },
                                      child: buildOrderCard(
                                        context: context,
                                        orderId: (buyerOrderResult.invoiceNumber
                                            .toFormatInvoiceNumber()),
                                        storeName: buyerOrderResult
                                                .orderSubDetails?.store?.name ??
                                            'No Shop Name',
                                        quantity: quantities,
                                        amount: buyerOrderResult.orderSubDetails
                                                    ?.total_amount !=
                                                null
                                            ? buyerOrderResult
                                                .orderSubDetails!.total_amount!
                                                .toStringAsFixed(2)
                                            : '0.00',
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
