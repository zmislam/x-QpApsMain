import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../reels/controllers/reels_controller.dart';
import '../../../../utils/reels_v2_deep_link_handler.dart';
import '../../../../repository/notification_repository.dart';

import '../../../../config/constants/api_constant.dart';
import '../../../../data/login_creadential.dart';
import '../../../../enum/notification_type_enum.dart';
import '../../../../models/api_response.dart';
import '../../../../models/notification.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/api_communication.dart';
import '../../../../utils/snackbar.dart';
import '../../../../utils/url_utils.dart';
import '../../seller_panel/views/seller_order_view.dart';
import '../../user_menu/sub_menus/help_support/views/help_support_details_view.dart';
import '../../../shared/modules/post_comment_page/views/post_comment_page_view.dart';

class NotificationController extends GetxController {
  late ApiCommunication _apiCommunication;
  late LoginCredential _loginCredential;
  late ScrollController scrollController;
  Rx<List<NotificationModel>> notificationList = Rx([]);
  RxBool isNotificationLoading = false.obs;
  RxInt unseenNotificationCount = 0.obs;
  RxInt skip = 0.obs;
  int limit = 10;
  RxBool isFetchingMore = false.obs;
  RxBool hasMoreData = true.obs;
  NotificationRepository notificationRepository = NotificationRepository();

  /// Notifications grouped into "New" (unseen) and "Earlier" (seen)
  List<NotificationModel> get newNotifications =>
      notificationList.value.where((n) => !(n.notification_seen ?? false)).toList();

  List<NotificationModel> get earlierNotifications =>
      notificationList.value.where((n) => n.notification_seen ?? false).toList();

  /// Fetches all notifications with pagination
  Future<void> getAllNotifications() async {
    if (isFetchingMore.value || !hasMoreData.value) return;

    isFetchingMore.value = true;

    final ApiResponse apiResponse = await notificationRepository.getAllNotifications(
      skip: notificationList.value.length,
      userId: _loginCredential.getUserData().id.toString(),
      limit: limit,
    );

    if (apiResponse.isSuccessful) {
      List<NotificationModel> fetchedNotifications = (apiResponse.data as List<NotificationModel>);

      if (apiResponse.pageCount! > notificationList.value.length + fetchedNotifications.length) {
        hasMoreData.value = true;
      } else {
        hasMoreData.value = false;
      }

      notificationList.value = [...notificationList.value, ...fetchedNotifications];

      debugPrint('Fetched notifications: ${fetchedNotifications.length}');
    } else {
      debugPrint('Error fetching notifications: ${apiResponse.message}');
    }

    isFetchingMore.value = false;
  }

  Future getUnseenNotificationsCount() async {
    final ApiResponse apiResponse = await notificationRepository.getUnseenCommentCount(
      userId: _loginCredential.getUserData().id.toString(),
    );
    if (apiResponse.isSuccessful) {
      unseenNotificationCount.value = apiResponse.data as int;
    } else {
      debugPrint('Notification count error: ${apiResponse.message}');
    }
  }

  Future<void> updateNotificationSeenStatus(String notificationId) async {
    try {
      final ApiResponse apiResponse = await notificationRepository.updateNotificationSeenStatus(notificationId: notificationId);

      if (apiResponse.isSuccessful) {
        notificationList.value = notificationList.value.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(notification_seen: true);
          }
          return notification;
        }).toList();

