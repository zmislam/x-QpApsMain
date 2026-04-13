import 'package:flutter/material.dart';
import '../../../../config/constants/marketplace_design_tokens.dart';

/// A pill-shaped status badge (e.g. "Pending", "Delivered", "Cancelled").
/// Color is automatically applied based on order/refund status.
class StatusBadge extends StatelessWidget {
  final String status;
  final Color? color;
  final bool isRefund;

  const StatusBadge({
    super.key,
    required this.status,
    this.color,
    this.isRefund = false,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ??
        (isRefund
            ? MarketplaceDesignTokens.refundStatusColor(status)
            : MarketplaceDesignTokens.orderStatusColor(status));

    final label = isRefund
        ? _capitalizeFirst(status)
        : MarketplaceDesignTokens.orderStatusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: MarketplaceDesignTokens.badge.copyWith(color: badgeColor),
      ),
    );
  }

  String _capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}
