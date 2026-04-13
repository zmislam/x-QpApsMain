import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../components/empty_state.dart';
import '../../../components/status_badge.dart';
import '../../buyer_reviews/controllers/buyer_reviews_controller.dart';
import '../../buyer_reviews/widgets/submit_review_sheet.dart';
import '../controllers/buyer_order_detail_controller.dart';
import '../widgets/order_items_list.dart';

/// Order details view showing items, address, status, cancel option.
class BuyerOrderDetailView extends GetView<BuyerOrderDetailController> {
  const BuyerOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: MarketplaceDesignTokens.heading(context),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: MarketplaceDesignTokens.pricePrimary,
            ),
          );
        }

        if (controller.hasError.value || controller.orderDetail.value == null) {
          return MarketplaceEmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load order',
            subtitle: 'Please try again.',
            actionLabel: 'Retry',
            onAction: controller.refreshOrderDetails,
          );
        }

        final order = controller.orderDetail.value!;
        final subStatus = order.subDetails?.status;

        return RefreshIndicator(
          onRefresh: controller.refreshOrderDetails,
          color: MarketplaceDesignTokens.pricePrimary,
          child: ListView(
            padding: const EdgeInsets.all(
                MarketplaceDesignTokens.sectionSpacing),
            children: [
              // Order header
              _OrderHeaderCard(
                invoiceNumber: order.invoiceNumber,
                status: subStatus,
                createdAt: order.createdAt,
                storeName: order.subDetails?.storeName,
              ),
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

              // Items list
              OrderItemsList(
                items: order.storeList,
                onReviewTap: subStatus == 'delivered'
                    ? (item) {
                        // Ensure reviews controller is available
                        if (!Get.isRegistered<BuyerReviewsController>()) {
                          Get.put(BuyerReviewsController());
                        }
                        Get.bottomSheet(
                          SubmitReviewSheet(
                            productId: item.productId ?? '',
                            orderId: order.orderId ?? '',
                            productName: item.product?.productName,
                          ),
                          isScrollControlled: true,
                        );
                      }
                    : null,
              ),
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

              // Order summary
              _OrderSummaryCard(
                items: order.storeList,
                totalAmount: order.subDetails?.totalAmount ?? 0,
              ),
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

              // Shipping address
              if (order.address != null)
                _AddressCard(
                  title: 'Shipping Address',
                  address: order.address!,
                ),
              if (order.billingAddress != null) ...[
                const SizedBox(height: 10),
                _AddressCard(
                  title: 'Billing Address',
                  address: order.billingAddress!,
                ),
              ],
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),

              // Cancel button (only if pending)
              if (controller.canCancel)
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: controller.isCancelling.value
                            ? null
                            : controller.cancelOrder,
                        icon: controller.isCancelling.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: MarketplaceDesignTokens.orderCancelled,
                                ),
                              )
                            : const Icon(Icons.cancel_outlined),
                        label: Text(controller.isCancelling.value
                            ? 'Cancelling...'
                            : 'Cancel Order'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              MarketplaceDesignTokens.orderCancelled,
                          side: const BorderSide(
                            color: MarketplaceDesignTokens.orderCancelled,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MarketplaceDesignTokens.cardRadius),
                          ),
                        ),
                      ),
                    )),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  final String? invoiceNumber;
  final String? status;
  final String? createdAt;
  final String? storeName;

  const _OrderHeaderCard({
    this.invoiceNumber,
    this.status,
    this.createdAt,
    this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  invoiceNumber ?? 'Order',
                  style: MarketplaceDesignTokens.sectionTitle(context),
                ),
              ),
              if (status != null) StatusBadge(status: status!),
            ],
          ),
          const SizedBox(height: 8),
          if (storeName != null)
            Row(
              children: [
                Icon(
                  Icons.storefront_outlined,
                  size: 16,
                  color: MarketplaceDesignTokens.textSecondary(context),
                ),
                const SizedBox(width: 6),
                Text(
                  storeName!,
                  style: MarketplaceDesignTokens.cardSubtext(context),
                ),
              ],
            ),
          if (createdAt != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: MarketplaceDesignTokens.textSecondary(context),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(createdAt!),
                  style: MarketplaceDesignTokens.cardSubtext(context),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final List items;
  final double totalAmount;

  const _OrderSummaryCard({required this.items, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: MarketplaceDesignTokens.sectionTitle(context),
          ),
          const SizedBox(height: 12),
          _summaryRow(
            context,
            'Items',
            '${items.length}',
          ),
          const SizedBox(height: 8),
          Divider(color: MarketplaceDesignTokens.divider(context)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: MarketplaceDesignTokens.productName(context)
                    .copyWith(fontSize: 16),
              ),
              Text(
                CurrencyHelper.formatPrice(totalAmount),
                style: MarketplaceDesignTokens.productPrice
                    .copyWith(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: MarketplaceDesignTokens.bodyText(context)),
        Text(value, style: MarketplaceDesignTokens.bodyText(context)),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final dynamic address;

  const _AddressCard({required this.title, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: MarketplaceDesignTokens.pricePrimary,
              ),
              const SizedBox(width: 6),
              Text(title,
                  style: MarketplaceDesignTokens.productName(context)),
            ],
          ),
          const SizedBox(height: 8),
          if (address.recipientsName != null)
            Text(
              address.recipientsName!,
              style: MarketplaceDesignTokens.bodyText(context),
            ),
          if (address.recipientsPhone != null)
            Text(
              address.recipientsPhone!,
              style: MarketplaceDesignTokens.cardSubtext(context),
            ),
          const SizedBox(height: 4),
          Text(
            address.fullAddress,
            style: MarketplaceDesignTokens.cardSubtext(context),
          ),
        ],
      ),
    );
  }
}
