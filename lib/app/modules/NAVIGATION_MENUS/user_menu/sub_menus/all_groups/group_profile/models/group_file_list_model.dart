

class FileItem {
  String? id;
  String? caption;
  String? media;
  String? videoThumbnail;
  PostId? postId;
  String? albumId;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updatedBy;
  int? version;
  DateTime? createdAt;
  DateTime? updatedAt;

  FileItem({
    this.id,
    this.caption,
    this.media,
    this.videoThumbnail,
    this.postId,
    this.albumId,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory FileItem.fromMap(Map<String, dynamic> json) {
    return FileItem(
      id: json['_id'] as String?,
      caption: json['caption'] as String?,
      media: json['media'] as String?,
      videoThumbnail: json['video_thumbnail'] as String?,
      postId: json['post_id'] != null ? PostId.fromMap(json['post_id']) : null,
      albumId: json['album_id'] as String?,
      status: json['status'] as String?,
      ipAddress: json['ip_address'] as String?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['update_by'] as String?,
      version: json['__v'] as int?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'caption': caption,
      'media': media,
      'video_thumbnail': videoThumbnail,
      'post_id': postId?.toMap(),
      'album_id': albumId,
      'status': status,
      'ip_address': ipAddress,
      'created_by': createdBy,
      'update_by': updatedBy,
      '__v': version,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class PostId {
  String? id;
  String? description;
  String? postType;
  String? toUserId;
  String? eventType;
  String? eventSubType;
  String? userId;
  String? locationId;
  String? locationName;
  String? feelingId;
  String? activityId;
  String? subActivityId;
  String? groupId;
  String? postPrivacy;
  String? pageId;
  String? campaignId;
  String? sharePostId;
  String? shareReelsId;
  String? workplaceId;
  String? instituteId;
  String? lifeEventId;
  String? link;
  String? linkTitle;
  String? linkDescription;
  String? linkImage;
  String? postBackgroundColor;
  String? status;
  String? ipAddress;
  bool? isHidden;
  bool? pinPost;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? version;

  PostId({
    this.id,
    this.description,
    this.postType,
    this.toUserId,
    this.eventType,
    this.eventSubType,
    this.userId,
    this.locationId,
    this.locationName,
    this.feelingId,
    this.activityId,
    this.subActivityId,
    this.groupId,
    this.postPrivacy,
    this.pageId,
    this.campaignId,
    this.sharePostId,
    this.shareReelsId,
    this.workplaceId,
    this.instituteId,
    this.lifeEventId,
    this.link,
    this.linkTitle,
    this.linkDescription,
    this.linkImage,
    this.postBackgroundColor,
    this.status,
    this.ipAddress,
    this.isHidden,
    this.pinPost,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory PostId.fromMap(Map<String, dynamic> json) {
    return PostId(
      id: json['_id'] as String?,
      description: json['description'] as String?,
      postType: json['post_type'] as String?,
      toUserId: json['to_user_id'] as String?,
      eventType: json['event_type'] as String?,
      eventSubType: json['event_sub_type'] as String?,
      userId: json['user_id'] as String?,
      locationId: json['location_id'] as String?,
      locationName: json['location_name'] as String?,
      feelingId: json['feeling_id'] as String?,
      activityId: json['activity_id'] as String?,
      subActivityId: json['sub_activity_id'] as String?,
      groupId: json['group_id'] as String?,
      postPrivacy: json['post_privacy'] as String?,
      pageId: json['page_id'] as String?,
      campaignId: json['campaign_id'] as String?,
      sharePostId: json['share_post_id'] as String?,
      shareReelsId: json['share_reels_id'] as String?,
      workplaceId: json['workplace_id'] as String?,
      instituteId: json['institute_id'] as String?,
      lifeEventId: json['life_event_id'] as String?,
      link: json['link'] as String?,
      linkTitle: json['link_title'] as String?,
      linkDescription: json['link_description'] as String?,
      linkImage: json['link_image'] as String?,
      postBackgroundColor: json['post_background_color'] as String?,
      status: json['status'] as String?,
      ipAddress: json['ip_address'] as String?,
      isHidden: json['is_hidden'] as bool?,
      pinPost: json['pin_post'] as bool?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      version: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'description': description,
      'post_type': postType,
      'to_user_id': toUserId,
      'event_type': eventType,
      'event_sub_type': eventSubType,
      'user_id': userId,
      'location_id': locationId,
      'location_name': locationName,
      'feeling_id': feelingId,
      'activity_id': activityId,
      'sub_activity_id': subActivityId,
      'group_id': groupId,
      'post_privacy': postPrivacy,
      'page_id': pageId,
      'campaign_id': campaignId,
      'share_post_id': sharePostId,
      'share_reels_id': shareReelsId,
      'workplace_id': workplaceId,
      'institute_id': instituteId,
      'life_event_id': lifeEventId,
      'link': link,
      'link_title': linkTitle,
      'link_description': linkDescription,
      'link_image': linkImage,
      'post_background_color': postBackgroundColor,
      'status': status,
      'ip_address': ipAddress,
      'is_hidden': isHidden,
      'pin_post': pinPost,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}
