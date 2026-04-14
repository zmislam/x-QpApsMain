import '../../../../services/api_communication.dart';
import '../../../../models/api_response.dart';
import '../models/reel_v2_model.dart';
import '../utils/reel_constants.dart';

/// Main Reels V2 API Service — handles all V2 reel endpoints.
/// Uses existing [ApiCommunication] Dio client for consistency.
class ReelsV2ApiService {
  final ApiCommunication _api = ApiCommunication();

  // ─── CRUD ────────────────────────────────────────────────

  Future<ApiResponse> createReel(Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.createReel,
      requestData: data,
    );
  }

  Future<ApiResponse> getReel(String id) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.getReel(id),
    );
  }

  Future<ApiResponse> updateReel(String id, Map<String, dynamic> data) async {
    return await _api.doPutRequest(
      apiEndPoint: ReelConstants.updateReel(id),
      requestData: data,
    );
  }

  Future<ApiResponse> deleteReel(String id) async {
    return await _api.doDeleteRequest(
      apiEndPoint: ReelConstants.deleteReel(id),
    );
  }

  Future<ApiResponse> getUserReels(String userId, {String? cursor, int limit = 10}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.userReels(userId),
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  Future<ApiResponse> getDrafts() async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.drafts,
    );
  }

  Future<ApiResponse> saveDraft(Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.drafts,
      requestData: data,
    );
  }

  Future<ApiResponse> deleteDraft(String draftId) async {
    return await _api.doDeleteRequest(
      apiEndPoint: '${ReelConstants.drafts}/$draftId',
    );
  }

  Future<ApiResponse> scheduleReel(Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.schedule,
      requestData: data,
    );
  }

  // ─── Interactions ────────────────────────────────────────

  Future<ApiResponse> addReaction(String reelId, String reactionType) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.addReaction(reelId),
      requestData: {'reaction_type': reactionType},
    );
  }

  Future<ApiResponse> removeReaction(String reelId) async {
    return await _api.doDeleteRequest(
      apiEndPoint: ReelConstants.removeReaction(reelId),
    );
  }

  Future<ApiResponse> addComment(String reelId, Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.addComment(reelId),
      requestData: data,
    );
  }

  Future<ApiResponse> getComments(String reelId, {String? cursor, int limit = 20, String sort = 'top'}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.getComments(reelId),
      queryParameters: {
        'limit': limit,
        'sort': sort,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  Future<ApiResponse> replyToComment(String commentId, Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.replyComment(commentId),
      requestData: data,
    );
  }

  Future<ApiResponse> editComment(String commentId, Map<String, dynamic> data) async {
    return await _api.doPutRequest(
      apiEndPoint: ReelConstants.editComment(commentId),
      requestData: data,
    );
  }

  Future<ApiResponse> deleteComment(String commentId) async {
    return await _api.doDeleteRequest(
      apiEndPoint: ReelConstants.deleteComment(commentId),
    );
  }

  Future<ApiResponse> getCommentReplies(String commentId, {String? cursor, int limit = 10}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.commentReplies(commentId),
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  Future<ApiResponse> pinComment(String commentId) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.pinComment(commentId),
    );
  }

  Future<ApiResponse> commentReaction(String commentId, String reactionType) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.commentReaction(commentId),
      requestData: {'reaction_type': reactionType},
    );
  }

  Future<ApiResponse> toggleBookmark(String reelId, {String? collectionId}) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.toggleBookmark(reelId),
      requestData: {
        if (collectionId != null) 'collection_id': collectionId,
      },
    );
  }

  Future<ApiResponse> shareReel(String reelId, Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.shareReel(reelId),
      requestData: data,
    );
  }

  Future<ApiResponse> notInterested(String reelId, {String? reason}) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.notInterested(reelId),
      requestData: {
        if (reason != null) 'reason': reason,
      },
    );
  }

  Future<ApiResponse> reportReel(String reelId, Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.reportReel(reelId),
      requestData: data,
    );
  }

  Future<ApiResponse> followAuthor(String reelId) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.followAuthor(reelId),
    );
  }

  // ─── Tracking ────────────────────────────────────────────

  Future<ApiResponse> trackView(List<Map<String, dynamic>> views) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.trackView,
      requestData: {'views': views},
    );
  }

  Future<ApiResponse> trackWatchTime(Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.trackWatchTime,
      requestData: data,
    );
  }

  Future<ApiResponse> trackImpression(List<Map<String, dynamic>> impressions) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.trackImpression,
      requestData: {'impressions': impressions},
    );
  }

  // ─── Sounds ──────────────────────────────────────────────

  Future<ApiResponse> getTrendingSounds({int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.trendingSounds,
      queryParameters: {'limit': limit},
    );
  }

  Future<ApiResponse> searchSounds(String query) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.searchSounds,
      queryParameters: {'q': query},
    );
  }

  Future<ApiResponse> toggleSaveSound(String soundId) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.toggleSaveSound(soundId),
    );
  }

  // ─── Search ───────────────────────────────────────────────

  Future<ApiResponse> searchReels(String query, {String? cursor, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: '${ReelConstants.v2Base}/search/reels',
      queryParameters: {
        'q': query,
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  Future<ApiResponse> searchHashtags(String query) async {
    return await _api.doGetRequest(
      apiEndPoint: '${ReelConstants.v2Base}/search/hashtags',
      queryParameters: {'q': query},
    );
  }

  Future<ApiResponse> searchCreators(String query) async {
    return await _api.doGetRequest(
      apiEndPoint: '${ReelConstants.v2Base}/search/creators',
      queryParameters: {'q': query},
    );
  }

  Future<ApiResponse> getTrendingHashtags() async {
    return await _api.doGetRequest(
      apiEndPoint: '${ReelConstants.v2Base}/hashtag/trending',
    );
  }

  Future<ApiResponse> getChallenges() async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.feedChallenges,
    );
  }

  // ─── Feed ────────────────────────────────────────────────

  Future<ApiResponse> getTrendingFeed({String? cursor, int limit = 10}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.feedTrending,
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  Future<ApiResponse> getHashtagFeed(String tag, {String? cursor, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.feedHashtag(tag),
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  Future<ApiResponse> getLocationFeed(String locationId, {String? cursor, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.feedLocation(locationId),
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  // ─── Collections ─────────────────────────────────────────

  Future<ApiResponse> getCollections() async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.collections,
    );
  }

  Future<ApiResponse> createCollection(Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.collections,
      requestData: data,
    );
  }

  Future<ApiResponse> updateCollection(String id, Map<String, dynamic> data) async {
    return await _api.doPutRequest(
      apiEndPoint: ReelConstants.updateCollection(id),
      requestData: data,
    );
  }

  Future<ApiResponse> deleteCollection(String id) async {
    return await _api.doDeleteRequest(
      apiEndPoint: ReelConstants.deleteCollection(id),
    );
  }

  Future<ApiResponse> addToCollection(String collectionId, String reelId) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.addToCollection(collectionId),
      requestData: {'reelId': reelId},
    );
  }

  Future<ApiResponse> removeFromCollection(String collectionId, String reelId) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.removeFromCollection(collectionId),
      requestData: {'reelId': reelId},
    );
  }

  Future<ApiResponse> getCollectionReels(String collectionId, {String? cursor, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.collectionReels(collectionId),
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  // ─── Settings ────────────────────────────────────────────

  Future<ApiResponse> getSettings() async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.settings,
    );
  }

  Future<ApiResponse> updateSettings(Map<String, dynamic> data) async {
    return await _api.doPutRequest(
      apiEndPoint: ReelConstants.settings,
      requestData: data,
    );
  }

  Future<ApiResponse> getLikedReels({String? cursor, int limit = 10}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.likedReels,
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  Future<ApiResponse> getWatchHistory({String? cursor, int limit = 20}) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.watchHistory,
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
  }

  Future<ApiResponse> clearWatchHistory() async {
    return await _api.doDeleteRequest(
      apiEndPoint: ReelConstants.watchHistory,
    );
  }

  // ─── Remix ───────────────────────────────────────────────

  Future<ApiResponse> createRemix(Map<String, dynamic> data) async {
    return await _api.doPostRequest(
      apiEndPoint: ReelConstants.createRemix,
      requestData: data,
    );
  }

  Future<ApiResponse> getRemixChain(String reelId) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.remixChain(reelId),
    );
  }

  Future<ApiResponse> getRemixes(String reelId) async {
    return await _api.doGetRequest(
      apiEndPoint: ReelConstants.remixes(reelId),
    );
  }
}
