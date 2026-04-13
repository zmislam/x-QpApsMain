import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/constants/marketplace_design_tokens.dart';
import '../controllers/buyer_refunds_controller.dart';
import '../models/refund_model.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Refund chat section — displayed inside RefundDetailView.
/// Shows message history + input bar for sending text/images.
class RefundChatSection extends StatelessWidget {
  final String refundId;

  const RefundChatSection({super.key, required this.refundId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerRefundsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header ───────────────────────────────────────
        Padding(
          padding:
              const EdgeInsets.all(MarketplaceDesignTokens.spacingMd),
          child: Row(
            children: [
              const Icon(Icons.chat_bubble_outline,
                  size: 18, color: MarketplaceDesignTokens.primary),
              const SizedBox(width: 8),
              Text(
                'Refund Chat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              // Refresh button
              GestureDetector(
                onTap: () => controller.fetchRefundChat(refundId),
                child: Icon(
                  Icons.refresh,
                  size: 20,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),

        // ─── Messages ─────────────────────────────────────
        Obx(() {
          if (controller.isLoadingChat.value) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: MarketplaceDesignTokens.primary),
              ),
            );
          }

          if (controller.chatMessages.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.forum_outlined,
                        size: 40,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.3)),
                    const SizedBox(height: 8),
                    Text(
                      'No messages yet',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      'Start a conversation about this refund',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: ListView.builder(
              controller: controller.chatScrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: MarketplaceDesignTokens.spacingMd,
              ),
              itemCount: controller.chatMessages.length,
              itemBuilder: (context, index) {
                final msg = controller.chatMessages[index];
                return _buildChatBubble(context, msg);
              },
            ),
          );
        }),

        // ─── Image Previews ───────────────────────────────
        Obx(() {
          if (controller.chatImages.isEmpty) return const SizedBox.shrink();
          return Container(
            height: 60,
            padding: const EdgeInsets.only(
              left: MarketplaceDesignTokens.spacingMd,
              bottom: 4,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.chatImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(controller.chatImages[index].path),
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: GestureDetector(
                          onTap: () =>
                              controller.removeChatImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),

        // ─── Input Bar ────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: MarketplaceDesignTokens.spacingMd,
            vertical: MarketplaceDesignTokens.spacingSm,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              // Image attach button
              GestureDetector(
                onTap: () => controller.pickChatImage(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: MarketplaceDesignTokens.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                        MarketplaceDesignTokens.radiusSm),
                  ),
                  child: const Icon(
                    Icons.attach_file,
                    size: 18,
                    color: MarketplaceDesignTokens.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Text input
              Expanded(
                child: TextField(
                  controller: controller.chatTextController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.4),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: MarketplaceDesignTokens.primary),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),

              // Send button
              Obx(() => GestureDetector(
                    onTap: controller.isSendingChat.value
                        ? null
                        : () => controller.sendChatMessage(refundId),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: controller.isSendingChat.value
                            ? Colors.grey.shade300
                            : MarketplaceDesignTokens.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: controller.isSendingChat.value
                          ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded,
                              size: 18, color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(BuildContext context, RefundChatMessage msg) {
    // Determine if this message is from the buyer (current user)
    final isBuyer = msg.sendBy != null && msg.adminId == null;
    final senderName = isBuyer
        ? (msg.sender?.fullName ?? 'You')
        : (msg.admin?.name ?? 'Support');

    return Padding(
      padding:
          const EdgeInsets.only(bottom: MarketplaceDesignTokens.spacingSm),
      child: Align(
        alignment: isBuyer ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isBuyer
                  ? MarketplaceDesignTokens.primary.withValues(alpha: 0.1)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isBuyer ? 12 : 2),
                bottomRight: Radius.circular(isBuyer ? 2 : 12),
              ),
              border: isBuyer
                  ? null
                  : Border.all(
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sender name
                Text(
                  senderName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isBuyer
                        ? MarketplaceDesignTokens.primary
                        : Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),

                // Message text
                if (msg.message != null && msg.message!.trim().isNotEmpty)
                  Text(
                    msg.message!,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),

                // Images
                if (msg.images.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: msg.images.map((img) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          img,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image,
                                size: 24, color: Colors.grey),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Timestamp
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _formatChatTime(msg.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatChatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return timeago.format(date, allowFromNow: true);
    } catch (_) {
      return dateStr;
    }
  }
}
