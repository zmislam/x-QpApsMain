import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import '../models/comment_model.dart';

import '../config/constants/api_constant.dart';
import '../models/api_response.dart';
import '../models/post.dart';
import '../models/video_campaign_model.dart';
import '../services/api_communication.dart';

class PostRepository {
  final ApiCommunication _apiCommunication = ApiCommunication();

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL POSTS                                                        ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getPosts({
    required int pageNo,
    required int pageSize,
    bool? forceRecallAPI,
  }) async {
    List<PostModel> postList = [];
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: true,
      forceRecallAPI: forceRecallAPI,
      enableLoading: false,
      timeToLiveInSeconds: 60 * 15,
      // ==> 15 m cached
      apiEndPoint: 'get-all-users-posts-v2?pageNo=$pageNo&pageSize=$pageSize',
    );

    if (apiResponse.isSuccessful) {
      int pageCount = (apiResponse.data as Map<String, dynamic>)['pageCount'];
      postList = (((apiResponse.data as Map<String, dynamic>)['posts']) as List)
          .map((element) => PostModel.fromMap(element))
          .toList();
      ApiResponse apiResponseToPass =
          apiResponse.copyWith(pageCount: pageCount, data: postList);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET INDIVIDUAL POSTS                                                 ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getIndividualPosts({
    required int pageNo,
    required int pageSize,
    required String userName,
  }) async {
    List<PostModel> postList = [];
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint:
          'get-all-users-posts-individual-for-app?pageNo=$pageNo&pageSize=$pageSize',
      requestData: {
        'username': userName,
      },
    );

    if (apiResponse.isSuccessful) {
      int pageCount = (apiResponse.data as Map<String, dynamic>)['pageCount'];
      final rawPosts = (apiResponse.data as Map<String, dynamic>)['posts'];
      final List<dynamic> rawList = (rawPosts is List) ? rawPosts : <dynamic>[];

      postList = rawList
          .where((e) => e != null)
          .map<PostModel?>((element) {
        try {
          if (element is Map<String, dynamic>) {
            return PostModel.fromMap(element);
          } else if (element is String) {
            return PostModel.fromJson(element); // existing factory that expects a string
          } else {
            debugPrint('Skipping unexpected post element: ${element.runtimeType}');
            return null;
          }
        } catch (err, st) {
          debugPrint('Error parsing post element -> $err\n$st');
          return null;
        }
      })
          .whereType<PostModel>()   // removes nulls safely
          .toList();

      ApiResponse apiResponseToPass =
          apiResponse.copyWith(pageCount: pageCount, data: postList);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL POSTS | GROUP                                                ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getGroupPosts({
    required String groupId,
    required int pageNo,
    required int pageSize,
  }) async {
    List<PostModel> postList = [];
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-group-posts?pageNo=$pageNo&pageSize=$pageSize',
      requestData: {
        'group_id': groupId,
      },
    );

    if (!apiResponse.isSuccessful) {
      return apiResponse;
    }

    // Defensive parsing of full response
    final data = apiResponse.data;
    if (data == null || data is! Map<String, dynamic>) {
      debugPrint('getGroupPosts: unexpected response format, expected Map<String,dynamic>');
      return apiResponse.copyWith(pageCount: 1, data: <PostModel>[]);
    }

    final Map<String, dynamic> full = data;
    final int? pageCount = (full['pageCount'] is int) ? full['pageCount'] as int : (full['pageCount'] != null ? int.tryParse('${full['pageCount']}') : null);

    final rawPosts = full['posts'];
    final List<dynamic> rawList = (rawPosts is List) ? rawPosts : <dynamic>[];

    // Optional: log bad entries for backend debugging
    rawList.asMap().forEach((i, e) {
      if (e == null || e is! Map<String, dynamic>) {
        debugPrint('getGroupPosts: skipping invalid post at index $i -> $e');
      }
    });

    // Filter and parse safely
    postList = rawList
        .where((e) => e != null && e is Map<String, dynamic>)
        .map((e) {
      try {
        return PostModel.fromMap(e as Map<String, dynamic>);
      } catch (err, st) {
        debugPrint('getGroupPosts: error parsing post element -> $err\n$st');
        return null;
      }
    })
        .where((p) => p != null)
        .map((p) => p!)
        .toList();

    final ApiResponse apiResponseToPass = apiResponse.copyWith(pageCount: pageCount, data: postList);
    return apiResponseToPass;
  }


  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET GROUP FEED POSTS                                                 ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getGroupFeedPosts({
    required int pageNo,
    required int pageSize,
    bool? forceRecallAPI,
  }) async {
    List<PostModel> postList = [];
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-groups-post?pageNo=$pageNo&pageSize=$pageSize',
      enableCache: true,
      forceRecallAPI: forceRecallAPI,
      enableLoading: false,
      timeToLiveInSeconds: 3600 * 5, // ? 5 Hour cache time
      // requestData: {
      //   'group_id': groupId,
      // }
    );

    if (apiResponse.isSuccessful) {
      int? pageCount = (apiResponse.data as Map<String, dynamic>)['totalCount'];
      postList = (((apiResponse.data as Map<String, dynamic>)['posts']) as List)
          .map((element) => PostModel.fromMap(element))
          .toList();
      ApiResponse apiResponseToPass =
          apiResponse.copyWith(pageCount: pageCount, data: postList);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET POST TYPE AD's FOR THE TIMELINE POST                             ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAdsPagePosts({
    required int pageNo,
    required int pageSize,
  }) async {
    List<PostModel> postList = [];
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'campaign/get-center-side-ads-as-post',
      enableCache: true,
      timeToLiveInSeconds: 3600 * 24 * 2, // ? 2 days cache time
      // requestData: {
      //   'group_id': groupId,
      // }
    );

