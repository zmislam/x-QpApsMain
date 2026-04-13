import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';

class InventoryAlertsController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = true.obs;
  final alerts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
    isLoading.value = true;
    final res = await _repo.getInventoryAlerts();
    isLoading.value = false;
    if (res.isSuccessful && res.data is Map) {
      final list = (res.data as Map)['alerts'];
      if (list is List) {
        alerts.value = list
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      }
    } else if (res.isSuccessful && res.data is List) {
      alerts.value = (res.data as List)
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList();
    }
  }

  int get unreadCount => alerts.where((a) => a['is_read'] != true).length;
}
