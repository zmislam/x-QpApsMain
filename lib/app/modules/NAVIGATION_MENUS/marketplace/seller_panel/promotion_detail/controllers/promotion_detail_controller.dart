import 'package:get/get.dart';
import '../../../../../../repository/seller_repository.dart';

class PromotionDetailController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final isLoading = true.obs;
  final promo = <String, dynamic>{}.obs;
  final analytics = <String, dynamic>{}.obs;
  final billing = <Map<String, dynamic>>[].obs;
  final dailyData = <Map<String, dynamic>>[].obs;
  final totals = <String, dynamic>{}.obs;

  String get promotionId => Get.arguments?.toString() ?? '';

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    await Future.wait([_fetchDetail(), _fetchAnalytics()]);
    isLoading.value = false;
  }

  Future<void> refreshData() => _load();

  Future<void> _fetchDetail() async {
    if (promotionId.isEmpty) return;
    final res = await _repo.getPromotionDetail(promotionId: promotionId);
    if (res.isSuccessful && res.data is Map) {
      promo.value = Map<String, dynamic>.from(res.data as Map);
    }
  }

  Future<void> _fetchAnalytics() async {
    if (promotionId.isEmpty) return;
    final res = await _repo.getPromotionAnalytics(promotionId: promotionId);
    if (res.isSuccessful && res.data is Map) {
      final d = Map<String, dynamic>.from(res.data as Map);
      analytics.value = d;

      // Extract daily data
      final analyticsBlock = d['analytics'];
      if (analyticsBlock is Map) {
        final daily = analyticsBlock['daily'];
        if (daily is List) {
          dailyData.value = daily
              .map((e) =>
                  e is Map<String, dynamic> ? e : <String, dynamic>{})
              .toList();
        }
        final t = analyticsBlock['totals'];
        if (t is Map) {
          totals.value = Map<String, dynamic>.from(t);
        }
      }

      // Billing events
      final b = d['billing'];
      if (b is List) {
        billing.value = b
            .map(
                (e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
            .toList();
      }
    }
  }

  // ── Helpers ──
  String statusLabel(String s) {
    switch (s) {
      case 'pending_review':
        return 'Pending Review';
      case 'active':
        return 'Active';
      case 'paused':
        return 'Paused';
      case 'draft':
        return 'Draft';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return s.capitalizeFirst ?? s;
    }
  }
}
