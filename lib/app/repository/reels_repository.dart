import 'package:image_picker/image_picker.dart';

import '../models/api_response.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_campaign_model.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_comment_model.dart';
import '../modules/NAVIGATION_MENUS/reels/model/reels_model.dart';
import '../services/api_communication.dart';
import '../utils/snackbar.dart';

class ReelsRepository {
  late final ApiCommunication _apiCommunication;
  ReelsRepository() {
    _apiCommunication = ApiCommunication(
      receiveTimeout: 600000,
    );
  }

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  REELS CREATION                                                       ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<bool> createReels({
    required Map<String, dynamic> requestData,
    required XFile video,
  }) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-user-reels',
      isFormData: true,
      enableLoading: true,
      fileKey: 'video',
      requestData: requestData,
      mediaXFiles: [video],
    );
    if (response.isSuccessful) {
      return true;
    } else {
      if (response.statusCode == 413) {
        showErrorSnackkbar(message: 'Max Size is 300 MB');
      }
      showErrorSnackkbar(message: '${response.message..toString()}');
      return false;
    }
  }

  Future<bool> createImageReels({
    required Map<String, dynamic> requestData,
    required XFile image,
  }) async {
    final ApiResponse response = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-user-reels',
      isFormData: true,
      enableLoading: true,
      fileKey: 'image',
      requestData: requestData,
      mediaXFiles: [image],
    );
    if (response.isSuccessful) {
      return true;
    } else {
      if (response.statusCode == 413) {
        showErrorSnackkbar(message: 'Max Size is 300 MB');
      }
      return false;
    }
  }

// !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// !┃    DELETE REELS                                                        ┃
// !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> deleteReel(
      {required String reelId, required String key}) async {
    final apiResponse = await _apiCommunication.doDeleteRequest(
        apiEndPoint: 'delete-own-user-reel/:$reelId',
        requestData: {
          'key': key,
        });

    return apiResponse;
  }

// @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// @┃  SHARE REELS ON NEWSFEED                                              ┃
// @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> shareReelsOnNewsFeed({
    required String reelsId,
    required String reelsDescription,
    required String reelsPrivacy,
    required String key,
  }) async {
    final apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'save-share-reels', requestData: {
      'description': reelsDescription,
      'reels_privacy': reelsPrivacy,
      'share_reels_id': reelsId,
      'key': key,
    });

    return apiResponse;
  }

// @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// @┃  NOTIFY SERVER ON REELS VIEW (Legacy)                                 ┃
// @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> notifyServerOnReelView({required String reelsId}) async {
    final apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'post/reels-view', requestData: {
      'reels_id': reelsId,
    });
    return apiResponse;
  }

// @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// @┃  TRACK REEL VIEW (New — with duration & completion)                   ┃
// @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> trackReelView({
    required String reelId,
    int watchTimeMs = 0,
    bool completed = false,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'reels/track-view',
      requestData: {
        'reelId': reelId,
        'watchTimeMs': watchTimeMs,
        'completed': completed,
      },
    );
    return apiResponse;
  }

