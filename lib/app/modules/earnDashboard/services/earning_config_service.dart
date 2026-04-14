import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/earning_config_model.dart';
import '../services/earning_api_service.dart';

/// Global service that fetches and caches the admin-managed earning config.
/// Registered as a permanent GetxService so all widgets can read dynamic config.
///
/// Usage:
///   final cfg = Get.find<EarningConfigService>();
///   Obx(() => Text('${cfg.revenueSharePercent}%'))
class EarningConfigService extends GetxService {
  final Rx<EarningConfig?> config = Rx<EarningConfig?>(null);
  final RxBool isLoaded = false.obs;

  final EarningApiService _api = EarningApiService();
  final GetStorage _storage = GetStorage();

  static const _cacheKey = 'earning_config_cache';
  static const _cacheTsKey = 'earning_config_cache_ts';
  static const _cacheDuration = Duration(hours: 1);

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
    fetchConfig();
  }

  /// Fetch fresh config from /api/earning/score-weights
  Future<void> fetchConfig() async {
    try {
      final res = await _api.fetchScoreWeights();
      if (res.isSuccessful && res.data != null) {
        final data = res.data as Map<String, dynamic>;
        config.value = EarningConfig.fromJson(data);
        isLoaded.value = true;
        _saveToCache(data);
      }
    } catch (e) {
      debugPrint('[EarningConfigService] fetchConfig error: $e');
      // Fallback: use cached data if available
      if (config.value == null) _loadFromCache();
    }
  }

  /// Check if cache is stale and refresh if needed
  Future<void> refreshIfStale() async {
    final ts = _storage.read<int>(_cacheTsKey);
    if (ts == null) {
      await fetchConfig();
      return;
    }
    final cachedAt = DateTime.fromMillisecondsSinceEpoch(ts);
    if (DateTime.now().difference(cachedAt) > _cacheDuration) {
      await fetchConfig();
    }
  }

  void _saveToCache(Map<String, dynamic> data) {
    try {
      _storage.write(_cacheKey, jsonEncode(data));
      _storage.write(_cacheTsKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('[EarningConfigService] cache write error: $e');
    }
  }

  void _loadFromCache() {
    try {
      final raw = _storage.read<String>(_cacheKey);
      if (raw != null && raw.isNotEmpty) {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        config.value = EarningConfig.fromJson(data);
        isLoaded.value = true;
      }
    } catch (e) {
      debugPrint('[EarningConfigService] cache read error: $e');
    }
  }

  // ─────────────────────────────────────────────────
  // Convenience getters (used by ALL widgets across the app)
  // ─────────────────────────────────────────────────

  double get revenueSharePercent =>
      config.value?.revenueSharePercentage ?? 50.0;

  String get distributionTime =>
      config.value?.distributionTime ?? '00:00';

  String get distributionMode =>
      config.value?.distributionMode ?? 'score_based';

  double get maxUserSharePercent =>
      config.value?.maxUserSharePercentage ?? 10.0;

  Map<String, double> get scoreWeights =>
      config.value?.scoreWeights ?? {};

  Map<String, double> get bonusMultipliers =>
      config.value?.bonusMultipliers ?? {};

  int get streakTier1Days => config.value?.streakTier1Days ?? 7;
  int get streakTier2Days => config.value?.streakTier2Days ?? 30;
  int get streakTier3Days => config.value?.streakTier3Days ?? 90;

  double get minEngagementScore =>
      config.value?.minEngagementScore ?? 1.0;

  int get minAccountAgeDays =>
      config.value?.minAccountAgeDays ?? 7;

  // Feature flags
  bool get tierEnabled =>
      config.value?.tierConfig?.enabled ?? false;

  bool get viralEnabled =>
      config.value?.viralConfig?.enabled ?? false;

  bool get pageMonetizationEnabled =>
      config.value?.pageMonetization?.enabled ?? false;

  bool get antiAbuseEnabled =>
      config.value?.antiAbuse?.fakeDetectionEnabled ?? false;

  // Tier helpers
  List<TierDefinition> get userTiers =>
      config.value?.tierConfig?.userTiers ?? [];

  List<TierDefinition> get pageTiers =>
      config.value?.tierConfig?.pageTiers ?? [];

  // Viral helpers
  List<ViralThreshold> get viralThresholds =>
      config.value?.viralConfig?.thresholds ?? [];

  /// Returns the streak tier label for a given streak length (dynamic from config)
  String getStreakTierLabel(int streakDays) {
    if (streakDays >= streakTier3Days) return 'Tier 3';
    if (streakDays >= streakTier2Days) return 'Tier 2';
    if (streakDays >= streakTier1Days) return 'Tier 1';
    return 'No Tier';
  }

  // Formatted distribution time for display (e.g., "00:00" → "12:00 AM UTC")
  String get distributionTimeFormatted {
    final t = distributionTime;
    if (t.isEmpty || !t.contains(':')) return '12:00 AM UTC';
    final parts = t.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    final suffix = h >= 12 ? 'PM' : 'AM';
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final mStr = m.toString().padLeft(2, '0');
    return '$h12:$mStr $suffix UTC';
  }
}
