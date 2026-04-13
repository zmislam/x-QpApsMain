import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../repository/buyer_repository.dart';
import '../../../../../../utils/snackbar.dart';
import '../models/buyer_order_detail_model.dart';

class BuyerOrderDetailController extends GetxController {
  final BuyerRepository _repo = BuyerRepository();

  Rx<BuyerOrderDetailModel?> orderDetail =
      Rx<BuyerOrderDetailModel?>(null);
  RxBool isLoading = true.obs;
  RxBool isCancelling = false.obs;
  RxBool hasError = false.obs;

  String? orderId;
  String? storeId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    orderId = args?['order_id'] as String?;
    storeId = args?['store_id'] as String?;
    if (orderId != null && storeId != null) {
      fetchOrderDetails();
    }
  }

  Future<void> fetchOrderDetails() async {
    if (orderId == null || storeId == null) return;
    isLoading.value = true;
    hasError.value = false;

    final response = await _repo.getOrderDetails(
      orderId: orderId!,
      storeId: storeId!,
    );

    isLoading.value = false;

    if (response.isSuccessful) {
      final rawData = response.data;
      List<dynamic> results = [];

      if (rawData is Map<String, dynamic>) {
        results = rawData['results'] as List<dynamic>? ?? rawData['data'] as List<dynamic>? ?? [];
      } else if (rawData is List) {
        results = rawData;
      }

      if (results.isNotEmpty) {
        orderDetail.value = BuyerOrderDetailModel.fromMap(
            results.first as Map<String, dynamic>);
      }
    } else {
      hasError.value = true;
      debugPrint('Error fetching order details: ${response.message}');
    }
  }

  bool get canCancel {
    final status = orderDetail.value?.subDetails?.status?.toLowerCase();
    return status == 'pending';
  }

  Future<void> cancelOrder() async {
    if (orderId == null || storeId == null || !canCancel) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text(
            'Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isCancelling.value = true;
    final response = await _repo.cancelOrder(
      orderId: orderId!,
      storeId: storeId!,
    );
    isCancelling.value = false;

    if (response.isSuccessful) {
      AppSnackbar.showSuccess('Order cancelled successfully');
      fetchOrderDetails(); // Refresh the detail
    } else {
      AppSnackbar.showError(
          response.message ?? 'Failed to cancel order');
    }
  }

  Future<void> refreshOrderDetails() async {
    await fetchOrderDetails();
  }
}
