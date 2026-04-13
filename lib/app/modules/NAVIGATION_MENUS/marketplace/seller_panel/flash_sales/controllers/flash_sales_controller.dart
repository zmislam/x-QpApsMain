import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';
import '../../../../../../utils/snackbar.dart';

class FlashSalesController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = true.obs;
  final flashSales = <Map<String, dynamic>>[].obs;
  final stores = <Map<String, dynamic>>[].obs;
  final isStoresLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFlashSales();
    _loadStores();
  }

  Future<void> fetchFlashSales({bool refresh = false}) async {
    if (!refresh) isLoading.value = true;
    final res = await _repo.getMyFlashSales();
    isLoading.value = false;
    if (res.isSuccessful && res.data is Map) {
      final list = (res.data as Map)['flashSales'];
      if (list is List) {
        flashSales.value = list
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      }
    } else if (res.isSuccessful && res.data is List) {
      flashSales.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
  }

  Future<void> _loadStores() async {
    isStoresLoading.value = true;
    final res = await _repo.getMyStores();
    isStoresLoading.value = false;
    if (res.isSuccessful && res.data is List) {
      stores.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
  }

  Future<void> createFlashSale(Map<String, dynamic> data) async {
    final res = await _repo.createFlashSale(flashSaleData: data);
    if (res.isSuccessful) {
      showSuccessSnackkbar(message: 'Flash sale created');
      fetchFlashSales(refresh: true);
      Get.back();
    } else {
      showErrorSnackkbar(message: res.message ?? 'Failed to create flash sale');
    }
  }

  String statusLabel(String s) {
    switch (s) {
      case 'scheduled':
        return 'Scheduled';
      case 'active':
        return 'Active';
      case 'ended':
        return 'Ended';
      case 'cancelled':
        return 'Cancelled';
      default:
        return s.capitalizeFirst ?? s;
    }
  }

  Color statusColor(String s) {
    switch (s) {
      case 'scheduled':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'ended':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
