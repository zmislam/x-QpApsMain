import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/seller_insights_controller.dart';

class SellerInsightsView extends GetView<SellerInsightsController> {
  const SellerInsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: controller.fetchInsights,
        child: ListView(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.sectionSpacing),
          children: [
            // ── Period selector ──
            _PeriodSelector(context),
            const SizedBox(height: 16),

            // ── Summary cards ──
            _SummaryRow(context),
            const SizedBox(height: 16),

            // ── Trend chart ──
            if (controller.dailyTrend.isNotEmpty) ...[
              _TrendChart(context),
              const SizedBox(height: 16),
            ],

            // ── Top products ──
            if (controller.topProducts.isNotEmpty) _TopProducts(context),
          ],
        ),
      );
    });
  }

  // ── Period Selector ──
  Widget _PeriodSelector(BuildContext ctx) {
    return Obx(() => Row(
          children: ['7d', '30d', '90d'].map((p) {
            final active = controller.period.value == p;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_periodLabel(p)),
                selected: active,
                onSelected: (_) => controller.changePeriod(p),
                selectedColor:
                    MarketplaceDesignTokens.primary.withValues(alpha: 0.12),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active
                      ? MarketplaceDesignTokens.primary
                      : MarketplaceDesignTokens.textSecondary(ctx),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MarketplaceDesignTokens.radiusSm),
                ),
              ),
            );
          }).toList(),
        ));
  }

  String _periodLabel(String p) {
    switch (p) {
      case '7d':
        return '7 Days';
      case '30d':
        return '30 Days';
      case '90d':
        return '90 Days';
      default:
        return p;
    }
  }

  // ── Summary Row ──
  Widget _SummaryRow(BuildContext ctx) {
    return Row(
      children: [
        _MetricCard(
          ctx,
          'Views',
          _fmtNum(controller.totalViews.value),
          controller.viewsChange.value,
          Icons.visibility_outlined,
        ),
        const SizedBox(width: 10),
        _MetricCard(
          ctx,
          'Saves',
          _fmtNum(controller.totalSaves.value),
          controller.savesChange.value,
          Icons.bookmark_outline,
        ),
        const SizedBox(width: 10),
        _MetricCard(
          ctx,
          'Shares',
          _fmtNum(controller.totalShares.value),
          controller.sharesChange.value,
          Icons.share_outlined,
        ),
      ],
    );
  }

  Widget _MetricCard(
      BuildContext ctx, String label, String value, double change, IconData icon) {
    final isPositive = change >= 0;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        decoration: MarketplaceDesignTokens.cardDecoration(ctx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                size: 20, color: MarketplaceDesignTokens.textSecondary(ctx)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: MarketplaceDesignTokens.textPrimary(ctx),
                )),
            const SizedBox(height: 4),
            Text(label,
                style: MarketplaceDesignTokens.cardSubtext(ctx)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                Text(
                  '${change.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Trend Chart ──
  Widget _TrendChart(BuildContext ctx) {
    final data = controller.dailyTrend;
    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      spots.add(
          FlSpot(i.toDouble(), (data[i]['views'] as num?)?.toDouble() ?? 0));
    }

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Views Trend',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
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
                      interval:
                          (data.length / 5).ceilToDouble().clamp(1, 30),
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
                    spots: spots,
                    isCurved: true,
                    color: MarketplaceDesignTokens.primary,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: MarketplaceDesignTokens.primary
                          .withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Products ──
  Widget _TopProducts(BuildContext ctx) {
    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(ctx),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Products',
              style: MarketplaceDesignTokens.sectionTitle(ctx)),
          const SizedBox(height: 12),
          ...controller.topProducts.asMap().entries.map((e) {
            final i = e.key;
            final p = e.value;
            final name = p['product_name']?.toString() ?? 'Product';
            final views = (p['views'] as num?) ?? 0;
            final saves = (p['saves'] as num?) ?? 0;
            final shares = (p['shares'] as num?) ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text('${i + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: i < 3
                              ? MarketplaceDesignTokens.primary
                              : MarketplaceDesignTokens.textSecondary(ctx),
                        )),
                  ),
                  Expanded(
                    child: Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: MarketplaceDesignTokens.bodyTextSmall(ctx)),
                  ),
                  _MiniStat(Icons.visibility_outlined, _fmtNum(views.toInt()), ctx),
                  const SizedBox(width: 12),
                  _MiniStat(Icons.bookmark_outline, _fmtNum(saves.toInt()), ctx),
                  const SizedBox(width: 12),
                  _MiniStat(Icons.share_outlined, _fmtNum(shares.toInt()), ctx),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _MiniStat(IconData icon, String val, BuildContext ctx) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 13, color: MarketplaceDesignTokens.textSecondary(ctx)),
        const SizedBox(width: 2),
        Text(val,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: MarketplaceDesignTokens.textPrimary(ctx),
            )),
      ],
    );
  }

  String _fmtNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
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
