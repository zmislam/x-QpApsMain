import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../components/shimmer_loaders/marketplace_list_shimmer_loader.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/seller_announcements_controller.dart';

class SellerAnnouncementsView
    extends GetView<SellerAnnouncementsController> {
  const SellerAnnouncementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcements',
          style: MarketplaceDesignTokens.sectionTitle(context)
              .copyWith(fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const MarketplaceListShimmerLoader();
        }

        if (controller.announcements.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAnnouncements,
          color: MarketplaceDesignTokens.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
            itemCount: controller.announcements.length +
                (controller.hasMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= controller.announcements.length) {
                // Load more trigger
                controller.loadMore();
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
              return _buildAnnouncementCard(
                  context, controller.announcements[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, dynamic announcement) {
    final a = announcement;
    final color = _typeColor(a.type);
    final icon = _typeIcon(a.type);
    final timeAgo =
        a.publishedAt != null ? timeago.format(a.publishedAt!) : '';

    return Container(
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.cardBg(context),
        borderRadius:
            BorderRadius.circular(MarketplaceDesignTokens.cardRadius),
        border: Border.all(color: MarketplaceDesignTokens.cardBorder(context)),
        boxShadow: const [MarketplaceDesignTokens.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar with type color
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft:
                    Radius.circular(MarketplaceDesignTokens.cardRadius),
                topRight:
                    Radius.circular(MarketplaceDesignTokens.cardRadius),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _typeLabel(a.type),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                if (timeAgo.isNotEmpty)
                  Text(
                    timeAgo,
                    style: MarketplaceDesignTokens.cardSubtext(context)
                        .copyWith(fontSize: 11),
                  ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  a.body,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
                if (a.expiresAt != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: MarketplaceDesignTokens.textSecondary(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Expires ${timeago.format(a.expiresAt!)}',
                        style: MarketplaceDesignTokens.cardSubtext(context)
                            .copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 64,
            color: MarketplaceDesignTokens.textSecondary(context)
                .withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No announcements',
            style: MarketplaceDesignTokens.sectionTitle(context)
                .copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Check back later for updates',
            style: MarketplaceDesignTokens.cardSubtext(context),
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'warning':
        return const Color(0xFFFB8C00);
      case 'promotion':
        return const Color(0xFF307777);
      case 'info':
      default:
        return const Color(0xFF1877F2);
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'warning':
        return Icons.warning_amber_outlined;
      case 'promotion':
        return Icons.local_offer_outlined;
      case 'info':
      default:
        return Icons.info_outline;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'warning':
        return 'WARNING';
      case 'promotion':
        return 'PROMOTION';
      case 'info':
      default:
        return 'INFO';
    }
  }
}
