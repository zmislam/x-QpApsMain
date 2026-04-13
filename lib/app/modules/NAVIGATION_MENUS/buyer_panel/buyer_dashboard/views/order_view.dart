import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../config/constants/app_assets.dart';
import '../controllers/buyer_panel_dashboard_controller.dart';
import '../components/order_card_widgets.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../utils/color_func.dart';
import '../../../../../utils/custom_drawer.dart';

class BuyerOrderView extends GetView<BuyerPanelDashboardController> {
  const BuyerOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBuyerOrderData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Orders'.tr,
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
              Get.offNamed(Routes.MARKETPLACE_BUYER_PANEL);
            },
          ),
          DrawerItem(
            iconPath: AppAssets.ORDER_ICON,
            title: 'Order'.tr,
            onTap: () {
              Get.offNamed(Routes.MARKETPLACE_BUYER_PANEL, arguments: {'tab': 1});
            },
          ),
          DrawerItem(
            iconPath: AppAssets.REVIEW_LIST_ICON,
            title: 'Review List'.tr,
            onTap: () {
              Get.offNamed(Routes.MARKETPLACE_BUYER_PANEL, arguments: {'tab': 2});
            },
          ),
          DrawerItem(
            iconPath: AppAssets.COMPLAIN_LIST_ICON,
            title: 'Complain List'.tr,
            onTap: () {
              Get.offNamed(Routes.MARKETPLACE_BUYER_PANEL, arguments: {'tab': 3});
            },
          ),
          DrawerItem(
            iconPath: AppAssets.COMPLAIN_LIST_ICON,
            title: 'Refund Details List'.tr,
            onTap: () {
              Get.offNamed(Routes.MARKETPLACE_BUYER_PANEL, arguments: {'tab': 3});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('Order History'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                          String quantities = buyerOrderResult.orderDetails
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
                                  Get.toNamed(Routes.MARKETPLACE_ORDER_DETAIL,
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
                                  amount: buyerOrderResult
                                              .orderSubDetails?.total_amount !=
                                          null
                                      ? buyerOrderResult
                                          .orderSubDetails!.total_amount!
                                          .toStringAsFixed(2)
                                      : '0.00',
                                  status: statusProperties['displayText'],
                                  statusColor: statusProperties['statusColor'],
                                  boxColor: statusProperties['boxColor'],
                                  date: orderDate,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
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
          ],
        ),
      ),
    );
  }
}
