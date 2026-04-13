import 'package:flutter/material.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../extension/date_time_extension.dart';
import '../models/buyer_access_status_model.dart';

class BuyerAccessStatusCard extends StatelessWidget {
  final BuyerAccessStatus status;

  const BuyerAccessStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
      ),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.shield_outlined,
                    size: 20, color: _statusColor),
                const SizedBox(width: 8),
                Text(
                  'Account Status',
                  style: MarketplaceDesignTokens.sectionTitle(context),
                ),
                const Spacer(),
                _buildVerificationBadge(context),
              ],
            ),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),

            // Profile Health Bar
            _buildHealthBar(context),
            const SizedBox(height: MarketplaceDesignTokens.spacingMd),

            // Stats Row
            Row(
              children: [
                _StatChip(
                  icon: Icons.store_outlined,
                  label: '${status.storeCount} Store${status.storeCount == 1 ? '' : 's'}',
                ),
                const SizedBox(width: MarketplaceDesignTokens.spacingSm),
                _StatChip(
                  icon: Icons.inventory_2_outlined,
                  label: '${status.listingCount} Listing${status.listingCount == 1 ? '' : 's'}',
                ),
                const SizedBox(width: MarketplaceDesignTokens.spacingSm),
                _StatChip(
                  icon: Icons.local_shipping_outlined,
                  label: '${status.activeOrders} Active',
                ),
              ],
            ),

            // Member Since
            if (status.memberSince != null) ...[
              const SizedBox(height: MarketplaceDesignTokens.spacingSm),
              Text(
                'Member since ${status.memberSince!.toFormatDateOfBirth()}',
                style: TextStyle(
                  fontSize: 12,
                  color: MarketplaceDesignTokens.textSecondary(context),
                ),
              ),
            ],

            // Missing items warning
            if (status.profileHealthMissing.isNotEmpty) ...[
              const SizedBox(height: MarketplaceDesignTokens.spacingMd),
              Container(
                padding: const EdgeInsets.all(
                    MarketplaceDesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Complete your profile: ${status.profileHealthMissing.map(_formatMissing).join(', ')}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _statusColor {
    if (status.profileHealthScore >= 80) return MarketplaceDesignTokens.primary;
    if (status.profileHealthScore >= 50) return Colors.amber;
    return Colors.red;
  }

  Widget _buildVerificationBadge(BuildContext context) {
    final isVerified = status.verificationStatus == 'approved';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isVerified
            ? MarketplaceDesignTokens.primary.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.verified : Icons.pending_outlined,
            size: 14,
            color: isVerified
                ? MarketplaceDesignTokens.primary
                : MarketplaceDesignTokens.textSecondary(context),
          ),
          const SizedBox(width: 4),
          Text(
            isVerified ? 'Verified' : 'Not Verified',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isVerified
                  ? MarketplaceDesignTokens.primary
                  : MarketplaceDesignTokens.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile Health',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MarketplaceDesignTokens.textPrimary(context),
              ),
            ),
            Text(
              '${status.profileHealthScore}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _statusColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: status.profileHealthScore / 100,
            backgroundColor: Colors.grey.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  String _formatMissing(String key) {
    return key.replaceAll('_', ' ').capitalize;
  }
}

extension _StringCap on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.cardBg(context),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: MarketplaceDesignTokens.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
