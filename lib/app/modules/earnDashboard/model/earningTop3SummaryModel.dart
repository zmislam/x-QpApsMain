import 'dart:convert';

class EarningTop3SummaryModel {
  EarningTop3Summary? results;
  int? status;

  EarningTop3SummaryModel({
    this.results,
    this.status,
  });

  EarningTop3SummaryModel copyWith({
    EarningTop3Summary? results,
    int? status,
  }) =>
      EarningTop3SummaryModel(
        results: results ?? this.results,
        status: status ?? this.status,
      );

  factory EarningTop3SummaryModel.fromRawJson(String str) => EarningTop3SummaryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EarningTop3SummaryModel.fromJson(Map<String, dynamic> json) => EarningTop3SummaryModel(
    results: json['results'] == null ? null : EarningTop3Summary.fromJson(json['results']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'results': results?.toJson(),
    'status': status,
  };
}

class EarningTop3Summary {
  List<Post>? top3ReactedPost;
  List<Post>? top3CommentedPost;
  List<Top3SharedPost>? top3SharedPost;
  List<Top3ReelsView>? top3ReelsView;

  EarningTop3Summary({
    this.top3ReactedPost,
    this.top3CommentedPost,
    this.top3SharedPost,
    this.top3ReelsView,
  });

  EarningTop3Summary copyWith({
    List<Post>? top3ReactedPost,
    List<Post>? top3CommentedPost,
    List<Top3SharedPost>? top3SharedPost,
    List<Top3ReelsView>? top3ReelsView,
  }) =>
      EarningTop3Summary(
        top3ReactedPost: top3ReactedPost ?? this.top3ReactedPost,
        top3CommentedPost: top3CommentedPost ?? this.top3CommentedPost,
        top3SharedPost: top3SharedPost ?? this.top3SharedPost,
        top3ReelsView: top3ReelsView ?? this.top3ReelsView,
      );

