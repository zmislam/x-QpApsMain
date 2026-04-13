import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';

class SellerPerformanceController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = true.obs;
  final performance = <String, dynamic>{}.obs;
  final commissionRate = 5.obs;

  @override
  void onInit() {
    super.onInit();
    _fetch();
  }

  Future<void> _fetch() async {
    isLoading.value = true;
    final res = await _repo.getMyPerformance();
    isLoading.value = false;
    if (res.isSuccessful && res.data is Map) {
      final d = Map<String, dynamic>.from(res.data as Map);
      final perf = d['performance'];
      if (perf is Map) {
        performance.value = Map<String, dynamic>.from(perf);
      }
      commissionRate.value = (d['commission_rate'] as num?)?.toInt() ?? 5;
    }
  }

  Future<void> refreshData() => _fetch();

  String get tier =>
      performance['tier']?.toString() ?? 'bronze';
}
