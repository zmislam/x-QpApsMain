import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../components/shimmer_loaders/marketplace_list_shimmer_loader.dart';
import '../controllers/marketplace_notifications_controller.dart';

class MarketplaceNotificationsView
    extends GetView<MarketplaceNotificationsController> {
  const MarketplaceNotificationsView({super.key});

  static const _filterTypes = <String?>[
    null, // All
    'new_order',
    'order_shipped',
    'order_delivered',
    'order_cancelled',
    'new_listing',
    'price_drop',
    'back_in_stock',
    'new_review',
    'new_question',
    'new_message',
    'low_stock',
    'listing_approved',
    'listing_rejected',
    'payout_processed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Marketplace Notifications',
          style: MarketplaceDesignTokens.sectionTitle(context)
              .copyWith(fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
        elevation: 0,
        actions: [
          Obx(() => controller.unreadCount.value > 0
              ? TextButton(
                  onPressed: controller.markAllAsRead,
                  child: Text(
                    'Mark all read',
                    style: TextStyle(
                      color: MarketplaceDesignTokens.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          // ─── Filter Chips ─────────────────────────────────
          _buildFilterChips(context),

          // ─── Notification List ────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const MarketplaceListShimmerLoader();
              }

              if (controller.notifications.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: controller.onRefresh,
                color: MarketplaceDesignTokens.primary,
                child: ListView.separated(
                  controller: controller.scrollController,
                  padding:
                      const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
                  itemCount: controller.notifications.length +
                      (controller.hasMore.value ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    if (index >= controller.notifications.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: MarketplaceDesignTokens.primary,
                            ),
                          ),
                        ),
                      );
                    }
                    return _buildNotificationTile(
                        context, controller.notifications[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─── Filter Chips Row ──────────────────────────────────────

  Widget _buildFilterChips(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Obx(() => ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _filterTypes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final type = _filterTypes[index];
              final isSelected = controller.selectedType.value == type;
              final label =
                  type == null ? 'All' : controller.labelForType(type);
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => controller.filterByType(type),
                selectedColor:
                    MarketplaceDesignTokens.primary.withValues(alpha: 0.15),
                labelStyle: TextStyle(
                  color: isSelected
                      ? MarketplaceDesignTokens.primary
                      : MarketplaceDesignTokens.textSecondary(context),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                backgroundColor: MarketplaceDesignTokens.cardBg(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? MarketplaceDesignTokens.primary
                        : MarketplaceDesignTokens.cardBorder(context),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            },
          )),
    );
  }

  // ─── Notification Tile ─────────────────────────────────────

  Widget _buildNotificationTile(
      BuildContext context, dynamic notification) {
    final n = notification;
    final iconColor = controller.iconColorForType(n.type);
    final createdAt = n.createdAt;
    final timeAgo = createdAt != null ? timeago.format(createdAt) : '';

    return Material(
      color: n.isRead
          ? MarketplaceDesignTokens.cardBg(context)
          : MarketplaceDesignTokens.primary.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
      child: InkWell(
        onTap: () => controller.onNotificationTap(n),
        borderRadius: BorderRadius.circular(MarketplaceDesignTokens.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon badge
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  controller.iconForType(n.type),
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      n.title ?? 'Notification',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            n.isRead ? FontWeight.w400 : FontWeight.w600,
                        color: MarketplaceDesignTokens.textPrimary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (n.body != null && n.body!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        n.body!,
                        style: MarketplaceDesignTokens.cardSubtext(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Type chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            controller.labelForType(n.type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: iconColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Time ago
                        Text(
                          timeAgo,
                          style:
                              MarketplaceDesignTokens.cardSubtext(context)
                                  .copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Unread dot
              if (!n.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4, left: 8),
                  decoration: const BoxDecoration(
                    color: MarketplaceDesignTokens.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: MarketplaceDesignTokens.textSecondary(context)
                .withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: MarketplaceDesignTokens.sectionTitle(context)
                .copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Marketplace updates will appear here',
            style: MarketplaceDesignTokens.cardSubtext(context),
          ),
        ],
      ),
    );
  }
}
