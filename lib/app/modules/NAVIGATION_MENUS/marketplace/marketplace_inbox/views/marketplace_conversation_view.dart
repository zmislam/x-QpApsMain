import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../config/constants/marketplace_design_tokens.dart';
import '../../../../../config/constants/api_constant.dart';
import '../controllers/marketplace_conversation_controller.dart';

class MarketplaceConversationView
    extends GetView<MarketplaceConversationController> {
  const MarketplaceConversationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  MarketplaceDesignTokens.primary.withValues(alpha: 0.1),
              backgroundImage: controller.otherUser?.profileImage != null &&
                      controller.otherUser!.profileImage!.isNotEmpty
                  ? NetworkImage(
                      '${ApiConstant.BASE_URL}${controller.otherUser!.profileImage!}')
                  : null,
              child: controller.otherUser?.profileImage == null ||
                      controller.otherUser!.profileImage!.isEmpty
                  ? const Icon(Icons.person,
                      color: MarketplaceDesignTokens.primary, size: 16)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.otherUser?.displayName ?? 'User',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: MarketplaceDesignTokens.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (controller.product?.productName != null)
                    Text(
                      controller.product!.productName!,
                      style: TextStyle(
                        fontSize: 11,
                        color: MarketplaceDesignTokens.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: MarketplaceDesignTokens.cardBg(context),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Product preview bar
          if (controller.product != null) _buildProductBar(context),

          // Messages
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: MarketplaceDesignTokens.primary,
                  ),
                );
              }

              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet. Send the first message!',
                    style: MarketplaceDesignTokens.cardSubtext(context),
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.sender?.id == controller.currentUserId;
                  return _buildBubble(context, msg, isMe);
                },
              );
            }),
          ),

          // Compose bar
          _buildComposeBar(context),
        ],
      ),
    );
  }

  Widget _buildProductBar(BuildContext context) {
    final p = controller.product!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.cardBg(context),
        border: Border(
          bottom: BorderSide(
              color: MarketplaceDesignTokens.divider(context)),
        ),
      ),
      child: Row(
        children: [
          if (p.firstImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                '${ApiConstant.BASE_URL}${p.firstImage!}',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 36,
                  height: 36,
                  color: MarketplaceDesignTokens.cardBorder(context),
                  child: const Icon(Icons.image, size: 18),
                ),
              ),
            ),
          if (p.firstImage != null) const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.productName ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MarketplaceDesignTokens.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (p.sellPrice != null)
                  Text(
                    '\$${(p.sellPrice! / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: MarketplaceDesignTokens.pricePrimary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(BuildContext context, dynamic msg, bool isMe) {
    final time = msg.createdAt != null
        ? '${msg.createdAt!.hour.toString().padLeft(2, '0')}:${msg.createdAt!.minute.toString().padLeft(2, '0')}'
        : '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isMe ? 48 : 0,
          right: isMe ? 0 : 48,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? MarketplaceDesignTokens.primary
              : MarketplaceDesignTokens.cardBg(context),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe
              ? null
              : Border.all(
                  color: MarketplaceDesignTokens.cardBorder(context)),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.message ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isMe
                    ? Colors.white
                    : MarketplaceDesignTokens.textPrimary(context),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe
                        ? Colors.white70
                        : MarketplaceDesignTokens.textSecondary(context),
                  ),
                ),
                if (isMe && msg.read == true) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComposeBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: MarketplaceDesignTokens.cardBg(context),
        border: Border(
          top: BorderSide(
            color: MarketplaceDesignTokens.divider(context),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: MarketplaceDesignTokens.cardSubtext(context),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => IconButton(
                onPressed:
                    controller.isSending.value ? null : controller.sendMessage,
                icon: controller.isSending.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: MarketplaceDesignTokens.primary,
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: MarketplaceDesignTokens.primary,
                      ),
              )),
        ],
      ),
    );
  }
}
