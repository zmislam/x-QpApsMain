// =============================================================================
// Advance Search Repository — V2 Search API communication layer
// =============================================================================
// All calls go to /api/v2/search/* endpoints.
//
// Created: 2026-03-14
// =============================================================================

import 'package:flutter/foundation.dart';

import '../../../config/constants/api_constant.dart';
import '../../../services/api_communication.dart';
import '../models/search_result_models.dart';
import '../models/search_suggestion_model.dart';

class AdvanceSearchRepository {
  final ApiCommunication _api = ApiCommunication();

  // ─── Unified Search ──────────────────────────────────────────────────────

  /// Performs a unified search across all categories or a specific one.
  /// [type] — 'all', 'people', 'posts', 'reels', 'pages', 'groups', 'marketplace'
  /// [filters] — category-specific filter params
  Future<UnifiedSearchResult> unifiedSearch({
    required String query,
    String type = 'all',
    int? limit,
    String? cursor,
    Map<String, String>? filters,
  }) async {
    if (query.trim().isEmpty) return UnifiedSearchResult.empty();

    final params = StringBuffer('q=${Uri.encodeQueryComponent(query)}&type=$type');
    if (limit != null) params.write('&limit=$limit');
    if (cursor != null && cursor.isNotEmpty) params.write('&cursor=$cursor');
    if (filters != null) {
      filters.forEach((key, value) {
        if (value.isNotEmpty) params.write('&$key=${Uri.encodeQueryComponent(value)}');
      });
    }

    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: false,
      enableLoading: false,
      apiEndPoint: 'v2/search/unified?$params',
    );

