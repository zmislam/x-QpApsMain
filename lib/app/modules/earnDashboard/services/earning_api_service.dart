import 'package:quantum_possibilities_flutter/app/services/api_communication.dart';
import 'package:quantum_possibilities_flutter/app/models/api_response.dart';

class EarningApiService {
  final ApiCommunication _api = ApiCommunication();

  // --- Combined dashboard data (primary endpoint) ---
  Future<ApiResponse> fetchDashboardData() {
    return _api.doGetRequest(
      apiEndPoint: 'earning/dashboard-data',
      responseDataKey: 'data',
    );
  }

  // --- Today's estimate ---
  Future<ApiResponse> fetchTodayEstimate() {
    return _api.doGetRequest(
      apiEndPoint: 'earning/today-estimate',
      responseDataKey: 'data',
    );
  }

  // --- Leaderboard ---
  Future<ApiResponse> fetchLeaderboard({String? date}) {
    return _api.doGetRequest(
      apiEndPoint: 'earning/top10-leaderboard',
      queryParameters: date != null ? {'date': date} : null,
      responseDataKey: 'data',
    );
  }

  // --- My ranking ---
  Future<ApiResponse> fetchMyRanking({String period = 'today'}) {
    return _api.doGetRequest(
      apiEndPoint: 'earning/my-ranking',
      queryParameters: {'period': period},
      responseDataKey: 'data',
    );
  }

  // --- Score weights ---
  Future<ApiResponse> fetchScoreWeights() {
    return _api.doGetRequest(
      apiEndPoint: 'earning/score-weights',
      responseDataKey: 'data',
    );
  }

  // --- Daily earnings (paginated) ---
  Future<ApiResponse> fetchDailyEarnings({int page = 1, int limit = 30}) {
    return _api.doGetRequest(
      apiEndPoint: 'earning/daily-earnings',
      queryParameters: {'page': page, 'limit': limit},
      responseDataKey: 'data',
    );
  }

  // --- Daily breakdown for a specific date ---
  Future<ApiResponse> fetchDailyBreakdown(String date) {
    return _api.doGetRequest(
      apiEndPoint: 'earning/daily-breakdown/$date',
      responseDataKey: 'data',
    );
  }

  // --- Page breakdown ---
  Future<ApiResponse> fetchPageBreakdown() {
    return _api.doGetRequest(
      apiEndPoint: 'earning/page-breakdown',
      responseDataKey: 'data',
    );
  }

  // --- Platform stats ---
  Future<ApiResponse> fetchPlatformStats() {
    return _api.doGetRequest(
      apiEndPoint: 'earning/platform-stats',
      responseDataKey: 'data',
    );
  }

  // --- Wallet summary ---
  Future<ApiResponse> fetchWalletSummary() {
    return _api.doGetRequest(
      apiEndPoint: 'earnings-wallet/summary',
      responseDataKey: 'data',
    );
  }

  // --- Stripe connect (initial setup) ---
  Future<ApiResponse> connectStripe() {
    return _api.doPostRequest(
      apiEndPoint: 'earnings-wallet/stripe/connect',
      responseDataKey: 'data',
    );
  }

  // --- Stripe onboarding link (reauth/update) ---
  Future<ApiResponse> getStripeOnboardingLink() {
    return _api.doGetRequest(
      apiEndPoint: 'earnings-wallet/stripe/onboarding-link',
      responseDataKey: 'data',
    );
  }

  // --- Request withdrawal ---
  Future<ApiResponse> requestWithdrawal({required int amountCents}) {
    return _api.doPostRequest(
      apiEndPoint: 'earnings-wallet/withdraw',
      requestData: {'amountCents': amountCents},
      responseDataKey: 'Full Response',
    );
  }

  // --- Legacy endpoints ---
  Future<ApiResponse> fetchEarningPoints() {
    return _api.doGetRequest(
      apiEndPoint: 'post/earning-points',
    );
  }

  Future<ApiResponse> fetchEarningTopThreeSummary() {
    return _api.doGetRequest(
      apiEndPoint: 'post/earning-top-three-summary',
    );
  }

  Future<ApiResponse> fetchEarningProfileOverview() {
    return _api.doGetRequest(
      apiEndPoint: 'post/earning-profile-overview',
    );
  }
}
