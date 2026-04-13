import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class SellerOrderDetailController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = true.obs;
  final hasError = false.obs;
  final order = Rx<Map<String, dynamic>?>(null);
  final isUpdating = false.obs;

  String? orderId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    orderId = args?['order_id']?.toString();
    if (orderId != null) {
      fetchOrderDetail();
    }
  }

  Future<void> fetchOrderDetail() async {
    if (orderId == null) return;
    isLoading.value = true;
    hasError.value = false;

    final res = await _repo.getOrderDetailsForSeller(orderId: orderId!);
    isLoading.value = false;

    if (res.isSuccessful && res.data != null) {
      if (res.data is Map<String, dynamic>) {
        order.value = res.data as Map<String, dynamic>;
      } else if (res.data is List && (res.data as List).isNotEmpty) {
        order.value = (res.data as List).first is Map<String, dynamic>
            ? (res.data as List).first as Map<String, dynamic>
            : null;
      }
    } else {
      hasError.value = true;
      debugPrint('Failed to load seller order detail: ${res.message}');
    }
  }

  Future<void> acceptOrder() async {
    final storeId = _storeId;
    if (orderId == null || storeId == null) return;
    isUpdating.value = true;
    final res = await _repo.acceptOrder(
      orderId: orderId!,
      storeId: storeId,
      status: 'approved',
    );
    isUpdating.value = false;
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Order accepted');
      fetchOrderDetail();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to accept order');
    }
  }

  Future<void> rejectOrder(String reason) async {
    final storeId = _storeId;
    if (orderId == null || storeId == null) return;
    isUpdating.value = true;
    final res = await _repo.acceptOrder(
      orderId: orderId!,
      storeId: storeId,
      status: 'rejected',
      rejectNote: reason,
    );
    isUpdating.value = false;
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Order rejected');
      fetchOrderDetail();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to reject order');
    }
  }

  Future<void> updateTracking(String trackingNumber, String courier) async {
    final storeId = _storeId;
    if (orderId == null || storeId == null) return;
    isUpdating.value = true;
    final res = await _repo.updateTrackingNumber(
      orderId: orderId!,
      storeId: storeId,
      trackingNumber: trackingNumber,
      courierSlug: courier,
    );
    isUpdating.value = false;
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Tracking updated');
      fetchOrderDetail();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to update tracking');
    }
  }

  String? get _storeId {
    final o = order.value;
    if (o == null) return null;
    return o['store_id']?.toString() ??
        (o['store'] is Map ? o['store']['_id']?.toString() : null);
  }

  String get status {
    return order.value?['status']?.toString().toLowerCase() ?? '';
  }

  bool get canAcceptReject => status == 'pending';
}
