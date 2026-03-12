import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../../../../../config/constants/api_constant.dart';
import '../../../../../config/constants/app_assets.dart';
import '../controllers/buyer_panel_dashboard_controller.dart';
import '../models/buyer_review_model.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../utils/custom_drawer.dart';

class BuyerReviewListView extends GetView<BuyerPanelDashboardController> {
  final DateFormat productDateTimeFormat = DateFormat('MMM d, yyyy h:mm a');

  BuyerReviewListView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getBuyerReviewData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Review List'.tr,
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
              Get.toNamed(
                Routes.BUYER_RETURN_REFUND_LIST,
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(color: Theme.of(context).cardTheme.color),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('All Review List'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => controller.reviewList.value.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10.0),
                      itemCount: controller.reviewList.value.length,
                      itemBuilder: (context, index) {
                        BuyerReviewModel review =
                            controller.reviewList.value[index];
                        return Container(
                          color: Theme.of(context).cardTheme.color,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        review.product != null
                                            ? '${ApiConstant.SERVER_IP}:82/uploads/product/${review.product?.media!.first.toString()}'
                                            : 'https://your-default-test-url.com/test-image.jpg',
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
                                          Text(
                                            review.product?.productName ??
                                                'No Product Name',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 5),
                                          RatingBarIndicator(
                                            rating:
                                                review.rating?.toDouble() ?? 0,
                                            itemBuilder: (context, _) =>
                                                const Icon(Icons.star,
                                                    color: Colors.orange),
                                            itemCount: 5,
                                            itemSize: 18.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  review.reviewTitle ?? 'No title',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  review.reviewDescription ?? 'No description',
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text('Time & Date:'.tr,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      review.createdAt != null
                                          ? productDateTimeFormat
                                              .format(review.createdAt!)
                                          : 'No Date',
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 1,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Image.asset(
                          AppAssets.NO_REVIEW_ICON,
                          height: Get.height / 3,
                          width: Get.height / 3,
                        )),
                  ),
          ),
        ],
      ),
    );
  }
}