    if (apiResponse.isSuccessful) {
      // int? pageCount = (apiResponse.data as Map<String, dynamic>)['pageCount'];
      postList = (((apiResponse.data as Map<String, dynamic>)['posts']) as List)
          .map((element) => PostModel.fromMap(element))
          .toList();
      ApiResponse apiResponseToPass = apiResponse.copyWith(data: postList);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET VIDEO TYPE AD's FOR THE TIMELINE POST                            ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getVideoAds() async {
    List<VideoCampaignModel> videoAdsList = [];
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'campaign/get-video-ads',
      enableCache: true,
      timeToLiveInSeconds: 3600 * 24 * 2,
      // requestData: {
      //   'group_id': groupId,
      // }
    );

    if (apiResponse.isSuccessful) {
      // int? pageCount = (apiResponse.data as Map<String, dynamic>)['pageCount'];
      videoAdsList =
          (((apiResponse.data as Map<String, dynamic>)['results']) as List)
              .map((element) => VideoCampaignModel.fromJson(element))
              .toList();
      ApiResponse apiResponseToPass = apiResponse.copyWith(data: videoAdsList);
      return apiResponseToPass;
    } else {
      return apiResponse;
    }
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  HANDEL POST REACTION                                                  ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> reactOnPost({
    required PostModel postModel,
    required String reaction,
    required String key,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'save-reaction-main-post',
      requestData: {
        'reaction_type': reaction,
        'post_id': postModel.id,
        'post_single_item_id': null,
        'key': key,
      },
    );
    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃    HANDEL POST REPORTING MARK TO REMOVE                                ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> reportAPost({
    required String post_id,
    required String report_type,
    required String description,
    required String report_type_id,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'save-post-report',
      enableLoading: true,
      requestData: {
        'post_id': post_id,
        'report_type': report_type,
        'description': description,
        'report_type_id': report_type_id
      },
    );

    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  HIDE A POST FROM TIMELINE                                             ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> hidePost(
      {required int status, required String post_id}) async {
    final apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'hide-unhide-post', requestData: {
      'status': status,
      'post_id': post_id,
    });

    return apiResponse;
  }

  // @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // @┃  BOOKMARK A POST                                                      ┃
  // @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> bookMarkAPost(
      {required String post_id, required String postPrivacy}) async {
    final apiResponse = await _apiCommunication
        .doPostRequest(apiEndPoint: 'save-post-bookmark', requestData: {
      'post_privacy': postPrivacy,
      'post_id': post_id,
    });

    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃   REMOVE A POST FROM BOOKMARK                                          ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> unBookmarkAPost(
      {required String post_id, required String bookMarkId}) async {
    final apiResponse = await _apiCommunication.doDeleteRequest(
      apiEndPoint: 'remove-post-bookmark/$bookMarkId',
    );

    return apiResponse;
  }

  // *┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // *┃  GET ALL COMMENTS OF A POST                                            ┃
  // *┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> getAllCommentsOfAPost({required String postID}) async {
    final apiResponse = await _apiCommunication.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      apiEndPoint: 'get-all-comments-direct-post/$postID',
    );

