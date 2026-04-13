import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../repository/buyer_repository.dart';
import '../../../../../../utils/snackbar.dart';

class BuyerAlert {
  final String type; // "price_drop" or "back_in_stock"
  final Map<String, dynamic>? product;
  final num? oldPrice;
  final num? newPrice;
  final String? date;

  BuyerAlert({
    required this.type,
    this.product,
    this.oldPrice,
    this.newPrice,
    this.date,
  });

  factory BuyerAlert.fromMap(Map<String, dynamic> map) {
    return BuyerAlert(
      type: map['type'] ?? '',
      product: map['product'] as Map<String, dynamic>?,
      oldPrice: map['old_price'],
      newPrice: map['new_price'],
      date: map['date']?.toString(),
    );
  }

  String get productName =>
      product?['product_name'] ?? 'Unknown Product';

  List<dynamic> get productMedia =>
      (product?['media'] as List?) ?? [];
}

class BuyerAlertsController extends GetxController {
  final BuyerRepository _repo = BuyerRepository();

  RxList<BuyerAlert> alerts = <BuyerAlert>[].obs;
  RxBool isLoading = true.obs;
  RxString filterType = ''.obs; // '' = all, 'price_drop', 'back_in_stock'

  List<BuyerAlert> get filteredAlerts {
    if (filterType.value.isEmpty) return alerts;
    return alerts.where((a) => a.type == filterType.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
    isLoading.value = true;
    final response = await _repo.getAlerts();
    if (response.isSuccessful && response.data is List) {
      alerts.value = (response.data as List)
          .map((e) => BuyerAlert.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      alerts.clear();
    }
    isLoading.value = false;
  }
}
