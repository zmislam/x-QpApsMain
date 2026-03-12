class ReelsCampaignResults {
  String? id;
  String? description;
  String? userId;
  String? status;
  String? createdAt;
  List<CampaignReactionModel>? reactions;
  String? reelsPrivacy;
  String? video;
  ReelUser? reelUser;
  ReelsCampaign? reelsCampaign;
  String? key;
  int? commentCount;
  int? replyCount;
  int? reactionCount;
  bool? isReelsAds;

  ReelsCampaignResults({
    this.id,
    this.description,
    this.userId,
    this.status,
    this.createdAt,
    this.reactions,
    this.reelsPrivacy,
    this.video,
    this.reelUser,
    this.reelsCampaign,
    this.key,
    this.commentCount,
    this.replyCount,
    this.reactionCount,
    this.isReelsAds,
  });

  // fromMap
  ReelsCampaignResults.fromMap(Map<String, dynamic> map) {
    id = map['_id'] as String?;
    description = map['description'] as String?;
    userId = map['user_id'] as String?;
    status = map['status'] as String?;
    createdAt = map['createdAt'] as String?;
    reactions = map['reactions'] == null
        ? null
        : List<CampaignReactionModel>.from(map['reactions']
            .map((reactionMap) => CampaignReactionModel.fromMap(reactionMap)));

    reelsPrivacy = map['reels_privacy'] as String?;
    video = map['video'] as String?;
    reelUser =
        map['reel_user'] == null ? null : ReelUser.fromMap(map['reel_user']);
    reelsCampaign =
        map['campaign'] == null ? null : ReelsCampaign.fromMap(map['campaign']);
    key = map['key'] as String?;
    commentCount = map['comment_count'] as int?;
    replyCount = map['reply_count'] as int?;
    reactionCount = map['reaction_count'] as int?;
    isReelsAds = map['isReelsAds'] as bool?;
  }

  // toMap
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['description'] = description;
    data['user_id'] = userId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    if (reactions != null) {
      data['reactions'] = reactions;
    }
    data['reels_privacy'] = reelsPrivacy;
    data['video'] = video;
    if (reelUser != null) {
      data['reel_user'] = reelUser?.toMap();
    }
    if (reelsCampaign != null) {
      data['campaign'] = reelsCampaign?.toMap();
    }
    data['key'] = key;
    data['comment_count'] = commentCount;
    data['reply_count'] = replyCount;
    data['reaction_count'] = reactionCount;
    data['isReelsAds'] = isReelsAds;
    return data;
  }
}

class ReelUser {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePic;

  ReelUser(
      {this.id, this.firstName, this.lastName, this.username, this.profilePic});

  // fromMap
  ReelUser.fromMap(Map<String, dynamic> map) {
    id = map['_id'] as String?;
    firstName = map['first_name'] as String?;
    lastName = map['last_name'] as String?;
    username = map['username'] as String?;
    profilePic = map['profile_pic'] as String?;
  }

  // toMap
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['profile_pic'] = profilePic;
    return data;
  }
}

class ReelsCampaign {
  String? id;
  String? userId;
  String? postId;
  String? campaignName;
  String? campaignCategory;
  String? pageName;
  CampaignPage? page;
  DateTime? startDate;
  DateTime? endDate;
  String? callToAction;
  String? websiteUrl;
  double? totalBudget;
  double? dailyBudget;
  String? gender;
  String? headline;
  String? description;
  String? phoneNumber;
  String? campaignCoverPic;
  String? adsPlacement;
  String? destination;
  String? ageGroup;
  String? fromAge;
  String? toAge;
  List<String>? locations;
  List<String>? keywords;
  String? adminStatus;
  String? status;
  String? createdBy;
  String? updatedBy;
  double? earningClickPrice;
  double? earningReactionPrice;
  double? earningCommentPrice;
  double? earningSharePrice;
  double? earningWatch10Sec;
  double? earningImpressionPrice;
  double? earningReachPrice;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReelsCampaign({
    this.id,
    this.userId,
    this.postId,
    this.campaignName,
    this.campaignCategory,
    this.pageName,
    this.page,
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
    this.createdBy,
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
  });

