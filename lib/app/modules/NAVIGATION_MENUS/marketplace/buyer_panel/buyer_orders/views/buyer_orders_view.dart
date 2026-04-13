import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../config/constants/api_constant.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../components/empty_state.dart';
import '../../../components/order_card.dart';
import '../controllers/buyer_orders_controller.dart';
import '../widgets/order_status_filter.dart';

/// Order history list with status filter, pagination, pull-to-refresh.
class BuyerOrdersView extends StatelessWidget {
  const BuyerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerOrdersController>();

    return Column(
      children: [
        const SizedBox(height: 12),
        // Status filter chips
        Obx(() => OrderStatusFilter(
              selectedStatus: controller.selectedStatus.value,
              onStatusChanged: controller.filterByStatus,
            )),
        const SizedBox(height: 12),
        // Order count
        Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${controller.totalCount.value} order${controller.totalCount.value != 1 ? 's' : ''}',
                    style: MarketplaceDesignTokens.cardSubtext(context),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
        // Order list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MarketplaceDesignTokens.pricePrimary,
                ),
              );
            }

            if (controller.orders.isEmpty) {
              return MarketplaceEmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'No Orders Found',
                subtitle: controller.selectedStatus.value.isNotEmpty
                    ? 'No orders with this status.'
                    : 'You haven\'t placed any orders yet.',
                actionLabel: 'Browse Marketplace',
                onAction: () => Get.toNamed(Routes.MARKETPLACE),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refreshOrders,
              color: MarketplaceDesignTokens.pricePrimary,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    controller.loadMoreOrders();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.orders.length +
                      (controller.hasMoreData.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= controller.orders.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: MarketplaceDesignTokens.pricePrimary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }

                    final order = controller.orders[index];
                    final sub = order.subDetail;
                    final storeName = sub?.store?.name;
                    final storeId = sub?.store?.id;

                    // Get first product image
                    String? imageUrl;
                    if (order.productImages.isNotEmpty) {
                      imageUrl =
                          '${ApiConstant.SERVER_IP_PORT}/uploads/products/${order.productImages.first}';
                    }

                    return OrderCard(
                      invoiceNumber: order.invoiceNumber,
                      storeName: storeName,
                      status: sub?.status,
                      totalAmount: sub?.totalAmount,
                      itemCount: sub?.totalProductCount,
                      firstProductImage: imageUrl,
                      createdAt: order.createdAt,
                      onTap: () {
                        if (order.orderId.isNotEmpty && storeId != null) {
                          Get.toNamed(Routes.MARKETPLACE_ORDER_DETAIL, arguments: {
                            'order_id': order.orderId,
                            'store_id': storeId,
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
