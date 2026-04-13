import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class SellerReturnsController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> refunds = <Map<String, dynamic>>[].obs;
  final RxBool hasMore = true.obs;
  final RxString statusFilter = ''.obs;

  static const int _pageSize = 20;
  int _skip = 0;

  // Detail state
  final RxBool isLoadingDetail = false.obs;
  final Rx<Map<String, dynamic>> refundDetail = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    fetchRefunds();
  }

  Future<void> fetchRefunds({bool loadMore = false}) async {
    if (loadMore) {
      _skip += _pageSize;
    } else {
      _skip = 0;
      refunds.clear();
      isLoading.value = true;
    }

    final response = await _repo.getRefundListForSeller(
      skip: _skip,
      limit: _pageSize,
    );
    isLoading.value = false;

    if (response.isSuccessful) {
      final data = response.data;
      List<Map<String, dynamic>> items = [];
      if (data is List && data.isNotEmpty) {
        final result = data[0] as Map<String, dynamic>? ?? {};
        final list = result['results'] as List? ?? result['order_list'] as List? ?? data;
        items = list
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      } else if (data is Map) {
        final list = (data as Map<String, dynamic>)['results'] as List? ?? [];
        items = list
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      }

      // Filter by status client-side if set
      if (statusFilter.value.isNotEmpty) {
        items = items
            .where((r) => r['status'] == statusFilter.value)
            .toList();
      }

      refunds.addAll(items);
      hasMore.value = items.length >= _pageSize;
    } else if (!loadMore) {
      AppSnackbar.showError(response.message ?? 'Failed to load returns');
    }
  }

  void setStatusFilter(String status) {
    statusFilter.value = status;
    fetchRefunds();
  }

  Future<void> fetchRefundDetails(String refundId) async {
    isLoadingDetail.value = true;
    final response =
        await _repo.getRefundDetailsForSeller(refundId: refundId);
    isLoadingDetail.value = false;

    if (response.isSuccessful) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        refundDetail.value = data;
      } else if (data is List && data.isNotEmpty) {
        refundDetail.value =
            data[0] is Map<String, dynamic> ? data[0] : {};
      }
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to load refund details');
    }
  }

  Future<void> acceptRefund(String refundId) async {
    final response = await _repo.acceptOrDeclineRefund(
      refundId: refundId,
      status: 'accepted',
    );
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Refund accepted');
      fetchRefunds();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to accept refund');
    }
  }

  Future<void> declineRefund(String refundId, String reason) async {
    final response = await _repo.acceptOrDeclineRefund(
      refundId: refundId,
      status: 'declined',
      rejectNote: reason,
    );
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Refund declined');
      fetchRefunds();
    } else {
      AppSnackbar.showError(response.message ?? 'Failed to decline refund');
    }
  }

  Future<void> markReceived(String refundId) async {
    final response = await _repo.updateRefundStatus(
      refundId: refundId,
      status: 'received',
    );
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Marked as received');
      fetchRefunds();
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to update status');
    }
  }

  Future<void> processRefund(String refundId, double amount) async {
    final response = await _repo.updateRefundStatus(
      refundId: refundId,
      status: 'refunded',
      amount: amount,
    );
    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Refund processed');
      fetchRefunds();
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to process refund');
    }
  }
}