    return apiResponse.copyWith(
      data: (((apiResponse.data as Map<String, dynamic>)['comments']) as List)
          .map((element) => CommentModel.fromMap(element))
          .toList(),
    );
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ACTION ON POST COMMENTS --> SEND COMMENT                              ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> sendCommentOnAPost(
      {required PostModel postModel,
      required String comment,
      required String processedFileData}) async {
    final apiResponse = await _apiCommunication.doPostRequestNew(
        apiEndPoint: 'save-user-comment-by-post',
        enableLoading: true,
        requestData: {
          'user_id': postModel.user_id?.id,
          'post_id': postModel.id,
          'comment_name': comment,
          'link': null,
          'link_title': null,
          'link_description': null,
          'link_image': null,
          'image_or_video': processedFileData,
          'key' : postModel.key ?? '',
        },
        fileKey: 'files',
        processedFileNames: processedFileData,
        responseDataKey: 'posts');

    return apiResponse;
  }

  // ?┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // ?┃  ACTION ON POST COMMENTS --> REPLY ON A COMMENT                        ┃
  // ?┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> replyOnCommentOfAPost({
    required String comment_id,
    required String replies_comment_name,
    required String post_id,
    required String replyUserID,
    required String files,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequestNew(
      apiEndPoint: 'reply-comment-by-direct-post',
      enableLoading: true,
      requestData: {
        'comment_id': comment_id,
        'replies_user_id': replyUserID,
        'replies_comment_name': replies_comment_name,
        'post_id': post_id,
        'image_or_video': files,
      },
      fileKey: 'image_or_video',
    );

    return apiResponse;
  }

  // @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // @┃  ACTION ON POST COMMENTS --> REACT ON A COMMENT                        ┃
  // @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> reactOnComment({
    required String reaction_type,
    required String post_id,
    required String comment_id,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-comment-reaction-of-direct-post',
        requestData: {
          'reaction_type': reaction_type,
          'post_id': post_id,
          'comment_id': comment_id
        });

    return apiResponse;
  }

  // @┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // @┃  ACTION ON POST COMMENTS --> REACT ON A COMMENT REPLY                  ┃
  // @┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> replyOnCommentWithReaction({
    required String reaction_type,
    required String post_id,
    required String comment_id,
    required String comment_replies_id,
    required String userId,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-comment-reaction-of-direct-post',
        requestData: {
          'reaction_type': reaction_type,
          'user_id': userId,
          'post_id': post_id,
          'comment_id': comment_id,
          'comment_replies_id': comment_replies_id,
        });

    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  ACTION ON POST COMMENTS --> DELETE MY COMMENT FROM A POST             ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> deleteCommentFromAPost({
    required String comment_id,
    required String post_id,
  }) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'delete-single-comment',
        requestData: {
          'comment_id': comment_id,
          'post_id': post_id,
          'type': 'main_comment'
        });

    return apiResponse;
  }

  // !┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // !┃  ACTION ON POST COMMENTS --> DELETE MY REPLY ON A POST COMMENT         ┃
  // !┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> deleteCommentReplyFromAPost(
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

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃  SHARE ANY POSTS                                                      ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> shareUserPost(
      {required String sharePostId,
      required String description,
      required String postTag}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
        apiEndPoint: 'save-share-post-with-caption',
        requestData: {
          'share_post_id': sharePostId,
          'description': description,
          'privacy': postTag,
        });
    return apiResponse;
  }

  // $┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  // $┃    CREATE PHOTO COMMENT ON A POST                                     ┃
  // $┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  Future<ApiResponse> createPhotoComment(
      {required String userId,
      required String postId,
      required String key,
      required String comment,
      required List<XFile> files}) async {
    final apiResponse = await _apiCommunication.doPostRequest(
      apiEndPoint: 'save-user-comment-by-post',
      isFormData: true,
      enableLoading: true,
      requestData: {
        'user_id': userId, //postModel.user_id?.id,
        'post_id': postId, //postModel.id,
        'comment_name': comment,
        'image_or_video': null,
        'link': null,
        'link_title': null,
        'link_description': null,
        'link_image': null,
        'key' : key
      },
      // fileKey: 'image_or_video',
      mediaXFiles: files,
    );

    return apiResponse;
  }
}
