import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../components/shimmer_loaders/marketplace_list_shimmer_loader.dart';
import '../../../../../config/constants/api_constant.dart';
import '../controllers/marketplace_inbox_controller.dart';

class MarketplaceInboxView extends GetView<MarketplaceInboxController> {
  const MarketplaceInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inbox',
          style: MarketplaceDesignTokens.sectionTitle(context)
              .copyWith(fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
        elevation: 0,
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: MarketplaceDesignTokens.pricePrimary,
          unselectedLabelColor:
              MarketplaceDesignTokens.textSecondary(context),
          indicatorColor: MarketplaceDesignTokens.pricePrimary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Buying'),
            Tab(text: 'Selling'),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const MarketplaceListShimmerLoader();
        }

        if (controller.conversations.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          color: MarketplaceDesignTokens.primary,
          child: ListView.separated(
            controller: controller.scrollController,
            padding:
                const EdgeInsets.all(MarketplaceDesignTokens.cardPadding),
            itemCount: controller.conversations.length +
                (controller.hasMore.value ? 1 : 0),
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: MarketplaceDesignTokens.divider(context)),
            itemBuilder: (context, index) {
              if (index >= controller.conversations.length) {
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
              return _buildConversationTile(
                  context, controller.conversations[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildConversationTile(BuildContext context, dynamic conversation) {
    final c = conversation;
    final hasUnread = c.unreadCount > 0;
    final timeAgo = c.lastMessageAt != null
        ? timeago.format(c.lastMessageAt!)
        : '';
    final productImage = c.product?.firstImage;

    return InkWell(
      onTap: () => controller.openConversation(c),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // User avatar / product thumbnail
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: MarketplaceDesignTokens.primary
                      .withValues(alpha: 0.1),
                  backgroundImage: c.otherUser?.profileImage != null &&
                          c.otherUser!.profileImage!.isNotEmpty
                      ? NetworkImage(
                          '${ApiConstant.BASE_URL}${c.otherUser!.profileImage!}')
                      : null,
                  child: c.otherUser?.profileImage == null ||
                          c.otherUser!.profileImage!.isEmpty
                      ? Icon(Icons.person,
                          color: MarketplaceDesignTokens.primary, size: 24)
                      : null,
                ),
                // Product thumbnail overlay
                if (productImage != null)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: MarketplaceDesignTokens.cardBg(context),
                          width: 1.5,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                              '${ApiConstant.BASE_URL}$productImage'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
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
                          c.otherUser?.displayName ?? 'User',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                hasUnread ? FontWeight.w700 : FontWeight.w500,
                            color: MarketplaceDesignTokens.textPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: MarketplaceDesignTokens.cardSubtext(context)
                            .copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Product name
                  if (c.product?.productName != null)
                    Text(
                      c.product!.productName!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: MarketplaceDesignTokens.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.lastMessage ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: hasUnread
                                ? MarketplaceDesignTokens.textPrimary(context)
                                : MarketplaceDesignTokens.textSecondary(
                                    context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: MarketplaceDesignTokens.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${c.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Order status chip
                  if (c.orderStatus != null && c.orderStatus!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: MarketplaceDesignTokens.orderStatusColor(
                                c.orderStatus)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        MarketplaceDesignTokens.orderStatusLabel(c.orderStatus),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: MarketplaceDesignTokens.orderStatusColor(
                              c.orderStatus),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 64,
            color: MarketplaceDesignTokens.textSecondary(context)
                .withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: MarketplaceDesignTokens.sectionTitle(context)
                .copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Start a conversation from a product page',
            style: MarketplaceDesignTokens.cardSubtext(context),
          ),
        ],
      ),
    );
  }
}
