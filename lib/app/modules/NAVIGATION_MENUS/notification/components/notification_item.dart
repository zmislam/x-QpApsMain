import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantum_possibilities_flutter/app/components/image.dart';
import 'package:quantum_possibilities_flutter/app/extension/string/string_image_path.dart';
import 'package:quantum_possibilities_flutter/app/models/notification.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../config/constants/app_assets.dart';
import '../../../../config/constants/color.dart';
import '../../../../enum/notification_type_enum.dart';
import '../controllers/notification_controller.dart';
import 'notification_options_bottom_sheet.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.model,
  });
  final NotificationModel model;

  @override
  Widget build(BuildContext context) {
    final isUnseen = !(model.notification_seen ?? false);
    final type = NotificationTypeEnum.fromString(model.notification_type);
    final bool hasActions = type.hasActionButtons && model.status == null;

    return Container(
      decoration: BoxDecoration(
        color: isUnseen
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.06)
            : Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image with overlay icon
          Stack(
            children: [
              RoundCornerNetworkImage(
                imageUrl: (model.notification_sender_id?.profile_pic ?? '')
                    .formatedProfileUrl,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 27,
                  width: 27,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    getIconPath(model),
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification text
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _getSenderDisplayName(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: getTextAsNotificationType(model),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    timeago.format(
                      DateTime.parse(
                          model.createdAt ?? DateTime.now().toIso8601String()),
                    ),
                    style: TextStyle(
                      color: isUnseen ? PRIMARY_COLOR : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),

                // Action buttons for actionable notifications
                if (hasActions) ...[
                  const SizedBox(height: 8),
                  _buildActionButtons(context, type),
                ],

                // Show status text if action already taken
                if (type.hasActionButtons && model.status != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      model.status == 'accept'
                          ? _getAcceptedText(type)
                          : _getDeclinedText(type),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
              ],
            ),
          ),

          // Three-dot menu
          InkWell(
            onTap: () => showNotificationOptionsBottomSheet(context, model),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.more_horiz, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// Build inline action buttons (Confirm/Delete, Join/Delete, Accept/Decline)
  Widget _buildActionButtons(BuildContext context, NotificationTypeEnum type) {
    final controller = Get.find<NotificationController>();

    switch (type) {
      case NotificationTypeEnum.FRIEND_REQUEST:
        return Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Confirm'.tr,
                isPrimary: true,
                onTap: () => controller.acceptFriendRequest(model),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionButton(
                label: 'Delete'.tr,
                isPrimary: false,
                onTap: () => controller.declineFriendRequest(model),
              ),
            ),
          ],
        );

      case NotificationTypeEnum.GROUP_INVITATION:
      case NotificationTypeEnum.GROUP_JOINING:
        return Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Join'.tr,
                isPrimary: true,
                onTap: () => controller.acceptGroupInvitation(model),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionButton(
                label: 'Delete'.tr,
                isPrimary: false,
                onTap: () => controller.declineGroupInvitation(model),
              ),
            ),
          ],
        );

      case NotificationTypeEnum.PAGE_INVITATION:
        return Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Accept'.tr,
                isPrimary: true,
                onTap: () => controller.acceptPageInvitation(model),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionButton(
                label: 'Decline'.tr,
                isPrimary: false,
                onTap: () => controller.declinePageInvitation(model),
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  String _getSenderDisplayName() {
    final type = model.notification_type;
    if (type == 'campaign' || type == 'monetization' || type == 'report_action') {
      return '';
    }
    if (type == 'support_reply') {
      return 'QP Admin ';
    }
    final firstName = model.notification_sender_id?.first_name;
    final lastName = model.notification_sender_id?.last_name;
    if ((firstName == null || firstName == 'null') &&
        (lastName == null || lastName == 'null')) {
      return '';
    }
    final name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    return name.isNotEmpty ? '$name ' : '';
  }

  String _getAcceptedText(NotificationTypeEnum type) {
    switch (type) {
      case NotificationTypeEnum.FRIEND_REQUEST:
        return 'Friend request accepted';
      case NotificationTypeEnum.GROUP_INVITATION:
      case NotificationTypeEnum.GROUP_JOINING:
        return 'Joined the group';
      case NotificationTypeEnum.PAGE_INVITATION:
        return 'Invitation accepted';
      default:
        return 'Accepted';
    }
  }

  String _getDeclinedText(NotificationTypeEnum type) {
    switch (type) {
      case NotificationTypeEnum.FRIEND_REQUEST:
        return 'Request removed';
      case NotificationTypeEnum.GROUP_INVITATION:
      case NotificationTypeEnum.GROUP_JOINING:
        return 'Invitation declined';
      case NotificationTypeEnum.PAGE_INVITATION:
        return 'Invitation declined';
      default:
        return 'Declined';
    }
  }

  String getTextAsNotificationType(NotificationModel model) {
    switch (model.notification_type) {
      case 'post_reaction':
        return 'has reacted on your post';
      case 'post_commented':
        return 'has commented on your post';
      case 'shared_reels_post':
        return 'has shared your reel';
      case 'reel_post_reaction':
        return 'has reacted on your reel';
      case 'reel_commented':
        return 'has commented on your reel';
      case 'reply_comment':
        return 'has reply on your comment';
      case 'comment_reaction':
        return 'has reacted on your comment';
      case 'follow_request':
        return 'is following you';
      case 'friend_request':
        return 'sent you a friend request.';
      case 'accept_friend_request':
        return 'accepted your friend request';
      case 'page_invitation':
        return 'invited you to follow ${model.resourceObject?.pageName ?? ''} page.';
      case 'accept_invitation':
        return 'has accepted your page invitation';
      case 'page':
      case 'page_post':
      case 'pages':
        return model.message ?? '';
      case 'group_invitation':
        return 'invited you to join the ${model.resourceObject?.groupName != null ? "${model.message ?? 'group'}" : 'group'}.';
      case 'group_post':
        return 'has posted in ${model.resourceObject?.groupName ?? ''} group';
      case 'group_joined':
        return 'has joined ${model.resourceObject?.groupName ?? ''} group';
      case 'group_joining':
        return 'sent a join request to ${model.resourceObject?.groupName ?? ''} group';
      case 'group_joining_accept':
        return 'accepted your ${model.resourceObject?.groupName ?? ''} group invitation';
      case 'received_money':
        return 'has sent ${model.message ?? ''} QP dollar on your wallet';
      case 'campaign':
      case 'report_action':
      case 'monetization':
      case 'support_reply':
      case 'order_placed':
      case 'order_status':
      case 'order_refund':
      case 'role_invitation':
        return model.message ?? '';
      case 'shared_post':
        return 'has shared your post';
      case 'post_tags':
        return 'has tagged you in a post';
      case 'check_in':
        return model.message ?? 'checked in';
      case 'page_like':
        return 'liked your Page.';
      case 'mention':
        return 'mentioned you and other followers in a comment.';
      default:
        // Use model.message as fallback instead of "Notification type not found"
        return model.message?.isNotEmpty == true
            ? model.message!
            : 'sent you a notification';
    }
  }

  String getIconPath(NotificationModel model) {
    switch (model.notification_type) {
      case 'post_reaction':
        return getReactionIconPath(model.notification_data?.reactionType ?? '');
      case 'post_commented':
      case 'support_reply':
      case 'reel_comment':
      case 'reel_commented':
      case 'reply_comment':
        return AppAssets.COMMENT_ICON;
      case 'order_status':
      case 'order_placed':
        return AppAssets.ORDER_STATUS_ICON;
      case 'order_refund':
        return AppAssets.REFUND_ICON;
      case 'reel_post_reaction':
      case 'comment_reaction':
        return getReactionIconPath(model.notification_data?.reactionType ?? '');
      case 'follow_request':
      case 'friend_request':
      case 'accept_friend_request':
        return AppAssets.FRIEND_REQUEST_ICON;
      case 'page_invitation':
      case 'accept_invitation':
      case 'page':
      case 'page_post':
      case 'pages':
      case 'page_like':
        return AppAssets.PAGE_INVITE_ICON;
      case 'group_invitation':
      case 'group_joining':
      case 'group_joined':
      case 'group_joining_accept':
      case 'group_post':
      case 'role_invitation':
        return AppAssets.GROUP_ICON;
      case 'campaign':
      case 'monetization':
        return AppAssets.CAMPAIGN_ICON;
      case 'received_money':
        return AppAssets.RECEIVE_MONEY_ICON;
      case 'shared_post':
      case 'shared_reels_post':
        return AppAssets.SHARE_ICON;
      case 'post_tags':
      case 'mention':
        return AppAssets.COMMENT_ICON;
      default:
        return AppAssets.PAGE_INVITE_ICON;
    }
  }

  String getReactionIconPath(reactionType) {
    switch (reactionType) {
      case 'love':
        return AppAssets.LOVE_ICON;
      case 'angry':
        return AppAssets.ANGRY_ICON;
      case 'haha':
        return AppAssets.HAHA_ICON;
      case 'sad':
        return AppAssets.SAD_ICON;
      case 'like':
        return AppAssets.LIKE_ICON;
      default:
        return AppAssets.LOVE_ICON;
    }
  }
}

/// Reusable action button for notification items (Join, Delete, Confirm, Accept, Decline)
class _ActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? PRIMARY_COLOR : Colors.grey[200],
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
