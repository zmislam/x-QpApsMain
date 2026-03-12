import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/notification.dart';
import '../components/notification_item.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getAllNotifications();

    return Scaffold(
      // ========================== body section ===============================
      body: RefreshIndicator(
        onRefresh: () async {
          controller.notificationList.value.clear(); // Clear the list
          controller.skip.value = 0; // Reset pagination
          controller.hasMoreData.value = true; // Reset more data flag
          await controller.getAllNotifications(); // Reload notifications
        },
        child: Obx(() {
          // Check if the notification list is empty
          if (controller.notificationList.value.isEmpty) {
            if (controller.isFetchingMore.value) {
              return const SizedBox.shrink();
            }
            return Center(child: Text('No notifications available.'.tr));
          }

          return ListView.builder(
            controller: controller.scrollController, // Attach the scroll controller
            itemCount: controller.notificationList.value.length + (controller.hasMoreData.value ? 1 : 0), // Add a loading indicator item
            itemBuilder: (context, index) {
              if (index < controller.notificationList.value.length) {
                NotificationModel notificationModel = controller.notificationList.value[index];

                return InkWell(
                  onTap: () {
                    controller.handleNotificationTap(notificationModel);
                  },
                  child: NotificationItem(
                    model: notificationModel,
                  ),
                );
              } else {
                // Show a loading indicator at the bottom if more data is being fetched
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        }),
      ),
    );
  }

  // Function to handle notification tap
  // void handleNotificationTap(NotificationModel notificationModel) {
  //   if (notificationModel.notification_type == 'support_reply') {
  //     Get.to(() => HelpSupportDetailsView(
  //           notificationModel.resourceObject?.ticketId ?? '',
  //         ));
  //   } else if (notificationModel.notification_type == 'order_status' || notificationModel.notification_type == 'order_placed' || notificationModel.notification_type == 'order_refund') {
  //     Get.to(() => const SellerOrderView());
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'accept_friend_request') {
  //     Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
  //       'username': notificationModel.notification_sender_id?.username,
  //       'isFromReels': 'false',
  //     });
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'post_commented' || notificationModel.notification_type == 'reply_comment' || notificationModel.notification_type == 'comment_reaction') {
  //     debugPrint('Action IS ON');
  //     try {
  //       Get.toNamed(
  //         Routes.NOTIFICATION_POST,
  //         arguments: {
  //           'postId': notificationModel.notification_data!.postId!.id.toString(),
  //           'commentId': notificationModel.notification_data!.commentId?.id,
  //         },
  //       );
  //     } catch (error) {
  //       showWarningSnackkbar(message: 'This post was not found');
  //     }
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'follow_request' || notificationModel.notification_type == 'friend_request') {
  //     Get.toNamed(
  //       Routes.OTHERS_PROFILE,
  //       arguments: {
  //         'username': notificationModel.notification_sender_id?.username,
  //         'isFromReels': 'false',
  //       },
  //     );
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'page_invitation') {
  //     Get.toNamed(
  //       Routes.PAGE_PROFILE,
  //       arguments: notificationModel.resourceObject?.pageUserName,
  //     );
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'group_invitation' || notificationModel.notification_type == 'group_joined' || notificationModel.notification_type == 'group_joining' || notificationModel.notification_type == 'group_joining_accept') {
  //     Get.toNamed(Routes.GROUP_PROFILE, arguments: {
  //       'id': notificationModel.resourceObject?.groupId,
  //       'group_type': '',
  //     });
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'role_invitation' && notificationModel.resourceObject?.groupId != null) {
  //     Get.toNamed(Routes.GROUP_PROFILE, arguments: {
  //       'id': notificationModel.resourceObject?.groupId,
  //       'group_type': '',
  //     });
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'page' && notificationModel.resourceObject?.pageUserName != null) {
  //     Get.toNamed(
  //       Routes.PAGE_PROFILE,
  //       arguments: notificationModel.resourceObject?.pageUserName,
  //     );
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'reel_post_reaction' || notificationModel.notification_type == 'reel_commented') {
  //     Get.toNamed(Routes.VIDEO, arguments: notificationModel.notification_data?.reelId);
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'campaign') {
  //     UriUtils.launchUrlInBrowser('${ApiConstant.SERVER_IP}/manage-ads/single-ad/${notificationModel.resourceObject?.campaignId}');
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else if (notificationModel.notification_type == 'received_money') {
  //     Get.toNamed(Routes.WALLET);
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   } else {
  //     try {
  //       Get.toNamed(
  //         Routes.NOTIFICATION_POST,
  //         arguments: {
  //           'postId': notificationModel.notification_data!.postId!.id.toString(),
  //           'commentId': null,
  //         },
  //       );
  //     } catch (error) {
  //       showWarningSnackkbar(message: 'Check Again later');
  //     }
  //     controller.updateNotificationSeenStatus(notificationModel.id.toString());
  //   }
  // }
}
