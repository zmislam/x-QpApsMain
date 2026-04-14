import 'package:get/get.dart';
import '../../models/reel_analytics_model.dart';
import '../../models/reel_v2_model.dart';
import '../../services/reels_v2_analytics_service.dart';

class ReelsAnalyticsController extends GetxController {
  final ReelsV2AnalyticsService _analyticsService = ReelsV2AnalyticsService();

  // ─── Overview State ───────────────────────────────────────
  final overview = Rxn<ReelAnalyticsOverview>();
  final overviewLoading = false.obs;
  final selectedPeriod = '30d'.obs; // '7d', '30d', '90d', 'lifetime'

  // ─── Individual Insight ───────────────────────────────────
  final reelInsight = Rxn<ReelInsightModel>();
  final reelInsightLoading = false.obs;
  final retentionData = <Map<String, dynamic>>[].obs;

  // ─── Audience Demographics ────────────────────────────────
  final audienceData = Rxn<AudienceDemographics>();
  final audienceLoading = false.obs;

  // ─── Top Performing ───────────────────────────────────────
  final topReels = <ReelV2Model>[].obs;
  final topReelsLoading = false.obs;

  // ─── Growth & Earnings ────────────────────────────────────
  final growthData = <Map<String, dynamic>>[].obs;
  final earningsData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadOverview();
    loadTopReels();
    loadAudience();
  }

  // ─── Overview Dashboard ───────────────────────────────────

  Future<void> loadOverview() async {
    overviewLoading.value = true;
    try {
      final res = await _analyticsService.getOverview(
        period: selectedPeriod.value,
      );
      if (res.isSuccessful && res.data != null) {
        overview.value = ReelAnalyticsOverview.fromMap(
          res.data is Map<String, dynamic> ? res.data as Map<String, dynamic> : <String, dynamic>{},
        );
      }
    } finally {
      overviewLoading.value = false;
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    loadOverview();
  }

  // ─── Per-Reel Insight ─────────────────────────────────────

  Future<void> loadReelInsight(String reelId) async {
    reelInsightLoading.value = true;
    try {
      final res = await _analyticsService.getReelInsights(reelId);
      if (res.isSuccessful && res.data != null) {
        reelInsight.value = ReelInsightModel.fromMap(
          res.data is Map<String, dynamic> ? res.data as Map<String, dynamic> : <String, dynamic>{},
        );
      }
    } finally {
      reelInsightLoading.value = false;
    }
  }

  Future<void> loadRetentionCurve(String reelId) async {
    final res = await _analyticsService.getRetentionCurve(reelId);
    if (res.isSuccessful && res.data != null) {
      final data = res.data is Map ? (res.data as Map)['dataPoints'] ?? [] : res.data;
      retentionData.value = (data as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
  }

  // ─── Audience ─────────────────────────────────────────────

  Future<void> loadAudience() async {
    audienceLoading.value = true;
    try {
      final res = await _analyticsService.getAudienceDemographics();
      if (res.isSuccessful && res.data != null) {
        audienceData.value = AudienceDemographics.fromMap(
          res.data is Map<String, dynamic> ? res.data as Map<String, dynamic> : <String, dynamic>{},
        );
      }
    } finally {
      audienceLoading.value = false;
    }
  }

  // ─── Top Performing ───────────────────────────────────────

  Future<void> loadTopReels() async {
    topReelsLoading.value = true;
    try {
      final res = await _analyticsService.getTopReels();
      if (res.isSuccessful && res.data != null) {
        final data = res.data is Map ? (res.data as Map)['reels'] ?? [] : res.data;
        topReels.value =
            (data as List).map((e) => ReelV2Model.fromMap(e)).toList();
      }
    } finally {
      topReelsLoading.value = false;
    }
  }

  // ─── Growth ───────────────────────────────────────────────

  Future<void> loadGrowthData() async {
    final res = await _analyticsService.getGrowth(
      period: selectedPeriod.value,
    );
    if (res.isSuccessful && res.data != null) {
      final data = res.data is Map ? (res.data as Map)['dataPoints'] ?? [] : res.data;
      growthData.value = (data as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
  }

  // ─── Earnings ─────────────────────────────────────────────

  Future<void> loadEarnings() async {
    final res = await _analyticsService.getEarnings();
    if (res.isSuccessful && res.data != null) {
      earningsData.value = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : {};
    }
  }

  // ─── Export ───────────────────────────────────────────────

  Future<void> exportAnalytics() async {
    final res = await _analyticsService.exportAnalytics(
      period: selectedPeriod.value,
    );
    if (res.isSuccessful) {
      Get.snackbar('Export', 'Analytics exported successfully',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
