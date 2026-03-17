import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../enum/notification_type_enum.dart';
import '../../../../extension/string/string_image_path.dart';
import '../../../../models/notification.dart';
import '../controllers/notification_controller.dart';

class NotificationOptionsBottomSheet extends StatelessWidget {
  final NotificationModel notification;

  const NotificationOptionsBottomSheet({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    final type = NotificationTypeEnum.fromString(notification.notification_type);
    final senderName = _getSenderName();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Notification preview header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                // Sender avatar
                CircleAvatar(
                  radius: 24,
                  backgroundImage: notification.notification_sender_id?.profile_pic != null
                      ? NetworkImage(notification.notification_sender_id!.profile_pic!.formatedProfileUrl)
                      : null,
                  child: notification.notification_sender_id?.profile_pic == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getNotificationSummary(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Options based on notification type
          if (type == NotificationTypeEnum.GROUP_INVITATION ||
              type == NotificationTypeEnum.PAGE_INVITATION) ...[
            _buildOption(
              context,
              icon: Icons.arrow_upward,
              title: 'Show more',
              subtitle: 'More of your notifications will be like this.',
              onTap: () => Get.back(),
            ),
            _buildOption(
              context,
              icon: Icons.arrow_downward,
              title: 'Show less',
              subtitle: 'Fewer of your notifications will be like this.',
              onTap: () => Get.back(),
            ),
          ],

          _buildOption(
            context,
            icon: Icons.cancel_outlined,
            title: 'Delete this notification',
            onTap: () {
              Get.back();
              controller.deleteNotification(notification.id!);
            },
          ),

          if (type == NotificationTypeEnum.GROUP_INVITATION ||
              type == NotificationTypeEnum.PAGE_INVITATION)
            _buildOption(
              context,
              icon: Icons.notifications_off_outlined,
              title: 'Turn off invitation notifications from this sender',
              onTap: () => Get.back(),
            ),

          if (type == NotificationTypeEnum.FRIEND_REQUEST && senderName.isNotEmpty)
            _buildOption(
              context,
              icon: Icons.report_outlined,
              title: 'Report $senderName',
              onTap: () => Get.back(),
            ),

          // Post-related — turn off post notifications
          if (_isPostRelated(type) && notification.notification_data?.postId?.id != null)
            _buildOption(
              context,
              icon: Icons.notifications_off_outlined,
              title: 'Turn off notifications for this post',
              onTap: () {
                Get.back();
                controller.notificationRepository.turnOffPostNotification(
                  postId: notification.notification_data!.postId!.id,
                  status: true,
                );
              },
            ),

          _buildOption(
            context,
            icon: Icons.report_problem_outlined,
            title: 'Report issue to notifications team',
            onTap: () => Get.back(),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSenderName() {
    final firstName = notification.notification_sender_id?.first_name;
    final lastName = notification.notification_sender_id?.last_name;
    if (firstName == null && lastName == null) return '';
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  String _getNotificationSummary() {
    final name = _getSenderName();
    final message = notification.message ?? '';
    if (name.isNotEmpty && message.isNotEmpty) return '$name $message';
    if (name.isNotEmpty) return name;
    return message;
  }

  bool _isPostRelated(NotificationTypeEnum type) {
    return type == NotificationTypeEnum.POST_COMMENTED ||
        type == NotificationTypeEnum.REPLY_COMMENT ||
        type == NotificationTypeEnum.COMMENT_REACTION ||
        type == NotificationTypeEnum.POST_REACTION ||
        type == NotificationTypeEnum.SHARED_POST ||
        type == NotificationTypeEnum.POST_TAGS;
  }
}

void showNotificationOptionsBottomSheet(BuildContext context, NotificationModel notification) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => NotificationOptionsBottomSheet(notification: notification),
  );
}