    if (response.isSuccessful) {
      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? responseData;
        return UnifiedSearchResult.fromJson(data);
      } catch (e) {
        debugPrint('[AdvanceSearch] unifiedSearch parse error: $e');
      }
    }
    return UnifiedSearchResult.empty();
  }

  // ─── Category-specific search (for pagination) ──────────────────────────

  /// Search a single category with cursor-based pagination.
  Future<SearchResultPage<T>> searchCategory<T>({
    required String category, // 'people', 'reels', 'pages', 'groups', 'marketplace', 'posts'
    required String query,
    required T Function(Map<String, dynamic>) fromJson,
    int limit = 20,
    String? cursor,
    Map<String, String>? filters,
  }) async {
    final params = StringBuffer('q=${Uri.encodeQueryComponent(query)}&limit=$limit');
    if (cursor != null && cursor.isNotEmpty) params.write('&cursor=$cursor');
    if (filters != null) {
      filters.forEach((key, value) {
        if (value.isNotEmpty) params.write('&$key=${Uri.encodeQueryComponent(value)}');
      });
    }

    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: false,
      enableLoading: false,
      apiEndPoint: 'v2/search/$category?$params',
    );

    if (response.isSuccessful) {
      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? responseData;
        return _parsePage(data, fromJson);
      } catch (e) {
        debugPrint('[AdvanceSearch] searchCategory($category) parse error: $e');
      }
    }
    return SearchResultPage.empty();
  }

  SearchResultPage<T> _parsePage<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final items = (json['items'] as List?)
            ?.map((e) => fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return SearchResultPage(
      items: items,
      total: (json['total'] as num?)?.toInt() ?? items.length,
      hasMore: json['hasMore'] as bool? ?? false,
      nextCursor: json['nextCursor'] as String?,
    );
  }

  // ─── Search Suggestions ──────────────────────────────────────────────────

  Future<List<SearchSuggestion>> getSearchSuggestions({
    required String query,
    int limit = 8,
  }) async {
    if (query.trim().isEmpty) return [];

    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: false,
      enableLoading: false,
      apiEndPoint: 'v2/search/suggestions?q=${Uri.encodeQueryComponent(query)}&limit=$limit',
    );

    if (response.isSuccessful) {
      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? responseData;
        final suggestions = data['suggestions'] as List? ?? [];
        return suggestions
            .map((s) => SearchSuggestion.fromJson(s as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('[AdvanceSearch] getSearchSuggestions parse error: $e');
      }
    }
    return [];
  }

  // ─── Search History ──────────────────────────────────────────────────────

  Future<List<SearchHistoryItem>> getSearchHistory({int limit = 20}) async {
    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: false,
      enableLoading: false,
      apiEndPoint: 'v2/search/history?limit=$limit',
    );

    if (response.isSuccessful) {
      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? responseData;
        final searches = data['searches'] as List? ?? [];
        return searches
            .map((s) => SearchHistoryItem.fromJson(s as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('[AdvanceSearch] getSearchHistory parse error: $e');
      }
    }
    return [];
  }

  Future<bool> addSearchHistory({
    required String query,
    String type = 'query',
    String? resultId,
    String? resultType,
    String category = 'all',
  }) async {
    final response = await _api.doPostRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: false,
      apiEndPoint: 'v2/search/history',
      requestData: {
        'query': query,
        'type': type,
        if (resultId != null) 'result_id': resultId,
        if (resultType != null) 'result_type': resultType,
        'category': category,
      },
    );
    return response.isSuccessful;
  }

  Future<bool> deleteSearchHistoryItem(String id) async {
    final response = await _api.doDeleteRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: false,
      apiEndPoint: 'v2/search/history/$id',
    );
    return response.isSuccessful;
  }

  Future<bool> clearAllSearchHistory() async {
    final response = await _api.doDeleteRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableLoading: false,
      apiEndPoint: 'v2/search/history',
    );
    return response.isSuccessful;
  }

  // ─── Trending Searches ──────────────────────────────────────────────────

  Future<List<TrendingSearch>> getTrendingSearches({int limit = 10}) async {
    final response = await _api.doGetRequest(
      responseDataKey: ApiConstant.FULL_RESPONSE,
      enableCache: false,
      enableLoading: false,
      apiEndPoint: 'v2/search/trending?limit=$limit',
    );

    if (response.isSuccessful) {
      try {
        final responseData = response.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? responseData;
        final trending = data['trending'] as List? ?? [];
        return trending
            .map((t) => TrendingSearch.fromJson(t as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('[AdvanceSearch] getTrendingSearches parse error: $e');
      }
    }
    return [];
  }

  // ─── User Actions ────────────────────────────────────────────────────────

  Future<bool> sendFriendRequest(String userId) async {
    final response = await _api.doPostRequest(
      enableLoading: false,
      apiEndPoint: 'send-friend-request',
      requestData: {'connected_user_id': userId},
    );
    return response.isSuccessful;
  }

  Future<bool> cancelFriendRequest(String userId) async {
    final response = await _api.doPostRequest(
      enableLoading: false,
      apiEndPoint: 'cancel-friend-request',
      requestData: {'requested_user_id': userId},
    );
    return response.isSuccessful;
  }

  Future<bool> followPage(String pageId) async {
    final response = await _api.doPostRequest(
      enableLoading: false,
      apiEndPoint: 'follow-page',
      requestData: {
        'page_id': pageId,
        'follow_unfollow_status': '',
        'like_unlike_status': '',
        'user_id': '',
      },
    );
    return response.isSuccessful;
  }

  Future<bool> unfollowPage(String pageId) async {
    final response = await _api.doPostRequest(
      enableLoading: false,
      apiEndPoint: 'unfollow-page',
      requestData: {'page_id': pageId},
    );
    return response.isSuccessful;
  }

  Future<bool> joinGroup(String groupId) async {
    final response = await _api.doPostRequest(
      enableLoading: false,
      apiEndPoint: 'groups/send-group-invitation-join-request',
      requestData: {
        'group_id': groupId,
        'type': 'join',
        'user_id_arr': <String>[],
      },
    );
    return response.isSuccessful;
  }
}
