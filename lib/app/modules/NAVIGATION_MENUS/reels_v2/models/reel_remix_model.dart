/// Reel Remix model — represents a remix relationship in the chain.
class ReelRemixModel {
  final String? id;
  final String? reelId;
  final String? sourceReelId;
  final String? authorId;
  final String? authorName;
  final String? authorAvatar;
  final String? remixType; // duet | stitch | greenScreen
  final String? thumbnailUrl;
  final String? videoUrl;
  final int? viewCount;
  final String? createdAt;

  ReelRemixModel({
    this.id,
    this.reelId,
    this.sourceReelId,
    this.authorId,
    this.authorName,
    this.authorAvatar,
    this.remixType,
    this.thumbnailUrl,
    this.videoUrl,
    this.viewCount,
    this.createdAt,
  });

  factory ReelRemixModel.fromMap(Map<String, dynamic> map) {
    return ReelRemixModel(
      id: map['_id'] as String?,
      reelId: map['reel_id'] as String?,
      sourceReelId: map['source_reel_id'] as String?,
      authorId: map['author_id'] as String?,
      authorName: map['author_name'] as String?,
      authorAvatar: map['author_avatar'] as String?,
      remixType: map['remix_type'] as String?,
      thumbnailUrl: map['thumbnail_url'] as String?,
      videoUrl: map['video_url'] as String?,
      viewCount: map['view_count'] as int? ?? 0,
      createdAt: map['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      if (reelId != null) 'reel_id': reelId,
      if (sourceReelId != null) 'source_reel_id': sourceReelId,
      if (authorId != null) 'author_id': authorId,
      if (authorName != null) 'author_name': authorName,
      if (remixType != null) 'remix_type': remixType,
    };
  }
}
