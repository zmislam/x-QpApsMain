import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/creator_tier_models.dart';
import '../services/creator_tier_api_service.dart';
import '../../earnDashboard/services/earning_config_service.dart';

class CreatorTierController extends GetxController {
  final CreatorTierApiService _api = CreatorTierApiService();
  final EarningConfigService _config = Get.find<EarningConfigService>();

  // State
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final confirmed = false.obs;

  // Data
  final tierInfo = Rxn<CreatorTierInfo>();
  final eligibility = Rxn<CreatorEligibility>();
  final application = Rxn<CreatorApplication>();
  final priorityScore = Rxn<PriorityScoreBreakdown>();
  final tierHistory = <TierHistoryEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      // Check application status first
      final appRes = await _api.getApplicationStatus();
      if (appRes.isSuccessful && appRes.data != null) {
        application.value = CreatorApplication.fromJson(appRes.data as Map<String, dynamic>);
      }

      final appStatus = application.value?.status ?? 'not_applied';

      if (appStatus == 'not_applied' || appStatus == 'rejected') {
        // Load eligibility
        final eligRes = await _api.checkEligibility();
        if (eligRes.isSuccessful && eligRes.data != null) {
          eligibility.value = CreatorEligibility.fromJson(eligRes.data as Map<String, dynamic>);
        }
      } else if (appStatus == 'approved') {
        // Load full tier data
        await Future.wait([
          _fetchTierInfo(),
          _fetchPriorityScore(),
          _fetchTierHistory(),
        ]);
      }
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> _fetchTierInfo() async {
    final res = await _api.getMyTier();
    if (res.isSuccessful && res.data != null) {
      tierInfo.value = CreatorTierInfo.fromJson(res.data as Map<String, dynamic>);
    }
  }

  Future<void> _fetchPriorityScore() async {
    final res = await _api.getPriorityScore();
    if (res.isSuccessful && res.data != null) {
      priorityScore.value = PriorityScoreBreakdown.fromJson(
        res.data is Map<String, dynamic> ? res.data as Map<String, dynamic> : <String, dynamic>{},
      );
    }
  }

  Future<void> _fetchTierHistory() async {
    final res = await _api.getTierHistory();
    if (res.isSuccessful && res.data != null) {
      final list = (res.data is List) ? res.data as List : [];
      tierHistory.value =
          list.map((e) => TierHistoryEntry.fromJson(e)).toList();
    }
  }

  /// Submit creator application
  Future<void> submitApplication() async {
    if (!confirmed.value) return;
    isSubmitting.value = true;
    try {
      final res = await _api.apply();
      if (res.isSuccessful) {
        Get.snackbar('Success', 'Creator application submitted!',
            backgroundColor: Colors.green.shade100);
        loadData();
      } else {
        Get.snackbar('Error', res.message ?? 'Failed to apply',
            backgroundColor: Colors.red.shade100);
      }
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.red.shade100);
    }
    isSubmitting.value = false;
  }

  Future<void> refreshData() => loadData();

  bool get tierEnabled => _config.tierEnabled;
}
