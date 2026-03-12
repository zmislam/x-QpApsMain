import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../config/constants/app_assets.dart';
import '../controllers/buyer_panel_dashboard_controller.dart';
import '../../../../../utils/custom_drawer.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../config/constants/color.dart';

class BuyerReturnRefundListView extends GetView<BuyerPanelDashboardController> {
  const BuyerReturnRefundListView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBuyerRefundData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Return and Refund List'.tr,
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            color: Theme.of(context).cardTheme.color,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('All Return & Refund List'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(() {
                if (controller.isLoadingBuyerDashboard.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.complaintList.value.isEmpty) {
                  return Center(
                      child: Text('No Refund and Return History Found'.tr));
                }
                return ListView.builder(
                  itemCount: controller.refundList.value.length,
                  itemBuilder: (context, index) {
                    final refund = controller.refundList.value[index];

                    return InkWell(
                      onTap: () {
                        Get.offNamed(Routes.BUYER_RETURN_REFUND_DETAILS,
                            arguments: {'refund_id': refund.id});
                      },
                      child: Card(
                        color: Theme.of(context).cardTheme.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Order Id: '.tr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'INV-OD-${refund.id ?? ''}',
                                    style: TextStyle(
                                        color: PRIMARY_COLOR,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Product Quantity: '.tr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${refund.productQuantity ?? '0'} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Delivery Charge: '.tr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    refund.deliveryCharge.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Store Name:'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    refund.store?.name ?? 'Unknown Store',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Status: '.tr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: refund.status == 'pending'
                                          ? const Color(0xFFF8DD4E)
                                          : const Color(0xFFE7F4EE),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      refund.status?.capitalizeFirst ?? '',
                                      style: TextStyle(
                                          color: refund.status == 'pending'
                                              ? const Color(0xFF835101)
                                              : const Color(0xFF0D894F),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Time & Date: '.tr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${(refund.createdAt?.toFormatDateAndTime() ?? '')} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                height: 100,
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                ),
                                child: Text(
                                  'Details: ${refund.note ?? ''}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
