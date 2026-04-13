import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';

/// Horizontal scrollable status filter chips for orders.
class OrderStatusFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  const OrderStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  static const _filters = [
    {'key': '', 'label': 'All'},
    {'key': 'pending', 'label': 'Pending'},
    {'key': 'onprocessing', 'label': 'Processing'},
    {'key': 'accepted', 'label': 'Accepted'},
    {'key': 'delivered', 'label': 'Delivered'},
    {'key': 'canceled', 'label': 'Cancelled'},
    {'key': 'refund', 'label': 'Refund'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MarketplaceDesignTokens.chipHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = selectedStatus == filter['key'];
          return GestureDetector(
            onTap: () => onStatusChanged(filter['key']!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? MarketplaceDesignTokens.pricePrimary
                    : MarketplaceDesignTokens.cardBg(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? MarketplaceDesignTokens.pricePrimary
                      : MarketplaceDesignTokens.cardBorder(context),
                ),
              ),
              child: Text(
                filter['label']!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : MarketplaceDesignTokens.textPrimary(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