  factory ReelsCampaign.fromMap(Map<String, dynamic> map) {
    return ReelsCampaign(
      id: map['_id'] ?? '',
      userId: map['user_id'] ?? '',
      postId: map['post_id'] ?? '',
      campaignName: map['campaign_name'] ?? '',
      campaignCategory: map['campaign_category'] ?? '',
      pageName: map['page_name'] ?? '',
      page: CampaignPage.fromMap(map['page_id'] ?? {}),
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      callToAction: map['call_to_action'] ?? '',
      websiteUrl: map['website_url'] ?? '',
      totalBudget: double.parse(map['total_budget'].toString()),
      dailyBudget: double.parse(map['daily_budget'].toString()),
      gender: map['gender'] ?? '',
      headline: map['headline'] ?? '',
      description: map['description'] ?? '',
      phoneNumber: map['phone_number'],
      campaignCoverPic: (map['campaign_cover_pic']) as String?,
      adsPlacement: map['ads_placement'] ?? '',
      destination: map['destination'],
      ageGroup: map['age_group'] ?? '',
      fromAge: map['from_age'].toString(),
      toAge: map['to_age'].toString(),
      locations: List<String>.from(map['locations'] ?? []),
      keywords: List<String>.from(map['keywords'] ?? []),
      adminStatus: map['admin_status'] ?? '',
      status: map['status'] ?? '',
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'] ?? '',
      earningClickPrice: double.parse(map['earning_click_price'].toString()),
      earningReactionPrice:
          double.parse(map['earning_reaction_price'].toString()),
      earningCommentPrice:
          double.parse(map['earning_comment_price'].toString()),
      earningSharePrice: double.parse(map['earning_share_price'].toString()),
      earningWatch10Sec: double.parse(map['earning_watch_10sec'].toString()),
      earningImpressionPrice:
          double.parse(map['earning_impression_price'].toString()),
      earningReachPrice: double.parse(map['earning_reach_price'].toString()),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
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
      'page': page?.toMap(),
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
      'created_by': createdBy,
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
    };
  }
}

class CampaignPage {
  String? id;
  String? pageName;
  List<String?> category;
  List<String?> friends;
  List<String?> location;
  String? bio;
  String? description;
  String? website;
  String? email;
  String? zipCode;
  String? profilePic;
  String? coverPic;
  String? pageUserName;
  String? phoneNumber;
  bool? isFollowed;
  String? privacy;
  bool? peopleCanMessage;

  CampaignPage({
    required this.id,
    required this.pageName,
    required this.category,
    required this.friends,
    required this.location,
    required this.bio,
    required this.description,
    this.website,
    this.email,
    required this.zipCode,
    required this.profilePic,
    required this.coverPic,
    required this.pageUserName,
    this.phoneNumber,
    required this.isFollowed,
    required this.privacy,
    required this.peopleCanMessage,
  });

  factory CampaignPage.fromMap(Map<String, dynamic> map) {
    return CampaignPage(
      id: map['_id'] ?? '',
      pageName: map['page_name'] ?? '',
      category: List<String>.from(map['category'] ?? []),
      friends: List<String>.from(map['friends'] ?? []),
      location: List<String>.from(map['location'] ?? []),
      bio: map['bio'] ?? '',
      description: map['description'] ?? '',
      website: map['website'],
      email: map['email'],
      zipCode: map['zip_code'] ?? '',
      profilePic: map['profile_pic'] ?? '',
      coverPic: map['cover_pic'] ?? '',
      pageUserName: map['page_user_name'] ?? '',
      phoneNumber: map['phone_number'],
      isFollowed: map['isFollowed'] ?? false,
      privacy: map['privacy'] ?? '',
      peopleCanMessage: map['people_can_message'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'page_name': pageName,
      'category': category,
      'friends': friends,
      'location': location,
      'bio': bio,
      'description': description,
      'website': website,
      'email': email,
      'zip_code': zipCode,
      'profile_pic': profilePic,
      'cover_pic': coverPic,
      'page_user_name': pageUserName,
      'phone_number': phoneNumber,
      'isFollowed': isFollowed,
      'privacy': privacy,
      'people_can_message': peopleCanMessage,
    };
  }
}

class CampaignReactionModel {
  final String? id;
  final String? reactionType;
  final String? userId;
  final String? postId;
  final CampaignReactedUser? reactedUser;

  CampaignReactionModel({
    this.id,
    this.reactionType,
    this.userId,
    this.postId,
    this.reactedUser,
  });

  factory CampaignReactionModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return CampaignReactionModel();

    return CampaignReactionModel(
      id: map['_id'] as String?,
      reactionType: map['reaction_type'] as String?,
      userId: map['user_id'] as String?,
      postId: map['post_id'] as String?,
      reactedUser: map['reacted_user'] != null
          ? CampaignReactedUser.fromMap(
              map['reacted_user'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'reaction_type': reactionType,
      'user_id': userId,
      'post_id': postId,
      'reacted_user': reactedUser?.toMap(),
    };
  }
}

class CampaignReactedUser {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePic;

  CampaignReactedUser({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
  });

  factory CampaignReactedUser.fromMap(Map<String, dynamic>? map) {
    if (map == null) return CampaignReactedUser();

    return CampaignReactedUser(
      id: map['_id'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      username: map['username'] as String?,
      profilePic: map['profile_pic'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'profile_pic': profilePic,
    };
  }
}
