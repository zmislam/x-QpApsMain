// =============================================================================
// Feeds Repository — API calls for the dedicated Feeds page
// =============================================================================
// Provides data access for each Feeds tab:
//   - All (latest)     → edgerank/feed?feed_mode=latest
//   - Favourites       → edgerank/feed?feed_mode=for_you
//   - Friends          → edgerank/feed?feed_mode=friends_first
//   - Groups           → get-all-groups-post (offset-based)
//   - Pages            → get-all-pages-post (offset-based)
//   - Explore          → explore/feed (cursor-based)
//
// Created: 2026-03-14
// =============================================================================

import 'package:flutter/foundation.dart';

import '../../../../config/constants/api_constant.dart';
import '../../../../models/api_response.dart';
import '../../../../models/post.dart';
import '../../../../services/api_communication.dart';

class FeedsRepository {
  final ApiCommunication _api = ApiCommunication();

  // ─── EdgeRank-based feeds (All / Favourites / Friends) ───────────────────

  /// Fetch EdgeRank feed for a given mode.
  /// [feedMode] — 'latest', 'for_you', or 'friends_first'
  Future<ApiResponse> getEdgeRankFeed({
    required String feedMode,
    int limit = 10,
    String? cursor,
    int? sessionSeed,
  }) async {
    String queryParams = 'limit=$limit&feed_mode=$feedMode';
    if (cursor != null && cursor.isNotEmpty) {
      queryParams += '&cursor=$cursor';
    }
    if (sessionSeed != null) {
      queryParams += '&session_seed=$sessionSeed';
    }

    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: false,
      enableLoading: false,
      apiEndPoint: 'edgerank/feed?$queryParams',
    );

    if (response.isSuccessful) {
      try {
        final responseData = response.data as Map<String, dynamic>;
        final data =
            responseData['data'] as Map<String, dynamic>? ?? responseData;

        final List<PostModel> posts = [];
        final rawPosts = data['posts'] as List? ?? [];
        for (final rawPost in rawPosts) {
          try {
            posts.add(
                PostModel.fromMap(Map<String, dynamic>.from(rawPost as Map)));
          } catch (e) {
            debugPrint('[Feeds] Failed to parse post: $e');
          }
        }

        final pagination =
            data['pagination'] as Map<String, dynamic>? ?? {};
        final nextCursor = pagination['nextCursor'] as String?;
        final hasMore = pagination['hasMore'] as bool? ?? false;

        return response.copyWith(data: {
          'posts': posts,
          'nextCursor': nextCursor,
          'hasMore': hasMore,
        });
      } catch (e) {
        debugPrint('[Feeds] EdgeRank parse error: $e');
        return response;
      }
    }
    return response;
  }

  // ─── Offset-based feeds (Groups / Pages) ─────────────────────────────────

  /// Fetch all joined groups' posts (offset-based).
  Future<ApiResponse> getGroupsFeed({
    required int pageNo,
    int pageSize = 20,
  }) async {
    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: true,
      enableLoading: false,
      timeToLiveInSeconds: 60 * 5,
      apiEndPoint: 'get-all-groups-post?pageNo=$pageNo&pageSize=$pageSize',
    );

    if (response.isSuccessful) {
      try {
        final data = response.data as Map<String, dynamic>;
        final List<PostModel> posts = ((data['posts'] ?? []) as List)
            .map((e) => PostModel.fromMap(e as Map<String, dynamic>))
            .toList();
        final totalCount = data['totalCount'] as int? ?? 0;
        final pageCount = data['pageCount'] ??
            (totalCount / pageSize).ceil();

        return response.copyWith(data: {
          'posts': posts,
          'pageCount': pageCount,
          'totalCount': totalCount,
        });
      } catch (e) {
        debugPrint('[Feeds] Groups parse error: $e');
        return response;
      }
    }
    return response;
  }

  /// Fetch all followed pages' posts (offset-based).
  Future<ApiResponse> getPagesFeed({
    required int pageNo,
    int pageSize = 20,
  }) async {
    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: true,
      enableLoading: false,
      timeToLiveInSeconds: 60 * 5,
      apiEndPoint: 'get-all-pages-post?pageNo=$pageNo&pageSize=$pageSize',
    );

    if (response.isSuccessful) {
      try {
        final data = response.data as Map<String, dynamic>;
        final List<PostModel> posts = ((data['posts'] ?? []) as List)
            .map((e) => PostModel.fromMap(e as Map<String, dynamic>))
            .toList();
        final totalPosts = data['totalPosts'] as int? ?? 0;
        final pageCount = data['pageCount'] ?? (totalPosts / pageSize).ceil();

        return response.copyWith(data: {
          'posts': posts,
          'pageCount': pageCount,
          'totalPosts': totalPosts,
        });
      } catch (e) {
        debugPrint('[Feeds] Pages parse error: $e');
        return response;
      }
    }
    return response;
  }

  // ─── Explore feed (cursor-based) ─────────────────────────────────────────

  /// Fetch explore feed with cursor-based pagination.
  Future<ApiResponse> getExploreFeed({
    int limit = 15,
    String? cursor,
    int? sessionSeed,
  }) async {
    String queryParams = 'limit=$limit';
    if (cursor != null && cursor.isNotEmpty) {
      queryParams += '&cursor=$cursor';
    }
    if (sessionSeed != null) {
      queryParams += '&session_seed=$sessionSeed';
    }

    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: true,
      enableLoading: false,
      apiEndPoint: 'explore/feed?$queryParams',
    );

    if (response.isSuccessful) {
      try {
        final responseData = response.data as Map<String, dynamic>;
        final data =
            responseData['data'] as Map<String, dynamic>? ?? responseData;

        final List<PostModel> posts = [];
        final rawPosts = data['posts'] as List? ?? [];
        for (final rawPost in rawPosts) {
          try {
            posts.add(
                PostModel.fromMap(Map<String, dynamic>.from(rawPost as Map)));
          } catch (e) {
            debugPrint('[Feeds] Explore parse error: $e');
          }
        }

        final pagination =
            data['pagination'] as Map<String, dynamic>? ?? {};
        final nextCursor = pagination['cursor'] as String?;
        final hasMore = pagination['hasMore'] as bool? ?? false;

        return response.copyWith(data: {
          'posts': posts,
          'nextCursor': nextCursor,
          'hasMore': hasMore,
        });
      } catch (e) {
        debugPrint('[Feeds] Explore parse error: $e');
        return response;
      }
    }
    return response;
  }

  // ─── Bookmarks / Favourites (offset-based) ───────────────────────────────

  /// Fetch user's bookmarked posts.
  Future<ApiResponse> getBookmarkedPosts({
    required int pageNo,
    int pageSize = 20,
  }) async {
    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: true,
      enableLoading: false,
      timeToLiveInSeconds: 60 * 5,
      apiEndPoint: 'bookmark-list?pageNo=$pageNo&pageSize=$pageSize',
    );
    return response;
  }

  void dispose() {
    // No-op — ApiCommunication does not require disposal
  }
}
