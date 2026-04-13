import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../../routes/app_pages.dart';
import '../controllers/seller_promotions_controller.dart';
import 'create_promotion_sheet.dart';

class SellerPromotionsView extends GetView<SellerPromotionsController> {
  const SellerPromotionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
        // ── Status Filter Chips ──
        SizedBox(
          height: MarketplaceDesignTokens.chipHeight + 16,
          child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: MarketplaceDesignTokens.cardPadding,
                    vertical: 8),
                children: [
                  _FilterChip(
                    label: 'All',
                    isActive: controller.statusFilter.value.isEmpty,
                    onTap: () => controller.onFilterChanged(''),
                  ),
                  for (final s in SellerPromotionsController.statusOptions)
                    if (s.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _FilterChip(
                          label: controller.statusLabel(s),
                          isActive: controller.statusFilter.value == s,
                          color: controller.statusColor(s),
                          onTap: () => controller.onFilterChanged(s),
                        ),
                      ),
                ],
              )),
        ),

        // ── Promotions List ──
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.promotions.isEmpty) {
              return _buildEmpty(context);
            }
            return RefreshIndicator(
              onRefresh: () => controller.fetchPromotions(refresh: true),
              child: ListView.separated(
                padding: const EdgeInsets.all(
                    MarketplaceDesignTokens.cardPadding),
                itemCount: controller.promotions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: MarketplaceDesignTokens.spacingSm),
                itemBuilder: (context, i) {
                  final promo = controller.promotions[i];
                  return _PromotionCard(promo: promo);
                },
              ),
            );
          }),
        ),
      ],
    ),
        // ── FAB: Create Promotion ──
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'createPromotion',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const CreatePromotionSheet(),
              );
            },
            backgroundColor: MarketplaceDesignTokens.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Promote',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined,
              size: 64,
              color: MarketplaceDesignTokens.textSecondary(context)),
          const SizedBox(height: 16),
          Text('No promotions yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: MarketplaceDesignTokens.textPrimary(context),
              )),
          const SizedBox(height: 8),
          Text('Boost your products to reach more buyers',
              style: TextStyle(
                fontSize: 14,
                color: MarketplaceDesignTokens.textSecondary(context),
              )),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━ Promotion Card ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
class _PromotionCard extends GetView<SellerPromotionsController> {
  final Map<String, dynamic> promo;
  const _PromotionCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    final id = promo['_id']?.toString() ?? '';
    final type = promo['promotion_type']?.toString() ?? '';
    final status = promo['status']?.toString() ?? '';
    final product = promo['product_id'];
    final store = promo['store_id'];
    final productName =
        (product is Map ? product['product_name'] : null)?.toString() ?? '';
    final storeName =
        (store is Map ? store['name'] : null)?.toString() ?? '';
    final dailyBudget = (promo['daily_budget_cents'] as num?) ?? 0;
    final totalBudget = (promo['total_budget_cents'] as num?) ?? 0;
    final totalSpent = (promo['total_spent_cents'] as num?) ?? 0;
    final impressions = (promo['total_impressions'] as num?) ?? 0;
    final clicks = (promo['total_clicks'] as num?) ?? 0;
    final startDate = promo['start_date']?.toString() ?? '';
    final endDate = promo['end_date']?.toString() ?? '';

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PROMOTION_DETAIL, arguments: id),
      child: Container(
        decoration: MarketplaceDesignTokens.cardDecoration(context),
        padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: type + status ──
            Row(
              children: [
                Icon(_typeIcon(type),
                    size: 20, color: MarketplaceDesignTokens.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _typeLabel(type),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.statusColor(status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.statusLabel(status),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: controller.statusColor(status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Product / Store name ──
            if (productName.isNotEmpty)
              Text(productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: MarketplaceDesignTokens.productName(context)),
            if (storeName.isNotEmpty)
              Text(storeName,
                  style: MarketplaceDesignTokens.cardSubtext(context)),
            const SizedBox(height: 10),

            // ── Budget + Performance row ──
            Row(
              children: [
                _Metric(
                    label: 'Budget',
                    value: '€${(totalBudget / 100).toStringAsFixed(2)}'),
                _Metric(
                    label: 'Spent',
                    value: '€${(totalSpent / 100).toStringAsFixed(2)}'),
                _Metric(label: 'Imp.', value: _formatNum(impressions)),
                _Metric(label: 'Clicks', value: _formatNum(clicks)),
              ],
            ),
            const SizedBox(height: 8),

            // ── Date range ──
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 13,
                    color: MarketplaceDesignTokens.textSecondary(context)),
                const SizedBox(width: 4),
                Text(
                  '${_shortDate(startDate)} – ${_shortDate(endDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '€${(dailyBudget / 100).toStringAsFixed(2)}/day',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MarketplaceDesignTokens.pricePrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Action buttons ──
            _ActionRow(id: id, status: status),
          ],
        ),
      ),
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

  String _formatNum(num n) {
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
}

// ━━━━━━━━━━━━━━━━ Action Row ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
class _ActionRow extends GetView<SellerPromotionsController> {
  final String id;
  final String status;
  const _ActionRow({required this.id, required this.status});

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];

    if (status == 'draft') {
      actions.add(_ActionBtn(
        label: 'Submit',
        icon: Icons.send_outlined,
        color: Colors.blue,
        onTap: () => controller.submitForReview(id),
      ));
    }
    if (status == 'active') {
      actions.add(_ActionBtn(
        label: 'Pause',
        icon: Icons.pause_circle_outline,
        color: Colors.orange,
        onTap: () => controller.pausePromotion(id),
      ));
    }
    if (status == 'paused') {
      actions.add(_ActionBtn(
        label: 'Resume',
        icon: Icons.play_circle_outline,
        color: Colors.green,
        onTap: () => controller.resumePromotion(id),
      ));
    }
    if (['draft', 'pending_review', 'approved', 'active', 'paused']
        .contains(status)) {
      actions.add(_ActionBtn(
        label: 'Cancel',
        icon: Icons.cancel_outlined,
        color: Colors.red,
        onTap: () => controller.cancelPromotion(id),
      ));
    }

    if (actions.isEmpty) return const SizedBox.shrink();

    return Row(children: actions);
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius:
                BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━ Metric Chip ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: MarketplaceDesignTokens.textPrimary(context),
              )),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                fontSize: 11,
                color: MarketplaceDesignTokens.textSecondary(context),
              )),
        ],
      ),
    );
  }
}

// ━━━━━━━━━━━━━━━━ Filter Chip ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ //
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color? color;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.isActive,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? MarketplaceDesignTokens.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius:
              BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
          border: Border.all(
            color: isActive
                ? activeColor
                : Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? activeColor
                : MarketplaceDesignTokens.textSecondary(context),
          ),
        ),
      ),
    );
  }
}