// @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// @┃  BATCH TRACK REEL VIEWS                                               ┃
// @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> batchTrackReelViews({
    required List<Map<String, dynamic>> views,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'reels/batch-track',
      requestData: {
        'views': views,
      },
    );
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  FOR YOU FEED (AI Recommendations)                                    ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getForYouReels({
    int limit = 10,
    String? cursor,
    List<String> excludeIds = const [],
  }) async {
    String endpoint = 'reels/for-you?limit=$limit';
    if (cursor != null && cursor.isNotEmpty) {
      endpoint += '&cursor=$cursor';
    }
    if (excludeIds.isNotEmpty) {
      endpoint += '&exclude=${excludeIds.join(",")}';
    }

    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: endpoint,
      responseDataKey: 'data',
    );

    if (apiResponse.isSuccessful && apiResponse.data != null) {
      final Map<String, dynamic> data = apiResponse.data as Map<String, dynamic>;
      final List reelsRaw = data['reels'] ?? [];
      final bool hasMore = data['hasMore'] ?? false;
      final String? nextCursor = data['nextCursor'];

      return apiResponse.copyWith(
        data: {
          'reels': reelsRaw.map((e) => ReelsModel.fromMap(e)).toList(),
          'hasMore': hasMore,
          'nextCursor': nextCursor,
        },
      );
    }
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  FOLLOWING FEED                                                       ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getFollowingReels({
    int limit = 10,
    String? cursor,
  }) async {
    String endpoint = 'reels/following?limit=$limit';
    if (cursor != null && cursor.isNotEmpty) {
      endpoint += '&cursor=$cursor';
    }

    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: endpoint,
      responseDataKey: 'data',
    );

    if (apiResponse.isSuccessful && apiResponse.data != null) {
      final Map<String, dynamic> data = apiResponse.data as Map<String, dynamic>;
      final List reelsRaw = data['reels'] ?? [];
      final bool hasMore = data['hasMore'] ?? false;
      final String? nextCursor = data['nextCursor'];

      return apiResponse.copyWith(
        data: {
          'reels': reelsRaw.map((e) => ReelsModel.fromMap(e)).toList(),
          'hasMore': hasMore,
          'nextCursor': nextCursor,
        },
      );
    }
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  TRENDING FEED                                                        ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getTrendingReels({
    int limit = 10,
    String timeframe = '24h',
  }) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reels/trending?limit=$limit&timeframe=$timeframe',
      responseDataKey: 'data',
    );

    if (apiResponse.isSuccessful && apiResponse.data != null) {
      final Map<String, dynamic> data = apiResponse.data as Map<String, dynamic>;
      final List reelsRaw = data['reels'] ?? [];

      return apiResponse.copyWith(
        data: {
          'reels': reelsRaw.map((e) => ReelsModel.fromMap(e)).toList(),
          'hasMore': false,
        },
      );
    }
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  GET AND SHOW REELS                                                   ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllReels({
    required int skip,
    required int limit,
    bool? enableLoading,
    String? reelId,
    int? reelLength,
  }) async {
    late final ApiResponse apiResponse;

    if (reelId != null) {
      apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint:
            'all-user-reels?limit=$limit&skip=$reelLength&reels_id=$reelId',
        responseDataKey: 'all_reels',
        enableLoading: true,
      );
    } else {
      apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint: 'all-user-reels?limit=$limit&skip=$skip',
        responseDataKey: 'all_reels',
        enableLoading: enableLoading ?? false,
      );
    }

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
        data: (apiResponse.data as List)
            .map((e) => ReelsModel.fromMap(e))
            .toList(),
      );
    } else {
      return apiResponse;
    }
  }

  Future<ApiResponse> getAllReelsOfAnIndividual(
      {required int fromCount, required String userName}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint:
          'all-user-reels?limit=1&skip=$fromCount&username=$userName',
      responseDataKey: 'all_reels',
    );

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: (apiResponse.data as List)
              .map((e) => ReelsModel.fromMap(e))
              .toList());
    } else {
      return apiResponse;
    }
  }

  Future<ApiResponse> getReelsByID({required String reelsID}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'get-single-reel/:$reelsID',
      responseDataKey: 'all_reels',
    );

    // Log the API response data type for debugging
    print('API Response Data: ${apiResponse.data.runtimeType}');

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: (apiResponse.data as List)
              .map((e) => ReelsModel.fromMap(e))
              .toList());
    } else {
      return apiResponse;
    }
  }

// ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ?┃  ACTION ON REELS LIKE                                                  ┃
// ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> LikeAReel({
    required String postId,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-reaction-reel-post',
        requestData: {
          'reaction_type': 'like',
          'post_id': postId,
          'post_single_item_id': null
        });

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: ReelsModel.fromMap(apiResponse.data as Map<String, dynamic>));
    } else {
      return apiResponse;
    }
  }

  Future<ApiResponse> LikeAddsOfAReel({
    required String postId,
    required String key,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-reaction-main-post',
        requestData: {
          'reaction_type': 'like',
          'post_id': postId,
          'post_single_item_id': null,
          'key': key,
        });

    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET REELS COMMENT                                                    ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllCommentsOfAReel({
    required String reelsId,
  }) async {
    final apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint: 'get-all-comments-direct-reel/$reelsId',
        responseDataKey: 'comments');

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: (apiResponse.data as List)
              .map((e) => ReelsCommentModel.fromMap(e))
              .toList());
    } else {
      return apiResponse;
    }
  }

  Future<ApiResponse> getAllCommentsOfAReelAd({
    required String reelsAdId,
  }) async {
    final apiResponse = await _apiCommunication.doGetRequest(
        apiEndPoint: 'campaign/get-reels-ads-comments/$reelsAdId',
        responseDataKey: 'comments');

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: (apiResponse.data as List)
              .map((e) => ReelsCommentModel.fromMap(e))
              .toList());
    } else {
      return apiResponse;
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ACTION ON REELS COMMENT                                               ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> commentOnAReel(
      {required String postId,
      required String userId,
      required String media,
      required String comment, required String key}) async {
    final apiResponse = await _apiCommunication.doPostRequestNew(
        apiEndPoint: 'save-user-comment-by-reel',
        enableLoading: true,
        fileKey: 'image_or_video',
        requestData: {
          'user_id': userId,
          'post_id': postId,
          'comment_name': comment,
          'image_or_video': media,
          'key' : key,
        });

    return apiResponse;
  }

  Future<ApiResponse> commentOnAReelsAdd(
      {required String postId,
      required String userId,
      required String key,
      required String comment}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-user-comment-by-post',
        requestData: {
          'user_id': userId,
          'post_id': postId,
          'comment_name': comment,
          'key' : key,
        });

    return apiResponse;
  }

  Future<ApiResponse> replyToReelComment(
      {required String comment_id,
      required String replies_user_id,
      required String replies_comment_name,
      required String file,
      required String post_id,
      required String key,
      }) async {
    final apiResponse = await _apiCommunication.doPostRequestNew(
        apiEndPoint: 'reply-comment-by-reel-post',
        requestData: {
          'comment_id': comment_id,
          'replies_user_id': replies_user_id,
          'replies_comment_name': replies_comment_name,
          'post_id': post_id,
          'image_or_video': file,
          'key': key
        },
        fileKey: 'image_or_video',
        enableLoading: true);
    return apiResponse;
  }

  Future<ApiResponse> replyToReelsAdComment({
    required String comment_id,
    required String replies_user_id,
    required String replies_comment_name,
    required String post_id,
    required String file,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequestNew(
      apiEndPoint: 'reply-comment-by-direct-post',
      requestData: {
        'comment_id': comment_id,
        'replies_user_id': replies_user_id,
        'replies_comment_name': replies_comment_name,
        'post_id': post_id,
        'image_or_video': file,
      },
      fileKey: 'image_or_video',
    );
    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ACTION ON REELS COMMENT REACTION                                      ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> reactOnAReelComment({
    required String? reactionType,
    required String post_id,
    required String comment_id,
    required String userId,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-comment-reaction-of-reel-post',
        requestData: {
          'reaction_type': reactionType,
          'post_id': post_id,
          'comment_id': comment_id,
          'user_id': userId,
        });

    return apiResponse;
  }

  Future<ApiResponse> reactOnAReplayOfReelComment({
    required String? reactionType,
    required String post_id,
    required String comment_id,
    required String comment_reply_id,
    required String userId,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-comment-reaction-of-reel-post',
        requestData: {
          'reaction_type': reactionType,
          'post_id': post_id,
          'comment_id': comment_id,
          'comment_replies_id': comment_reply_id,
          'user_id': userId,
        });

    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  REELS COMMENT DELETE                                                  ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> deleteACommentFromReel(
      {required String comment_id,
      required String post_id,
      required String key}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment-reel',
        requestData: {
          'comment_id': comment_id,
          'post_id': post_id,
          'type': 'main_comment',
          'key': key,
        });

    return apiResponse;
  }

  Future<ApiResponse> deleteACommentFromReelAd(
      {required String comment_id, required String post_id}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment',
        requestData: {
          'comment_id': comment_id,
          'post_id': post_id,
          'type': 'main_comment'
        });

    return apiResponse;
  }

  Future<ApiResponse> deleteAReplyFromAReelComment(
      {required String reply_id,
      required String post_id,
      required String key}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment-reel',
        requestData: {
          'comment_id': reply_id,
          'post_id': post_id,
          'type': 'reply_comment',
          'key': key
        });

    return apiResponse;
  }

  Future<ApiResponse> deleteAReplyFromAReelCommentOnAd(
      {required String reply_id, required String post_id}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment',
        requestData: {
          'comment_id': reply_id,
          'post_id': post_id,
          'type': 'reply_comment'
        });

    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  SUGGESTED REELS (Newsfeed Insertion & Viewer)                        ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  /// Fetch suggested reels for newsfeed insertion cards.
  /// GET /api/feed/insertion-suggestions/reels?limit=10
  Future<ApiResponse> getSuggestedReelsForFeed({int limit = 10}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'feed/insertion-suggestions/reels?limit=$limit',
      responseDataKey: 'data',
    );

    if (apiResponse.isSuccessful) {
      final reelsList = (apiResponse.data as List)
          .map((e) => ReelsModel.fromMap(e))
          .toList();
      return apiResponse.copyWith(data: reelsList);
    }
    return apiResponse;
  }

  /// Fetch full reel data for the suggested viewer queue.
  /// GET /api/reels/suggested-queue?ids=id1,id2,id3
  Future<ApiResponse> getSuggestedQueue({required List<String> ids}) async {
    final idsParam = ids.join(',');
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reels/suggested-queue?ids=$idsParam',
      responseDataKey: 'data',
    );

    if (apiResponse.isSuccessful) {
      final reelsList = (apiResponse.data as List)
          .map((e) => ReelsModel.fromMap(e))
          .toList();
      return apiResponse.copyWith(data: reelsList);
    }
    return apiResponse;
  }

  /// Dismiss a suggestion card from the newsfeed.
  /// POST /api/feed/insertion-dismiss
  Future<ApiResponse> dismissSuggestionCard({
    required String insertionType,
    required String insertionId,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'feed/insertion-dismiss',
      requestData: {
        'insertionType': insertionType,
        'insertionId': insertionId,
      },
    );
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  GET REELS CAMPAIGNS LIST                                             ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllReelCampaigns() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'campaign/get-reels-ads',
      responseDataKey: 'results',
      enableCache: true,
      timeToLiveInSeconds: 3600 * 24 * 2,
    );

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: (apiResponse.data as List)
              .map((e) => ReelsCampaignResults.fromMap(e))
              .toList());
    } else {
      return apiResponse;
    }
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  BOOKMARK / SAVE REEL                                                 ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> toggleBookmark({required String reelId}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'reels/bookmark/$reelId',
      requestData: {},
    );
    return apiResponse;
  }

  Future<ApiResponse> getMyBookmarkedReels({int limit = 20, int skip = 0}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reels/my-bookmarks?limit=$limit&skip=$skip',
      responseDataKey: 'reels',
    );
    if (apiResponse.isSuccessful && apiResponse.data != null) {
      return apiResponse.copyWith(
        data: (apiResponse.data as List).map((e) => ReelsModel.fromMap(e)).toList(),
      );
    }
    return apiResponse;
  }

  Future<ApiResponse> getBookmarkIds() async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reels/bookmark-ids',
      responseDataKey: 'ids',
    );
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  FEEDBACK (Interested / Not Interested / Hide)                        ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> sendFeedback({
    required String reelId,
    required String signalType,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'reels/feedback/$reelId',
      requestData: {'signal_type': signalType},
    );
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  REACT ON REEL (with reaction type)                                   ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> reactOnAReel({
    required String postId,
    required String reactionType,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-reaction-reel-post',
        requestData: {
          'reaction_type': reactionType,
          'post_id': postId,
          'post_single_item_id': null
        });

    if (apiResponse.isSuccessful) {
      return apiResponse.copyWith(
          data: ReelsModel.fromMap(apiResponse.data as Map<String, dynamic>));
    }
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  WATCH HISTORY                                                        ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getWatchHistory({int limit = 20, int skip = 0}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reels/watch-history?limit=$limit&skip=$skip',
      responseDataKey: 'reels',
    );
    if (apiResponse.isSuccessful && apiResponse.data != null) {
      return apiResponse.copyWith(
        data: (apiResponse.data as List).map((e) => ReelsModel.fromMap(e)).toList(),
      );
    }
    return apiResponse;
  }

  Future<ApiResponse> removeFromWatchHistory({required String reelId}) async {
    final apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'reels/watch-history/$reelId',
      requestData: {},
    );
    return apiResponse;
  }

  Future<ApiResponse> clearWatchHistory() async {
    final apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'reels/watch-history',
      requestData: {},
    );
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  SEARCH SUGGESTIONS                                                   ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getSearchSuggestions({int limit = 15}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'reels/search-suggestions?limit=$limit',
      responseDataKey: 'data',
    );
    return apiResponse;
  }

// *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// *┃  SEARCH REELS                                                         ┃
// *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> searchReels({required String query, int limit = 20, int skip = 0}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      apiEndPoint: 'v2/search/reels?q=$query&limit=$limit&skip=$skip',
      responseDataKey: 'reels',
    );
    if (apiResponse.isSuccessful && apiResponse.data != null) {
      return apiResponse.copyWith(
        data: (apiResponse.data as List).map((e) => ReelsModel.fromMap(e)).toList(),
      );
    }
    return apiResponse;
  }
}
