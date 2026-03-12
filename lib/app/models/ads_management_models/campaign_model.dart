// To parse this JSON data, do
//
//     final campaignModel = campaignModelFromJson(jsonString);

import 'dart:convert';

List<CampaignModel> campaignModelFromJson(String str) => List<CampaignModel>.from(json.decode(str).map((x) => CampaignModel.fromJson(x)));

String campaignModelToJson(List<CampaignModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CampaignModel {
  String? id;
  String? userId;
  String? postId;
  dynamic deletedAt;
  String? campaignName;
  String? campaignCategory;
  String? pageName;
  String? pageId;
  DateTime? startDate;
  DateTime? endDate;
  String? callToAction;
  String? websiteUrl;
  double? totalBudget;
  double? dailyBudget;
  String? gender;
  String? headline;
  String? description;
  dynamic phoneNumber;
  List? campaignCoverPic;
  String? adsPlacement;
  String? destination;
  String? ageGroup;
  int? fromAge;
  int? toAge;
  List<String>? locations;
  List<String>? keywords;
  String? adminStatus;
  String? status;
  String? approvedDeclinedBy;
  String? createdBy;
  dynamic rejectNote;
  String? updatedBy;
  double? earningClickPrice;
  double? earningReactionPrice;
  double? earningCommentPrice;
  double? earningSharePrice;
  double? earningWatch10Sec;
  double? earningImpressionPrice;
  int? earningReachPrice;
  dynamic aspectRatio;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<Subscription>? subscriptions;

  CampaignModel({
    this.id,
    this.userId,
    this.postId,
    this.deletedAt,
    this.campaignName,
    this.campaignCategory,
    this.pageName,
    this.pageId,
    this.startDate,
    this.endDate,
    this.callToAction,
    this.websiteUrl,
    this.totalBudget,
    this.dailyBudget,
    this.gender,
    this.headline,
    this.description,
    this.phoneNumber,
    this.campaignCoverPic,
    this.adsPlacement,
    this.destination,
    this.ageGroup,
    this.fromAge,
    this.toAge,
    this.locations,
    this.keywords,
    this.adminStatus,
    this.status,
    this.approvedDeclinedBy,
    this.createdBy,
    this.rejectNote,
    this.updatedBy,
    this.earningClickPrice,
    this.earningReactionPrice,
    this.earningCommentPrice,
    this.earningSharePrice,
    this.earningWatch10Sec,
    this.earningImpressionPrice,
    this.earningReachPrice,
    this.aspectRatio,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.subscriptions,
  });

  CampaignModel copyWith({
    String? id,
    String? userId,
    String? postId,
    dynamic deletedAt,
    String? campaignName,
    String? campaignCategory,
    String? pageName,
    String? pageId,
    DateTime? startDate,
    DateTime? endDate,
    String? callToAction,
    String? websiteUrl,
    double? totalBudget,
    double? dailyBudget,
    String? gender,
    String? headline,
    String? description,
    dynamic phoneNumber,
    dynamic campaignCoverPic,
    String? adsPlacement,
    String? destination,
    String? ageGroup,
    int? fromAge,
    int? toAge,
    List<String>? locations,
    List<String>? keywords,
    String? adminStatus,
    String? status,
    String? approvedDeclinedBy,
    String? createdBy,
    dynamic rejectNote,
    String? updatedBy,
    double? earningClickPrice,
    double? earningReactionPrice,
    double? earningCommentPrice,
    double? earningSharePrice,
    double? earningWatch10Sec,
    double? earningImpressionPrice,
    int? earningReachPrice,
    dynamic aspectRatio,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    List<Subscription>? subscriptions,
  }) =>
      CampaignModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        postId: postId ?? this.postId,
        deletedAt: deletedAt ?? this.deletedAt,
        campaignName: campaignName ?? this.campaignName,
        campaignCategory: campaignCategory ?? this.campaignCategory,
        pageName: pageName ?? this.pageName,
        pageId: pageId ?? this.pageId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        callToAction: callToAction ?? this.callToAction,
        websiteUrl: websiteUrl ?? this.websiteUrl,
        totalBudget: totalBudget ?? this.totalBudget,
        dailyBudget: dailyBudget ?? this.dailyBudget,
        gender: gender ?? this.gender,
        headline: headline ?? this.headline,
        description: description ?? this.description,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        campaignCoverPic: campaignCoverPic ?? this.campaignCoverPic,
        adsPlacement: adsPlacement ?? this.adsPlacement,
        destination: destination ?? this.destination,
        ageGroup: ageGroup ?? this.ageGroup,
        fromAge: fromAge ?? this.fromAge,
        toAge: toAge ?? this.toAge,
        locations: locations ?? this.locations,
        keywords: keywords ?? this.keywords,
        adminStatus: adminStatus ?? this.adminStatus,
        status: status ?? this.status,
        approvedDeclinedBy: approvedDeclinedBy ?? this.approvedDeclinedBy,
        createdBy: createdBy ?? this.createdBy,
        rejectNote: rejectNote ?? this.rejectNote,
        updatedBy: updatedBy ?? this.updatedBy,
        earningClickPrice: earningClickPrice ?? this.earningClickPrice,
        earningReactionPrice: earningReactionPrice ?? this.earningReactionPrice,
        earningCommentPrice: earningCommentPrice ?? this.earningCommentPrice,
        earningSharePrice: earningSharePrice ?? this.earningSharePrice,
        earningWatch10Sec: earningWatch10Sec ?? this.earningWatch10Sec,
        earningImpressionPrice: earningImpressionPrice ?? this.earningImpressionPrice,
        earningReachPrice: earningReachPrice ?? this.earningReachPrice,
        aspectRatio: aspectRatio ?? this.aspectRatio,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        subscriptions: subscriptions ?? this.subscriptions,
      );

  factory CampaignModel.fromJson(Map<String, dynamic> json) => CampaignModel(
        id: json['_id'],
        userId: json['user_id'],
        postId: json['post_id'],
        deletedAt: json['deleted_at'],
        campaignName: json['campaign_name'],
        campaignCategory: json['campaign_category'],
        pageName: json['page_name'],
        pageId: json['page_id'],
        startDate: json['start_date'] == null ? null : DateTime.parse(json['start_date']),
        endDate: json['end_date'] == null ? null : DateTime.parse(json['end_date']),
        callToAction: json['call_to_action'],
        websiteUrl: json['website_url'],
        totalBudget: double.parse(json['total_budget'].toString()),
        dailyBudget: double.parse(json['daily_budget'].toString()),
        gender: json['gender'],
        headline: json['headline'],
        description: json['description'],
        phoneNumber: json['phone_number'],
        campaignCoverPic: json['campaign_cover_pic'] == null
            ? []
            : json['campaign_cover_pic'] is! String
                ? json['campaign_cover_pic']
                : [json['campaign_cover_pic']],
        adsPlacement: json['ads_placement'],
        destination: json['destination'],
        ageGroup: json['age_group'],
        fromAge: json['from_age'],
        toAge: json['to_age'],
        locations: json['locations'] == null ? [] : List<String>.from(json['locations']!.map((x) => x)),
        keywords: json['keywords'] == null ? [] : List<String>.from(json['keywords']!.map((x) => x)),
        adminStatus: json['admin_status'],
        status: json['status'],
        approvedDeclinedBy: json['approved_declined_by'],
        createdBy: json['created_by'],
        rejectNote: json['reject_note'],
        updatedBy: json['updated_by'],
        earningClickPrice: json['earning_click_price']?.toDouble(),
        earningReactionPrice: json['earning_reaction_price']?.toDouble(),
        earningCommentPrice: json['earning_comment_price']?.toDouble(),
        earningSharePrice: json['earning_share_price']?.toDouble(),
        earningWatch10Sec: json['earning_watch_10sec']?.toDouble(),
        earningImpressionPrice: json['earning_impression_price']?.toDouble(),
        earningReachPrice: json['earning_reach_price'],
        aspectRatio: json['aspectRatio'],
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
        v: json['__v'],
        subscriptions: json['subscriptions'] == null ? [] : List<Subscription>.from(json['subscriptions']!.map((x) => Subscription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId,
        'post_id': postId,
        'deleted_at': deletedAt,
        'campaign_name': campaignName,
        'campaign_category': campaignCategory,
        'page_name': pageName,
        'page_id': pageId,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'call_to_action': callToAction,
        'website_url': websiteUrl,
        'total_budget': totalBudget,
        'daily_budget': dailyBudget,
        'gender': gender,
        'headline': headline,
        'description': description,
        'phone_number': phoneNumber,
        'campaign_cover_pic': campaignCoverPic,
        'ads_placement': adsPlacement,
        'destination': destination,
        'age_group': ageGroup,
        'from_age': fromAge,
        'to_age': toAge,
        'locations': locations == null ? [] : List<dynamic>.from(locations!.map((x) => x)),
        'keywords': keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
        'admin_status': adminStatus,
        'status': status,
        'approved_declined_by': approvedDeclinedBy,
        'created_by': createdBy,
        'reject_note': rejectNote,
        'updated_by': updatedBy,
        'earning_click_price': earningClickPrice,
        'earning_reaction_price': earningReactionPrice,
        'earning_comment_price': earningCommentPrice,
        'earning_share_price': earningSharePrice,
        'earning_watch_10sec': earningWatch10Sec,
        'earning_impression_price': earningImpressionPrice,
        'earning_reach_price': earningReachPrice,
        'aspectRatio': aspectRatio,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'subscriptions': subscriptions == null ? [] : List<dynamic>.from(subscriptions!.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'CampaignModel{id: $id, userId: $userId, postId: $postId, deletedAt: $deletedAt, campaignName: $campaignName, campaignCategory: $campaignCategory, pageName: $pageName, pageId: $pageId, startDate: $startDate, endDate: $endDate, callToAction: $callToAction, websiteUrl: $websiteUrl, totalBudget: $totalBudget, dailyBudget: $dailyBudget, gender: $gender, headline: $headline, description: $description, phoneNumber: $phoneNumber, campaignCoverPic: $campaignCoverPic, adsPlacement: $adsPlacement, destination: $destination, ageGroup: $ageGroup, fromAge: $fromAge, toAge: $toAge, locations: $locations, keywords: $keywords, adminStatus: $adminStatus, status: $status, approvedDeclinedBy: $approvedDeclinedBy, createdBy: $createdBy, rejectNote: $rejectNote, updatedBy: $updatedBy, earningClickPrice: $earningClickPrice, earningReactionPrice: $earningReactionPrice, earningCommentPrice: $earningCommentPrice, earningSharePrice: $earningSharePrice, earningWatch10Sec: $earningWatch10Sec, earningImpressionPrice: $earningImpressionPrice, earningReachPrice: $earningReachPrice, aspectRatio: $aspectRatio, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, subscriptions: $subscriptions}';
  }
}

class Subscription {
  String? id;
  String? campaignId;
  bool? isActive;
  String? ageGroup;
  String? gender;
  int? fromAge;
  int? toAge;
  List<String>? locations;
  List<String>? keywords;
  double? totalBudget;
  double? dailyBudget;
  DateTime? startDate;
  DateTime? endDate;
  String? websiteUrl;
  String? adsPlacement;
  double? earningClickPrice;
  double? earningReactionPrice;
  double? earningCommentPrice;
  double? earningSharePrice;
  double? earningWatch10Sec;
  double? earningImpressionPrice;
  int? earningReachPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Subscription({
    this.id,
    this.campaignId,
    this.isActive,
    this.ageGroup,
    this.gender,
    this.fromAge,
    this.toAge,
    this.locations,
    this.keywords,
    this.totalBudget,
    this.dailyBudget,
    this.startDate,
    this.endDate,
    this.websiteUrl,
    this.adsPlacement,
    this.earningClickPrice,
    this.earningReactionPrice,
    this.earningCommentPrice,
    this.earningSharePrice,
    this.earningWatch10Sec,
    this.earningImpressionPrice,
    this.earningReachPrice,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json['_id'],
        campaignId: json['campaign_id'],
        isActive: json['isActive'],
        ageGroup: json['age_group'],
        gender: json['gender'],
        fromAge: json['from_age'],
        toAge: json['to_age'],
        locations: json['locations'] == null ? [] : List<String>.from(json['locations']!.map((x) => x)),
        keywords: json['keywords'] == null ? [] : List<String>.from(json['keywords']!.map((x) => x)),
        totalBudget: double.parse(json['total_budget'].toString()),
        dailyBudget: double.parse(json['daily_budget'].toString()),
        startDate: json['start_date'] == null ? null : DateTime.parse(json['start_date']),
        endDate: json['end_date'] == null ? null : DateTime.parse(json['end_date']),
        websiteUrl: json['website_url'],
        adsPlacement: json['ads_placement'],
        earningClickPrice: json['earning_click_price']?.toDouble(),
        earningReactionPrice: json['earning_reaction_price']?.toDouble(),
        earningCommentPrice: json['earning_comment_price']?.toDouble(),
        earningSharePrice: json['earning_share_price']?.toDouble(),
        earningWatch10Sec: json['earning_watch_10sec']?.toDouble(),
        earningImpressionPrice: json['earning_impression_price']?.toDouble(),
        earningReachPrice: json['earning_reach_price'],
        createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'campaign_id': campaignId,
        'isActive': isActive,
        'age_group': ageGroup,
        'gender': gender,
        'from_age': fromAge,
        'to_age': toAge,
        'locations': locations == null ? [] : List<dynamic>.from(locations!.map((x) => x)),
        'keywords': keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
        'total_budget': totalBudget,
        'daily_budget': dailyBudget,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'website_url': websiteUrl,
        'ads_placement': adsPlacement,
        'earning_click_price': earningClickPrice,
        'earning_reaction_price': earningReactionPrice,
        'earning_comment_price': earningCommentPrice,
        'earning_share_price': earningSharePrice,
        'earning_watch_10sec': earningWatch10Sec,
        'earning_impression_price': earningImpressionPrice,
        'earning_reach_price': earningReachPrice,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return 'Subscription{id: $id, campaignId: $campaignId, isActive: $isActive, ageGroup: $ageGroup, gender: $gender, fromAge: $fromAge, toAge: $toAge, locations: $locations, keywords: $keywords, totalBudget: $totalBudget, dailyBudget: $dailyBudget, startDate: $startDate, endDate: $endDate, websiteUrl: $websiteUrl, adsPlacement: $adsPlacement, earningClickPrice: $earningClickPrice, earningReactionPrice: $earningReactionPrice, earningCommentPrice: $earningCommentPrice, earningSharePrice: $earningSharePrice, earningWatch10Sec: $earningWatch10Sec, earningImpressionPrice: $earningImpressionPrice, earningReachPrice: $earningReachPrice, createdAt: $createdAt, updatedAt: $updatedAt, v: $v}';
  }
}
