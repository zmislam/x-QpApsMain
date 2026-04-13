import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';

/// Quick Actions grid: +Product, Orders, Payments, Store
class SellerQuickActions extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback onOrders;
  final VoidCallback onPayments;
  final VoidCallback onStore;

  const SellerQuickActions({
    super.key,
    required this.onAddProduct,
    required this.onOrders,
    required this.onPayments,
    required this.onStore,
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
              Icon(Icons.flash_on,
                  size: 18, color: MarketplaceDesignTokens.pricePrimary),
              const SizedBox(width: 6),
              Text(
                'Quick Actions',
                style: MarketplaceDesignTokens.bodyText(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionChip(
                  icon: Icons.add,
                  label: 'Product',
                  onTap: onAddProduct,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionChip(
                  icon: Icons.local_shipping_outlined,
                  label: 'Orders',
                  onTap: onOrders,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionChip(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Payments',
                  onTap: onPayments,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionChip(
                  icon: Icons.storefront_outlined,
                  label: 'Store',
                  onTap: onStore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: MarketplaceDesignTokens.pricePrimary.withValues(alpha: 0.08),
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: MarketplaceDesignTokens.pricePrimary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: MarketplaceDesignTokens.pricePrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