        getUnseenNotificationsCount();
      }
    } catch (error) {
      debugPrint('Error updating seen status: $error');
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  MARK ALL AS READ                                                      ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> markAllAsRead() async {
    try {
      final ApiResponse apiResponse = await notificationRepository.markAllAsRead(
        userId: _loginCredential.getUserData().id.toString(),
      );
      if (apiResponse.isSuccessful) {
        notificationList.value = notificationList.value
            .map((n) => n.copyWith(notification_seen: true))
            .toList();
        unseenNotificationCount.value = 0;
        showSuccessSnackkbar(message: 'All notifications marked as read'.tr);
      }
    } catch (error) {
      debugPrint('Error marking all as read: $error');
    }
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  DELETE NOTIFICATION                                                   ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> deleteNotification(String notificationId) async {
    try {
      final ApiResponse apiResponse = await notificationRepository.deleteNotification(notificationId: notificationId);
      if (apiResponse.isSuccessful) {
        notificationList.value = notificationList.value
            .where((n) => n.id != notificationId)
            .toList();
        getUnseenNotificationsCount();
      }
    } catch (error) {
      debugPrint('Error deleting notification: $error');
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  FRIEND REQUEST ACTIONS                                                ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> acceptFriendRequest(NotificationModel notification) async {
    try {
      final senderId = notification.notification_sender_id?.id;
      if (senderId == null) return;

      final ApiResponse apiResponse = await notificationRepository.respondToFriendRequest(
        requestId: senderId,
        action: 1,
      );
      if (apiResponse.isSuccessful) {
        _updateNotificationStatus(notification.id!, 'accept');
        showSuccessSnackkbar(message: 'Friend request accepted'.tr);
      }
    } catch (error) {
      debugPrint('Error accepting friend request: $error');
      showWarningSnackkbar(message: 'Failed to accept request'.tr);
    }
  }

  Future<void> declineFriendRequest(NotificationModel notification) async {
    try {
      final senderId = notification.notification_sender_id?.id;
      if (senderId == null) return;

      final ApiResponse apiResponse = await notificationRepository.respondToFriendRequest(
        requestId: senderId,
        action: 0,
      );
      if (apiResponse.isSuccessful) {
        _updateNotificationStatus(notification.id!, 'decline');
      }
    } catch (error) {
      debugPrint('Error declining friend request: $error');
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GROUP INVITATION ACTIONS                                              ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> acceptGroupInvitation(NotificationModel notification) async {
    try {
      final groupId = notification.resourceObject?.groupId;
      if (groupId == null) return;

      final ApiResponse apiResponse = await notificationRepository.respondToGroupInvitation(
        groupId: groupId,
        action: 'accept',
      );
      if (apiResponse.isSuccessful) {
        _updateNotificationStatus(notification.id!, 'accept');
        showSuccessSnackkbar(message: 'Group invitation accepted'.tr);
      }
    } catch (error) {
      debugPrint('Error accepting group invitation: $error');
      showWarningSnackkbar(message: 'Failed to join group'.tr);
    }
  }

  Future<void> declineGroupInvitation(NotificationModel notification) async {
    try {
      final groupId = notification.resourceObject?.groupId;
      if (groupId == null) return;

      final ApiResponse apiResponse = await notificationRepository.respondToGroupInvitation(
        groupId: groupId,
        action: 'decline',
      );
      if (apiResponse.isSuccessful) {
        _updateNotificationStatus(notification.id!, 'decline');
      }
    } catch (error) {
      debugPrint('Error declining group invitation: $error');
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  PAGE INVITATION ACTIONS                                               ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> acceptPageInvitation(NotificationModel notification) async {
    try {
      final pageUserName = notification.resourceObject?.pageUserName;
      if (pageUserName == null) return;

      final ApiResponse apiResponse = await notificationRepository.acceptPageInvitation(pageId: pageUserName);
      if (apiResponse.isSuccessful) {
        _updateNotificationStatus(notification.id!, 'accept');
        showSuccessSnackkbar(message: 'Page invitation accepted'.tr);
      }
    } catch (error) {
      debugPrint('Error accepting page invitation: $error');
      showWarningSnackkbar(message: 'Failed to accept invitation'.tr);
    }
  }

  Future<void> declinePageInvitation(NotificationModel notification) async {
    try {
      final pageUserName = notification.resourceObject?.pageUserName;
      if (pageUserName == null) return;

      final ApiResponse apiResponse = await notificationRepository.declinePageInvitation(pageId: pageUserName);
      if (apiResponse.isSuccessful) {
        _updateNotificationStatus(notification.id!, 'decline');
      }
    } catch (error) {
      debugPrint('Error declining page invitation: $error');
    }
  }

  /// Update notification status locally after an action (accept/decline)
  void _updateNotificationStatus(String notificationId, String status) {
    notificationList.value = notificationList.value.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(notification_seen: true, status: status);
      }
      return n;
    }).toList();
    getUnseenNotificationsCount();
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  LOAD MORE (SEE PREVIOUS NOTIFICATIONS)                                ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<void> loadMore() async {
    if (!hasMoreData.value || isFetchingMore.value) return;
    await getAllNotifications();
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  HANDLE NOTIFICATION TAP                                               ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  void handleNotificationTap(NotificationModel notificationModel) {
    final type = NotificationTypeEnum.fromString(notificationModel.notification_type);

    switch (type) {
      case NotificationTypeEnum.SUPPORT_REPLY:
        Get.to(() => HelpSupportDetailsView(notificationModel.resourceObject?.ticketId ?? ''));
        break;

      case NotificationTypeEnum.ORDER_STATUS:
      case NotificationTypeEnum.ORDER_PLACED:
      case NotificationTypeEnum.ORDER_REFUND:
        Get.to(() => const SellerOrderView());
        break;

      case NotificationTypeEnum.ACCEPT_FRIEND_REQUEST:
      case NotificationTypeEnum.FOLLOW_REQUEST:
      case NotificationTypeEnum.FRIEND_REQUEST:
        final username = notificationModel.notification_sender_id?.username;
        if (username != null && username.isNotEmpty) {
          Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
            'username': username,
            'isFromReels': 'false',
          });
        }
        break;

      case NotificationTypeEnum.SHARED_POST:
      case NotificationTypeEnum.POST_REACTION:
      case NotificationTypeEnum.POST_TAGS:
        // Non-comment notifications: go to post page
        try {
          final postId = notificationModel.notification_data?.postId?.id;
          if (postId != null) {
            Get.toNamed(Routes.NOTIFICATION_POST, arguments: {
              'postId': postId,
            });
          } else {
            showWarningSnackkbar(message: 'This post is no longer available'.tr);
          }
        } catch (_) {
          showWarningSnackkbar(message: 'This post was not found'.tr);
        }
        break;

      case NotificationTypeEnum.POST_COMMENTED:
      case NotificationTypeEnum.REPLY_COMMENT:
      case NotificationTypeEnum.COMMENT_REACTION:
        // Comment notifications: go directly to comments page (single back to notifications)
        try {
          final postId = notificationModel.notification_data?.postId?.id;
          if (postId != null) {
            Get.to(
              () => PostCommentPageView(
                postId: postId,
              ),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 250),
            );
          } else {
            showWarningSnackkbar(message: 'This post is no longer available'.tr);
          }
        } catch (_) {
          showWarningSnackkbar(message: 'This post was not found'.tr);
        }
        break;

      case NotificationTypeEnum.PAGE_INVITATION:
      case NotificationTypeEnum.ACCEPT_INVITATION:
      case NotificationTypeEnum.PAGE:
      case NotificationTypeEnum.PAGE_POST:
      case NotificationTypeEnum.PAGES:
        final pageUserName = notificationModel.resourceObject?.pageUserName;
        if (pageUserName != null) {
          Get.toNamed(Routes.PAGE_PROFILE, arguments: pageUserName);
        }
        break;

      case NotificationTypeEnum.GROUP_INVITATION:
      case NotificationTypeEnum.GROUP_JOINED:
      case NotificationTypeEnum.GROUP_JOINING:
      case NotificationTypeEnum.GROUP_JOINING_ACCEPT:
      case NotificationTypeEnum.GROUP_POST:
        final groupId = notificationModel.resourceObject?.groupId;
        if (groupId != null) {
          Get.toNamed(Routes.GROUP_PROFILE, arguments: {
            'id': groupId,
            'group_type': '',
          });
        }
        break;

      case NotificationTypeEnum.ROLE_INVITATION:
        if (notificationModel.resourceObject?.groupId != null) {
          Get.toNamed(Routes.GROUP_PROFILE, arguments: {
            'id': notificationModel.resourceObject?.groupId,
            'group_type': '',
          });
        }
        break;

      case NotificationTypeEnum.SHARED_REELS_POST:
      case NotificationTypeEnum.REEL_POST_REACTION:
      case NotificationTypeEnum.REEL_COMMENTED:
        try {
          final reelId = notificationModel.notification_data?.reelId;
          if (reelId != null) {
            // Phase 12B: Route to V2 if enabled
            if (ReelsV2DeepLinkHandler.handleReelNotification(
              reelId: reelId,
              commentId: notificationModel.notification_data?.commentId?.id,
            )) {
              break;
            }

            // V1 fallback
            final reelController = Get.find<ReelsController>();
            reelController.getAndUpdateReelListWithSpecificReel(reelId: reelId);

            Get.toNamed(Routes.REELS, arguments: {
              'reel_id': reelId,
              'comment_id': notificationModel.notification_data?.commentId?.id,
            });

            if (notificationModel.notification_data?.commentId?.id != null) {
              reelController.openCommentComponentOfReels(
                reelID: reelId,
                commentId: notificationModel.notification_data?.commentId?.id,
              );
            }
          }
        } catch (_) {
          showWarningSnackkbar(message: 'This reel is no longer available'.tr);
        }
        break;

      case NotificationTypeEnum.CAMPAIGN:
        UriUtils.launchUrlInBrowser(
          '${ApiConstant.SERVER_IP}/manage-ads/single-ad/${notificationModel.resourceObject?.campaignId}',
        );
        break;

      case NotificationTypeEnum.RECEIVED_MONEY:
        Get.toNamed(Routes.WALLET);
        break;

      case NotificationTypeEnum.CHECK_IN:
      case NotificationTypeEnum.MENTION:
        // Try to open associated post
        try {
          final postId = notificationModel.notification_data?.postId?.id;
          if (postId != null) {
            Get.toNamed(Routes.NOTIFICATION_POST, arguments: {
              'postId': postId,
              'commentId': null,
            });
          }
        } catch (_) {}
        break;

      case NotificationTypeEnum.PAGE_LIKE:
        final pageUserName = notificationModel.resourceObject?.pageUserName;
        if (pageUserName != null) {
          Get.toNamed(Routes.PAGE_PROFILE, arguments: pageUserName);
        }
        break;

      case NotificationTypeEnum.MONETIZATION:
      case NotificationTypeEnum.REPORT_ACTION:
        // Info-only notifications — no navigation
        break;

      case NotificationTypeEnum.UNKNOWN:
        try {
          final postId = notificationModel.notification_data?.postId?.id;
          if (postId != null) {
            Get.toNamed(Routes.NOTIFICATION_POST, arguments: {
              'postId': postId,
              'commentId': null,
            });
          }
        } catch (_) {
          // Silently fail for truly unknown types
        }
        break;
    }

    updateNotificationSeenStatus(notificationModel.id.toString());
  }

  @override
  void onInit() {
    _apiCommunication = ApiCommunication();
    _loginCredential = LoginCredential();
    scrollController = ScrollController();

    getUnseenNotificationsCount();

    super.onInit();
  }

  @override
  void onReady() {
    scrollController.addListener(_scrollListener);
    super.onReady();
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (hasMoreData.value && !isFetchingMore.value) {
        await getAllNotifications();
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    _apiCommunication.endConnection();
    super.onClose();
  }
}