  factory EarningTop3Summary.fromRawJson(String str) => EarningTop3Summary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EarningTop3Summary.fromJson(Map<String, dynamic> json) => EarningTop3Summary(
    top3ReactedPost: json['top_3_reacted_post'] == null ? [] : List<Post>.from(json['top_3_reacted_post']!.map((x) => Post.fromJson(x))),
    top3CommentedPost: json['top_3_commented_post'] == null ? [] : List<Post>.from(json['top_3_commented_post']!.map((x) => Post.fromJson(x))),
    top3SharedPost: json['top_3_shared_post'] == null ? [] : List<Top3SharedPost>.from(json['top_3_shared_post']!.map((x) => Top3SharedPost.fromJson(x))),
    top3ReelsView: json['top_3_reels_view'] == null ? [] : List<Top3ReelsView>.from(json['top_3_reels_view']!.map((x) => Top3ReelsView.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'top_3_reacted_post': top3ReactedPost == null ? [] : List<dynamic>.from(top3ReactedPost!.map((x) => x.toJson())),
    'top_3_commented_post': top3CommentedPost == null ? [] : List<dynamic>.from(top3CommentedPost!.map((x) => x.toJson())),
    'top_3_shared_post': top3SharedPost == null ? [] : List<dynamic>.from(top3SharedPost!.map((x) => x.toJson())),
    'top_3_reels_view': top3ReelsView == null ? [] : List<dynamic>.from(top3ReelsView!.map((x) => x.toJson())),
  };
}

class Post {
  String? id;
  String? description;
  String? postType;
  String? eventType;
  String? eventSubType;
  String? userId;
  dynamic locationId;
  dynamic feelingId;
  dynamic activityId;
  dynamic subActivityId;
  String? postPrivacy;
  dynamic pageId;
  String? sharePostId;
  dynamic workplaceId;
  dynamic instituteId;
  dynamic link;
  String? linkTitle;
  String? linkDescription;
  String? linkImage;
  String? postBackgroundColor;
  String? status;
  dynamic ipAddress;
  bool? isHidden;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  dynamic isCampaignActive;
  DateTime? modificationDate;
  Comments? comments;
  dynamic toUserId;
  String? locationName;
  dynamic groupId;
  dynamic campaignId;
  String? shareReelsId;
  String? lifeEventId;
  bool? pinPost;
  Comments? reactions;
  dynamic productId;
  dynamic layoutType;

  Post({
    this.id,
    this.description,
    this.postType,
    this.eventType,
    this.eventSubType,
    this.userId,
    this.locationId,
    this.feelingId,
    this.activityId,
    this.subActivityId,
    this.postPrivacy,
    this.pageId,
    this.sharePostId,
    this.workplaceId,
    this.instituteId,
    this.link,
    this.linkTitle,
    this.linkDescription,
    this.linkImage,
    this.postBackgroundColor,
    this.status,
    this.ipAddress,
    this.isHidden,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isCampaignActive,
    this.modificationDate,
    this.comments,
    this.toUserId,
    this.locationName,
    this.groupId,
    this.campaignId,
    this.shareReelsId,
    this.lifeEventId,
    this.pinPost,
    this.reactions,
    this.productId,
    this.layoutType,
  });

  Post copyWith({
    String? id,
    String? description,
    String? postType,
    String? eventType,
    String? eventSubType,
    String? userId,
    dynamic locationId,
    dynamic feelingId,
    dynamic activityId,
    dynamic subActivityId,
    String? postPrivacy,
    dynamic pageId,
    String? sharePostId,
    dynamic workplaceId,
    dynamic instituteId,
    dynamic link,
    String? linkTitle,
    String? linkDescription,
    String? linkImage,
    String? postBackgroundColor,
    String? status,
    dynamic ipAddress,
    bool? isHidden,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    dynamic isCampaignActive,
    DateTime? modificationDate,
    Comments? comments,
    dynamic toUserId,
    String? locationName,
    dynamic groupId,
    dynamic campaignId,
    String? shareReelsId,
    String? lifeEventId,
    bool? pinPost,
    Comments? reactions,
    dynamic productId,
    dynamic layoutType,
  }) =>
      Post(
        id: id ?? this.id,
        description: description ?? this.description,
        postType: postType ?? this.postType,
        eventType: eventType ?? this.eventType,
        eventSubType: eventSubType ?? this.eventSubType,
        userId: userId ?? this.userId,
        locationId: locationId ?? this.locationId,
        feelingId: feelingId ?? this.feelingId,
        activityId: activityId ?? this.activityId,
        subActivityId: subActivityId ?? this.subActivityId,
        postPrivacy: postPrivacy ?? this.postPrivacy,
        pageId: pageId ?? this.pageId,
        sharePostId: sharePostId ?? this.sharePostId,
        workplaceId: workplaceId ?? this.workplaceId,
        instituteId: instituteId ?? this.instituteId,
        link: link ?? this.link,
        linkTitle: linkTitle ?? this.linkTitle,
        linkDescription: linkDescription ?? this.linkDescription,
        linkImage: linkImage ?? this.linkImage,
        postBackgroundColor: postBackgroundColor ?? this.postBackgroundColor,
        status: status ?? this.status,
        ipAddress: ipAddress ?? this.ipAddress,
        isHidden: isHidden ?? this.isHidden,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        isCampaignActive: isCampaignActive ?? this.isCampaignActive,
        modificationDate: modificationDate ?? this.modificationDate,
        comments: comments ?? this.comments,
        toUserId: toUserId ?? this.toUserId,
        locationName: locationName ?? this.locationName,
        groupId: groupId ?? this.groupId,
        campaignId: campaignId ?? this.campaignId,
        shareReelsId: shareReelsId ?? this.shareReelsId,
        lifeEventId: lifeEventId ?? this.lifeEventId,
        pinPost: pinPost ?? this.pinPost,
        reactions: reactions ?? this.reactions,
        productId: productId ?? this.productId,
        layoutType: layoutType ?? this.layoutType,
      );

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['_id'],
    description: json['description'],
    postType: json['post_type'],
    eventType: json['event_type'],
    eventSubType: json['event_sub_type'],
    userId: json['user_id'],
    locationId: json['location_id'],
    feelingId: json['feeling_id'],
    activityId: json['activity_id'],
    subActivityId: json['sub_activity_id'],
    postPrivacy: json['post_privacy'],
    pageId: json['page_id'],
    sharePostId: json['share_post_id'],
    workplaceId: json['workplace_id'],
    instituteId: json['institute_id'],
    link: json['link'],
    linkTitle: json['link_title'],
    linkDescription: json['link_description'],
    linkImage: json['link_image'],
    postBackgroundColor: json['post_background_color'],
    status: json['status'],
    ipAddress: json['ip_address'],
    isHidden: json['is_hidden'],
    createdBy: json['created_by'],
    updatedBy: json['updated_by'],
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    v: json['__v'],
    isCampaignActive: json['is_campaign_active'],
    modificationDate: json['modification_date'] == null ? null : DateTime.parse(json['modification_date']),
    comments: json['comments'] == null ? null : Comments.fromJson(json['comments']),
    toUserId: json['to_user_id'],
    locationName: json['location_name'],
    groupId: json['group_id'],
    campaignId: json['campaign_id'],
    shareReelsId: json['share_reels_id'],
    lifeEventId: json['life_event_id'],
    pinPost: json['pin_post'],
    reactions: json['reactions'] == null ? null : Comments.fromJson(json['reactions']),
    productId: json['product_id'],
    layoutType: json['layout_type'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'description': description,
    'post_type': postType,
    'event_type': eventType,
    'event_sub_type': eventSubType,
    'user_id': userId,
    'location_id': locationId,
    'feeling_id': feelingId,
    'activity_id': activityId,
    'sub_activity_id': subActivityId,
    'post_privacy': postPrivacy,
    'page_id': pageId,
    'share_post_id': sharePostId,
    'workplace_id': workplaceId,
    'institute_id': instituteId,
    'link': link,
    'link_title': linkTitle,
    'link_description': linkDescription,
    'link_image': linkImage,
    'post_background_color': postBackgroundColor,
    'status': status,
    'ip_address': ipAddress,
    'is_hidden': isHidden,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'is_campaign_active': isCampaignActive,
    'modification_date': modificationDate?.toIso8601String(),
    'comments': comments?.toJson(),
    'to_user_id': toUserId,
    'location_name': locationName,
    'group_id': groupId,
    'campaign_id': campaignId,
    'share_reels_id': shareReelsId,
    'life_event_id': lifeEventId,
    'pin_post': pinPost,
    'reactions': reactions?.toJson(),
    'product_id': productId,
    'layout_type': layoutType,
  };
}

class Comments {
  int? count;

  Comments({
    this.count,
  });

  Comments copyWith({
    int? count,
  }) =>
      Comments(
        count: count ?? this.count,
      );

  factory Comments.fromRawJson(String str) => Comments.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    count: json['count'],
  );

  Map<String, dynamic> toJson() => {
    'count': count,
  };
}

class Top3ReelsView {
  Reels? reels;

