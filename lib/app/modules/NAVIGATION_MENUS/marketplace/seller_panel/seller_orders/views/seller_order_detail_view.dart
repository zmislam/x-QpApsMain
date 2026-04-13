import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/seller_order_detail_controller.dart';

class SellerOrderDetailView extends GetView<SellerOrderDetailController> {
  const SellerOrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details',
            style: MarketplaceDesignTokens.heading(context)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
                color: MarketplaceDesignTokens.pricePrimary),
          );
        }
        if (controller.hasError.value || controller.order.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 64,
                    color: MarketplaceDesignTokens.textSecondary(context)),
                const SizedBox(height: 16),
                Text('Failed to load order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    )),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchOrderDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MarketplaceDesignTokens.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final o = controller.order.value!;
        return RefreshIndicator(
          onRefresh: controller.fetchOrderDetail,
          color: MarketplaceDesignTokens.pricePrimary,
          child: ListView(
            padding:
                const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
            children: [
              _StatusCard(context, o),
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),
              _ItemsCard(context, o),
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),
              _BuyerCard(context, o),
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),
              _AddressCard(context, o),
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),
              _SummaryCard(context, o),
              const SizedBox(height: MarketplaceDesignTokens.sectionSpacing),
              if (controller.canAcceptReject) ...[
                _ActionButtons(context),
                const SizedBox(
                    height: MarketplaceDesignTokens.sectionSpacing),
              ],
              _TrackingSection(context, o),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // ─── Status card ────────────────────────────────────────
  Widget _StatusCard(BuildContext context, Map<String, dynamic> o) {
    final status = o['status']?.toString() ?? 'unknown';
    final invoice = o['invoice_number']?.toString() ?? '';
    final date = o['createdAt']?.toString().split('T').first ?? '';
    final payMethod = o['payment_method']?.toString() ?? '';
    final Color statusColor;
    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'approved':
      case 'delivered':
        statusColor = MarketplaceDesignTokens.inStock;
        break;
      case 'rejected':
      case 'cancelled':
        statusColor = MarketplaceDesignTokens.outOfStock;
        break;
      default:
        statusColor = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text('Order #$invoice',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  )),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(
                    MarketplaceDesignTokens.radiusSm),
              ),
              child: Text(status.capitalizeFirst ?? status,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor)),
            ),
          ]),
          const SizedBox(height: 8),
          _InfoRow(context, 'Date', date),
          if (payMethod.isNotEmpty)
            _InfoRow(context, 'Payment', payMethod),
        ],
      ),
    );
  }

  // ─── Items card ─────────────────────────────────────────
  Widget _ItemsCard(BuildContext context, Map<String, dynamic> o) {
    final items = _extractItems(o);
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items',
              style: MarketplaceDesignTokens.sectionTitle(context)),
          const Divider(),
          ...items.map((item) {
            final name = item['product_name']?.toString() ??
                (item['product'] is Map
                    ? item['product']['product_name']?.toString()
                    : '') ??
                '';
            final qty = item['quantity']?.toString() ?? '1';
            final price = item['total_amount'] ?? item['sell_price'] ?? 0;
            final priceVal = price is num ? price : 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: MarketplaceDesignTokens.textPrimary(
                                  context),
                            )),
                        Text('Qty: $qty',
                            style:
                                MarketplaceDesignTokens.cardSubtext(context)),
                      ],
                    ),
                  ),
                  Text(
                      '€${(priceVal is int ? priceVal / 100 : (priceVal as num) / 100).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: MarketplaceDesignTokens.pricePrimary,
                      )),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Buyer info card ──────────────────────────────────────
  Widget _BuyerCard(BuildContext context, Map<String, dynamic> o) {
    final buyer = o['buyer'] is Map ? o['buyer'] as Map : {};
    final name = buyer['name']?.toString() ??
        '${buyer['first_name'] ?? ''} ${buyer['last_name'] ?? ''}'.trim();
    final email = buyer['email']?.toString() ?? '';
    if (name.isEmpty && email.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buyer', style: MarketplaceDesignTokens.sectionTitle(context)),
          const SizedBox(height: 8),
          if (name.isNotEmpty) _InfoRow(context, 'Name', name),
          if (email.isNotEmpty) _InfoRow(context, 'Email', email),
        ],
      ),
    );
  }

  // ─── Address card ───────────────────────────────────────
  Widget _AddressCard(BuildContext context, Map<String, dynamic> o) {
    final addr = o['shipping_address'] ?? o['address'];
    if (addr is! Map) return const SizedBox.shrink();
    final lines = <String>[
      addr['address']?.toString() ?? '',
      addr['city']?.toString() ?? '',
      addr['state']?.toString() ?? '',
      addr['country']?.toString() ?? '',
      addr['zip_code']?.toString() ?? '',
    ].where((s) => s.isNotEmpty).toList();
    if (lines.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shipping Address',
              style: MarketplaceDesignTokens.sectionTitle(context)),
          const SizedBox(height: 8),
          Text(lines.join(', '),
              style: MarketplaceDesignTokens.bodyText(context)),
        ],
      ),
    );
  }

  // ─── Summary card ───────────────────────────────────────
  Widget _SummaryCard(BuildContext context, Map<String, dynamic> o) {
    final subtotal = _num(o['subtotal'] ?? o['total_amount']);
    final vat = _num(o['vat_amount'] ?? o['vat']);
    final shipping = _num(o['shipping_cost']);
    final discount = _num(o['discount']);
    final total = _num(o['grand_total'] ?? o['total_amount']);
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary',
              style: MarketplaceDesignTokens.sectionTitle(context)),
          const SizedBox(height: 8),
          _SummaryRow(context, 'Subtotal', subtotal),
          if (vat > 0) _SummaryRow(context, 'VAT', vat),
          if (shipping > 0) _SummaryRow(context, 'Shipping', shipping),
          if (discount > 0)
            _SummaryRow(context, 'Discount', -discount),
          const Divider(),
          _SummaryRow(context, 'Total', total, bold: true),
        ],
      ),
    );
  }

  // ─── Actions (Accept / Reject) ──────────────────────────
  Widget _ActionButtons(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.isUpdating.value
                    ? null
                    : () => _showRejectDialog(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: MarketplaceDesignTokens.outOfStock,
                  side: const BorderSide(
                      color: MarketplaceDesignTokens.outOfStock),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm)),
                ),
                child: const Text('Reject',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isUpdating.value
                    ? null
                    : controller.acceptOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MarketplaceDesignTokens.inStock,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm)),
                ),
                child: controller.isUpdating.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Accept',
                        style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ));
  }

  // ─── Tracking section ───────────────────────────────────
  Widget _TrackingSection(BuildContext context, Map<String, dynamic> o) {
    final tracking = o['tracking_number']?.toString() ?? '';
    final courier = o['courier']?.toString() ?? '';
    final status = o['status']?.toString().toLowerCase() ?? '';
    final canUpdate =
        status == 'approved' || status == 'shipped' || status == 'processing';
    return Container(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tracking',
              style: MarketplaceDesignTokens.sectionTitle(context)),
          const SizedBox(height: 8),
          if (tracking.isNotEmpty) ...[
            _InfoRow(context, 'Tracking #', tracking),
            if (courier.isNotEmpty) _InfoRow(context, 'Courier', courier),
          ] else
            Text('No tracking info yet',
                style: MarketplaceDesignTokens.cardSubtext(context)),
          if (canUpdate) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showTrackingDialog(context),
                icon: const Icon(Icons.local_shipping_outlined, size: 18),
                label: Text(tracking.isEmpty
                    ? 'Add Tracking'
                    : 'Update Tracking'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: MarketplaceDesignTokens.primary,
                  side: const BorderSide(
                      color: MarketplaceDesignTokens.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MarketplaceDesignTokens.radiusSm)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Dialogs ────────────────────────────────────────────
  void _showRejectDialog(BuildContext context) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Order'),
        content: TextField(
          controller: reasonCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Reason for rejection...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.rejectOrder(reasonCtrl.text.trim());
            },
            child: const Text('Reject',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTrackingDialog(BuildContext context) {
    final trackCtrl = TextEditingController();
    final courierCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Tracking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: trackCtrl,
              decoration: const InputDecoration(
                labelText: 'Tracking Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: courierCtrl,
              decoration: const InputDecoration(
                labelText: 'Courier Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.updateTracking(
                  trackCtrl.text.trim(), courierCtrl.text.trim());
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────
  Widget _InfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: MarketplaceDesignTokens.cardSubtext(context)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: MarketplaceDesignTokens.textPrimary(context),
                )),
          ),
        ],
      ),
    );
  }

  Widget _SummaryRow(BuildContext context, String label, double amount,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: bold
                  ? TextStyle(
                      fontWeight: FontWeight.w700,
                      color: MarketplaceDesignTokens.textPrimary(context))
                  : MarketplaceDesignTokens.cardSubtext(context)),
          Text(
            '€${(amount / 100).toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: bold
                  ? MarketplaceDesignTokens.pricePrimary
                  : MarketplaceDesignTokens.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _extractItems(Map<String, dynamic> o) {
    // Try different response shapes
    final storeList = o['store_list'] ?? o['items'] ?? o['products'];
    if (storeList is List) {
      return storeList
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
    return [];
  }

  double _num(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }
}
