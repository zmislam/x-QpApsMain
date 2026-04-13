import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';

class CommissionSummaryController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = true.obs;
  final overview = <String, dynamic>{}.obs;
  final performance = <String, dynamic>{}.obs;
  final commissionRate = 5.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    await Future.wait([_fetchOverview(), _fetchPerformance()]);
    isLoading.value = false;
  }

  Future<void> refreshData() => _load();

  Future<void> _fetchOverview() async {
    final res = await _repo.getDashboardOverview();
    if (res.isSuccessful && res.data is Map) {
      overview.value = Map<String, dynamic>.from(res.data as Map);
    }
  }

  Future<void> _fetchPerformance() async {
    final res = await _repo.getMyPerformance();
    if (res.isSuccessful && res.data is Map) {
      final d = Map<String, dynamic>.from(res.data as Map);
      final perf = d['performance'];
      if (perf is Map) {
        performance.value = Map<String, dynamic>.from(perf);
      }
      commissionRate.value = (d['commission_rate'] as num?)?.toInt() ?? 5;
    }
  }

  String get tier => performance['tier']?.toString() ?? 'bronze';
  double get totalRevenue =>
      (overview['total_revenue'] as num?)?.toDouble() ?? 0;
  double get monthlyRevenue =>
      (overview['monthly_revenue'] as num?)?.toDouble() ?? 0;
  double get totalCommission => totalRevenue * (commissionRate.value / 100);
  double get monthlyCommission =>
      monthlyRevenue * (commissionRate.value / 100);
  double get netEarnings => totalRevenue - totalCommission;
  double get monthlyNetEarnings => monthlyRevenue - monthlyCommission;
}
