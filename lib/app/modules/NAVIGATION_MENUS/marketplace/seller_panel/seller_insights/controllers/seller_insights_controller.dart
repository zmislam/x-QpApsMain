import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';

class SellerInsightsController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = true.obs;
  final period = '30d'.obs;
  final totalViews = 0.obs;
  final totalSaves = 0.obs;
  final totalShares = 0.obs;
  final viewsChange = 0.0.obs;
  final savesChange = 0.0.obs;
  final sharesChange = 0.0.obs;
  final dailyTrend = <Map<String, dynamic>>[].obs;
  final topProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInsights();
  }

  Future<void> fetchInsights() async {
    isLoading.value = true;
    final res = await _repo.getSellerInsights(period: period.value);
    isLoading.value = false;

    if (res.isSuccessful && res.data is Map) {
      final d = Map<String, dynamic>.from(res.data as Map);
      totalViews.value = (d['total_views'] as num?)?.toInt() ?? 0;
      totalSaves.value = (d['total_saves'] as num?)?.toInt() ?? 0;
      totalShares.value = (d['total_shares'] as num?)?.toInt() ?? 0;
      viewsChange.value = (d['views_change'] as num?)?.toDouble() ?? 0;
      savesChange.value = (d['saves_change'] as num?)?.toDouble() ?? 0;
      sharesChange.value = (d['shares_change'] as num?)?.toDouble() ?? 0;

      if (d['daily_trend'] is List) {
        dailyTrend.value = (d['daily_trend'] as List)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      }
      if (d['top_products'] is List) {
        topProducts.value = (d['top_products'] as List)
            .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      }
    }
  }

  void changePeriod(String p) {
    if (period.value == p) return;
    period.value = p;
    fetchInsights();
  }
}
