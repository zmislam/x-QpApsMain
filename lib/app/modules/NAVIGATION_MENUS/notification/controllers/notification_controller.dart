import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../reels/controllers/reels_controller.dart';
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

  void updateUnseenNotificationCount() {
    unseenNotificationCount.value = notificationList
        .value
        // .where((notification) => !(notification.notification_seen??false))
        .length;
  }

  /// Fetches all notifications with pagination
  Future<void> getAllNotifications() async {
    if (isFetchingMore.value || !hasMoreData.value) return; // Prevent duplicate calls

    isFetchingMore.value = true;

    final ApiResponse apiResponse = await notificationRepository.getAllNotifications(skip: notificationList.value.length, userId: _loginCredential.getUserData().id.toString(), limit: limit);

    if (apiResponse.isSuccessful) {
      List<NotificationModel> fetchedNotifications = (apiResponse.data as List<NotificationModel>);

      // $ Will be using the page count as total count
      if (apiResponse.pageCount! > notificationList.value.length) {
        hasMoreData.value = true;
      } else {
        hasMoreData.value = false;
      }

      // Append new data to the existing list
      notificationList.value = [...notificationList.value, ...fetchedNotifications];

      debugPrint('Fetched notifications: ${fetchedNotifications.length}');
    } else {
      debugPrint('Error fetching notifications: ${apiResponse.message}');
    }

    isFetchingMore.value = false;
  }

  Future getUnseenNotificationsCount() async {
    // ! PLEASE NOTE WE CAN SEND PAGE ID FROM HERE
    // ! BUT WE ARE NOT SENDING IT AS PER INSTRUCTION FROM BACKEND TEAM
    // * IF NEEDED COMMENT OUT THE BELOW LINE

    // final ApiResponse apiResponse = await notificationRepository.getUnseenCommentCount(userId:_loginCredential.getProfileSwitch() ? _loginCredential.getUserData().page_id.toString() :  _loginCredential.getUserData().id.toString());

    final ApiResponse apiResponse = await notificationRepository.getUnseenCommentCount(userId: _loginCredential.getUserData().id.toString());
    if (apiResponse.isSuccessful) {
      unseenNotificationCount.value = apiResponse.data as int;
      debugPrint('Notification data....${apiResponse.data}');
    } else {
      debugPrint('Notification data On Error....${apiResponse.message}');
    }
  }

  Future<void> updateNotificationSeenStatus(String notificationId) async {
    isNotificationLoading.value = false;

    try {
      final ApiResponse apiResponse = await notificationRepository.updateNotificationSeenStatus(notificationId: notificationId);

      if (apiResponse.isSuccessful) {
        debugPrint('Notification seen status updated successfully');
        notificationList.value = notificationList.value.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(notification_seen: true);
          }
          return notification;
        }).toList();

        // Refresh unseen notifications count
        getUnseenNotificationsCount();
        // // Refresh unseen count
        // updateUnseenNotificationCount();
      }
    } catch (error) {
      debugPrint('Error: $error');
    } finally {
      isNotificationLoading.value = false;
    }
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (skip.value != limit) {
        skip.value += 1;
        await getAllNotifications();
      }
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  HANDEL NOTIFICATION TAP                                               ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  void handleNotificationTap(NotificationModel notificationModel) {
    final type = NotificationTypeEnum.fromString(notificationModel.notification_type);

    debugPrint('NOTIFICATION TYPE');
    debugPrint('$type');

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
        Get.toNamed(Routes.OTHERS_PROFILE, arguments: {
          'username': notificationModel.notification_sender_id?.username,
          'isFromReels': 'false',
        });
        break;

      case NotificationTypeEnum.SHARED_POST:
      case NotificationTypeEnum.POST_REACTION:
      case NotificationTypeEnum.POST_COMMENTED:
      case NotificationTypeEnum.REPLY_COMMENT:
      case NotificationTypeEnum.COMMENT_REACTION:
        debugPrint('Action IS ON');
        try {
          Get.toNamed(Routes.NOTIFICATION_POST, arguments: {
            'postId': notificationModel.notification_data!.postId!.id.toString(),
            'commentId': notificationModel.notification_data!.commentId?.id,
          });
        } catch (_) {
          showWarningSnackkbar(message: 'This post was not found');
        }
        break;

      case NotificationTypeEnum.PAGE_INVITATION:
        Get.toNamed(Routes.PAGE_PROFILE, arguments: notificationModel.resourceObject?.pageUserName);
        break;

      case NotificationTypeEnum.GROUP_INVITATION:
      case NotificationTypeEnum.GROUP_JOINED:
      case NotificationTypeEnum.GROUP_JOINING:
      case NotificationTypeEnum.GROUP_JOINING_ACCEPT:
        Get.toNamed(Routes.GROUP_PROFILE, arguments: {
          'id': notificationModel.resourceObject?.groupId,
          'group_type': '',
        });
        break;

      case NotificationTypeEnum.ROLE_INVITATION:
        if (notificationModel.resourceObject?.groupId != null) {
          Get.toNamed(Routes.GROUP_PROFILE, arguments: {
            'id': notificationModel.resourceObject?.groupId,
            'group_type': '',
          });
        }
        break;

      case NotificationTypeEnum.PAGE:
        if (notificationModel.resourceObject?.pageUserName != null) {
          Get.toNamed(Routes.PAGE_PROFILE, arguments: notificationModel.resourceObject?.pageUserName);
        }
        break;

      case NotificationTypeEnum.SHARED_REELS_POST:
      case NotificationTypeEnum.REEL_POST_REACTION:
      case NotificationTypeEnum.REEL_COMMENTED:
        final reelController = Get.find<ReelsController>();
        reelController.getAndUpdateReelListWithSpecificReel(reelId: notificationModel.notification_data?.reelId);

        Get.toNamed(Routes.REELS, arguments: {
          'reel_id': notificationModel.notification_data?.reelId,
          'comment_id': notificationModel.notification_data?.commentId?.id,
        });

        if (notificationModel.notification_data?.commentId?.id != null) {
          reelController.openCommentComponentOfReels(reelID: notificationModel.notification_data?.reelId ?? '', commentId: notificationModel.notification_data?.commentId?.id);
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

      case NotificationTypeEnum.UNKNOWN:
        try {
          Get.toNamed(Routes.NOTIFICATION_POST, arguments: {
            'postId': notificationModel.notification_data!.postId!.id.toString(),
            'commentId': null,
          });
        } catch (_) {
          showWarningSnackkbar(message: 'Check Again later');
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
    // scrollController.addListener(_scrollListener);

    //! API CALL COMMENTED OUT ----------------------
    // getUnseenNotificationsCount();

    super.onInit();
  }

  @override
  void onReady() {
    scrollController.addListener(_scrollListener);

    super.onClose();
  }

  @override
  void onClose() {
    _apiCommunication.endConnection();
    super.onClose();
  }
}
