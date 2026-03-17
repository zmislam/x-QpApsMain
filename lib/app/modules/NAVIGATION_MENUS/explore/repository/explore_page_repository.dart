import 'package:flutter/foundation.dart';

import '../../../../config/constants/api_constant.dart';
import '../../../../models/api_response.dart';
import '../../../../models/post.dart';
import '../../../../services/api_communication.dart';

/// Top-level function for background isolate JSON parsing.
/// Must be a top-level (not instance/closure) function for compute().
List<PostModel> _parsePostListIsolate(List<dynamic> jsonList) {
  return jsonList
      .map((e) {
        try {
          return PostModel.fromMap(Map<String, dynamic>.from(e as Map));
        } catch (_) {
          return null;
        }
      })
      .whereType<PostModel>()
      .toList();
}

/// Response wrapper for the cursor-based Explore feed endpoint.
class ExploreFeedResponse {
  final List<PostModel> posts;
  final String? nextCursor;
  final bool hasMore;
  final Map<String, dynamic> meta;

  ExploreFeedResponse({
    required this.posts,
    this.nextCursor,
    this.hasMore = false,
    this.meta = const {},
  });
}

class ExplorePageRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  /// Fetch explore feed with cursor-based pagination (EdgeRank).
  ///
  /// Falls back to [getLegacyExplorePosts] if this fails.
  Future<ApiResponse> getExploreFeed({
    int limit = 15,
    String? cursor,
    int? sessionSeed,
    bool? forceRecallAPI,
  }) async {
    String queryParams = 'limit=$limit';
    if (cursor != null && cursor.isNotEmpty) {
      queryParams += '&cursor=$cursor';
    }
    if (sessionSeed != null) {
      queryParams += '&session_seed=$sessionSeed';
    }

    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: true,
      forceRecallAPI: forceRecallAPI,
      enableLoading: false,
      apiEndPoint: 'explore/feed?$queryParams',
    );

    if (apiResponse.isSuccessful) {
      try {
        final responseData = apiResponse.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ??
            responseData;

        // Parse posts on background isolate to keep UI thread free
        final rawPosts = data['posts'] as List? ?? [];
        final posts = rawPosts.isEmpty
            ? <PostModel>[]
            : await compute(_parsePostListIsolate, rawPosts);

        // Parse pagination
        final pagination =
            data['pagination'] as Map<String, dynamic>? ?? {};
        // Backend returns 'nextCursor' (not 'cursor')
        final nextCursor = pagination['nextCursor'] as String? ??
            pagination['cursor'] as String?;
        final hasMore = pagination['hasMore'] as bool? ?? false;
        debugPrint('[Explore-Repo] pagination=$pagination, nextCursor=$nextCursor, hasMore=$hasMore');
        final meta = data['meta'] as Map<String, dynamic>? ?? {};

        final feedResponse = ExploreFeedResponse(
          posts: posts,
          nextCursor: nextCursor,
          hasMore: hasMore,
          meta: meta,
        );

        return apiResponse.copyWith(data: feedResponse);
      } catch (e) {
        debugPrint('[Explore] Parse error: $e');
        return apiResponse.copyWith(
          isSuccessful: false,
          message: 'Failed to parse explore feed: $e',
        );
      }
    }
    return apiResponse;
  }

  /// Legacy fallback — offset-based pagination.
  Future<ApiResponse> getLegacyExplorePosts({
    required int pageNo,
    int pageSize = 15,
  }) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-explore-post?pageNo=$pageNo&pageSize=$pageSize',
    );

    if (apiResponse.isSuccessful) {
      try {
        final data = apiResponse.data as Map<String, dynamic>;
        final postsRaw = data['posts'] ?? data['data'] ?? [];
        final posts = (postsRaw as List)
            .map((e) => PostModel.fromMap(e as Map<String, dynamic>))
            .toList();
        return apiResponse.copyWith(data: posts);
      } catch (e) {
        return apiResponse.copyWith(
          isSuccessful: false,
          message: 'Failed to parse legacy explore: $e',
        );
      }
    }
    return apiResponse;
  }

  /// Fire-and-forget engagement tracking.
  Future<void> trackEngagement(String action, {String? postId}) async {
    try {
      await _apiCommunication.doPostRequest(
        apiEndPoint: 'explore/track',
        requestData: {
          'action': action,
          if (postId != null) 'post_id': postId,
        },
      );
    } catch (_) {}
  }
}
