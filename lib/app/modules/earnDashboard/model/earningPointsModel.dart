import 'dart:convert';

class EarningPointsModel {
  final List<EarningPointsResult>? result;
  final int? status;

  EarningPointsModel({
    this.result,
    this.status,
  });

  EarningPointsModel copyWith({
    List<EarningPointsResult>? result,
    int? status,
  }) =>
      EarningPointsModel(
        result: result ?? this.result,
        status: status ?? this.status,
      );

  factory EarningPointsModel.fromRawJson(String str) =>
      EarningPointsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EarningPointsModel.fromJson(Map<String, dynamic> json) =>
      EarningPointsModel(
        result: json['result'] == null
            ? null
            : List<EarningPointsResult>.from(
                json['result'].map((x) => EarningPointsResult.fromJson(x))),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'result': result == null
            ? null
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        'status': status,
      };
}

class EarningPointsResult {
  final PointCount? myPostReactionPointCount;
  final PointCount? myActivityPostReactionPointCount;
  final PointCount? myPostCommentPointCount;
  final PointCount? myActivityPostCommentPointCount;
  final PointCount? myReelsViewPoints;
  final PointCount? myActivityReelsViewPoints;
  final CampaignPoints? campaignPoints;
  final PointCount? withdrawPoints;
  final double? totalPoints;
  final double? totalWithdrawPoints;
  final double? currentPoints;
  final PointCount? myPostSharePointCount;
  final PointCount? myActivityPostSharePointCount;

  EarningPointsResult({
    this.myPostReactionPointCount,
    this.myActivityPostReactionPointCount,
    this.myPostCommentPointCount,
    this.myActivityPostCommentPointCount,
    this.myReelsViewPoints,
    this.myActivityReelsViewPoints,
    this.campaignPoints,
    this.withdrawPoints,
    this.totalPoints,
    this.totalWithdrawPoints,
    this.currentPoints,
    this.myPostSharePointCount,
    this.myActivityPostSharePointCount,
  });

  EarningPointsResult copyWith({
    PointCount? myPostReactionPointCount,
    PointCount? myActivityPostReactionPointCount,
    PointCount? myPostCommentPointCount,
    PointCount? myActivityPostCommentPointCount,
    PointCount? myReelsViewPoints,
    PointCount? myActivityReelsViewPoints,
    CampaignPoints? campaignPoints,
    PointCount? withdrawPoints,
    double? totalPoints,
    double? totalWithdrawPoints,
    double? currentPoints,
    PointCount? myPostSharePointCount,
    PointCount? myActivityPostSharePointCount,
  }) =>
      EarningPointsResult(
        myPostReactionPointCount:
            myPostReactionPointCount ?? this.myPostReactionPointCount,
        myActivityPostReactionPointCount: myActivityPostReactionPointCount ??
            this.myActivityPostReactionPointCount,
        myPostCommentPointCount:
            myPostCommentPointCount ?? this.myPostCommentPointCount,
        myActivityPostCommentPointCount: myActivityPostCommentPointCount ??
            this.myActivityPostCommentPointCount,
        myReelsViewPoints: myReelsViewPoints ?? this.myReelsViewPoints,
        myActivityReelsViewPoints:
            myActivityReelsViewPoints ?? this.myActivityReelsViewPoints,
        campaignPoints: campaignPoints ?? this.campaignPoints,
        withdrawPoints: withdrawPoints ?? this.withdrawPoints,
        totalPoints: totalPoints ?? this.totalPoints,
        totalWithdrawPoints: totalWithdrawPoints ?? this.totalWithdrawPoints,
        currentPoints: currentPoints ?? this.currentPoints,
        myPostSharePointCount:
            myPostSharePointCount ?? this.myPostSharePointCount,
        myActivityPostSharePointCount:
            myActivityPostSharePointCount ?? this.myActivityPostSharePointCount,
      );

  factory EarningPointsResult.fromRawJson(String str) =>
      EarningPointsResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EarningPointsResult.fromJson(Map<String, dynamic> json) =>
      EarningPointsResult(
        myPostReactionPointCount: json['my_post_reaction_point_count'] == null
            ? null
            : PointCount.fromJson(json['my_post_reaction_point_count']),
        myActivityPostReactionPointCount:
            json['my_activity_post_reaction_point_count'] == null
                ? null
                : PointCount.fromJson(
                    json['my_activity_post_reaction_point_count']),
        myPostCommentPointCount: json['my_post_comment_point_count'] == null
            ? null
            : PointCount.fromJson(json['my_post_comment_point_count']),
        myActivityPostCommentPointCount:
            json['my_activity_post_comment_point_count'] == null
                ? null
                : PointCount.fromJson(
                    json['my_activity_post_comment_point_count']),
        myReelsViewPoints: json['my_reels_view_points'] == null
            ? null
            : PointCount.fromJson(json['my_reels_view_points']),
        myActivityReelsViewPoints: json['my_activity_reels_view_points'] == null
            ? null
            : PointCount.fromJson(json['my_activity_reels_view_points']),
        campaignPoints: json['campaign_points'] == null
            ? null
            : CampaignPoints.fromJson(json['campaign_points']),
        withdrawPoints: json['withdraw_points'] == null
            ? null
            : PointCount.fromJson(json['withdraw_points']),
        totalPoints: json['total_points']?.toDouble(),
        totalWithdrawPoints: json['total_withdraw_points']?.toDouble(),
        currentPoints: json['current_points']?.toDouble(),
        myPostSharePointCount: json['my_post_share_point_count'] == null
            ? null
            : PointCount.fromJson(json['my_post_share_point_count']),
        myActivityPostSharePointCount:
            json['my_activity_post_share_point_count'] == null
                ? null
                : PointCount.fromJson(
                    json['my_activity_post_share_point_count']),
      );

