import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../routes/app_pages.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../components/empty_state.dart';
import '../../../components/status_badge.dart';
import '../controllers/seller_orders_controller.dart';

/// Seller order list with status filter, search, accept/reject & tracking.
class SellerOrdersView extends GetView<SellerOrdersController> {
  const SellerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          child: TextField(
            onChanged: (v) => controller.search(v),
            decoration: InputDecoration(
              hintText: 'Search by invoice...',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: MarketplaceDesignTokens.cardBorder(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
                borderSide: BorderSide(
                    color: MarketplaceDesignTokens.cardBorder(context)),
              ),
            ),
          ),
        ),

        // Status filter
        SizedBox(
          height: MarketplaceDesignTokens.chipHeight,
          child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: controller.statusFilter.value.isEmpty,
                    onTap: () => controller.setStatusFilter(''),
                  ),
                  _FilterChip(
                    label: 'Pending',
                    selected: controller.statusFilter.value == 'pending',
                    onTap: () => controller.setStatusFilter('pending'),
                  ),
                  _FilterChip(
                    label: 'Accepted',
                    selected: controller.statusFilter.value == 'accepted',
                    onTap: () => controller.setStatusFilter('accepted'),
                  ),
                  _FilterChip(
                    label: 'In Process',
                    selected:
                        controller.statusFilter.value == 'onprocessing',
                    onTap: () =>
                        controller.setStatusFilter('onprocessing'),
                  ),
                  _FilterChip(
                    label: 'Delivered',
                    selected: controller.statusFilter.value == 'delivered',
                    onTap: () => controller.setStatusFilter('delivered'),
                  ),
                  _FilterChip(
                    label: 'Cancelled',
                    selected: controller.statusFilter.value == 'canceled',
                    onTap: () => controller.setStatusFilter('canceled'),
                  ),
                ],
              )),
        ),
        const SizedBox(height: 8),

        // Order list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.orders.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MarketplaceDesignTokens.pricePrimary,
                ),
              );
            }

            if (controller.orders.isEmpty) {
              return MarketplaceEmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No orders found',
                subtitle: 'Orders from buyers will appear here',
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchOrders(),
              color: MarketplaceDesignTokens.pricePrimary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding),
                itemCount: controller.orders.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.orders.length) {
                    controller.fetchOrders(loadMore: true);
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: MarketplaceDesignTokens.pricePrimary,
                        strokeWidth: 2,
                      )),
                    );
                  }
                  return _SellerOrderCard(
                    order: controller.orders[index],
                    onAccept: () => controller.acceptOrder(
                      controller.orders[index]['_id']?.toString() ?? '',
                      controller.orders[index]['store_id']?.toString() ?? '',
                    ),
                    onReject: () => _showRejectDialog(
                      context,
                      controller.orders[index]['_id']?.toString() ?? '',
                      controller.orders[index]['store_id']?.toString() ?? '',
                    ),
                    onAddTracking: () => _showTrackingSheet(
                      context,
                      controller.orders[index]['_id']?.toString() ?? '',
                      controller.orders[index]['store_id']?.toString() ?? '',
                    ),
                    onViewTracking: () => _showTrackingDetails(
                      context,
                      controller.orders[index]['_id']?.toString() ?? '',
                      controller.orders[index]['store_id']?.toString() ?? '',
                    ),
                    onView: () {
                      Get.toNamed(
                        Routes.MARKETPLACE_SELLER_ORDER_DETAIL,
                        arguments: {
                          'order_id': controller.orders[index]['_id'],
                        },
                      );
                    },
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showRejectDialog(
      BuildContext context, String orderId, String storeId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Order'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            hintText: 'Reason for rejection...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.rejectOrder(orderId, storeId, reasonCtrl.text);
            },
            child: Text('Reject',
                style:
                    TextStyle(color: MarketplaceDesignTokens.outOfStock)),
          ),
        ],
      ),
    );
  }

  void _showTrackingSheet(
      BuildContext context, String orderId, String storeId) {
    final trackingCtrl = TextEditingController();
    final courierCtrl = TextEditingController();
    bool submitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: MarketplaceDesignTokens.cardBg(ctx),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(MarketplaceDesignTokens.radiusLg),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Text(
                  'Add Tracking Number',
                  style: MarketplaceDesignTokens.sectionTitle(ctx),
                ),
                const SizedBox(height: 16),

                // Tracking number field
                TextField(
                  controller: trackingCtrl,
                  decoration: InputDecoration(
                    labelText: 'Tracking Number',
                    hintText: 'e.g. 1Z999AA10123456784',
                    prefixIcon:
                        const Icon(Icons.local_shipping_outlined, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusMd),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Courier slug field
                TextField(
                  controller: courierCtrl,
                  decoration: InputDecoration(
                    labelText: 'Courier (slug)',
                    hintText: 'e.g. ups, fedex, dhl, usps',
                    prefixIcon: const Icon(Icons.business, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusMd),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: submitting
                        ? null
                        : () async {
                            final tracking = trackingCtrl.text.trim();
                            final courier = courierCtrl.text.trim();
                            if (tracking.isEmpty || courier.isEmpty) {
                              Get.snackbar(
                                'Missing Info',
                                'Enter both tracking number and courier',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            setState(() => submitting = true);
                            final ok =
                                await controller.updateTrackingNumber(
                              orderId: orderId,
                              storeId: storeId,
                              trackingNumber: tracking,
                              courierSlug: courier,
                            );
                            setState(() => submitting = false);
                            if (ok && ctx.mounted) {
                              Navigator.pop(ctx);
                            }
                          },
                    icon: const Icon(Icons.check, size: 20),
                    label: Text(
                        submitting ? 'Submitting...' : 'Update Tracking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          MarketplaceDesignTokens.pricePrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MarketplaceDesignTokens.radiusMd),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTrackingDetails(
      BuildContext context, String orderId, String storeId) {
    controller.fetchTrackingDetails(orderId, storeId);
    controller.fetchTrackingNumber(orderId, storeId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: MarketplaceDesignTokens.cardBg(context),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(MarketplaceDesignTokens.radiusLg),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header with tracking number
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.spacingMd,
                  vertical: MarketplaceDesignTokens.spacingSm,
                ),
                child: Obx(() => Row(
                      children: [
                        const Icon(Icons.local_shipping_outlined, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tracking Details',
                                style: MarketplaceDesignTokens.sectionTitle(
                                    context),
                              ),
                              if (controller
                                  .currentTrackingNumber.value.isNotEmpty)
                                Text(
                                  controller.currentTrackingNumber.value,
                                  style:
                                      MarketplaceDesignTokens.cardSubtext(
                                          context),
                                ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              const Divider(height: 1),

              // Checkpoints
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingTracking.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MarketplaceDesignTokens.pricePrimary,
                      ),
                    );
                  }
                  if (controller.trackingCheckpoints.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(
                            MarketplaceDesignTokens.spacingLg),
                        child: Text(
                          'No tracking updates available yet',
                          style:
                              MarketplaceDesignTokens.cardSubtext(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(
                        MarketplaceDesignTokens.spacingMd),
                    itemCount: controller.trackingCheckpoints.length,
                    itemBuilder: (_, i) => _TrackingCheckpoint(
                      checkpoint: controller.trackingCheckpoints[i],
                      isFirst: i == 0,
                      isLast:
                          i == controller.trackingCheckpoints.length - 1,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor:
            MarketplaceDesignTokens.pricePrimary.withValues(alpha: 0.15),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected
              ? MarketplaceDesignTokens.pricePrimary
              : MarketplaceDesignTokens.textSecondary(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        side: BorderSide(
          color: selected
              ? MarketplaceDesignTokens.pricePrimary
              : MarketplaceDesignTokens.cardBorder(context),
        ),
      ),
    );
  }
}

class _SellerOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onAddTracking;
  final VoidCallback onViewTracking;
  final VoidCallback onView;

  const _SellerOrderCard({
    required this.order,
    required this.onAccept,
    required this.onReject,
    required this.onAddTracking,
    required this.onViewTracking,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final invoiceNumber = order['invoice_number'] as String? ?? '';
    final status = order['status'] as String? ?? 'pending';
    final totalSellPrice = order['total_sell_price'] ?? 0;
    final productCount = order['productCount'] ?? 0;
    final images = order['product_images'] as List? ?? [];
    final createdAt = order['createdAt'] as String? ?? '';

    return GestureDetector(
      onTap: onView,
      child: Container(
        margin:
            const EdgeInsets.only(bottom: MarketplaceDesignTokens.gridSpacing),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: invoice + status
            Row(
              children: [
                Expanded(
                  child: Text(
                    invoiceNumber.isNotEmpty
                        ? '#$invoiceNumber'
                        : '#${order['_id']?.toString().substring(0, 8) ?? ''}',
                    style: MarketplaceDesignTokens.bodyText(context)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                StatusBadge(
                  status: status,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Product images row
            if (images.isNotEmpty)
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    ...images.take(3).map((img) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              img.toString(),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 40,
                                height: 40,
                                color: const Color(0xFFF0F0F0),
                                child: const Icon(Icons.image_outlined,
                                    size: 16, color: Colors.grey),
                              ),
                            ),
                          ),
                        )),
                    if (images.length > 3)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: MarketplaceDesignTokens.pricePrimary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '+${images.length - 3}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: MarketplaceDesignTokens.pricePrimary,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    Text(
                      '$productCount item${productCount != 1 ? 's' : ''}',
                      style: MarketplaceDesignTokens.statLabel(context),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),

            // Footer: price + date + actions
            Row(
              children: [
                Text(
                  CurrencyHelper.formatPrice(totalSellPrice),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: MarketplaceDesignTokens.pricePrimary,
                  ),
                ),
                const Spacer(),
                if (createdAt.isNotEmpty)
                  Text(
                    _formatDate(createdAt),
                    style: MarketplaceDesignTokens.statLabel(context),
                  ),
              ],
            ),

            // Accept / Reject buttons for pending orders
            if (status == 'pending') ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MarketplaceDesignTokens.outOfStock,
                        side: const BorderSide(
                            color: MarketplaceDesignTokens.outOfStock),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MarketplaceDesignTokens.radiusSm),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Reject', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MarketplaceDesignTokens.pricePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MarketplaceDesignTokens.radiusSm),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Accept', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],

            // Tracking actions for accepted orders
            if (status == 'accepted') ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAddTracking,
                  icon: const Icon(Icons.local_shipping_outlined, size: 18),
                  label: const Text('Add Tracking Number',
                      style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarketplaceDesignTokens.pricePrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],

            // View tracking for in-process/delivered orders
            if (status == 'onprocessing' || status == 'delivered') ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onViewTracking,
                  icon: const Icon(Icons.track_changes, size: 18),
                  label: const Text('View Tracking',
                      style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: MarketplaceDesignTokens.pricePrimary,
                    side: const BorderSide(
                        color: MarketplaceDesignTokens.pricePrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final d = DateTime.parse(isoDate);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return isoDate;
    }
  }
}

class _TrackingCheckpoint extends StatelessWidget {
  final Map<String, dynamic> checkpoint;
  final bool isFirst;
  final bool isLast;

  const _TrackingCheckpoint({
    required this.checkpoint,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final message = checkpoint['message'] as String? ??
        checkpoint['checkpoint_time'] as String? ??
        '';
    final tag = checkpoint['tag'] as String? ?? '';
    final location = checkpoint['location'] as String? ?? '';
    final time = checkpoint['checkpoint_time'] as String? ?? '';

    String formattedTime = time;
    if (time.isNotEmpty) {
      try {
        final dt = DateTime.parse(time);
        formattedTime =
            '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isFirst
                        ? MarketplaceDesignTokens.pricePrimary
                        : MarketplaceDesignTokens.textSecondary(context)
                            .withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: MarketplaceDesignTokens.textSecondary(context)
                          .withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: MarketplaceDesignTokens.bodyText(context).copyWith(
                      fontWeight: isFirst ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (tag.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      tag.replaceAll('_', ' ').capitalizeFirst ?? tag,
                      style: TextStyle(
                        fontSize: 11,
                        color: MarketplaceDesignTokens.pricePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (location.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            MarketplaceDesignTokens.textSecondary(context),
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          MarketplaceDesignTokens.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
