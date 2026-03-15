// =============================================================================
// Search Suggestion & History Models
// =============================================================================

class SearchSuggestion {
  final String type; // "user" | "page" | "group" | "query"
  final String? id;
  final String text;
  final String? subtitle;
  final String? avatar;
  final bool verified;
  final bool isFriend;

  SearchSuggestion({
    required this.type,
    this.id,
    required this.text,
    this.subtitle,
    this.avatar,
    this.verified = false,
    this.isFriend = false,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      type: json['type']?.toString() ?? 'query',
      id: json['id']?.toString(),
      text: json['text']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      avatar: json['avatar']?.toString(),
      verified: json['verified'] == true,
      isFriend: json['isFriend'] == true,
    );
  }
}

class SearchHistoryItem {
  final String id;
  final String query;
  final String type; // "query" | "user" | "page" | "group" | "product" | "reel"
  final String? resultId;
  final String? resultType;
  final String? timestamp;

  SearchHistoryItem({
    required this.id,
    required this.query,
    required this.type,
    this.resultId,
    this.resultType,
    this.timestamp,
  });

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['_id']?.toString() ?? '',
      query: json['query']?.toString() ?? '',
      type: json['type']?.toString() ?? 'query',
      resultId: json['result_id']?.toString(),
      resultType: json['result_type']?.toString(),
      timestamp: json['timestamp']?.toString(),
    );
  }
}

class TrendingSearch {
  final String query;
  final String? category;
  final int searchCount;

  TrendingSearch({
    required this.query,
    this.category,
    this.searchCount = 0,
  });

  factory TrendingSearch.fromJson(Map<String, dynamic> json) {
    return TrendingSearch(
      query: json['query']?.toString() ?? '',
      category: json['category']?.toString() ?? json['type']?.toString(),
      searchCount: (json['searchCount'] as num?)?.toInt() ??
          (json['search_count'] as num?)?.toInt() ??
          0,
    );
  }
}
