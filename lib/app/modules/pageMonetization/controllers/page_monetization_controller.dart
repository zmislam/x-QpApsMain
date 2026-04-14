import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/page_monetization_models.dart';
import '../services/page_monetization_api_service.dart';
import '../../earnDashboard/services/earning_config_service.dart';

class PageMonetizationController extends GetxController {
  final PageMonetizationApiService _api = PageMonetizationApiService();
  final EarningConfigService _config = Get.find<EarningConfigService>();

  // State
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final confirmed = false.obs;

  // Selected page
  final selectedPageId = ''.obs;
  final pages = <PageMonetizationSummary>[].obs;

  // Data for selected page
  final eligibility = Rxn<PageEligibility>();
  final monetizationStatus = Rxn<PageMonetizationStatus>();
  final tierInfo = Rxn<PageTierInfo>();
  final tierHistory = <PageTierHistoryEntry>[].obs;
  final viralContent = <PageViralContent>[].obs;
  final riskProfile = Rxn<PageRiskProfile>();

  // Page argument
  String? get initialPageId => Get.arguments?['pageId'] as String?;

  @override
  void onInit() {
    super.onInit();
    _loadMyPages();
  }

  /// Load user's pages with monetization status
  Future<void> _loadMyPages() async {
    isLoading.value = true;
    try {
      final res = await _api.getMyPages();
      if (res.isSuccessful && res.data != null) {
        final list = (res.data is List) ? res.data as List : [res.data];
        pages.value = list
            .map((p) => PageMonetizationSummary.fromJson(p as Map<String, dynamic>))
            .toList();

        // Auto-select if arguments provided or first page
        if (initialPageId != null && initialPageId!.isNotEmpty) {
          selectPage(initialPageId!);
        } else if (pages.isNotEmpty) {
          selectPage(pages.first.pageId);
        }
      }
    } catch (_) {}
    isLoading.value = false;
  }

  /// Select a page and load its data
  void selectPage(String pageId) {
    selectedPageId.value = pageId;
    _loadPageData(pageId);
  }

  /// Load all data for selected page
  Future<void> _loadPageData(String pageId) async {
    isLoading.value = true;
    eligibility.value = null;
    monetizationStatus.value = null;
    tierInfo.value = null;
    tierHistory.clear();
    viralContent.clear();
    riskProfile.value = null;

    try {
      // Fetch status first to determine what else to load
      final statusRes = await _api.getStatus(pageId);
      if (statusRes.isSuccessful && statusRes.data != null) {
        monetizationStatus.value =
            PageMonetizationStatus.fromJson(statusRes.data as Map<String, dynamic>);
      }

      final status = monetizationStatus.value?.status ?? 'not_applied';

      if (status == 'not_applied' || status == 'rejected') {
        // Load eligibility
        final eligRes = await _api.checkEligibility(pageId);
        if (eligRes.isSuccessful && eligRes.data != null) {
          eligibility.value = PageEligibility.fromJson(eligRes.data as Map<String, dynamic>);
        }
      } else if (status == 'approved' || status == 'active') {
        // Load full monetization data in parallel
        await Future.wait([
          _fetchTierInfo(pageId),
          _fetchTierHistory(pageId),
          _fetchViralContent(pageId),
          _fetchRiskProfile(pageId),
        ]);
      } else if (status == 'suspended') {
        await _fetchRiskProfile(pageId);
      }
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> _fetchTierInfo(String pageId) async {
    final res = await _api.getTierInfo(pageId);
    if (res.isSuccessful && res.data != null) {
      tierInfo.value = PageTierInfo.fromJson(res.data as Map<String, dynamic>);
    }
  }

  Future<void> _fetchTierHistory(String pageId) async {
    final res = await _api.getTierHistory(pageId);
    if (res.isSuccessful && res.data != null) {
      final list = (res.data is List) ? res.data as List : [];
      tierHistory.value =
          list.map((e) => PageTierHistoryEntry.fromJson(e)).toList();
    }
  }

  Future<void> _fetchViralContent(String pageId) async {
    final res = await _api.getViralContent(pageId);
    if (res.isSuccessful && res.data != null) {
      final list = (res.data is List) ? res.data as List : [];
      viralContent.value =
          list.map((e) => PageViralContent.fromJson(e)).toList();
    }
  }

  Future<void> _fetchRiskProfile(String pageId) async {
    final res = await _api.getRiskProfile(pageId);
    if (res.isSuccessful && res.data != null) {
      riskProfile.value = PageRiskProfile.fromJson(res.data as Map<String, dynamic>);
    }
  }

  /// Submit monetization application
  Future<void> submitApplication() async {
    if (selectedPageId.isEmpty || !confirmed.value) return;
    isSubmitting.value = true;
    try {
      final res = await _api.applyForMonetization(selectedPageId.value);
      if (res.isSuccessful) {
        Get.snackbar('Success', 'Application submitted!',
            backgroundColor: Colors.green.shade100);
        // Reload page data
        selectPage(selectedPageId.value);
      } else {
        Get.snackbar('Error', res.message ?? 'Failed to submit',
            backgroundColor: Colors.red.shade100);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.red.shade100);
    }
    isSubmitting.value = false;
  }

  /// Refresh current page data
  Future<void> refreshData() async {
    if (selectedPageId.isEmpty) {
      await _loadMyPages();
    } else {
      await _loadPageData(selectedPageId.value);
    }
  }

  /// Config helpers
  bool get pageMonetizationEnabled => _config.pageMonetizationEnabled;
}
