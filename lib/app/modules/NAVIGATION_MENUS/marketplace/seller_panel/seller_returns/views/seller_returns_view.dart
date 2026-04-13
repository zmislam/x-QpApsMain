import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../components/empty_state.dart';
import '../../../components/status_badge.dart';
import '../controllers/seller_returns_controller.dart';

/// Seller Returns & Refunds view — list refund requests and manage status.
class SellerReturnsView extends GetView<SellerReturnsController> {
  const SellerReturnsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Status filter chips
        SizedBox(
          height: MarketplaceDesignTokens.chipHeight,
          child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.cardPadding,
                  vertical: 6,
                ),
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
                    label: 'Sent',
                    selected: controller.statusFilter.value == 'sent',
                    onTap: () => controller.setStatusFilter('sent'),
                  ),
                  _FilterChip(
                    label: 'Received',
                    selected: controller.statusFilter.value == 'received',
                    onTap: () => controller.setStatusFilter('received'),
                  ),
                  _FilterChip(
                    label: 'Refunded',
                    selected: controller.statusFilter.value == 'refunded',
                    onTap: () => controller.setStatusFilter('refunded'),
                  ),
                  _FilterChip(
                    label: 'Declined',
                    selected: controller.statusFilter.value == 'declined',
                    onTap: () => controller.setStatusFilter('declined'),
                  ),
                ],
              )),
        ),

        // Refund list
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.refunds.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MarketplaceDesignTokens.pricePrimary,
                ),
              );
            }
            if (controller.refunds.isEmpty) {
              return MarketplaceEmptyState(
                icon: Icons.assignment_return_outlined,
                title: 'No return requests',
                subtitle: 'Return requests will appear here',
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchRefunds(),
              color: MarketplaceDesignTokens.pricePrimary,
              child: ListView.builder(
                padding: const EdgeInsets.all(
                    MarketplaceDesignTokens.cardPadding),
                itemCount: controller.refunds.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= controller.refunds.length) {
                    controller.fetchRefunds(loadMore: true);
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
                  return _RefundCard(
                    refund: controller.refunds[index],
                    onAccept: () => controller.acceptRefund(
                      controller.refunds[index]['_id']?.toString() ?? '',
                    ),
                    onDecline: () => _showDeclineDialog(
                      context,
                      controller.refunds[index]['_id']?.toString() ?? '',
                    ),
                    onMarkReceived: () => controller.markReceived(
                      controller.refunds[index]['_id']?.toString() ?? '',
                    ),
                    onProcessRefund: () => _showRefundAmountDialog(
                      context,
                      controller.refunds[index],
                    ),
                    onViewDetail: () => _showRefundDetail(
                      context,
                      controller.refunds[index]['_id']?.toString() ?? '',
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showDeclineDialog(BuildContext context, String refundId) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline Refund'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            hintText: 'Reason for declining...',
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
              controller.declineRefund(refundId, reasonCtrl.text);
            },
            child: Text('Decline',
                style:
                    TextStyle(color: MarketplaceDesignTokens.outOfStock)),
          ),
        ],
      ),
    );
  }

  void _showRefundAmountDialog(
      BuildContext context, Map<String, dynamic> refund) {
    final refundId = refund['_id']?.toString() ?? '';
    final totalPrice = refund['total_sell_price'] ?? refund['sell_price'] ?? 0;
    final amountCtrl =
        TextEditingController(text: totalPrice.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Process Refund'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the refund amount to transfer to buyer:'),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '€ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(amountCtrl.text.trim());
              if (amount != null && amount > 0) {
                Navigator.pop(ctx);
                controller.processRefund(refundId, amount);
              }
            },
            child: const Text('Refund'),
          ),
        ],
      ),
    );
  }

  void _showRefundDetail(BuildContext context, String refundId) {
    controller.fetchRefundDetails(refundId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
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
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MarketplaceDesignTokens.spacingMd,
                  vertical: MarketplaceDesignTokens.spacingSm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.assignment_return_outlined, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Refund Details',
                      style:
                          MarketplaceDesignTokens.sectionTitle(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingDetail.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MarketplaceDesignTokens.pricePrimary,
                      ),
                    );
                  }
                  final d = controller.refundDetail.value;
                  if (d.isEmpty) {
                    return Center(
                      child: Text(
                        'No details available',
                        style:
                            MarketplaceDesignTokens.cardSubtext(context),
                      ),
                    );
                  }

                  final note = d['note'] as String? ?? '';
                  final status = d['status'] as String? ?? '';
                  final rejectNote = d['rejection_note'] as String? ?? '';
                  final courier = d['courier'] as String? ?? '';
                  final tracking = d['tracking_number'] as String? ?? '';
                  final images = d['images'] as List? ?? [];
                  final details = d['refund_details'] as List? ?? [];

                  return ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(
                        MarketplaceDesignTokens.spacingMd),
                    children: [
                      // Status
                      Row(
                        children: [
                          const Text('Status: ',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          StatusBadge(status: status),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Note
                      if (note.isNotEmpty) ...[
                        Text('Buyer Note:',
                            style: MarketplaceDesignTokens.bodyText(context)
                                .copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(note,
                            style:
                                MarketplaceDesignTokens.cardSubtext(context)),
                        const SizedBox(height: 12),
                      ],

                      // Rejection note
                      if (rejectNote.isNotEmpty) ...[
                        Text('Decline Reason:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: MarketplaceDesignTokens.outOfStock,
                            )),
                        const SizedBox(height: 4),
                        Text(rejectNote),
                        const SizedBox(height: 12),
                      ],

                      // Courier info
                      if (courier.isNotEmpty || tracking.isNotEmpty) ...[
                        Text('Shipping Info:',
                            style: MarketplaceDesignTokens.bodyText(context)
                                .copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        if (courier.isNotEmpty)
                          Text('Courier: $courier'),
                        if (tracking.isNotEmpty)
                          Text('Tracking: $tracking'),
                        const SizedBox(height: 12),
                      ],

                      // Images
                      if (images.isNotEmpty) ...[
                        Text('Images:',
                            style: MarketplaceDesignTokens.bodyText(context)
                                .copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MarketplaceDesignTokens.radiusSm),
                              child: Image.network(
                                images[i].toString(),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_outlined),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Refund line items
                      if (details.isNotEmpty) ...[
                        Text('Items:',
                            style: MarketplaceDesignTokens.bodyText(context)
                                .copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        ...details.map((item) {
                          final m = item is Map<String, dynamic>
                              ? item
                              : <String, dynamic>{};
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    m['product_name']
                                            ?.toString() ??
                                        'Product',
                                  ),
                                ),
                                Text(
                                  'x${m['refund_quantity'] ?? 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  CurrencyHelper.formatPrice(
                                      m['sell_price'] ?? 0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: MarketplaceDesignTokens
                                        .pricePrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
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

// ─── Filter Chip ────────────────────────────────────────────
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

// ─── Refund Card ────────────────────────────────────────────
class _RefundCard extends StatelessWidget {
  final Map<String, dynamic> refund;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onMarkReceived;
  final VoidCallback onProcessRefund;
  final VoidCallback onViewDetail;

  const _RefundCard({
    required this.refund,
    required this.onAccept,
    required this.onDecline,
    required this.onMarkReceived,
    required this.onProcessRefund,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final status = refund['status'] as String? ?? 'pending';
    final note = refund['note'] as String? ?? '';
    final buyerName = refund['refund_by_name'] as String? ??
        (refund['refund_by'] is Map
            ? (refund['refund_by'] as Map)['name']?.toString()
            : null) ??
        'Buyer';
    final createdAt = refund['createdAt'] as String? ?? '';
    final productName = refund['product_name'] as String? ?? '';
    final amount = refund['delivery_charge'] ?? refund['sell_price'] ?? 0;

    return GestureDetector(
      onTap: onViewDetail,
      child: Container(
        margin: const EdgeInsets.only(
            bottom: MarketplaceDesignTokens.gridSpacing),
        padding:
            const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusSm),
                  ),
                  child: Icon(
                    Icons.assignment_return_outlined,
                    size: 18,
                    color: _statusColor(status),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buyerName,
                        style: MarketplaceDesignTokens.bodyText(context)
                            .copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (productName.isNotEmpty)
                        Text(
                          productName,
                          style:
                              MarketplaceDesignTokens.cardSubtext(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                StatusBadge(status: status),
              ],
            ),

            // Note preview
            if (note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                note,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: MarketplaceDesignTokens.cardSubtext(context),
              ),
            ],

            // Footer
            const SizedBox(height: 8),
            Row(
              children: [
                if ((amount as num) > 0)
                  Text(
                    CurrencyHelper.formatPrice(amount),
                    style: const TextStyle(
                      fontSize: 14,
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

            // Action buttons based on status
            if (status == 'pending') ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            MarketplaceDesignTokens.outOfStock,
                        side: const BorderSide(
                            color: MarketplaceDesignTokens.outOfStock),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MarketplaceDesignTokens.radiusSm),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Decline',
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            MarketplaceDesignTokens.pricePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MarketplaceDesignTokens.radiusSm),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Accept',
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],

            if (status == 'sent') ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onMarkReceived,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Mark as Received',
                      style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        MarketplaceDesignTokens.pricePrimary,
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

            if (status == 'received') ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onProcessRefund,
                  icon: const Icon(Icons.payments_outlined, size: 18),
                  label: const Text('Process Refund',
                      style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        MarketplaceDesignTokens.pricePrimary,
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
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return MarketplaceDesignTokens.pricePrimary;
      case 'declined':
        return MarketplaceDesignTokens.outOfStock;
      case 'sent':
        return Colors.blue;
      case 'received':
        return Colors.teal;
      case 'refunded':
        return MarketplaceDesignTokens.inStock;
      case 'solved':
        return Colors.grey;
      default:
        return Colors.grey;
    }
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
