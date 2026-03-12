import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../extension/date_time_extension.dart';
import '../components/seller_drawer_items.dart';
import '../components/seller_order_card_widgets.dart';
import '../controllers/seller_panel_dashboard_controller.dart';
import '../../../../utils/color_func.dart';
import '../../../../utils/custom_drawer.dart';

class SellerOrderView extends GetView<SellerPanelDashboardController> {
  const SellerOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getSellerDetailsOrderListData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Orders'.tr,
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
          Builder(
            builder: (context) {
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
            },
          ),
        ],
      ),
      endDrawer: CustomDrawer(
        title: 'Seller Dashboard Menu'.tr,
        drawerItems: sellerDrawerItems,
      ),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Orders'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Filters Button Press
                      debugPrint('Filters Button Pressed');
                      showFilterOrderBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: const Icon(Icons.tune, size: 16),
                    label: Text('Filters'.tr,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Filters Button Press
                      debugPrint('Date Button Pressed');
                      controller.showDateRangePickerDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: const Icon(Icons.date_range, size: 16),
                    label: Text('Pick Date'.tr,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded ListView
            Expanded(
              child: controller.sellerDetailsOrderList.value.isNotEmpty
                  ? ListView.builder(
                      controller: controller.scrollControllerOrder,
                      itemCount: controller.sellerDetailsOrderList.value.length,
                      itemBuilder: (context, index) {
                        final sellerOrderResult =
                            controller.sellerDetailsOrderList.value[index];
                        String quantities =
                            sellerOrderResult.productCount.toString();
                        String orderDate =
                            (sellerOrderResult.createdAt?.toFormatDateAndTime()??'');

                        var statusProperties =
                            getStatusProperties(sellerOrderResult.status);

                        return Column(
                          children: [
                            buildSellerOrderBoardCard(
                              context: context,
                              orderId: (
                                  sellerOrderResult.invoiceNumber.toFormatInvoiceNumber()),
                              items: quantities,
                              orderAmount:
                                  sellerOrderResult.totalSellPrice != null
                                      ? sellerOrderResult.totalSellPrice!
                                          .toStringAsFixed(2)
                                      : '0.00',
                              status: statusProperties['displayText'],
                              statusColor: statusProperties['statusColor'],
                              boxColor: statusProperties['boxColor'],
                              date: orderDate,
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
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
          ],
        );
      }),
    );
  }

  void showFilterOrderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                // leading: const Icon(Icons.clear_all),
                title: Text('All Orders'.tr),
                onTap: () {
                  _applyFilter('');
                  Get.back();
                },
              ),
              ListTile(
                // leading: const Icon(Icons.pending),
                title: Text('Pending'.tr),
                onTap: () {
                  _applyFilter('pending');
                  Get.back();
                },
              ),
              ListTile(
                // leading: const Icon(Icons.check_circle),
                title: Text('On Processing'.tr),
                onTap: () {
                  _applyFilter('onprocessing');
                  Get.back();
                },
              ),
              ListTile(
                // leading: const Icon(Icons.access_time),
                title: Text('Delivered'.tr),
                onTap: () {
                  _applyFilter('delivered');
                  Get.back();
                },
              ),
              ListTile(
                // leading: const Icon(Icons.access_time),
                title: Text('Refunded'.tr),
                onTap: () {
                  _applyFilter('refund');
                  Get.back();
                },
              ),
              ListTile(
                // leading: const Icon(Icons.access_time),
                title: Text('Canceled'.tr),
                onTap: () {
                  _applyFilter('canceled');
                  Get.back();
                },
              ),
              ListTile(
                // leading: const Icon(Icons.access_time),
                title: Text('Accepted'.tr),
                onTap: () {
                  _applyFilter('accepted');
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(String status) {
    controller.getSellerDetailsOrderListData(status: status);
  }
}
