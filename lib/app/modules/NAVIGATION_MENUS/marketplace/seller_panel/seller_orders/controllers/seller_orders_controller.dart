import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class SellerOrdersController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  final RxBool hasMore = true.obs;
  final RxString statusFilter = ''.obs;
  final RxString searchQuery = ''.obs;

  static const int _pageSize = 20;
  int _skip = 0;

  // ─── Tracking state ───────────────────────────────────────
  final RxBool isLoadingTracking = false.obs;
  final RxList<Map<String, dynamic>> trackingCheckpoints =
      <Map<String, dynamic>>[].obs;
  final RxString currentTrackingNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders({bool loadMore = false}) async {
    if (loadMore) {
      _skip += _pageSize;
    } else {
      _skip = 0;
      orders.clear();
      isLoading.value = true;
    }

    final response = await _repo.getOrderListForSeller(
      skip: _skip,
      limit: _pageSize,
      status: statusFilter.value.isEmpty ? null : statusFilter.value,
      keyword: searchQuery.value.isEmpty ? null : searchQuery.value,
    );

    isLoading.value = false;

    if (response.isSuccessful) {
      final data = response.data;
      List<Map<String, dynamic>> items = [];
      if (data is List && data.isNotEmpty) {
        final result = data[0] as Map<String, dynamic>? ?? {};
        final orderList = result['order_list'] as List? ?? [];
        items = orderList
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      }
      orders.addAll(items);
      hasMore.value = items.length >= _pageSize;
    } else if (!loadMore) {
      AppSnackbar.showError(response.message ?? 'Failed to load orders');
    }
  }

  void setStatusFilter(String status) {
    statusFilter.value = status;
    fetchOrders();
  }

  void search(String query) {
    searchQuery.value = query;
    fetchOrders();
  }

  Future<void> acceptOrder(String orderId, String storeId) async {
    final response = await _repo.acceptOrder(
      orderId: orderId,
      storeId: storeId,
      status: 'accepted',
    );
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Order accepted');
      fetchOrders();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to accept order');
    }
  }

  Future<void> rejectOrder(
      String orderId, String storeId, String reason) async {
    final response = await _repo.acceptOrder(
      orderId: orderId,
      storeId: storeId,
      status: 'canceled',
      rejectNote: reason,
    );
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Order rejected');
      fetchOrders();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to reject order');
    }
  }

  // ─── Tracking ─────────────────────────────────────────────
  Future<bool> updateTrackingNumber({
    required String orderId,
    required String storeId,
    required String trackingNumber,
    required String courierSlug,
  }) async {
    final response = await _repo.updateTrackingNumber(
      orderId: orderId,
      storeId: storeId,
      trackingNumber: trackingNumber,
      courierSlug: courierSlug,
    );
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Tracking number updated');
      fetchOrders();
      return true;
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to update tracking number');
      return false;
    }
  }

  Future<void> fetchTrackingNumber(String orderId, String storeId) async {
    final response = await _repo.getTrackingNumber(
      orderId: orderId,
      storeId: storeId,
    );
    if (response.isSuccessful && response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      currentTrackingNumber.value =
          data['tracking_number'] as String? ?? '';
    }
  }

  Future<void> fetchTrackingDetails(String orderId, String storeId) async {
    isLoadingTracking.value = true;
    trackingCheckpoints.clear();

    final response = await _repo.getTrackingDetails(
      orderId: orderId,
      storeId: storeId,
    );
    isLoadingTracking.value = false;

    if (response.isSuccessful) {
      final data = response.data;
      if (data is List) {
        trackingCheckpoints.value = data
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      }
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to load tracking details');
    }
  }
}
