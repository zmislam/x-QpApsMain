import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/inventory_alerts_controller.dart';

class InventoryAlertsView extends GetView<InventoryAlertsController> {
  const InventoryAlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.alerts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 64,
                  color: MarketplaceDesignTokens.textSecondary(context)),
              const SizedBox(height: 16),
              Text('No inventory alerts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  )),
              const SizedBox(height: 8),
              Text('Your stock levels look good!',
                  style: TextStyle(
                    fontSize: 14,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  )),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchAlerts,
        child: ListView.separated(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
          itemCount: controller.alerts.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: MarketplaceDesignTokens.spacingSm),
          itemBuilder: (_, i) =>
              _AlertCard(alert: controller.alerts[i]),
        ),
      );
    });
  }
}

class _AlertCard extends StatelessWidget {
  final Map<String, dynamic> alert;
  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final type = alert['alert_type']?.toString() ?? '';
    final isOutOfStock = type == 'out_of_stock';
    final product = alert['product_id'];
    final productName =
        (product is Map ? product['product_name'] : null)?.toString() ??
            'Product';
    final currentStock = (alert['current_stock'] as num?) ?? 0;
    final threshold = (alert['threshold'] as num?) ?? 5;
    final isRead = alert['is_read'] == true;
    final createdAt = alert['createdAt']?.toString() ?? '';

    return Container(
      decoration: MarketplaceDesignTokens.cardDecoration(context),
      padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alert icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isOutOfStock ? Colors.red : Colors.orange)
                  .withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
            ),
            child: Icon(
              isOutOfStock
                  ? Icons.error_outline
                  : Icons.warning_amber_outlined,
              color: isOutOfStock ? Colors.red : Colors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isRead ? FontWeight.w400 : FontWeight.w600,
                          color:
                              MarketplaceDesignTokens.textPrimary(context),
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MarketplaceDesignTokens.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isOutOfStock
                      ? 'Out of stock'
                      : 'Low stock — $currentStock left (threshold: $threshold)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isOutOfStock ? Colors.red : Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                // Stock level bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: threshold > 0
                        ? (currentStock / threshold).clamp(0.0, 1.0)
                        : 0,
                    backgroundColor: Theme.of(context)
                        .dividerColor
                        .withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        isOutOfStock ? Colors.red : Colors.orange),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _timeAgo(createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(String iso) {
    if (iso.isEmpty) return '';
    try {
      final d = DateTime.parse(iso);
      final diff = DateTime.now().difference(d);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return '';
    }
  }
}
