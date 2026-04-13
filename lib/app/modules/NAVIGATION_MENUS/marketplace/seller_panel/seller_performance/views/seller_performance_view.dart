import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/seller_performance_controller.dart';

class SellerPerformanceView extends GetView<SellerPerformanceController> {
  const SellerPerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.performance.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events_outlined,
                  size: 64,
                  color: MarketplaceDesignTokens.textSecondary(context)),
              const SizedBox(height: 16),
              Text('No performance data yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  )),
              const SizedBox(height: 8),
              Text('Start selling to build your performance record',
                  style: TextStyle(
                    fontSize: 14,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  )),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
          children: [
            _TierCard(context),
            const SizedBox(height: 16),
            _MetricsCard(context),
            const SizedBox(height: 16),
            _TierLadder(context),
          ],
        ),
      );
    });
  }

  // ━━━━━━━━━━━━━━━ Tier Card ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
  Widget _TierCard(BuildContext ctx) {
    final tier = controller.tier;
    final score = (controller.performance['score'] as num?)?.toInt() ?? 0;
    final commission = controller.commissionRate.value;

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(_tierIcon(tier), size: 56, color: _tierColor(tier)),
          const SizedBox(height: 12),
          Text(
            tier.capitalizeFirst ?? tier,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _tierColor(tier),
            ),
          ),
          const SizedBox(height: 4),
          Text('Seller Tier',
              style: MarketplaceDesignTokens.cardSubtext(ctx)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TierStat('Score', '$score', ctx),
              Container(
                  width: 1,
                  height: 30,
                  color: Theme.of(ctx).dividerColor.withValues(alpha: 0.3)),
              _TierStat('Commission', '$commission%', ctx),
            ],
          ),
        ],
      ),
    );
  }

  Widget _TierStat(String label, String value, BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: MarketplaceDesignTokens.textPrimary(ctx),
              )),
          const SizedBox(height: 2),
          Text(label,
              style: MarketplaceDesignTokens.cardSubtext(ctx)),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━ Metrics Card ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
  Widget _MetricsCard(BuildContext ctx) {
    final p = controller.performance;
    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Metrics',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 12),
          _MetricRow(
              ctx, 'Total Orders', '${(p['total_orders'] as num?) ?? 0}'),
          _MetricRow(ctx, 'Fulfilled',
              '${(p['fulfilled_orders'] as num?) ?? 0}'),
          _MetricBar(ctx, 'Fulfillment Rate',
              (p['fulfillment_rate'] as num?)?.toDouble() ?? 0),
          _MetricBar(ctx, 'On-time Delivery',
              (p['on_time_delivery_rate'] as num?)?.toDouble() ?? 0),
          _MetricRow(ctx, 'Avg Shipping',
              '${((p['avg_shipping_days'] as num?)?.toStringAsFixed(1)) ?? '--'} days'),
          _MetricRow(ctx, 'Avg Rating',
              '${((p['avg_rating'] as num?)?.toStringAsFixed(1)) ?? '--'} / 5'),
          _MetricRow(ctx, 'Response Time',
              '${((p['response_time_hours'] as num?)?.toStringAsFixed(1)) ?? '--'} hrs'),
          _MetricBar(ctx, 'Refund Rate',
              (p['refund_rate'] as num?)?.toDouble() ?? 0,
              invert: true),
        ],
      ),
    );
  }

  Widget _MetricRow(BuildContext ctx, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: MarketplaceDesignTokens.bodyTextSmall(ctx)),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MarketplaceDesignTokens.textPrimary(ctx),
              )),
        ],
      ),
    );
  }

  Widget _MetricBar(BuildContext ctx, String label, double pct,
      {bool invert = false}) {
    final clampedPct = pct.clamp(0, 100);
    final color = invert
        ? (clampedPct < 5
            ? Colors.green
            : clampedPct < 15
                ? Colors.orange
                : Colors.red)
        : (clampedPct >= 90
            ? Colors.green
            : clampedPct >= 70
                ? Colors.orange
                : Colors.red);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: MarketplaceDesignTokens.bodyTextSmall(ctx)),
              Text('${clampedPct.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: clampedPct / 100,
              backgroundColor:
                  Theme.of(ctx).dividerColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━ Tier Ladder ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
  Widget _TierLadder(BuildContext ctx) {
    final currentTier = controller.tier;
    final tiers = ['bronze', 'silver', 'gold', 'platinum'];
    final currentIdx = tiers.indexOf(currentTier);

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tier Ladder',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 12),
          ...tiers.reversed.map((t) {
            final idx = tiers.indexOf(t);
            final isCurrent = t == currentTier;
            final isAchieved = idx <= currentIdx;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAchieved
                          ? _tierColor(t).withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.1),
                      border: Border.all(
                        color: isCurrent
                            ? _tierColor(t)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      isAchieved ? Icons.check : Icons.lock_outline,
                      size: 14,
                      color: isAchieved
                          ? _tierColor(t)
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.capitalizeFirst ?? t,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isCurrent ? FontWeight.w700 : FontWeight.w400,
                        color: isCurrent
                            ? _tierColor(t)
                            : MarketplaceDesignTokens.textPrimary(ctx),
                      ),
                    ),
                  ),
                  Text(
                    _tierCommission(t),
                    style: TextStyle(
                      fontSize: 12,
                      color: MarketplaceDesignTokens.textSecondary(ctx),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Helpers ──
  IconData _tierIcon(String tier) {
    switch (tier) {
      case 'platinum':
        return Icons.diamond_outlined;
      case 'gold':
        return Icons.emoji_events;
      case 'silver':
        return Icons.workspace_premium;
      default:
        return Icons.shield_outlined;
    }
  }

  Color _tierColor(String tier) {
    switch (tier) {
      case 'platinum':
        return const Color(0xFF7C4DFF);
      case 'gold':
        return const Color(0xFFFFB300);
      case 'silver':
        return const Color(0xFF90A4AE);
      default:
        return const Color(0xFFCD7F32);
    }
  }

  String _tierCommission(String tier) {
    switch (tier) {
      case 'platinum':
        return '2% commission';
      case 'gold':
        return '3% commission';
      case 'silver':
        return '4% commission';
      default:
        return '5% commission';
    }
  }
}
