import 'dart:convert';

class EarningSummaryModel {
  List<EarningSummaryResult>? results;
  int? status;

  EarningSummaryModel({
    this.results,
    this.status,
  });

  EarningSummaryModel copyWith({
    List<EarningSummaryResult>? results,
    int? status,
  }) =>
      EarningSummaryModel(
        results: results ?? this.results,
        status: status ?? this.status,
      );

  factory EarningSummaryModel.fromRawJson(String str) => EarningSummaryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EarningSummaryModel.fromJson(Map<String, dynamic> json) => EarningSummaryModel(
    results: json['results'] == null ? [] : List<EarningSummaryResult>.from(json['results']!.map((x) => EarningSummaryResult.fromJson(x))),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'results': results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    'status': status,
  };
}

class EarningSummaryResult {
  List<Total>? totalPost;
  List<Total>? totalReels;
  List<Total>? totalPostReactionCount;
  List<Total>? totalPostCommentCount;
  List<Total>? totalSharePost;

  EarningSummaryResult({
    this.totalPost,
    this.totalReels,
    this.totalPostReactionCount,
    this.totalPostCommentCount,
    this.totalSharePost,
  });

  EarningSummaryResult copyWith({
    List<Total>? totalPost,
    List<Total>? totalReels,
    List<Total>? totalPostReactionCount,
    List<Total>? totalPostCommentCount,
    List<Total>? totalSharePost,
  }) =>
      EarningSummaryResult(
        totalPost: totalPost ?? this.totalPost,
        totalReels: totalReels ?? this.totalReels,
        totalPostReactionCount: totalPostReactionCount ?? this.totalPostReactionCount,
        totalPostCommentCount: totalPostCommentCount ?? this.totalPostCommentCount,
        totalSharePost: totalSharePost ?? this.totalSharePost,
      );

  factory EarningSummaryResult.fromRawJson(String str) => EarningSummaryResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EarningSummaryResult.fromJson(Map<String, dynamic> json) => EarningSummaryResult(
    totalPost: json['total_post'] == null ? [] : List<Total>.from(json['total_post']!.map((x) => Total.fromJson(x))),
    totalReels: json['total_reels'] == null ? [] : List<Total>.from(json['total_reels']!.map((x) => Total.fromJson(x))),
    totalPostReactionCount: json['total_post_reaction_count'] == null ? [] : List<Total>.from(json['total_post_reaction_count']!.map((x) => Total.fromJson(x))),
    totalPostCommentCount: json['total_post_comment_count'] == null ? [] : List<Total>.from(json['total_post_comment_count']!.map((x) => Total.fromJson(x))),
    totalSharePost: json['total_share_post'] == null ? [] : List<Total>.from(json['total_share_post']!.map((x) => Total.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'total_post': totalPost == null ? [] : List<dynamic>.from(totalPost!.map((x) => x.toJson())),
    'total_reels': totalReels == null ? [] : List<dynamic>.from(totalReels!.map((x) => x.toJson())),
    'total_post_reaction_count': totalPostReactionCount == null ? [] : List<dynamic>.from(totalPostReactionCount!.map((x) => x.toJson())),
    'total_post_comment_count': totalPostCommentCount == null ? [] : List<dynamic>.from(totalPostCommentCount!.map((x) => x.toJson())),
    'total_share_post': totalSharePost == null ? [] : List<dynamic>.from(totalSharePost!.map((x) => x.toJson())),
  };
}

class Total {
  int? count;

  Total({
    this.count,
  });

  Total copyWith({
    int? count,
  }) =>
      Total(
        count: count ?? this.count,
      );

  factory Total.fromRawJson(String str) => Total.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Total.fromJson(Map<String, dynamic> json) => Total(
    count: json['count'],
  );

  Map<String, dynamic> toJson() => {
    'count': count,
  };
}
