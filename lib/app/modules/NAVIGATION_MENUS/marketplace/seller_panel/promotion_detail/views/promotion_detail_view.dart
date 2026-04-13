import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/promotion_detail_controller.dart';

class PromotionDetailView extends GetView<PromotionDetailController> {
  const PromotionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Promotion Detail'), elevation: 0),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.promo.isEmpty) {
          return const Center(child: Text('Promotion not found'));
        }
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: ListView(
            padding:
                const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
            children: [
              _InfoCard(context),
              const SizedBox(height: 16),
              _TotalsCard(context),
              const SizedBox(height: 16),
              if (controller.dailyData.isNotEmpty) ...[
                _DailyChart(context, 'Impressions & Clicks', 'impressions',
                    'clicks'),
                const SizedBox(height: 16),
                _RevenueChart(context),
                const SizedBox(height: 16),
              ],
              if (controller.billing.isNotEmpty) _BillingCard(context),
            ],
          ),
        );
      }),
    );
  }

  // ━━━━━━━━━━━━━━━ Info Card ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
  Widget _InfoCard(BuildContext ctx) {
    final p = controller.promo;
    final type = p['promotion_type']?.toString() ?? '';
    final status = p['status']?.toString() ?? '';
    final product = p['product_id'];
    final store = p['store_id'];
    final productName =
        (product is Map ? product['product_name'] : null)?.toString() ?? '';
    final storeName =
        (store is Map ? store['name'] : null)?.toString() ?? '';
    final placements = (p['placements'] as List?)
            ?.map((e) => e.toString().replaceAll('_', ' ').capitalizeFirst)
            .join(', ') ??
        '';
    final billingType =
        (p['billing_type']?.toString() ?? '').replaceAll('_', ' ');
    final dailyBudget = (p['daily_budget_cents'] as num?) ?? 0;
    final totalBudget = (p['total_budget_cents'] as num?) ?? 0;
    final startDate = _shortDate(p['start_date']?.toString() ?? '');
    final endDate = _shortDate(p['end_date']?.toString() ?? '');

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type + status row
          Row(
            children: [
              Icon(_typeIcon(type),
                  size: 22, color: MarketplaceDesignTokens.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_typeLabel(type),
                    style: MarketplaceDesignTokens.sectionTitle(ctx)),
              ),
              _StatusBadge(status, controller.statusLabel(status)),
            ],
          ),
          const SizedBox(height: 12),
          if (productName.isNotEmpty) _Row('Product', productName, ctx),
          if (storeName.isNotEmpty) _Row('Store', storeName, ctx),
          _Row('Schedule', '$startDate – $endDate', ctx),
          _Row('Daily Budget',
              '€${(dailyBudget / 100).toStringAsFixed(2)}', ctx),
          _Row('Total Budget',
              '€${(totalBudget / 100).toStringAsFixed(2)}', ctx),
          _Row('Billing',
              billingType.isEmpty ? 'N/A' : billingType.capitalizeFirst!, ctx),
          if (placements.isNotEmpty) _Row('Placements', placements, ctx),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━ Totals Card ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
  Widget _TotalsCard(BuildContext ctx) {
    final t = controller.totals;
    // Fallback to promo-level totals if analytics totals empty
    final p = controller.promo;
    final imp = (t['impressions'] as num?) ??
        (p['total_impressions'] as num?) ??
        0;
    final clicks =
        (t['clicks'] as num?) ?? (p['total_clicks'] as num?) ?? 0;
    final purchases = (t['purchases'] as num?) ??
        (p['total_purchases'] as num?) ??
        0;
    final revCents = (t['purchase_revenue_cents'] as num?) ??
        (p['total_purchase_revenue_cents'] as num?) ??
        0;
    final costCents = (t['cost_cents'] as num?) ??
        (p['total_spent_cents'] as num?) ??
        0;
    final ctr = (t['ctr'] as num?) ?? 0;
    final convRate = (t['conversion_rate'] as num?) ?? 0;
    final roas = (t['roas'] as num?) ?? 0;

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Summary',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatTile('Impressions', _fmtNum(imp), ctx),
              _StatTile('Clicks', _fmtNum(clicks), ctx),
              _StatTile('CTR', '${ctr.toStringAsFixed(1)}%', ctx),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatTile('Purchases', _fmtNum(purchases), ctx),
              _StatTile('Revenue',
                  '€${(revCents / 100).toStringAsFixed(2)}', ctx),
              _StatTile('Cost',
                  '€${(costCents / 100).toStringAsFixed(2)}', ctx),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatTile('Conv. Rate', '${convRate.toStringAsFixed(1)}%', ctx),
              _StatTile('ROAS', '${roas.toStringAsFixed(2)}x', ctx),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━ Daily Chart (Impressions + Clicks) ━━━━━━━━━━━━━━━━━━━━━ //
  Widget _DailyChart(
      BuildContext ctx, String title, String key1, String key2) {
    final data = controller.dailyData;
    if (data.isEmpty) return const SizedBox.shrink();

    final spots1 = <FlSpot>[];
    final spots2 = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      spots1.add(FlSpot(
          i.toDouble(), (data[i][key1] as num?)?.toDouble() ?? 0));
      spots2.add(FlSpot(
          i.toDouble(), (data[i][key2] as num?)?.toDouble() ?? 0));
    }

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 8),
          Row(
            children: [
              _LegendDot(MarketplaceDesignTokens.primary, 'Impressions'),
              const SizedBox(width: 16),
              _LegendDot(Colors.orange, 'Clicks'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: (data.length / 5).ceilToDouble().clamp(1, 30),
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _chartDate(data[idx]['date']?.toString() ?? ''),
                          style: const TextStyle(fontSize: 9),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots1,
                    isCurved: true,
                    color: MarketplaceDesignTokens.primary,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: MarketplaceDesignTokens.primary
                          .withValues(alpha: 0.08),
                    ),
                  ),
                  LineChartBarData(
                    spots: spots2,
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━ Revenue Chart ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
  Widget _RevenueChart(BuildContext ctx) {
    final data = controller.dailyData;
    if (data.isEmpty) return const SizedBox.shrink();

    final bars = <BarChartGroupData>[];
    for (int i = 0; i < data.length; i++) {
      final rev = ((data[i]['purchase_revenue_cents'] as num?) ?? 0) / 100;
      final cost = ((data[i]['cost_cents'] as num?) ?? 0) / 100;
      bars.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
              toY: rev,
              width: 6,
              color: MarketplaceDesignTokens.inStock,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3))),
          BarChartRodData(
              toY: cost,
              width: 6,
              color: Colors.redAccent.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3))),
        ],
      ));
    }

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue vs Cost',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 8),
          Row(
            children: [
              _LegendDot(MarketplaceDesignTokens.inStock, 'Revenue'),
              const SizedBox(width: 16),
              _LegendDot(Colors.redAccent, 'Cost'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) {
                          return const SizedBox.shrink();
                        }
                        if (data.length > 10 && idx % 2 != 0) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _chartDate(data[idx]['date']?.toString() ?? ''),
                          style: const TextStyle(fontSize: 9),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: bars,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━ Billing Card ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
  Widget _BillingCard(BuildContext ctx) {
    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Billing Events',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 12),
          ...controller.billing.map((e) {
            final amount = (e['amount_cents'] as num?) ?? 0;
            final desc = e['description']?.toString() ?? '';
            final status = e['status']?.toString() ?? '';
            final date = _shortDate(e['createdAt']?.toString() ?? '');
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: status == 'succeeded'
                          ? MarketplaceDesignTokens.inStock
                          : status == 'failed'
                              ? Colors.red
                              : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(desc,
                            style:
                                MarketplaceDesignTokens.bodyTextSmall(ctx)),
                        Text(date,
                            style: TextStyle(
                                fontSize: 11,
                                color: MarketplaceDesignTokens.textSecondary(
                                    ctx))),
                      ],
                    ),
                  ),
                  Text(
                    '€${(amount / 100).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.textPrimary(ctx),
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

  // ━━━━━━━━━━ Private helpers ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
  Widget _Row(String label, String value, BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: MarketplaceDesignTokens.textSecondary(ctx))),
          ),
          Expanded(
              child: Text(value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: MarketplaceDesignTokens.textPrimary(ctx),
                  ))),
        ],
      ),
    );
  }

  Widget _StatTile(String label, String value, BuildContext ctx) {
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
          Text(label,
              style: TextStyle(
                fontSize: 11,
                color: MarketplaceDesignTokens.textSecondary(ctx),
              )),
        ],
      ),
    );
  }

  Widget _LegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'boost_product':
        return Icons.rocket_launch_outlined;
      case 'featured_product':
        return Icons.star_outline;
      case 'promote_store':
        return Icons.storefront_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'boost_product':
        return 'Boost Product';
      case 'featured_product':
        return 'Featured Product';
      case 'promote_store':
        return 'Promote Store';
      default:
        return type.capitalizeFirst ?? type;
    }
  }

  String _fmtNum(num n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  String _shortDate(String iso) {
    if (iso.isEmpty) return '--';
    try {
      final d = DateTime.parse(iso);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return '--';
    }
  }

  String _chartDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final d = DateTime.parse(iso);
      return '${d.day}/${d.month}';
    } catch (_) {
      return '';
    }
  }
}

// ── Status Badge ──
class _StatusBadge extends StatelessWidget {
  final String status;
  final String label;
  const _StatusBadge(this.status, this.label);

  Color get _color {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'draft':
        return Colors.blueGrey;
      case 'pending_review':
        return Colors.blue;
      case 'approved':
        return Colors.teal;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.purple;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: _color)),
    );
  }
}
