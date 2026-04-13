import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../models/marketplace_notification_model.dart';
import '../../../../../models/api_response.dart';
import '../../../../../repository/marketplace_notification_repository.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../utils/snackbar.dart';

class MarketplaceNotificationsController extends GetxController {
  final MarketplaceNotificationRepository _repo =
      MarketplaceNotificationRepository();

  final notifications = <MarketplaceNotificationModel>[].obs;
  final isLoading = true.obs;
  final isFetchingMore = false.obs;
  final hasMore = true.obs;
  final unreadCount = 0.obs;
  final selectedType = Rxn<String>();

  int _currentPage = 1;
  static const int _limit = 20;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isFetchingMore.value &&
        hasMore.value) {
      loadMore();
    }
  }

  /// Fetch notifications (first page or with current filter).
  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      hasMore.value = true;
      notifications.clear();
    }

    isLoading.value = notifications.isEmpty;

    final ApiResponse response = await _repo.getNotifications(
      page: _currentPage,
      limit: _limit,
      type: selectedType.value,
    );

    isLoading.value = false;

    if (response.isSuccessful && response.data is Map) {
      final Map<String, dynamic> fullResponse =
          Map<String, dynamic>.from(response.data as Map);
      final List<dynamic> dataList = fullResponse['data'] ?? [];
      final List<MarketplaceNotificationModel> fetched = dataList
          .map((e) =>
              MarketplaceNotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();

      notifications.addAll(fetched);

      // Update unread count from response if present
      if (fullResponse['unread_count'] != null) {
        unreadCount.value = fullResponse['unread_count'] as int? ?? 0;
      }

      // Check pagination
      final pagination = fullResponse['pagination'] as Map?;
      if (pagination != null) {
        final int totalPages = pagination['pages'] ?? 1;
        hasMore.value = _currentPage < totalPages;
      } else {
        hasMore.value = fetched.length >= _limit;
      }
    }
  }

  /// Load more (next page).
  Future<void> loadMore() async {
    if (isFetchingMore.value || !hasMore.value) return;
    isFetchingMore.value = true;
    _currentPage++;
    await fetchNotifications();
    isFetchingMore.value = false;
  }

  /// Pull-to-refresh.
  Future<void> onRefresh() async {
    await fetchNotifications(refresh: true);
    await fetchUnreadCount();
  }

  /// Fetch unread count.
  Future<void> fetchUnreadCount() async {
    final ApiResponse response = await _repo.getUnreadCount();
    if (response.isSuccessful && response.data is Map) {
      unreadCount.value =
          (response.data as Map)['count'] as int? ?? 0;
    }
  }

  /// Filter by type.
  void filterByType(String? type) {
    selectedType.value = type;
    fetchNotifications(refresh: true);
  }

  /// Mark all as read.
  Future<void> markAllAsRead() async {
    final ApiResponse response = await _repo.markRead(markAll: true);
    if (response.isSuccessful) {
      notifications.value =
          notifications.map((n) => n.copyWith(isRead: true)).toList();
      unreadCount.value = 0;
      showSuccessSnackkbar(message: 'All notifications marked as read'.tr);
    }
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    final ApiResponse response =
        await _repo.markRead(notificationIds: [notificationId]);
    if (response.isSuccessful) {
      final idx = notifications.indexWhere((n) => n.id == notificationId);
      if (idx != -1) {
        notifications[idx] = notifications[idx].copyWith(isRead: true);
        if (unreadCount.value > 0) unreadCount.value--;
      }
    }
  }

  /// Handle notification tap — navigate based on reference type.
  void onNotificationTap(MarketplaceNotificationModel notification) {
    // Mark as read first
    if (!notification.isRead && notification.id != null) {
      markAsRead(notification.id!);
    }

    final refType = notification.referenceType;
    final refId = notification.referenceId;
    if (refId == null || refId.isEmpty) return;

    switch (refType) {
      case 'product':
        Get.toNamed(Routes.PRODUCT_DETAILS, arguments: {'productId': refId});
        break;
      case 'order':
        // Determine buyer/seller based on notification type
        if (_isSellerNotificationType(notification.type)) {
          Get.toNamed(Routes.MARKETPLACE_SELLER_ORDER_DETAIL,
              arguments: {'orderId': refId});
        } else {
          Get.toNamed(Routes.MARKETPLACE_ORDER_DETAIL,
              arguments: {'orderId': refId});
        }
        break;
      case 'store':
        Get.toNamed(Routes.STORE_PRODUCTS_PAGE, arguments: {'storeId': refId});
        break;
      case 'refund':
        Get.toNamed(Routes.MARKETPLACE_REFUND_DETAIL,
            arguments: {'refundId': refId});
        break;
      case 'conversation':
        Get.toNamed(Routes.MARKETPLACE_INBOX);
        break;
      default:
        break;
    }
  }

  bool _isSellerNotificationType(String? type) {
    return const [
      'new_order',
      'low_stock',
      'listing_approved',
      'listing_rejected',
      'payout_processed',
    ].contains(type);
  }

  // ─── Helpers ─────────────────────────────────────────────

  IconData iconForType(String? type) {
    switch (type) {
      case 'new_listing':
        return Icons.new_releases_outlined;
      case 'price_drop':
        return Icons.trending_down;
      case 'back_in_stock':
        return Icons.inventory_2_outlined;
      case 'order_shipped':
        return Icons.local_shipping_outlined;
      case 'order_delivered':
        return Icons.check_circle_outline;
      case 'new_order':
        return Icons.shopping_bag_outlined;
      case 'order_cancelled':
        return Icons.cancel_outlined;
      case 'new_review':
        return Icons.rate_review_outlined;
      case 'new_question':
        return Icons.help_outline;
      case 'new_message':
        return Icons.message_outlined;
      case 'low_stock':
        return Icons.warning_amber_outlined;
      case 'listing_approved':
        return Icons.verified_outlined;
      case 'listing_rejected':
        return Icons.block_outlined;
      case 'payout_processed':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color iconColorForType(String? type) {
    switch (type) {
      case 'new_listing':
      case 'listing_approved':
      case 'order_delivered':
      case 'back_in_stock':
        return const Color(0xFF43A047); // green
      case 'price_drop':
      case 'payout_processed':
        return const Color(0xFF307777); // teal
      case 'new_order':
      case 'order_shipped':
      case 'new_message':
        return const Color(0xFF1877F2); // blue
      case 'new_review':
      case 'new_question':
        return const Color(0xFFFF9017); // orange
      case 'order_cancelled':
      case 'listing_rejected':
        return const Color(0xFFE53935); // red
      case 'low_stock':
        return const Color(0xFFFB8C00); // amber
      default:
        return const Color(0xFF65676B); // grey
    }
  }

  String labelForType(String? type) {
    switch (type) {
      case 'new_listing':
        return 'New Listing';
      case 'price_drop':
        return 'Price Drop';
      case 'back_in_stock':
        return 'Back in Stock';
      case 'order_shipped':
        return 'Shipped';
      case 'order_delivered':
        return 'Delivered';
      case 'new_order':
        return 'New Order';
      case 'order_cancelled':
        return 'Cancelled';
      case 'new_review':
        return 'New Review';
      case 'new_question':
        return 'New Question';
      case 'new_message':
        return 'New Message';
      case 'low_stock':
        return 'Low Stock';
      case 'listing_approved':
        return 'Approved';
      case 'listing_rejected':
        return 'Rejected';
      case 'payout_processed':
        return 'Payout';
      default:
        return 'Notification';
    }
  }
}
