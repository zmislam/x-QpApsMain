import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../components/status_badge.dart';
import '../models/refund_model.dart';
import '../../../../../../utils/currency_helper.dart';
import 'package:timeago/timeago.dart' as timeago;

class RefundCard extends StatelessWidget {
  final RefundListItem refund;
  final VoidCallback? onTap;

  const RefundCard({
    super.key,
    required this.refund,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: MarketplaceDesignTokens.spacingSm),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
          boxShadow: MarketplaceDesignTokens.shadowSm(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header: Status + Date ─────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(status: refund.status ?? 'pending'),
                if (refund.createdAt != null)
                  Text(
                    _formatDate(refund.createdAt!),
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

            const SizedBox(height: MarketplaceDesignTokens.spacingSm),

            // ─── Store Info ─────────────────────────────────
            if (refund.store != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: 16,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      refund.store!.name ?? 'Unknown Store',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: MarketplaceDesignTokens.spacingXs),
            ],

            // ─── Refund Details Row ─────────────────────────
            Row(
              children: [
                // Product count
                _buildInfoChip(
                  context,
                  icon: Icons.inventory_2_outlined,
                  label: '${refund.productQuantity} item${refund.productQuantity != 1 ? "s" : ""}',
                ),
                const SizedBox(width: MarketplaceDesignTokens.spacingMd),
                // Delivery charge
                if (refund.deliveryCharge > 0)
                  _buildInfoChip(
                    context,
                    icon: Icons.local_shipping_outlined,
                    label: CurrencyHelper.formatPrice(refund.deliveryCharge),
                  ),
              ],
            ),

            // ─── Note Preview ───────────────────────────────
            if (refund.note != null && refund.note!.isNotEmpty) ...[
              const SizedBox(height: MarketplaceDesignTokens.spacingXs),
              Text(
                refund.note!,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // ─── Images Preview ─────────────────────────────
            if (refund.images.isNotEmpty) ...[
              const SizedBox(height: MarketplaceDesignTokens.spacingSm),
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    ...refund.images.take(3).map((img) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              img,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 44,
                                height: 44,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image,
                                    size: 20, color: Colors.grey),
                              ),
                            ),
                          ),
                        )),
                    if (refund.images.length > 3)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: MarketplaceDesignTokens.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '+${refund.images.length - 3}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: MarketplaceDesignTokens.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // ─── Footer: View Detail Arrow ──────────────────
            const SizedBox(height: MarketplaceDesignTokens.spacingSm),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: MarketplaceDesignTokens.primary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context,
      {required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14,
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.5)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7),
          ),
        ),
      ],
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
