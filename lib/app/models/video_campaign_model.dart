import 'post.dart';

class VideoCampaignModel {
  final String? id;
  final String? userId;
  final String? postId;
  final String? campaignName;
  final String? campaignCategory;
  final String? pageName;
  final PageId? pageId;
  final String? startDate;
  final String? endDate;
  final String? callToAction;
  final String? websiteUrl;
  final double? totalBudget;
  final double? dailyBudget;
  final String? gender;
  final String? headline;
  final String? description;
  final String? phoneNumber;
  final List<String>? campaignCoverPic;
  final String? adsPlacement;
  final String? destination;
  final String? ageGroup;
  final int? fromAge;
  final int? toAge;
  final List<String>? locations;
  final List<String>? keywords;
  final String? adminStatus;
  final String? status;
  final String? approvedDeclinedBy;
  final String? createdBy;
  final String? rejectNote;
  final String? updatedBy;
  final double? earningClickPrice;
  final double? earningReactionPrice;
  final double? earningCommentPrice;
  final double? earningSharePrice;
  final double? earningWatch10Sec;
  final double? earningImpressionPrice;
  final double? earningReachPrice;
  final String? createdAt;
  final String? updatedAt;
  final bool? hasSubscriptions;
  final String? calStartDate;
  final String? calEndDate;
  final String? calAdsPlacement;
  final int? calToAge;
  final double? calTotalBudget;
  final double? calDailyBudget;
  final String? calGender;
  final String? calAgeGroup;
  final int? calFromAge;
  final List<String>? calLocations;
  final String? today;
  final double? remainingDailyBudget;
  final double? randomField;
  final int? priority;
  final isAlreadyPlayed=false;

  VideoCampaignModel({
    this.id,
    this.userId,
    this.postId,
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
    this.createdAt,
    this.updatedAt,
    this.hasSubscriptions,
    this.calStartDate,
    this.calEndDate,
    this.calAdsPlacement,
    this.calToAge,
    this.calTotalBudget,
    this.calDailyBudget,
    this.calGender,
    this.calAgeGroup,
    this.calFromAge,
    this.calLocations,
    this.today,
    this.remainingDailyBudget,
    this.randomField,
    this.priority,
  });

  factory VideoCampaignModel.fromJson(Map<String, dynamic>? map) {
    if (map == null) return VideoCampaignModel();

    return VideoCampaignModel(
      id: map['_id'],
      userId: map['user_id'],
      postId: map['post_id'],
      campaignName: map['campaign_name'],
      campaignCategory: map['campaign_category'],
      pageName: map['page_name'],
      pageId: map['page_id'] != null ? PageId.fromJson(map['page_id']) : null,
      startDate: map['start_date'],
      endDate: map['end_date'],
      callToAction: map['call_to_action'],
      websiteUrl: map['website_url'],
      totalBudget: (map['total_budget'] as num?)?.toDouble(),
      dailyBudget: (map['daily_budget'] as num?)?.toDouble(),
      gender: map['gender'],
      headline: map['headline'],
      description: map['description'],
      phoneNumber: map['phone_number'],
      campaignCoverPic: List<String>.from(map['campaign_cover_pic'] ?? []),
      adsPlacement: map['ads_placement'],
      destination: map['destination'],
      ageGroup: map['age_group'],
      fromAge: map['from_age'],
      toAge: map['to_age'],
      locations: List<String>.from(map['locations'] ?? []),
      keywords: List<String>.from(map['keywords'] ?? []),
      adminStatus: map['admin_status'],
      status: map['status'],
      approvedDeclinedBy: map['approved_declined_by'],
      createdBy: map['created_by'],
      rejectNote: map['reject_note'],
      updatedBy: map['updated_by'],
      earningClickPrice: (map['earning_click_price'] as num?)?.toDouble(),
      earningReactionPrice: (map['earning_reaction_price'] as num?)?.toDouble(),
      earningCommentPrice: (map['earning_comment_price'] as num?)?.toDouble(),
      earningSharePrice: (map['earning_share_price'] as num?)?.toDouble(),
      earningWatch10Sec: (map['earning_watch_10sec'] as num?)?.toDouble(),
      earningImpressionPrice:
          (map['earning_impression_price'] as num?)?.toDouble(),
      earningReachPrice: (map['earning_reach_price'] as num?)?.toDouble(),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      hasSubscriptions: map['hasSubscriptions'],
      calStartDate: map['cal_start_date'],
      calEndDate: map['cal_end_date'],
      calAdsPlacement: map['cal_ads_placement'],
      calToAge: map['cal_to_age'],
      calTotalBudget: (map['cal_total_budget'] as num?)?.toDouble(),
      calDailyBudget: (map['cal_daily_budget'] as num?)?.toDouble(),
      calGender: map['cal_gender'],
      calAgeGroup: map['cal_age_group'],
      calFromAge: map['cal_from_age'],
      calLocations: List<String>.from(map['cal_locations'] ?? []),
      today: map['today'],
      remainingDailyBudget:
          (map['remaining_daily_budget'] as num?)?.toDouble(),
      randomField: (map['randomField'] as num?)?.toDouble(),
      priority: map['priority'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': userId,
      'post_id': postId,
      'campaign_name': campaignName,
      'campaign_category': campaignCategory,
      'page_name': pageName,
      'page_id': pageId?.toJson(),
      'start_date': startDate,
      'end_date': endDate,
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
      'locations': locations,
      'keywords': keywords,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'hasSubscriptions': hasSubscriptions,
      'cal_start_date': calStartDate,
      'cal_end_date': calEndDate,
      'cal_ads_placement': calAdsPlacement,
      'cal_to_age': calToAge,
      'cal_total_budget': calTotalBudget,
      'cal_daily_budget': calDailyBudget,
      'cal_gender': calGender,
      'cal_age_group': calAgeGroup,
      'cal_from_age': calFromAge,
      'cal_locations': calLocations,
      'today': today,
      'remaining_daily_budget': remainingDailyBudget,
      'randomField': randomField,
      'priority': priority,
    };
  }
}