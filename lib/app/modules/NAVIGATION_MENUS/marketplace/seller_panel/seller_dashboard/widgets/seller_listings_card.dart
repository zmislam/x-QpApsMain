import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../models/seller_dashboard_model.dart';

/// Listing stats breakdown: Needs Attention, Active, Sold, Drafts, etc.
class SellerListingsCard extends StatelessWidget {
  final SellerListings listings;

  const SellerListingsCard({super.key, required this.listings});

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
              Icon(Icons.inventory_2_outlined,
                  size: 18, color: MarketplaceDesignTokens.pricePrimary),
              const SizedBox(width: 6),
              Text(
                'Listings Overview',
                style: MarketplaceDesignTokens.bodyText(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                '${listings.total} total',
                style: MarketplaceDesignTokens.statLabel(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ListingRow(
            label: 'Needs Attention',
            count: listings.needsAttention,
            color: MarketplaceDesignTokens.outOfStock,
            icon: Icons.warning_amber_rounded,
          ),
          _ListingRow(
            label: 'Active / Pending',
            count: listings.activePending,
            color: MarketplaceDesignTokens.inStock,
            icon: Icons.check_circle_outline,
          ),
          _ListingRow(
            label: 'Sold / Out of Stock',
            count: listings.soldOutOfStock,
            color: MarketplaceDesignTokens.lowStock,
            icon: Icons.remove_shopping_cart_outlined,
          ),
          _ListingRow(
            label: 'Drafts',
            count: listings.drafts,
            color: MarketplaceDesignTokens.textSecondary(context),
            icon: Icons.edit_note,
          ),
        ],
      ),
    );
  }
}

class _ListingRow extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _ListingRow({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: MarketplaceDesignTokens.bodyTextSmall(context),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