  Top3ReelsView({
    this.reels,
  });

  Top3ReelsView copyWith({
    Reels? reels,
  }) =>
      Top3ReelsView(
        reels: reels ?? this.reels,
      );

  factory Top3ReelsView.fromRawJson(String str) => Top3ReelsView.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Top3ReelsView.fromJson(Map<String, dynamic> json) => Top3ReelsView(
    reels: json['reels'] == null ? null : Reels.fromJson(json['reels']),
  );

  Map<String, dynamic> toJson() => {
    'reels': reels?.toJson(),
  };
}

class Reels {
  String? id;
  String? description;
  String? userId;
  String? video;
  String? reelsPrivacy;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? videoThumbnail;
  String? location;
  Comments? views;
  dynamic campaignId;
  bool? enabledComment;
  dynamic repostReelId;
  dynamic musicId;
  ReelsData? reelsData;
  double? aspectRatio;
  List<dynamic>? image;
  String? link;
  String? reelsType;
  int? viewCount;
  dynamic url;
  dynamic livePostId;
  DateTime? modificationDate;

  Reels({
    this.id,
    this.description,
    this.userId,
    this.video,
    this.reelsPrivacy,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.videoThumbnail,
    this.location,
    this.views,
    this.campaignId,
    this.enabledComment,
    this.repostReelId,
    this.musicId,
    this.reelsData,
    this.aspectRatio,
    this.image,
    this.link,
    this.reelsType,
    this.viewCount,
    this.url,
    this.livePostId,
    this.modificationDate,
  });

