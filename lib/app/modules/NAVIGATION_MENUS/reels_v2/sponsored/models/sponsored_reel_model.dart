/// Model for a sponsored reel placement in the V2 reels feed.
/// Maps to backend CampaignV2 data returned from ad serve endpoint.
class SponsoredReelModel {
  final String? id;
  final String? campaignId;
  final String? advertiserId;
  final String? advertiserName;
  final String? advertiserAvatar;
  final bool isVerified;

  // Video / creative
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? caption;
  final int? durationMs;

  // CTA
  final String? ctaLabel;
  final String? ctaUrl;
  final String? ctaType; // learn_more, shop_now, sign_up, download, contact_us

  // Targeting metadata
  final String? targetingReason;
  final List<String> targetingCategories;

  // Tracking
  final String? impressionBeaconUrl;
  final String? clickBeaconUrl;
  final int frequencyCap;
  final int currentFrequency;

  // Status
  final String? status; // active, paused, completed
  final String? boostId;
  final bool isBoosted;

  // Engagement counts
  int likeCount;
  int commentCount;
  int shareCount;
  int viewCount;
  String? userReaction;

  SponsoredReelModel({
    this.id,
    this.campaignId,
    this.advertiserId,
    this.advertiserName,
    this.advertiserAvatar,
    this.isVerified = false,
    this.videoUrl,
    this.thumbnailUrl,
    this.caption,
    this.durationMs,
    this.ctaLabel,
    this.ctaUrl,
    this.ctaType,
    this.targetingReason,
    this.targetingCategories = const [],
    this.impressionBeaconUrl,
    this.clickBeaconUrl,
    this.frequencyCap = 3,
    this.currentFrequency = 0,
    this.status,
    this.boostId,
    this.isBoosted = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.viewCount = 0,
    this.userReaction,
  });

  factory SponsoredReelModel.fromJson(Map<String, dynamic> json) {
    return SponsoredReelModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      campaignId: json['campaignId'] as String? ?? json['campaign_id'] as String?,
      advertiserId: json['advertiserId'] as String? ?? json['advertiser_id'] as String?,
      advertiserName: json['advertiserName'] as String? ?? json['advertiser_name'] as String?,
      advertiserAvatar: json['advertiserAvatar'] as String? ?? json['advertiser_avatar'] as String?,
      isVerified: json['isVerified'] == true || json['is_verified'] == true,
      videoUrl: json['videoUrl'] as String? ?? json['video_url'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String? ?? json['thumbnail_url'] as String?,
      caption: json['caption'] as String?,
      durationMs: json['durationMs'] as int? ?? json['duration_ms'] as int?,
      ctaLabel: json['ctaLabel'] as String? ?? json['cta_label'] as String? ?? 'Learn More',
      ctaUrl: json['ctaUrl'] as String? ?? json['cta_url'] as String? ?? json['website_url'] as String?,
      ctaType: json['ctaType'] as String? ?? json['cta_type'] as String?,
      targetingReason: json['targetingReason'] as String? ?? json['targeting_reason'] as String?,
      targetingCategories: (json['targetingCategories'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['targeting_categories'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      impressionBeaconUrl: json['impressionBeaconUrl'] as String? ?? json['impression_beacon_url'] as String?,
      clickBeaconUrl: json['clickBeaconUrl'] as String? ?? json['click_beacon_url'] as String?,
      frequencyCap: json['frequencyCap'] as int? ?? json['frequency_cap'] as int? ?? 3,
      currentFrequency: json['currentFrequency'] as int? ?? json['current_frequency'] as int? ?? 0,
      status: json['status'] as String?,
      boostId: json['boostId'] as String? ?? json['boost_id'] as String?,
      isBoosted: json['isBoosted'] == true || json['is_boosted'] == true,
      likeCount: json['likeCount'] as int? ?? json['like_count'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? json['comment_count'] as int? ?? 0,
      shareCount: json['shareCount'] as int? ?? json['share_count'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? json['view_count'] as int? ?? 0,
      userReaction: json['userReaction'] as String? ?? json['user_reaction'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'campaignId': campaignId,
        'advertiserId': advertiserId,
        'advertiserName': advertiserName,
        'advertiserAvatar': advertiserAvatar,
        'isVerified': isVerified,
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
        'caption': caption,
        'durationMs': durationMs,
        'ctaLabel': ctaLabel,
        'ctaUrl': ctaUrl,
        'ctaType': ctaType,
        'targetingReason': targetingReason,
        'targetingCategories': targetingCategories,
        'impressionBeaconUrl': impressionBeaconUrl,
        'clickBeaconUrl': clickBeaconUrl,
        'frequencyCap': frequencyCap,
        'currentFrequency': currentFrequency,
        'status': status,
        'boostId': boostId,
        'isBoosted': isBoosted,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'shareCount': shareCount,
        'viewCount': viewCount,
        'userReaction': userReaction,
      };

  SponsoredReelModel copyWith({
    String? id,
    String? campaignId,
    String? advertiserId,
    String? advertiserName,
    String? advertiserAvatar,
    bool? isVerified,
    String? videoUrl,
    String? thumbnailUrl,
    String? caption,
    int? durationMs,
    String? ctaLabel,
    String? ctaUrl,
    String? ctaType,
    String? targetingReason,
    List<String>? targetingCategories,
    String? impressionBeaconUrl,
    String? clickBeaconUrl,
    int? frequencyCap,
    int? currentFrequency,
    String? status,
    String? boostId,
    bool? isBoosted,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    int? viewCount,
    String? userReaction,
  }) {
    return SponsoredReelModel(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      advertiserId: advertiserId ?? this.advertiserId,
      advertiserName: advertiserName ?? this.advertiserName,
      advertiserAvatar: advertiserAvatar ?? this.advertiserAvatar,
      isVerified: isVerified ?? this.isVerified,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      durationMs: durationMs ?? this.durationMs,
      ctaLabel: ctaLabel ?? this.ctaLabel,
      ctaUrl: ctaUrl ?? this.ctaUrl,
      ctaType: ctaType ?? this.ctaType,
      targetingReason: targetingReason ?? this.targetingReason,
      targetingCategories: targetingCategories ?? this.targetingCategories,
      impressionBeaconUrl: impressionBeaconUrl ?? this.impressionBeaconUrl,
      clickBeaconUrl: clickBeaconUrl ?? this.clickBeaconUrl,
      frequencyCap: frequencyCap ?? this.frequencyCap,
      currentFrequency: currentFrequency ?? this.currentFrequency,
      status: status ?? this.status,
      boostId: boostId ?? this.boostId,
      isBoosted: isBoosted ?? this.isBoosted,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      viewCount: viewCount ?? this.viewCount,
      userReaction: userReaction ?? this.userReaction,
    );
  }
}
