import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/commission_summary_controller.dart';

class CommissionSummaryView extends GetView<CommissionSummaryController> {
  const CommissionSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
          children: [
            _RateCard(context),
            const SizedBox(height: 16),
            _SummaryCard(context),
            const SizedBox(height: 16),
            _BreakdownCard(context),
          ],
        ),
      );
    });
  }

  // ── Rate Card ──
  Widget _RateCard(BuildContext ctx) {
    final tier = controller.tier;
    final rate = controller.commissionRate.value;
    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: MarketplaceDesignTokens.primary.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusMd),
            ),
            child: Center(
              child: Text('$rate%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: MarketplaceDesignTokens.primary,
                  )),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Commission Rate',
                    style: MarketplaceDesignTokens.sectionTitle(ctx)),
                const SizedBox(height: 4),
                Text(
                  '${tier.capitalizeFirst} tier — $rate% per sale',
                  style: MarketplaceDesignTokens.cardSubtext(ctx),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary Card ──
  Widget _SummaryCard(BuildContext ctx) {
    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This Month',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatTile(ctx, 'Revenue',
                  '€${controller.monthlyRevenue.toStringAsFixed(2)}'),
              _StatTile(ctx, 'Commission',
                  '€${controller.monthlyCommission.toStringAsFixed(2)}'),
              _StatTile(ctx, 'Net Earnings',
                  '€${controller.monthlyNetEarnings.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  // ── Breakdown Card ──
  Widget _BreakdownCard(BuildContext ctx) {
    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('All-time Summary',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 12),
          _DetailRow(ctx, 'Total Revenue',
              '€${controller.totalRevenue.toStringAsFixed(2)}'),
          _DetailRow(ctx, 'Total Commission',
              '-€${controller.totalCommission.toStringAsFixed(2)}',
              color: Colors.red),
          const Divider(height: 20),
          _DetailRow(ctx, 'Net Earnings',
              '€${controller.netEarnings.toStringAsFixed(2)}',
              bold: true, color: MarketplaceDesignTokens.inStock),
          const SizedBox(height: 16),
          Text('Tier Benefits',
              style: MarketplaceDesignTokens.bodyText(ctx)
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _TierRow(ctx, 'Bronze', '5%', controller.tier == 'bronze'),
          _TierRow(ctx, 'Silver', '4%', controller.tier == 'silver'),
          _TierRow(ctx, 'Gold', '3%', controller.tier == 'gold'),
          _TierRow(ctx, 'Platinum', '2%', controller.tier == 'platinum'),
        ],
      ),
    );
  }

  Widget _StatTile(BuildContext ctx, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: MarketplaceDesignTokens.textPrimary(ctx),
              )),
          const SizedBox(height: 2),
          Text(label, style: MarketplaceDesignTokens.cardSubtext(ctx)),
        ],
      ),
    );
  }

  Widget _DetailRow(BuildContext ctx, String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: MarketplaceDesignTokens.bodyTextSmall(ctx)),
          Text(value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                color: color ?? MarketplaceDesignTokens.textPrimary(ctx),
              )),
        ],
      ),
    );
  }

  Widget _TierRow(BuildContext ctx, String name, String rate, bool active) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? MarketplaceDesignTokens.primary : Colors.grey[300],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active
                      ? MarketplaceDesignTokens.primary
                      : MarketplaceDesignTokens.textPrimary(ctx),
                )),
          ),
          Text(rate,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MarketplaceDesignTokens.textSecondary(ctx),
              )),
        ],
      ),
    );
  }
}
