import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../utils/currency_helper.dart';
import '../../../components/status_badge.dart';
import '../controllers/buyer_refunds_controller.dart';
import '../models/refund_model.dart';
import '../widgets/refund_chat_section.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../../config/constants/api_constant.dart';

/// Full refund detail page — shows refund info, items, images, + embedded chat.
class RefundDetailView extends StatefulWidget {
  const RefundDetailView({super.key});

  @override
  State<RefundDetailView> createState() => _RefundDetailViewState();
}

class _RefundDetailViewState extends State<RefundDetailView> {
  late final BuyerRefundsController controller;
  late final String refundId;

  @override
  void initState() {
    super.initState();
    controller = Get.find<BuyerRefundsController>();
    refundId = Get.arguments?['refundId'] as String? ?? '';
    if (refundId.isNotEmpty) {
      controller.fetchRefundDetail(refundId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: MarketplaceDesignTokens.primary,
            ),
          );
        }

        final detail = controller.refundDetail.value;
        if (detail == null) {
          return Center(
            child: Text(
              'Refund not found',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.6),
              ),
            ),
          );
        }

        return ListView(
          children: [
            // ─── Status Header ──────────────────────────────
            _buildStatusHeader(context, detail),

            // ─── Store Info ─────────────────────────────────
            if (detail.store != null) _buildStoreSection(context, detail.store!),

            // ─── Refund Items ───────────────────────────────
            if (detail.refundDetails.isNotEmpty)
              _buildItemsSection(context, detail.refundDetails),

            // ─── Note ───────────────────────────────────────
            if (detail.note != null && detail.note!.isNotEmpty)
              _buildNoteSection(context, detail.note!),

            // ─── Attached Images ────────────────────────────
            if (detail.images.isNotEmpty)
              _buildImagesSection(context, detail.images),

            // ─── Delivery Charge ────────────────────────────
            if (detail.deliveryCharge > 0)
              _buildInfoRow(
                context,
                label: 'Delivery Charge',
                value: CurrencyHelper.formatPrice(detail.deliveryCharge),
              ),

            // ─── Summary ────────────────────────────────────
            _buildSummarySection(context, detail),

            const Divider(height: 32),

            // ─── Refund Chat ────────────────────────────────
            RefundChatSection(refundId: refundId),

            const SizedBox(height: 24),
          ],
        );
      }),
    );
  }

  Widget _buildStatusHeader(BuildContext context, RefundDetailModel detail) {
    return Container(
      margin: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
        boxShadow: MarketplaceDesignTokens.shadowSm(context),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: MarketplaceDesignTokens.refundStatusColor(
                      detail.status ?? 'pending')
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(
                  MarketplaceDesignTokens.radiusSm),
            ),
            child: Icon(
              Icons.replay_outlined,
              size: 24,
              color: MarketplaceDesignTokens.refundStatusColor(
                  detail.status ?? 'pending'),
            ),
          ),
          const SizedBox(width: MarketplaceDesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(status: detail.status ?? 'pending'),
                const SizedBox(height: 4),
                if (detail.createdAt != null)
                  Text(
                    'Submitted ${_formatDate(detail.createdAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreSection(BuildContext context, RefundStore store) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: MarketplaceDesignTokens.spacingMd,
      ),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.store_outlined,
              size: 18,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          Text(
            store.name ?? 'Unknown Store',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(
      BuildContext context, List<RefundDetailItem> items) {
    return Container(
      margin: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
        boxShadow: MarketplaceDesignTokens.shadowSm(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              MarketplaceDesignTokens.spacingMd,
              MarketplaceDesignTokens.spacingMd,
              MarketplaceDesignTokens.spacingMd,
              MarketplaceDesignTokens.spacingXs,
            ),
            child: Text(
              'Refund Items (${items.length})',
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          ...items.map((item) => _buildItemTile(context, item)),
        ],
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, RefundDetailItem item) {
    final productName =
        item.product?.productName ?? 'Unknown Product';
    final firstMedia = item.product?.media.isNotEmpty == true
        ? '${ApiConstant.SERVER_IP_PORT}/uploads/products/${item.product!.media.first}'
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MarketplaceDesignTokens.spacingMd,
        vertical: MarketplaceDesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: firstMedia != null
                ? Image.network(
                    firstMedia,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
          const SizedBox(width: MarketplaceDesignTokens.spacingSm),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (item.productVariant != null &&
                    item.productVariant!.displayText.isNotEmpty)
                  Text(
                    item.productVariant!.displayText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.6),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Qty: ${item.refundQuantity}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      CurrencyHelper.formatPrice(item.sellPrice),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: MarketplaceDesignTokens.primary,
                      ),
                    ),
                  ],
                ),
                if (item.refundNote != null &&
                    item.refundNote!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Note: ${item.refundNote}',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 56,
      height: 56,
      color: Colors.grey.shade200,
      child: const Icon(Icons.inventory_2_outlined,
          size: 24, color: Colors.grey),
    );
  }

  Widget _buildNoteSection(BuildContext context, String note) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: MarketplaceDesignTokens.spacingMd,
      ),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: Colors.orange.shade50.withValues(alpha: 0.5),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.note_outlined, size: 16, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              note,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesSection(BuildContext context, List<String> images) {
    return Padding(
      padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attached Evidence',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image,
                            size: 24, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MarketplaceDesignTokens.spacingMd,
        vertical: MarketplaceDesignTokens.spacingXs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(
      BuildContext context, RefundDetailModel detail) {
    double totalRefund = 0;
    for (final item in detail.refundDetails) {
      totalRefund += item.sellPrice * item.refundQuantity;
    }
    totalRefund += detail.deliveryCharge;

    return Container(
      margin: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.primary.withValues(alpha: 0.05),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
        border: Border.all(
          color: MarketplaceDesignTokens.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Estimated Refund Amount',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            CurrencyHelper.formatPrice(totalRefund),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MarketplaceDesignTokens.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return timeago.format(date);
    } catch (_) {
      return dateStr;
    }
  }
}
