import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/revenue_share_models.dart';
import '../model/analytics_models.dart';
import '../services/earning_api_service.dart';
import '../services/earning_config_service.dart';

class EarnDashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final EarningApiService _api = EarningApiService();
  final EarningConfigService configService = Get.find<EarningConfigService>();

  // --- Tab ---
  late TabController tabController;

  // --- Loading ---
  final isLoading = true.obs;
  final isEarningsLoading = false.obs;
  final isBreakdownLoading = false.obs;
  final isWalletLoading = false.obs;

  // --- Today Estimate ---
  final todayEstimate = Rxn<TodayEstimateModel>();

  // --- Countdown ---
  final countdownText = ''.obs;
  Timer? _countdownTimer;

  // --- Page Breakdown ---
  final pageBreakdown = <PageBreakdownEntry>[].obs;

  // --- Score Weights ---
  final scoreWeights = Rxn<ScoreWeightsModel>();

  // --- Platform Stats ---
  final platformStats = Rxn<PlatformStatsModel>();

  // --- Leaderboard ---
  final leaderboard = <LeaderboardEntry>[].obs;
  final leaderboardSummary = Rxn<LeaderboardSummary>();
  final leaderboardCalculatedAt = Rxn<String>();
  final currentUserInTop10 = false.obs;
  Timer? _leaderboardTimer;

  // --- Daily Earnings ---
  final dailyEarnings = <DailyEarningEntry>[].obs;
  final dailyEarningsPagination = Rxn<PaginationMeta>();
  final dailyEarningsSummary = Rxn<DailyEarningsSummary>();
  final earningsCurrentPage = 1.obs;

  // --- Daily Breakdown (for detail sheet) ---
  final selectedDayBreakdown = Rxn<DailyBreakdownModel>();

  // --- Wallet ---
  final walletSummary = Rxn<WalletSummaryModel>();
  final walletBalance = 0.0.obs;

  // --- Analytics (Phase 1) ---
  final analyticsPeriod = '7d'.obs;
  final isAnalyticsLoading = false.obs;
  final earningsTrend = Rxn<EarningsTrendData>();
  final periodCompare = Rxn<PeriodCompareData>();
  final contentEarnings = <ContentEarningEntry>[].obs;
  final scoreOptimizer = Rxn<ScoreOptimizerData>();
  final earningForecast = Rxn<EarningForecastData>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    _loadDashboard();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _leaderboardTimer?.cancel();
    tabController.dispose();
    super.onClose();
  }

  // ──────────────────────────────────────────────
  // INITIAL LOAD — matches qp-web fetchAllRevenueShareData
  // ──────────────────────────────────────────────
  Future<void> _loadDashboard() async {
    isLoading.value = true;

    // Ensure admin config is fresh for dynamic widgets
    configService.refreshIfStale();

    try {
      final res = await _api.fetchDashboardData();
      if (res.isSuccessful && res.data != null) {
        final data = res.data as Map<String, dynamic>;
        // today_estimate
        if (data['today_estimate'] != null) {
          todayEstimate.value =
              TodayEstimateModel.fromJson(data['today_estimate']);
          _startCountdown();
        }
        // page_breakdown
        if (data['page_breakdown'] != null) {
          pageBreakdown.value = (data['page_breakdown'] as List)
              .map((e) => PageBreakdownEntry.fromJson(e))
              .toList();
        }
        // score_weights
        if (data['score_weights'] != null) {
          scoreWeights.value =
              ScoreWeightsModel.fromJson(data['score_weights']);
        }
        // platform_stats
        if (data['platform_stats'] != null) {
          platformStats.value =
              PlatformStatsModel.fromJson(data['platform_stats']);
        }
        // leaderboard
        final lb = data['leaderboard'];
        if (lb != null) {
          leaderboard.value = (lb['leaderboard'] as List? ?? [])
              .map((e) => LeaderboardEntry.fromJson(e))
              .toList();
          leaderboardSummary.value = lb['summary'] != null
              ? LeaderboardSummary.fromJson(lb['summary'])
              : null;
          leaderboardCalculatedAt.value = lb['calculated_at']?.toString();
          currentUserInTop10.value = lb['current_user_in_top10'] == true;
        }
      } else {
        // Fallback: individual calls (matches qp-web catch block)
        await Future.wait([
          _fetchTodayEstimate(),
          _fetchScoreWeights(),
          _fetchPageBreakdown(),
        ]);
        _fetchPlatformStats();
        _fetchLeaderboard();
      }
    } catch (e) {
      debugPrint('[_loadDashboard] Error: $e');
      // Fallback
      await Future.wait([
        _fetchTodayEstimate(),
        _fetchScoreWeights(),
        _fetchPageBreakdown(),
      ]);
      _fetchPlatformStats();
      _fetchLeaderboard();
    } finally {
      isLoading.value = false;
    }

    // Start leaderboard auto-refresh (every 30s, matches web)
    _leaderboardTimer?.cancel();
    _leaderboardTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _fetchLeaderboard(),
    );

    // Fetch wallet + earnings in background
    fetchWalletSummary();
    fetchDailyEarnings();
  }

  // ──────────────────────────────────────────────
  // INDIVIDUAL FETCHERS
  // ──────────────────────────────────────────────
  Future<void> _fetchTodayEstimate() async {
    try {
      final res = await _api.fetchTodayEstimate();
      if (res.isSuccessful && res.data != null) {
        todayEstimate.value =
            TodayEstimateModel.fromJson(res.data as Map<String, dynamic>);
        _startCountdown();
      }
    } catch (e) {
      debugPrint('[_fetchTodayEstimate] Error: $e');
    }
  }

  Future<void> _fetchScoreWeights() async {
    try {
      final res = await _api.fetchScoreWeights();
      if (res.isSuccessful && res.data != null) {
        scoreWeights.value =
            ScoreWeightsModel.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('[_fetchScoreWeights] Error: $e');
    }
  }

  Future<void> _fetchPageBreakdown() async {
    try {
      final res = await _api.fetchPageBreakdown();
      if (res.isSuccessful && res.data != null) {
        pageBreakdown.value = (res.data as List)
            .map((e) => PageBreakdownEntry.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint('[_fetchPageBreakdown] Error: $e');
    }
  }

  Future<void> _fetchPlatformStats() async {
    try {
      final res = await _api.fetchPlatformStats();
      if (res.isSuccessful && res.data != null) {
        platformStats.value =
            PlatformStatsModel.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('[_fetchPlatformStats] Error: $e');
    }
  }

  Future<void> _fetchLeaderboard({String? date}) async {
    try {
      final res = await _api.fetchLeaderboard(date: date);
      if (res.isSuccessful && res.data != null) {
        final data = res.data as Map<String, dynamic>;
        leaderboard.value = (data['leaderboard'] as List? ?? [])
            .map((e) => LeaderboardEntry.fromJson(e))
            .toList();
        leaderboardSummary.value = data['summary'] != null
            ? LeaderboardSummary.fromJson(data['summary'])
            : null;
        leaderboardCalculatedAt.value = data['calculated_at']?.toString();
        currentUserInTop10.value = data['current_user_in_top10'] == true;
      }
    } catch (e) {
      debugPrint('[_fetchLeaderboard] Error: $e');
    }
  }

  // ──────────────────────────────────────────────
  // DAILY EARNINGS (paginated)
  // ──────────────────────────────────────────────
  Future<void> fetchDailyEarnings({int page = 1, int limit = 30}) async {
    try {
      isEarningsLoading.value = true;
      final res = await _api.fetchDailyEarnings(page: page, limit: limit);
      if (res.isSuccessful && res.data != null) {
        final data = res.data as Map<String, dynamic>;
        dailyEarnings.value = (data['earnings'] as List? ?? [])
            .map((e) => DailyEarningEntry.fromJson(e))
            .toList();
        if (data['pagination'] != null) {
          dailyEarningsPagination.value =
              PaginationMeta.fromJson(data['pagination']);
        }
        if (data['summary'] != null) {
          dailyEarningsSummary.value =
              DailyEarningsSummary.fromJson(data['summary']);
        }
        earningsCurrentPage.value = page;
      }
    } catch (e) {
      debugPrint('[fetchDailyEarnings] Error: $e');
    } finally {
      isEarningsLoading.value = false;
    }
  }

  // ──────────────────────────────────────────────
  // DAILY BREAKDOWN (for detail bottom sheet)
  // ──────────────────────────────────────────────
  Future<DailyBreakdownModel?> fetchDailyBreakdown(String date) async {
    try {
      isBreakdownLoading.value = true;
      // API expects YYYY-MM-DD, but entries may have full ISO strings
      final dateOnly = date.contains('T') ? date.split('T').first : date;
      final res = await _api.fetchDailyBreakdown(dateOnly);
      if (res.isSuccessful && res.data != null) {
        final breakdown =
            DailyBreakdownModel.fromJson(res.data as Map<String, dynamic>);
        selectedDayBreakdown.value = breakdown;
        return breakdown;
      }
    } catch (e) {
      debugPrint('[fetchDailyBreakdown] Error: $e');
    } finally {
      isBreakdownLoading.value = false;
    }
    return null;
  }

  // ──────────────────────────────────────────────
  // WALLET
  // ──────────────────────────────────────────────
  Future<void> fetchWalletSummary() async {
    try {
      isWalletLoading.value = true;
      final res = await _api.fetchWalletSummary();
      if (res.isSuccessful && res.data != null) {
        walletSummary.value =
            WalletSummaryModel.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('[fetchWalletSummary] Error: $e');
    } finally {
      isWalletLoading.value = false;
    }
  }

  // --- Stripe Connect ---
  Future<void> connectStripe() async {
    try {
      final hasAccount = walletSummary.value?.hasStripeAccount ?? false;
      final res = hasAccount
          ? await _api.getStripeOnboardingLink()
          : await _api.connectStripe();
      if (res.isSuccessful && res.data != null) {
        final data = res.data as Map<String, dynamic>;
        final url = data['onboardingUrl']?.toString();
        if (url != null && url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      } else {
        Get.snackbar('Error', res.message ?? 'Failed to connect Stripe',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint('[connectStripe] Error: $e');
      Get.snackbar('Error', 'Failed to connect Stripe',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --- Request Withdrawal ---
  Future<bool> requestWithdrawal(double amountDollars) async {
    try {
      final amountCents = (amountDollars * 100).round();
      final res = await _api.requestWithdrawal(amountCents: amountCents);
      if (res.isSuccessful) {
        final data = res.data;
        if (data is Map<String, dynamic> && data['success'] == true) {
          Get.snackbar(
            'Success',
            'Withdrawal submitted! Funds arrive in 1-2 business days.',
            snackPosition: SnackPosition.BOTTOM,
          );
          await fetchWalletSummary();
          return true;
        } else {
          final msg = data is Map ? data['message']?.toString() : null;
          Get.snackbar('Error', msg ?? 'Withdrawal failed',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Error', res.message ?? 'Withdrawal failed',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint('[requestWithdrawal] Error: $e');
      Get.snackbar('Error', 'Withdrawal failed',
          snackPosition: SnackPosition.BOTTOM);
    }
    return false;
  }

  // ──────────────────────────────────────────────
  // COUNTDOWN — matches qp-web DistributionCountdown
  // ──────────────────────────────────────────────
  void _startCountdown() {
    _countdownTimer?.cancel();
    _updateCountdownText();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdownText(),
    );
  }

  void _updateCountdownText() {
    final countdown = todayEstimate.value?.countdown;
    if (countdown == null || countdown.nextDistribution.isEmpty) {
      countdownText.value = '';
      return;
    }
    if (countdown.distributionCompletedToday) {
      countdownText.value = 'Completed Today';
      return;
    }
    final target = DateTime.tryParse(countdown.nextDistribution);
    if (target == null) {
      countdownText.value = '';
      return;
    }
    final now = DateTime.now().toUtc();
    final diff = target.difference(now);
    if (diff.isNegative) {
      countdownText.value = 'Processing...';
      return;
    }
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    countdownText.value = '$h:$m:$s';
  }

  // ──────────────────────────────────────────────
  // REFRESH
  // ──────────────────────────────────────────────
  Future<void> refreshDashboard() async {
    await _loadDashboard();
  }

  // ──────────────────────────────────────────────
  // ANALYTICS (Phase 1)
  // ──────────────────────────────────────────────
  void setAnalyticsPeriod(String period) {
    analyticsPeriod.value = period;
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    isAnalyticsLoading.value = true;
    try {
      final period = analyticsPeriod.value;
      await Future.wait([
        _fetchEarningTrends(period),
        _fetchContentEarnings(period),
        _fetchScoreOptimizer(),
        _fetchEarningForecast(),
      ]);
    } catch (e) {
      debugPrint('[fetchAnalytics] Error: $e');
    } finally {
      isAnalyticsLoading.value = false;
    }
  }

  Future<void> _fetchEarningTrends(String period) async {
    try {
      final res = await _api.fetchEarningTrends(period: period);
      if (res.isSuccessful && res.data != null) {
        final data = res.data as Map<String, dynamic>;
        earningsTrend.value = EarningsTrendData.fromJson(data);
        // Extract period compare if available
        if (data['periodCompare'] != null) {
          periodCompare.value = PeriodCompareData.fromJson(data['periodCompare']);
        }
      }
    } catch (e) {
      debugPrint('[_fetchEarningTrends] Error: $e');
    }
  }

  Future<void> _fetchContentEarnings(String period) async {
    try {
      final res = await _api.fetchContentEarnings(period: period);
      if (res.isSuccessful && res.data != null) {
        final list = res.data is List ? res.data as List : (res.data as Map<String, dynamic>)['contentList'] as List? ?? [];
        contentEarnings.value =
            list.map((e) => ContentEarningEntry.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('[_fetchContentEarnings] Error: $e');
    }
  }

  Future<void> _fetchScoreOptimizer() async {
    try {
      final res = await _api.fetchScoreOptimizer();
      if (res.isSuccessful && res.data != null) {
        scoreOptimizer.value =
            ScoreOptimizerData.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('[_fetchScoreOptimizer] Error: $e');
    }
  }

  Future<void> _fetchEarningForecast() async {
    try {
      final res = await _api.fetchEarningForecast();
      if (res.isSuccessful && res.data != null) {
        earningForecast.value =
            EarningForecastData.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('[_fetchEarningForecast] Error: $e');
    }
  }
}