  Reels copyWith({
    String? id,
    String? description,
    String? userId,
    String? video,
    String? reelsPrivacy,
    dynamic status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? videoThumbnail,
    String? location,
    Comments? views,
    dynamic campaignId,
    bool? enabledComment,
    dynamic repostReelId,
    dynamic musicId,
    ReelsData? reelsData,
    double? aspectRatio,
    List<dynamic>? image,
    String? link,
    String? reelsType,
    int? viewCount,
    dynamic url,
    dynamic livePostId,
    DateTime? modificationDate,
  }) =>
      Reels(
        id: id ?? this.id,
        description: description ?? this.description,
        userId: userId ?? this.userId,
        video: video ?? this.video,
        reelsPrivacy: reelsPrivacy ?? this.reelsPrivacy,
        status: status ?? this.status,
        ipAddress: ipAddress ?? this.ipAddress,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        videoThumbnail: videoThumbnail ?? this.videoThumbnail,
        location: location ?? this.location,
        views: views ?? this.views,
        campaignId: campaignId ?? this.campaignId,
        enabledComment: enabledComment ?? this.enabledComment,
        repostReelId: repostReelId ?? this.repostReelId,
        musicId: musicId ?? this.musicId,
        reelsData: reelsData ?? this.reelsData,
        aspectRatio: aspectRatio ?? this.aspectRatio,
        image: image ?? this.image,
        link: link ?? this.link,
        reelsType: reelsType ?? this.reelsType,
        viewCount: viewCount ?? this.viewCount,
        url: url ?? this.url,
        livePostId: livePostId ?? this.livePostId,
        modificationDate: modificationDate ?? this.modificationDate,
      );

  factory Reels.fromRawJson(String str) => Reels.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Reels.fromJson(Map<String, dynamic> json) => Reels(
    id: json['_id'],
    description: json['description'],
    userId: json['user_id'],
    video: json['video'],
    reelsPrivacy: json['reels_privacy'],
    status: json['status'],
    ipAddress: json['ip_address'],
    createdBy: json['created_by'],
    updatedBy: json['updated_by'],
    createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    v: json['__v'],
    videoThumbnail: json['video_thumbnail'],
    location: json['location'],
    views: json['views'] == null ? null : Comments.fromJson(json['views']),
    campaignId: json['campaign_id'],
    enabledComment: json['enabled_comment'],
    repostReelId: json['repost_reel_id'],
    musicId: json['music_id'],
    reelsData: json['reels_data'] == null ? null : ReelsData.fromJson(json['reels_data']),
    aspectRatio: json['aspectRatio']?.toDouble(),
    image: json['image'] == null ? [] : List<dynamic>.from(json['image']!.map((x) => x)),
    link: json['link'],
    reelsType: json['reels_type'],
    viewCount: json['view_count'],
    url: json['url'],
    livePostId: json['live_post_id'],
    modificationDate: json['modification_date'] == null ? null : DateTime.parse(json['modification_date']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'description': description,
    'user_id': userId,
    'video': video,
    'reels_privacy': reelsPrivacy,
    'status': status,
    'ip_address': ipAddress,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'video_thumbnail': videoThumbnail,
    'location': location,
    'views': views?.toJson(),
    'campaign_id': campaignId,
    'enabled_comment': enabledComment,
    'repost_reel_id': repostReelId,
    'music_id': musicId,
    'reels_data': reelsData?.toJson(),
    'aspectRatio': aspectRatio,
    'image': image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
    'link': link,
    'reels_type': reelsType,
    'view_count': viewCount,
    'url': url,
    'live_post_id': livePostId,
    'modification_date': modificationDate?.toIso8601String(),
  };
}

class ReelsData {
  ReelsTextModel? reelsTextModel;
  ReelsEmojiModel? reelsEmojiModel;
  dynamic audioModel;

  ReelsData({
    this.reelsTextModel,
    this.reelsEmojiModel,
    this.audioModel,
  });

  ReelsData copyWith({
    ReelsTextModel? reelsTextModel,
    ReelsEmojiModel? reelsEmojiModel,
    dynamic audioModel,
  }) =>
      ReelsData(
        reelsTextModel: reelsTextModel ?? this.reelsTextModel,
        reelsEmojiModel: reelsEmojiModel ?? this.reelsEmojiModel,
        audioModel: audioModel ?? this.audioModel,
      );

  factory ReelsData.fromRawJson(String str) => ReelsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReelsData.fromJson(Map<String, dynamic> json) => ReelsData(
    reelsTextModel: json['reelsTextModel'] == null ? null : ReelsTextModel.fromJson(json['reelsTextModel']),
    reelsEmojiModel: json['reelsEmojiModel'] == null ? null : ReelsEmojiModel.fromJson(json['reelsEmojiModel']),
    audioModel: json['audioModel'],
  );

