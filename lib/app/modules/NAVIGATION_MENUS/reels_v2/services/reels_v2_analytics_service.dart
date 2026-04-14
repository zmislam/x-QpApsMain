import '../../../../services/api_communication.dart';
import '../../../../models/api_response.dart';
import '../utils/reel_constants.dart';

/// Reels V2 Analytics API Service — all analytics endpoints.
class ReelsV2AnalyticsService {
  final ApiCommunication _api = ApiCommunication();

  // ─── Overview ─────────────────────────────────────────────

  Future<ApiResponse> getOverview({String period = '30d'}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.analyticsOverview,
      queryParameters: {'period': period},
    );
  }

  // ─── Per-Reel Insights ────────────────────────────────────

  Future<ApiResponse> getReelInsights(String reelId) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.reelInsights(reelId),
    );
  }

  Future<ApiResponse> getRetentionCurve(String reelId) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.retentionCurve(reelId),
    );
  }

  // ─── Audience ─────────────────────────────────────────────

  Future<ApiResponse> getAudienceDemographics() async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.audienceDemographics,
    );
  }

  // ─── Top Reels ────────────────────────────────────────────

  Future<ApiResponse> getTopReels({String period = '30d', int limit = 10}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.topReels,
      queryParameters: {'period': period, 'limit': limit},
    );
  }

  // ─── Growth ───────────────────────────────────────────────

  Future<ApiResponse> getGrowth({String period = '30d'}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.growth,
      queryParameters: {'period': period},
    );
  }

  // ─── Earnings ─────────────────────────────────────────────

  Future<ApiResponse> getEarnings() async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.earnings,
    );
  }

  // ─── Export ───────────────────────────────────────────────

  Future<ApiResponse> exportAnalytics({String period = '30d'}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.exportAnalytics,
      queryParameters: {'period': period},
    );
  }
}