  Map<String, dynamic> toJson() => {
        'my_post_reaction_point_count': myPostReactionPointCount?.toJson(),
        'my_activity_post_reaction_point_count':
            myActivityPostReactionPointCount?.toJson(),
        'my_post_comment_point_count': myPostCommentPointCount?.toJson(),
        'my_activity_post_comment_point_count':
            myActivityPostCommentPointCount?.toJson(),
        'my_reels_view_points': myReelsViewPoints?.toJson(),
        'my_activity_reels_view_points': myActivityReelsViewPoints?.toJson(),
        'campaign_points': campaignPoints?.toJson(),
        'withdraw_points': withdrawPoints?.toJson(),
        'total_points': totalPoints,
        'total_withdraw_points': totalWithdrawPoints,
        'current_points': currentPoints,
        'my_post_share_point_count': myPostSharePointCount?.toJson(),
        'my_activity_post_share_point_count':
            myActivityPostSharePointCount?.toJson(),
      };
}

class PointCount {
  final double? points;

  PointCount({
    this.points,
  });

  PointCount copyWith({
    double? points,
  }) =>
      PointCount(
        points: points ?? this.points,
      );

  factory PointCount.fromRawJson(String str) =>
      PointCount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PointCount.fromJson(Map<String, dynamic> json) => PointCount(
        points: json['points']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'points': points,
      };
}

class CampaignPoints {
  final double? campaignClickPoint;
  final double? campaignImpressionPoint;
  final double? campaignReachedPoint;
  final double? campaignReactionPoint;
  final double? campaignCommentPoint;
  final double? campaignSharePoint;
  final double? campaignWatch10SecPoint;

  CampaignPoints({
    this.campaignClickPoint,
    this.campaignImpressionPoint,
    this.campaignReachedPoint,
    this.campaignReactionPoint,
    this.campaignCommentPoint,
    this.campaignSharePoint,
    this.campaignWatch10SecPoint,
  });

  CampaignPoints copyWith({
    double? campaignClickPoint,
    double? campaignImpressionPoint,
    double? campaignReachedPoint,
    double? campaignReactionPoint,
    double? campaignCommentPoint,
    double? campaignSharePoint,
    double? campaignWatch10SecPoint,
  }) =>
      CampaignPoints(
        campaignClickPoint: campaignClickPoint ?? this.campaignClickPoint,
        campaignImpressionPoint:
            campaignImpressionPoint ?? this.campaignImpressionPoint,
        campaignReachedPoint: campaignReachedPoint ?? this.campaignReachedPoint,
        campaignReactionPoint:
            campaignReactionPoint ?? this.campaignReactionPoint,
        campaignCommentPoint: campaignCommentPoint ?? this.campaignCommentPoint,
        campaignSharePoint: campaignSharePoint ?? this.campaignSharePoint,
        campaignWatch10SecPoint:
            campaignWatch10SecPoint ?? this.campaignWatch10SecPoint,
      );

  factory CampaignPoints.fromRawJson(String str) =>
      CampaignPoints.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CampaignPoints.fromJson(Map<String, dynamic> json) => CampaignPoints(
        campaignClickPoint: json['campaign_click_point']?.toDouble(),
        campaignImpressionPoint: json['campaign_impression_point']?.toDouble(),
        campaignReachedPoint: json['campaign_reached_point']?.toDouble(),
        campaignReactionPoint: json['campaign_reaction_point']?.toDouble(),
        campaignCommentPoint: json['campaign_comment_point']?.toDouble(),
        campaignSharePoint: json['campaign_share_point']?.toDouble(),
        campaignWatch10SecPoint: json['campaign_watch_10sec_point']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'campaign_click_point': campaignClickPoint,
        'campaign_impression_point': campaignImpressionPoint,
        'campaign_reached_point': campaignReachedPoint,
        'campaign_reaction_point': campaignReactionPoint,
        'campaign_comment_point': campaignCommentPoint,
        'campaign_share_point': campaignSharePoint,
        'campaign_watch_10sec_point': campaignWatch10SecPoint,
      };
}
