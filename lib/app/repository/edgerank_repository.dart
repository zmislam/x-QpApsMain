import 'package:flutter/foundation.dart';

import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../models/feed_insertion_model.dart';
import '../models/post.dart';
import '../models/sponsored_ad_model.dart';
import '../services/api_communication.dart';

/// Response wrapper for the EdgeRank feed endpoint.
class EdgeRankFeedResponse {
  final List<PostModel> posts;
  final List<FeedInsertionModel> insertions;
  final List<SponsoredAdModel> sponsoredAds;
  final String? nextCursor;
  final bool hasMore;
  final Map<String, dynamic> meta;

  EdgeRankFeedResponse({
    required this.posts,
    required this.insertions,
    this.sponsoredAds = const [],
    this.nextCursor,
    this.hasMore = false,
    this.meta = const {},
  });
}

/// Repository for the EdgeRank feed API.
///
/// Calls `GET /api/edgerank/feed` with cursor-based pagination.
class EdgeRankRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  /// Fetch posts from the EdgeRank feed.
  ///
  /// [limit]      — number of posts per page (default 10 for mobile)
  /// [cursor]     — Base64 pagination cursor from previous response
  /// [feedMode]   — 'for_you' | 'friends_first' | 'latest'
  /// [sessionSeed]— timestamp for deterministic randomization
  /// [includeBreakdown] — include score debug info
  /// [forceRecallAPI]   — bypass cache
  Future<ApiResponse> getEdgeRankFeed({
    int limit = 10,
    String? cursor,
    String feedMode = 'for_you',
    bool includeBreakdown = false,
    int? sessionSeed,
    bool? forceRecallAPI,
  }) async {
    // Build query params
    String queryParams = 'limit=$limit&feed_mode=$feedMode';
    if (cursor != null && cursor.isNotEmpty) {
      queryParams += '&cursor=$cursor';
    }
    if (sessionSeed != null) {
      queryParams += '&session_seed=$sessionSeed';
    }
    if (includeBreakdown) {
      queryParams += '&include_breakdown=true';
    }

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: false,
      forceRecallAPI: forceRecallAPI,
      enableLoading: false,
      apiEndPoint: 'edgerank/feed?$queryParams',
    );

    if (apiResponse.isSuccessful) {
      try {
        final responseData = apiResponse.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ??
            responseData;

        // Parse posts
        final List<PostModel> posts = [];
        final rawPosts = data['posts'] as List? ?? [];
        for (final rawPost in rawPosts) {
          try {
            posts.add(PostModel.fromMap(
                Map<String, dynamic>.from(rawPost as Map)));
          } catch (e) {
            debugPrint('EdgeRank: Failed to parse post: $e');
          }
        }

        // Parse insertions
        final List<FeedInsertionModel> insertions = [];
        final rawInsertions = data['insertions'] as List? ?? [];
        for (final rawInsertion in rawInsertions) {
          try {
            final insertion = FeedInsertionModel.fromMap(
                Map<String, dynamic>.from(rawInsertion as Map));
            // Anchor insertion to post ID by position
            if (insertion.position < posts.length) {
              insertion.anchorPostId = posts[insertion.position].id;
            }
            insertions.add(insertion);
          } catch (e) {
            debugPrint('EdgeRank: Failed to parse insertion: $e');
          }
        }

        // Parse sponsored ads
        final List<SponsoredAdModel> sponsoredAds = [];
        final rawAds = data['sponsoredAds'] as List? ?? [];
        for (final rawAd in rawAds) {
          try {
            final ad = SponsoredAdModel.fromMap(
                Map<String, dynamic>.from(rawAd as Map));
            // Anchor ad to post ID by position
            if (ad.position < posts.length) {
              ad.anchorPostId = posts[ad.position].id;
            }
            sponsoredAds.add(ad);
          } catch (e) {
            debugPrint('EdgeRank: Failed to parse sponsored ad: $e');
          }
        }

        // Parse pagination
        final pagination = data['pagination'] as Map<String, dynamic>? ?? {};
        final meta = data['meta'] as Map<String, dynamic>? ?? {};

        final feedResponse = EdgeRankFeedResponse(
          posts: posts,
          insertions: insertions,
          sponsoredAds: sponsoredAds,
          nextCursor: pagination['nextCursor'] as String?,
          hasMore: pagination['hasMore'] as bool? ?? false,
          meta: meta,
        );

        return apiResponse.copyWith(data: feedResponse);
      } catch (e) {
        debugPrint('EdgeRank: Failed to parse feed response: $e');
        return ApiResponse(
          isSuccessful: false,
          message: 'Failed to parse EdgeRank feed: $e',
        );
      }
    }

    return apiResponse;
  }

  /// Track user engagement action.
  ///
  /// [action] — one of: click, reaction, comment, share, follow
  Future<ApiResponse> trackEngagement(
    String action, {
    String? postId,
    List<String>? postIds,
    String? feedMode,
  }) async {
    final payload = <String, dynamic>{'action': action};

    final normalizedPostId = postId?.trim();
    if (normalizedPostId != null && normalizedPostId.isNotEmpty) {
      payload['post_id'] = normalizedPostId;
    }

    final normalizedPostIds = (postIds ?? const <String>[])
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .take(100)
        .toList();
    if (normalizedPostIds.isNotEmpty) {
      payload['post_ids'] = normalizedPostIds;
    }

    final normalizedFeedMode = feedMode?.trim();
    if (normalizedFeedMode != null && normalizedFeedMode.isNotEmpty) {
      payload['feed_mode'] = normalizedFeedMode;
    }

    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'edgerank/track',
      requestData: payload,
    );
  }

  /// Fetch suggestion data for a feed insertion type.
  ///
  /// [type] — one of: friends, groups, pages, stories, reels
  /// [limit] — max items to return
  Future<ApiResponse> getInsertionSuggestions({
    required String type,
    int limit = 5,
  }) async {
    return await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: false,
      apiEndPoint: 'feed/insertion-suggestions/$type?limit=$limit',
    );
  }

  /// Dismiss a feed insertion.
  Future<ApiResponse> dismissInsertion({
    required String insertionType,
    String? itemId,
  }) async {
    return await _apiCommunication.doPostRequest(
      apiEndPoint: 'feed/insertion-dismiss',
      requestData: {
        'insertion_type': insertionType,
        if (itemId != null) 'item_id': itemId,
      },
    );
  }
}
