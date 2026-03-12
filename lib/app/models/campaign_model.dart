
class Campaign {
  String? id;
  String? userId;
  String? postId;
  String? deletedAt;
  String? campaignName;
  String? campaignCategory;
  String? pageName;
  String? pageId;
  DateTime? startDate;
  DateTime? endDate;
  String? callToAction;
  String? websiteUrl;
  num? totalBudget;
  num? dailyBudget;
  String? gender;
  String? headline;
  String? description;
  String? phoneNumber;
  List<String?>? campaignCoverPic;
  String? adsPlacement;
  String? destination;
  String? ageGroup;
  int? fromAge;
  int? toAge;
  List<String?>? locations;
  List<String?>? keywords;
  String? adminStatus;
  String? status;
  String? approvedDeclinedBy;
  String? createdBy;
  String? rejectNote;
  String? updatedBy;
  num? earningClickPrice;
  num? earningReactionPrice;
  num? earningCommentPrice;
  num? earningSharePrice;
  num? earningWatch10Sec;
  num? earningImpressionPrice;
  num? earningReachPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Campaign({
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
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  // From JSON constructor
  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['_id'] as String?,
      userId: json['user_id'] as String?,
      postId: json['post_id'] as String?,
      deletedAt: json['deleted_at'] as String?,
      campaignName: json['campaign_name'] as String?,
      campaignCategory: json['campaign_category'] as String?,
      pageName: json['page_name'] as String?,
      pageId: json['page_id'] as String?,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      callToAction: json['call_to_action'] as String?,
      websiteUrl: json['website_url'] as String?,
      totalBudget: json['total_budget'] as num?,
      dailyBudget: json['daily_budget'] as num?,
      gender: json['gender'] as String?,
      headline: json['headline'] as String?,
      description: json['description'] as String?,
      phoneNumber: json['phone_number'] as String?,
      campaignCoverPic: json['campaign_cover_pic'] != null
          ? List<String>.from(json['campaign_cover_pic'])
          : null,
      adsPlacement: json['ads_placement'] as String?,
      destination: json['destination'] as String?,
      ageGroup: json['age_group'] as String?,
      fromAge: json['from_age'] as int?,
      toAge: json['to_age'] as int?,
      locations: json['locations'] != null
          ? List<String>.from(json['locations'])
          : null,
      keywords: json['keywords'] != null
          ? List<String>.from(json['keywords'])
          : null,
      adminStatus: json['admin_status'] as String?,
      status: json['status'] as String?,
      approvedDeclinedBy: json['approved_declined_by'] as String?,
      createdBy: json['created_by'] as String?,
      rejectNote: json['reject_note'] as String?,
      updatedBy: json['updated_by'] as String?,
      earningClickPrice: json['earning_click_price'] as num?,
      earningReactionPrice: json['earning_reaction_price'] as num?,
      earningCommentPrice: json['earning_comment_price'] as num?,
      earningSharePrice: json['earning_share_price'] as num?,
      earningWatch10Sec: json['earning_watch_10sec'] as num?,
      earningImpressionPrice: json['earning_impression_price'] as num?,
      earningReachPrice: json['earning_reach_price'] as num?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'] as int?,
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