  Map<String, dynamic> toJson() => {
    'reelsTextModel': reelsTextModel?.toJson(),
    'reelsEmojiModel': reelsEmojiModel?.toJson(),
    'audioModel': audioModel,
  };
}

class ReelsEmojiModel {
  double? positionX;
  double? positionY;
  int? emojiScale;
  String? emojiSrc;
  String? emojiType;

  ReelsEmojiModel({
    this.positionX,
    this.positionY,
    this.emojiScale,
    this.emojiSrc,
    this.emojiType,
  });

  ReelsEmojiModel copyWith({
    double? positionX,
    double? positionY,
    int? emojiScale,
    String? emojiSrc,
    String? emojiType,
  }) =>
      ReelsEmojiModel(
        positionX: positionX ?? this.positionX,
        positionY: positionY ?? this.positionY,
        emojiScale: emojiScale ?? this.emojiScale,
        emojiSrc: emojiSrc ?? this.emojiSrc,
        emojiType: emojiType ?? this.emojiType,
      );

  factory ReelsEmojiModel.fromRawJson(String str) => ReelsEmojiModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReelsEmojiModel.fromJson(Map<String, dynamic> json) => ReelsEmojiModel(
    positionX: json['positionX']?.toDouble(),
    positionY: json['positionY']?.toDouble(),
    emojiScale: json['emojiScale'],
    emojiSrc: json['emojiSrc'],
    emojiType: json['emojiType'],
  );

  Map<String, dynamic> toJson() => {
    'positionX': positionX,
    'positionY': positionY,
    'emojiScale': emojiScale,
    'emojiSrc': emojiSrc,
    'emojiType': emojiType,
  };
}

class ReelsTextModel {
  String? reelsText;
  dynamic reelsTextFont;
  int? textColor;
  int? textBgColor;
  double? textPositionX;
  double? textPositionY;
  double? textScale;

  ReelsTextModel({
    this.reelsText,
    this.reelsTextFont,
    this.textColor,
    this.textBgColor,
    this.textPositionX,
    this.textPositionY,
    this.textScale,
  });

  ReelsTextModel copyWith({
    String? reelsText,
    dynamic reelsTextFont,
    int? textColor,
    int? textBgColor,
    double? textPositionX,
    double? textPositionY,
    double? textScale,
  }) =>
      ReelsTextModel(
        reelsText: reelsText ?? this.reelsText,
        reelsTextFont: reelsTextFont ?? this.reelsTextFont,
        textColor: textColor ?? this.textColor,
        textBgColor: textBgColor ?? this.textBgColor,
        textPositionX: textPositionX ?? this.textPositionX,
        textPositionY: textPositionY ?? this.textPositionY,
        textScale: textScale ?? this.textScale,
      );

  factory ReelsTextModel.fromRawJson(String str) => ReelsTextModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReelsTextModel.fromJson(Map<String, dynamic> json) => ReelsTextModel(
    reelsText: json['reelsText'],
    reelsTextFont: json['reelsTextFont'],
    textColor: json['textColor'],
    textBgColor: json['textBgColor'],
    textPositionX: json['textPositionX']?.toDouble(),
    textPositionY: json['textPositionY']?.toDouble(),
    textScale: json['textScale']?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'reelsText': reelsText,
    'reelsTextFont': reelsTextFont,
    'textColor': textColor,
    'textBgColor': textBgColor,
    'textPositionX': textPositionX,
    'textPositionY': textPositionY,
    'textScale': textScale,
  };
}

class Top3SharedPost {
  String? id;
  int? count;
  Post? post;

  Top3SharedPost({
    this.id,
    this.count,
    this.post,
  });

  Top3SharedPost copyWith({
    String? id,
    int? count,
    Post? post,
  }) =>
      Top3SharedPost(
        id: id ?? this.id,
        count: count ?? this.count,
        post: post ?? this.post,
      );

  factory Top3SharedPost.fromRawJson(String str) => Top3SharedPost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Top3SharedPost.fromJson(Map<String, dynamic> json) => Top3SharedPost(
    id: json['_id'],
    count: json['count'],
    post: json['post'] == null ? null : Post.fromJson(json['post']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'count': count,
    'post': post?.toJson(),
  };
}
