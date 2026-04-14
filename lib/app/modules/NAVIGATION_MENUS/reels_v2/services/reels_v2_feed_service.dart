import '../../../../services/api_communication.dart';
import '../../../../models/api_response.dart';
import '../models/reel_v2_model.dart';
import '../utils/reel_constants.dart';
import '../utils/reel_enums.dart';

/// Feed-specific API service for fetching reel feeds.
/// Handles cursor-based pagination for all feed types.
class ReelsV2FeedService {
  final ApiCommunication _api = ApiCommunication();

  /// Fetch feed by type with cursor pagination.
  Future<ReelFeedResponse> fetchFeed({
    required ReelFeedType feedType,
    String? cursor,
    int limit = 10,
    String? tag,
    String? soundId,
    String? locationId,
    String? topicId,
    String? reelId,
  }) async {
    String endpoint;
    switch (feedType) {
      case ReelFeedType.forYou:
        endpoint = ReelConstants.feedForYou;
        break;
      case ReelFeedType.following:
        endpoint = ReelConstants.feedFollowing;
        break;
      case ReelFeedType.trending:
        endpoint = ReelConstants.feedTrending;
        break;
      case ReelFeedType.hashtag:
        endpoint = ReelConstants.feedHashtag(tag!);
        break;
      case ReelFeedType.sound:
        endpoint = ReelConstants.feedSound(soundId!);
        break;
      case ReelFeedType.location:
        endpoint = ReelConstants.feedLocation(locationId!);
        break;
      case ReelFeedType.topic:
        endpoint = ReelConstants.feedTopic(topicId!);
        break;
      case ReelFeedType.related:
        endpoint = ReelConstants.feedRelated(reelId!);
        break;
      case ReelFeedType.challenges:
        endpoint = ReelConstants.feedChallenges;
        break;
    }

    final response = await _api.doGetRequest(
      apiEndPoint: endpoint,
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );

    return ReelFeedResponse.fromApiResponse(response);
  }

  /// Quick fetch for the For You feed.
  Future<ReelFeedResponse> fetchForYou({String? cursor, int limit = 10}) async {
    return fetchFeed(feedType: ReelFeedType.forYou, cursor: cursor, limit: limit);
  }

  /// Quick fetch for the Following feed.
  Future<ReelFeedResponse> fetchFollowing({String? cursor, int limit = 10}) async {
    return fetchFeed(feedType: ReelFeedType.following, cursor: cursor, limit: limit);
  }

  /// Quick fetch for the Trending feed.
  Future<ReelFeedResponse> fetchTrending({String? cursor, int limit = 10}) async {
    return fetchFeed(feedType: ReelFeedType.trending, cursor: cursor, limit: limit);
  }
}

/// Parsed feed response with reels list and cursor.
class ReelFeedResponse {
  final List<ReelV2Model> reels;
  final String? nextCursor;
  final bool hasMore;
  final bool isSuccessful;
  final String? message;

  ReelFeedResponse({
    this.reels = const [],
    this.nextCursor,
    this.hasMore = false,
    this.isSuccessful = false,
    this.message,
  });

  factory ReelFeedResponse.fromApiResponse(ApiResponse response) {
    if (!response.isSuccessful || response.data == null) {
      return ReelFeedResponse(
        isSuccessful: false,
        message: response.message,
      );
    }

    final data = response.data as Map<String, dynamic>;
    final reelsList = data['reels'] as List? ?? [];
    final nextCursor = data['next_cursor'] as String?;

    return ReelFeedResponse(
      reels: reelsList
          .map((e) => ReelV2Model.fromMap(e as Map<String, dynamic>))
          .toList(),
      nextCursor: nextCursor,
      hasMore: nextCursor != null,
      isSuccessful: true,
    );
  }
}
