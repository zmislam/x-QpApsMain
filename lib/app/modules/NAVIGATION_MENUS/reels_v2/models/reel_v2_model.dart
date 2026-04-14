import 'dart:convert';

/// Core V2 Reel model — maps to backend `reels_v2` collection.
/// All fields nullable for safe JSON parsing.
class ReelV2Model {
  String? id;
  String? authorId;
  String? collabAuthorId;
  String? pageId;

  // Video
  String? videoUrl;
  String? originalVideoUrl;
  String? thumbnailUrl;
  String? abThumbnailUrl;
  int? durationMs;
  double? aspectRatio;
  List<QualityVariant>? qualityVariants;

  // Content
  String? caption;
  List<String>? hashtags;
  List<String>? mentionedUserIds;
  List<TaggedPerson>? taggedPeople;
  String? locationId;
  String? locationName;
  List<String>? topicIds;

  // Audio
  String? soundId;
  String? soundName;
  String? soundArtist;
  bool? isOriginalAudio;
  double? originalAudioVolume;
  double? musicVolume;

  // Settings
  String? privacy;
  String? commentPermission;
  bool? allowRemix;
  bool? allowDownload;
  bool? allowStitch;

  // Remix
  String? remixSourceReelId;
  String? remixType;

  // Series
  String? seriesId;
  int? seriesOrder;

  // Counts
  int? viewCount;
  int? likeCount;
  int? commentCount;
  int? shareCount;
  int? saveCount;
  int? remixCount;
  int? loopCount;
  double? engagementScore;

  // Status
  String? status;
  String? scheduledAt;
  String? processingJobId;
  int? processingProgress;

  // Accessibility
  List<AutoCaption>? autoCaptions;
  String? altText;

  // Soft delete
  bool? isDeleted;
  String? deletedAt;

  // Timestamps
  String? createdAt;
  String? updatedAt;

  // Populated data (from API)
  ReelAuthorModel? author;
  bool? isLiked;
  bool? isBookmarked;
  String? myReaction;

  /// Convenience getter for author display name
  String? get authorName => author?.displayName;

  ReelV2Model({
    this.id,
    this.authorId,
    this.collabAuthorId,
    this.pageId,
    this.videoUrl,
    this.originalVideoUrl,
    this.thumbnailUrl,
    this.abThumbnailUrl,
    this.durationMs,
    this.aspectRatio,
    this.qualityVariants,
    this.caption,
    this.hashtags,
    this.mentionedUserIds,
    this.taggedPeople,
    this.locationId,
    this.locationName,
    this.topicIds,
    this.soundId,
    this.soundName,
    this.soundArtist,
    this.isOriginalAudio,
    this.originalAudioVolume,
    this.musicVolume,
    this.privacy,
    this.commentPermission,
    this.allowRemix,
    this.allowDownload,
    this.allowStitch,
    this.remixSourceReelId,
    this.remixType,
    this.seriesId,
    this.seriesOrder,
    this.viewCount,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.saveCount,
    this.remixCount,
    this.loopCount,
    this.engagementScore,
    this.status,
    this.scheduledAt,
    this.processingJobId,
    this.processingProgress,
    this.autoCaptions,
    this.altText,
    this.isDeleted,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.author,
    this.isLiked,
    this.isBookmarked,
    this.myReaction,
  });

