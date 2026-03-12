import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../extension/date_time_extension.dart';
import '../../../../../extension/string/string_image_path.dart';
import '../../../../../config/constants/app_assets.dart';
import '../controllers/buyer_panel_dashboard_controller.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../config/constants/color.dart';
import '../../../../../utils/custom_drawer.dart';

class BuyerComplaintListView extends GetView<BuyerPanelDashboardController> {
  const BuyerComplaintListView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBuyerComplaintData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Complaint List'.tr,
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
                  child: Text('All Complaint List'.tr,
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
                  return Center(child: Text('No Complaints Found'.tr));
                }
                return ListView.builder(
                  itemCount: controller.complaintList.value.length,
                  itemBuilder: (context, index) {
                    final complaint = controller.complaintList.value[index];
                    final productName = complaint.products != null &&
                            complaint.products!.isNotEmpty
                        ? complaint.products!.first.productName ??
                            'Unknown Product'
                        : 'Unknown Product';

                    return Card(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    complaint.products != null &&
                                            complaint.products!.isNotEmpty
                                        ? (complaint
                                                .products!.first.media!.first)
                                            .formatedProductUrlLive
                                        : '',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                        AppAssets.DEFAULT_IMAGE,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                productName,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              complaint.products != null &&
                                                      (complaint.products!
                                                              .length >
                                                          1)
                                                  ? Text('    +${complaint.products!.length - 1} other products'.tr,
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Order ID: '.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  (complaint.order?.invoiceNumber
                                          ?.toFormatInvoiceNumber() ??
                                      ''),
                                  style: const TextStyle(
                                      color: PRIMARY_COLOR,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Store Name:'.tr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  complaint.store?.name ?? 'Unknown Store',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Status: '.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: complaint.status == 'pending'
                                        ? const Color(0xFFF8DD4E)
                                        : const Color(0xFFE7F4EE),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    complaint.status?.capitalizeFirst ?? '',
                                    style: TextStyle(
                                        color: complaint.status == 'pending'
                                            ? const Color(0xFF835101)
                                            : const Color(0xFF0D894F),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Time & Date: '.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('${(complaint.createdAt.toFormatDateAndTime())} '.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Type: '.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${complaint.issueType?.capitalizeFirst ?? 'N/A'} ',
                                  style: const TextStyle(
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
                                'Details: ${complaint.details ?? ''}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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
