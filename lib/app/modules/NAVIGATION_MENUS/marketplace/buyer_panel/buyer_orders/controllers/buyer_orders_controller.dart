import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../repository/buyer_repository.dart';
import '../models/buyer_order_model.dart';

class BuyerOrdersController extends GetxController {
  final BuyerRepository _repo = BuyerRepository();

  RxList<BuyerOrderListItem> orders = <BuyerOrderListItem>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxString selectedStatus = ''.obs;
  RxInt totalCount = 0.obs;

  static const int _pageSize = 20;
  int _currentSkip = 0;

  final List<String> statusFilters = [
    '',
    'pending',
    'onprocessing',
    'accepted',
    'delivered',
    'canceled',
    'refund',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders({bool refresh = false}) async {
    if (refresh) {
      _currentSkip = 0;
      hasMoreData.value = true;
    }
    isLoading.value = true;

    final response = await _repo.getOrderList(
      limit: _pageSize,
      skip: 0,
      status: selectedStatus.value.isNotEmpty ? selectedStatus.value : null,
    );

    isLoading.value = false;

    if (response.isSuccessful) {
      final rawData = response.data;
      List<dynamic> results = [];
      int count = 0;

      if (rawData is Map<String, dynamic>) {
        // Full response mode
        results = rawData['results'] as List<dynamic>? ?? rawData['data'] as List<dynamic>? ?? [];
        count = rawData['totalCount'] as int? ?? results.length;
      } else if (rawData is List) {
        results = rawData;
        count = results.length;
      }
      totalCount.value = count;

      orders.value = results
          .map((e) => BuyerOrderListItem.fromMap(e as Map<String, dynamic>))
          .toList();
      _currentSkip = orders.length;
      hasMoreData.value = orders.length < totalCount.value;
    } else {
      debugPrint('Error fetching orders: ${response.message}');
    }
  }

  Future<void> loadMoreOrders() async {
    if (isLoadingMore.value || !hasMoreData.value) return;
    isLoadingMore.value = true;

    final response = await _repo.getOrderList(
      limit: _pageSize,
      skip: _currentSkip,
      status: selectedStatus.value.isNotEmpty ? selectedStatus.value : null,
    );

    isLoadingMore.value = false;

    if (response.isSuccessful) {
      final rawData = response.data;
      List<dynamic> results = [];

      if (rawData is Map<String, dynamic>) {
        results = rawData['results'] as List<dynamic>? ?? rawData['data'] as List<dynamic>? ?? [];
      } else if (rawData is List) {
        results = rawData;
      }
      final newItems = results
          .map((e) => BuyerOrderListItem.fromMap(e as Map<String, dynamic>))
          .toList();
      orders.addAll(newItems);
      _currentSkip = orders.length;
      hasMoreData.value = newItems.length >= _pageSize;
    }
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    fetchOrders(refresh: true);
  }

  Future<void> refreshOrders() async {
    await fetchOrders(refresh: true);
  }
}
