import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../routes/app_pages.dart';

/// Quick action grid per plan section 6.7:
/// [📦 Orders] [⭐ Reviews] [🔄 Returns] [🏬 Stores]
class BuyerQuickActions extends StatelessWidget {
  final Function(int tabIndex)? onSwitchTab;

  const BuyerQuickActions({super.key, this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: MarketplaceDesignTokens.sectionTitle(context),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ActionButton(
              icon: Icons.shopping_bag_outlined,
              label: 'Orders',
              color: MarketplaceDesignTokens.pricePrimary,
              onTap: () => onSwitchTab?.call(1),
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: Icons.star_border_rounded,
              label: 'Reviews',
              color: MarketplaceDesignTokens.ratingStarFill,
              onTap: () => onSwitchTab?.call(2),
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: Icons.replay_rounded,
              label: 'Returns',
              color: MarketplaceDesignTokens.orderRefund,
              onTap: () => onSwitchTab?.call(3),
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: Icons.storefront_outlined,
              label: 'Stores',
              color: MarketplaceDesignTokens.sellerBadge,
              onTap: () => Get.toNamed(Routes.MARKETPLACE),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