  factory ReelV2Model.fromMap(Map<String, dynamic> map) {
    return ReelV2Model(
      id: map['_id'] as String?,
      authorId: map['author_id'] is String
          ? map['author_id'] as String?
          : (map['author_id'] is Map ? map['author_id']['_id'] as String? : null),
      collabAuthorId: map['collab_author_id'] as String?,
      pageId: map['page_id'] as String?,
      videoUrl: map['video_url'] as String?,
      originalVideoUrl: map['original_video_url'] as String?,
      thumbnailUrl: map['thumbnail_url'] as String?,
      abThumbnailUrl: map['ab_thumbnail_url'] as String?,
      durationMs: map['duration_ms'] as int?,
      aspectRatio: (map['aspect_ratio'] as num?)?.toDouble(),
      qualityVariants: map['quality_variants'] != null
          ? (map['quality_variants'] as List)
              .map((e) => QualityVariant.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      caption: map['caption'] as String?,
      hashtags: map['hashtags'] != null
          ? List<String>.from(map['hashtags'])
          : null,
      mentionedUserIds: map['mentioned_user_ids'] != null
          ? List<String>.from(map['mentioned_user_ids'])
          : null,
      taggedPeople: map['tagged_people'] != null
          ? (map['tagged_people'] as List)
              .map((e) => TaggedPerson.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      locationId: map['location_id'] as String?,
      locationName: map['location_name'] as String?,
      topicIds: map['topic_ids'] != null
          ? List<String>.from(map['topic_ids'])
          : null,
      soundId: map['sound_id'] is String
          ? map['sound_id'] as String?
          : (map['sound_id'] is Map ? map['sound_id']['_id'] as String? : null),
      soundName: map['sound_name'] as String?,
      soundArtist: map['sound_artist'] as String?,
      isOriginalAudio: map['is_original_audio'] as bool?,
      originalAudioVolume: (map['original_audio_volume'] as num?)?.toDouble(),
      musicVolume: (map['music_volume'] as num?)?.toDouble(),
      privacy: map['privacy'] as String?,
      commentPermission: map['comment_permission'] as String?,
      allowRemix: map['allow_remix'] as bool?,
      allowDownload: map['allow_download'] as bool?,
      allowStitch: map['allow_stitch'] as bool?,
      remixSourceReelId: map['remix_source_reel_id'] as String?,
      remixType: map['remix_type'] as String?,
      seriesId: map['series_id'] as String?,
      seriesOrder: map['series_order'] as int?,
      viewCount: map['view_count'] as int? ?? 0,
      likeCount: map['like_count'] as int? ?? 0,
      commentCount: map['comment_count'] as int? ?? 0,
      shareCount: map['share_count'] as int? ?? 0,
      saveCount: map['save_count'] as int? ?? 0,
      remixCount: map['remix_count'] as int? ?? 0,
      loopCount: map['loop_count'] as int? ?? 0,
      engagementScore: (map['engagement_score'] as num?)?.toDouble(),
      status: map['status'] as String?,
      scheduledAt: map['scheduled_at'] as String?,
      processingJobId: map['processing_job_id'] as String?,
      processingProgress: map['processing_progress'] as int?,
      autoCaptions: map['auto_captions'] != null
          ? (map['auto_captions'] as List)
              .map((e) => AutoCaption.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      altText: map['alt_text'] as String?,
      isDeleted: map['is_deleted'] as bool?,
      deletedAt: map['deleted_at'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      author: map['author_id'] is Map
          ? ReelAuthorModel.fromMap(map['author_id'] as Map<String, dynamic>)
          : null,
      isLiked: map['is_liked'] as bool?,
      isBookmarked: map['is_bookmarked'] as bool?,
      myReaction: map['my_reaction'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) '_id': id,
      'author_id': authorId,
      if (collabAuthorId != null) 'collab_author_id': collabAuthorId,
      if (pageId != null) 'page_id': pageId,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'duration_ms': durationMs,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (caption != null) 'caption': caption,
      if (hashtags != null) 'hashtags': hashtags,
      if (locationId != null) 'location_id': locationId,
      if (locationName != null) 'location_name': locationName,
      if (topicIds != null) 'topic_ids': topicIds,
      if (soundId != null) 'sound_id': soundId,
      if (soundName != null) 'sound_name': soundName,
      if (soundArtist != null) 'sound_artist': soundArtist,
      if (isOriginalAudio != null) 'is_original_audio': isOriginalAudio,
      if (privacy != null) 'privacy': privacy,
      if (commentPermission != null) 'comment_permission': commentPermission,
      if (allowRemix != null) 'allow_remix': allowRemix,
      if (allowDownload != null) 'allow_download': allowDownload,
      if (allowStitch != null) 'allow_stitch': allowStitch,
      if (remixSourceReelId != null) 'remix_source_reel_id': remixSourceReelId,
      if (remixType != null) 'remix_type': remixType,
    };
  }

  String toJson() => json.encode(toMap());

  factory ReelV2Model.fromJson(String source) =>
      ReelV2Model.fromMap(json.decode(source) as Map<String, dynamic>);
}

class QualityVariant {
  String? quality;
  String? url;
  int? sizeBytes;

  QualityVariant({this.quality, this.url, this.sizeBytes});

  factory QualityVariant.fromMap(Map<String, dynamic> map) {
    return QualityVariant(
      quality: map['quality'] as String?,
      url: map['url'] as String?,
      sizeBytes: map['size_bytes'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'quality': quality,
        'url': url,
        'size_bytes': sizeBytes,
      };
}

class TaggedPerson {
  String? userId;
  String? username;
  double? x;
  double? y;

  TaggedPerson({this.userId, this.username, this.x, this.y});

  factory TaggedPerson.fromMap(Map<String, dynamic> map) {
    return TaggedPerson(
      userId: map['user_id'] as String?,
      username: map['username'] as String?,
      x: (map['x'] as num?)?.toDouble(),
      y: (map['y'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'user_id': userId,
        'username': username,
        'x': x,
        'y': y,
      };
}

class AutoCaption {
  int? startMs;
  int? endMs;
  String? text;
  String? language;

  AutoCaption({this.startMs, this.endMs, this.text, this.language});

  factory AutoCaption.fromMap(Map<String, dynamic> map) {
    return AutoCaption(
      startMs: map['start_ms'] as int?,
      endMs: map['end_ms'] as int?,
      text: map['text'] as String?,
      language: map['language'] as String?,
    );
  }
}

class ReelAuthorModel {
  String? id;
  String? firstName;
  String? lastName;
  String? profileImg;
  bool? isVerified;

  ReelAuthorModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profileImg,
    this.isVerified,
  });

  String get displayName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory ReelAuthorModel.fromMap(Map<String, dynamic> map) {
    return ReelAuthorModel(
      id: map['_id'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      profileImg: map['profile_img'] as String?,
      isVerified: map['is_verified'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'profile_img': profileImg,
        'is_verified': isVerified,
      };
}
