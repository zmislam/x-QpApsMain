import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/feed_design_tokens.dart';
import '../../../../models/notification.dart';
import '../../../../routes/app_pages.dart';
import '../../../tab_view/controllers/tab_view_controller.dart';
import '../components/notification_item.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('==== NotificationView build() START ====');
    try {
      controller.getAllNotifications();
    } catch (e, stack) {
      debugPrint('ERROR in getAllNotifications call: $e');
      debugPrint('Stack: $stack');
    }
    debugPrint('==== NotificationView build() returning Scaffold ====');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: FeedDesignTokens.textPrimary(context)),
            onPressed: () {
              final tabController = Get.find<TabViewController>();
              tabController.tabIndex.value = 0;
              if (tabController.tabControllerInitComplete.value) {
                tabController.tabController.animateTo(0);
              }
            },
          ),
          title: Text(
            'Notifications'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: FeedDesignTokens.textPrimary(context),
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.search,
                  color: FeedDesignTokens.textPrimary(context), size: 24),
              onPressed: () => Get.toNamed(Routes.ADVANCE_SEARCH),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz,
                  color: FeedDesignTokens.textPrimary(context), size: 24),
              onSelected: (value) {
                if (value == 'mark_all_read') {
                  controller.markAllAsRead();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'mark_all_read',
                  child: Row(
                    children: [
                      const Icon(Icons.mark_email_read_outlined, size: 20),
                      const SizedBox(width: 10),
                      Text('Mark all as read'.tr),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

      body: RefreshIndicator(
        onRefresh: () async {
          controller.notificationList.value.clear();
          controller.skip.value = 0;
          controller.hasMoreData.value = true;
          await controller.getAllNotifications();
          await controller.getUnseenNotificationsCount();
        },
        child: Obx(() {
          try {
          final allNotifications = controller.notificationList.value;

          if (allNotifications.isEmpty) {
            if (controller.isFetchingMore.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'No notifications available.'.tr,
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final newNotifications = controller.newNotifications;
          final earlierNotifications = controller.earlierNotifications;

          return ListView(
            controller: controller.scrollController,
            children: [
              // ── "New" Section ──
              if (newNotifications.isNotEmpty) ...[
                _SectionHeader(title: 'New'.tr),
                ...newNotifications.map(
                  (n) => _buildNotificationTile(context, n),
                ),
              ],

              // ── "Earlier" Section ──
              if (earlierNotifications.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Earlier'.tr,
                  showDivider: newNotifications.isNotEmpty,
                ),
                ...earlierNotifications.map(
                  (n) => _buildNotificationTile(context, n),
                ),
              ],

              // ── "See previous notifications" / Loading ──
              if (controller.hasMoreData.value)
                _SeePreviousButton(
                  isLoading: controller.isFetchingMore.value,
                  onTap: () => controller.loadMore(),
                ),

              const SizedBox(height: 20),
            ],
          );
          } catch (e, stack) {
            debugPrint('ERROR in Obx builder: $e');
            debugPrint('Stack: $stack');
            return Center(child: Text('Error: $e'));
          }
        }),
      ),
      ),
    );
  }

  Widget _buildNotificationTile(
      BuildContext context, NotificationModel notificationModel) {
    return InkWell(
      onTap: () => controller.handleNotificationTap(notificationModel),
      child: NotificationItem(model: notificationModel),
    );
  }
}

// ── Section Header ("New" / "Earlier") ──────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool showDivider;

  const _SectionHeader({required this.title, this.showDivider = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDivider)
          Divider(
            height: 1,
            thickness: 6,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// ── "See previous notifications" Button ─────────────────────────────
class _SeePreviousButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SeePreviousButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'See previous notifications'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}
