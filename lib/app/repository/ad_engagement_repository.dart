// =============================================================================
// Ad Engagement Repository — Campaign V2 Engagement API calls
// =============================================================================
// Handles all engagement-related API calls for sponsored/campaign ads.
// Uses the /api/campaigns-v2/engagement/* endpoints (separate from regular
// post engagement which uses /api/save-reaction-main-post etc.).
//
// Created: 2026-03-14
// =============================================================================

import '../models/api_response.dart';
import '../services/api_communication.dart';

/// Repository for sponsored ad engagement (reactions, comments).
/// Mirrors the web's `useAdEngagement.js` hook but in Dart.
class AdEngagementRepository {
  final ApiCommunication _api = ApiCommunication();

  // ─────────────────────────────────────────────────────────────────────────
  //  ENGAGEMENT DATA (combined reactions + comment count)
  // ─────────────────────────────────────────────────────────────────────────

  /// Fetch full engagement data for an ad.
  /// Returns: { reactions: {like:N,...}, total_reactions, comment_count, user_reaction }
  Future<ApiResponse> getEngagementData(String adId) async {
    return _api.doGetRequest(
      apiEndPoint: 'campaigns-v2/engagement/$adId',
      responseDataKey: 'data',
    );
  }

  /// Fetch engagement data for multiple ads in one call.
  /// Body: { ad_ids: [...] } (max 50)
  Future<ApiResponse> getEngagementDataBatch(List<String> adIds) async {
    return _api.doPostRequest(
      apiEndPoint: 'campaigns-v2/engagement/batch',
      requestData: {'ad_ids': adIds},
      responseDataKey: 'data',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  REACTIONS
  // ─────────────────────────────────────────────────────────────────────────

  /// Save or toggle a reaction on an ad.
  /// Body: { ad_id, reaction_type }
  /// Returns: { action, reactions, total_reactions, user_reaction }
  Future<ApiResponse> saveReaction(String adId, String reactionType) async {
    return _api.doPostRequest(
      apiEndPoint: 'campaigns-v2/engagement/reaction',
      requestData: {
        'ad_id': adId,
        'reaction_type': reactionType,
      },
      responseDataKey: 'data',
    );
  }

  /// Get list of users who reacted to an ad.
  /// Query: ?type=like&page=1&limit=20
  Future<ApiResponse> getReactionUsers(String adId,
      {String? type, int page = 1, int limit = 20}) async {
    String query = 'page=$page&limit=$limit';
    if (type != null) query += '&type=$type';
    return _api.doGetRequest(
      apiEndPoint: 'campaigns-v2/engagement/reactions/$adId?$query',
      responseDataKey: 'data',
    );
  }

  /// Get reaction counts summary for an ad.
  /// Returns: { total, byType: {like:N,...}, userReaction }
  Future<ApiResponse> getReactionSummary(String adId) async {
    return _api.doGetRequest(
      apiEndPoint: 'campaigns-v2/engagement/reactions/$adId/summary',
      responseDataKey: 'data',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  COMMENTS
  // ─────────────────────────────────────────────────────────────────────────

  /// Fetch paginated comments for an ad.
  /// Query: ?page=1&limit=10&sort=newest
  Future<ApiResponse> getComments(String adId,
      {int page = 1, int limit = 10, String sort = 'newest'}) async {
    return _api.doGetRequest(
      apiEndPoint:
          'campaigns-v2/engagement/comments/$adId?page=$page&limit=$limit&sort=$sort',
      responseDataKey: 'data',
    );
  }

  /// Create a new comment (or reply) on an ad.
  /// Body: { ad_id, comment_text, parent_comment_id? }
  Future<ApiResponse> saveComment(String adId, String commentText,
      {String? parentCommentId}) async {
    final body = <String, dynamic>{
      'ad_id': adId,
      'comment_text': commentText,
    };
    if (parentCommentId != null) {
      body['parent_comment_id'] = parentCommentId;
    }
    return _api.doPostRequest(
      apiEndPoint: 'campaigns-v2/engagement/comment',
      requestData: body,
      responseDataKey: 'data',
    );
  }

  /// Edit an existing comment.
  /// Body: { comment_id, comment_text }
  Future<ApiResponse> editComment(
      String commentId, String commentText) async {
    return _api.doPostRequest(
      apiEndPoint: 'campaigns-v2/engagement/comment',
      requestData: {
        'comment_id': commentId,
        'comment_text': commentText,
      },
      responseDataKey: 'data',
    );
  }

  /// Delete a comment (soft delete).
  /// Body: { comment_id }
  Future<ApiResponse> deleteComment(String commentId) async {
    return _api.doPostRequest(
      apiEndPoint: 'campaigns-v2/engagement/comment',
      requestData: {'comment_id': commentId},
      responseDataKey: 'data',
    );
  }

  /// Fetch paginated replies for a comment.
  /// Query: ?page=1&limit=5
  Future<ApiResponse> getCommentReplies(String commentId,
      {int page = 1, int limit = 5}) async {
    return _api.doGetRequest(
      apiEndPoint:
          'campaigns-v2/engagement/comments/$commentId/replies?page=$page&limit=$limit',
      responseDataKey: 'data',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  COMMENT REACTIONS
  // ─────────────────────────────────────────────────────────────────────────

  /// Save or toggle a reaction on a comment.
  /// Body: { comment_id, reaction_type }
  Future<ApiResponse> saveCommentReaction(
      String commentId, String reactionType) async {
    return _api.doPostRequest(
      apiEndPoint: 'campaigns-v2/engagement/comment-reaction',
      requestData: {
        'comment_id': commentId,
        'reaction_type': reactionType,
      },
      responseDataKey: 'data',
    );
  }

  /// Clean up connections.
  void dispose() {
    _api.endConnection();
  }
}
