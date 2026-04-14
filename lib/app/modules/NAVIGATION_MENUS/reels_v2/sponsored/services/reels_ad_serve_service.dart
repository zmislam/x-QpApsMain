import 'package:flutter/material.dart';
import '../../../../../services/api_communication.dart';
import '../../../../../models/api_response.dart';
import '../../utils/reel_constants.dart';
import '../models/sponsored_reel_model.dart';

/// Service for fetching and tracking sponsored reels.
/// Uses CampaignV2 ad serve endpoints.
class ReelsAdServeService {
  final ApiCommunication _api = ApiCommunication();

  /// Fetch sponsored reels for in-feed placement.
  /// Returns a list of [SponsoredReelModel] for merge into organic feed.
  Future<List<SponsoredReelModel>> fetchSponsoredReels({int limit = 3}) async {
    try {
      final response = await _api.doGetRequest(
        apiEndPoint: ReelConstants.sponsoredServe,
        queryParameters: {
          'placement': 'Reels',
          'limit': limit,
        },
      );
      if (response.isSuccessful && response.data != null) {
        final list = response.data is List
            ? response.data as List
            : ((response.data as Map<String, dynamic>)['ads'] as List?) ?? [];
        return list
            .map((e) => SponsoredReelModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('[ReelsAdServe] Error fetching sponsored reels: $e');
    }
    return [];
  }

  /// Track an ad impression (auto-fire when reel viewed >= 1s).
  Future<void> trackImpression(String adId) async {
    try {
      await _api.doPostRequest(
        apiEndPoint: ReelConstants.sponsoredImpression(adId),
        requestData: {'event': 'impression'},
      );
    } catch (e) {
      debugPrint('[ReelsAdServe] Error tracking impression: $e');
    }
  }

  /// Track a CTA click.
  Future<void> trackClick(String adId) async {
    try {
      await _api.doPostRequest(
        apiEndPoint: ReelConstants.sponsoredClick(adId),
        requestData: {'event': 'click'},
      );
    } catch (e) {
      debugPrint('[ReelsAdServe] Error tracking click: $e');
    }
  }

  /// Send ad feedback (hide, not interested, etc.).
  Future<ApiResponse> sendFeedback(String adId, String feedbackType) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.sponsoredFeedback(adId),
      requestData: {'type': feedbackType},
    );
  }

  /// React on a sponsored reel.
  Future<ApiResponse> reactOnAd(String adId, String reactionType) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.sponsoredReaction(adId),
      requestData: {'reaction': reactionType},
    );
  }

  /// Comment on a sponsored reel.
  Future<ApiResponse> commentOnAd(String adId, String text) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.sponsoredComment(adId),
      requestData: {'text': text},
    );
  }

  /// Get comments for a sponsored reel.
  Future<ApiResponse> getAdComments(String adId, {String? cursor}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.sponsoredComments(adId),
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  /// Fetch targeting reason for "Why this ad?" display.
  Future<String?> getTargetingReason(String adId) async {
    try {
      final response = await _api.doGetRequest(
        apiEndPoint: ReelConstants.sponsoredWhyThisAd(adId),
      );
      if (response.isSuccessful && response.data != null) {
        return (response.data as Map<String, dynamic>)['reason'] as String?;
      }
    } catch (e) {
      debugPrint('[ReelsAdServe] Error fetching targeting reason: $e');
    }
    return null;
  }
}
