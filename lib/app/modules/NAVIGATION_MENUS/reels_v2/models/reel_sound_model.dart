import 'dart:convert';

/// V2 Reel Sound model — maps to backend `reel_v2_sounds` collection.
class ReelSoundModel {
  String? id;
  String? title;
  String? artist;
  String? audioUrl;
  String? coverUrl;
  int? durationMs;
  String? genre;
  bool? isOriginal;
  String? originalReelId;
  String? originalAuthorId;
  int? usageCount;
  int? trendingScore;
  bool? isExplicit;
  bool? isFeatured;
  String? createdAt;
  String? updatedAt;

  // Client-side state
  bool? isSaved;

  ReelSoundModel({
    this.id,
    this.title,
    this.artist,
    this.audioUrl,
    this.coverUrl,
    this.durationMs,
    this.genre,
    this.isOriginal,
    this.originalReelId,
    this.originalAuthorId,
    this.usageCount,
    this.trendingScore,
    this.isExplicit,
    this.isFeatured,
    this.createdAt,
    this.updatedAt,
    this.isSaved,
  });

  factory ReelSoundModel.fromMap(Map<String, dynamic> map) {
    return ReelSoundModel(
      id: map['_id'] as String?,
      title: map['title'] as String?,
      artist: map['artist'] as String?,
      audioUrl: map['audio_url'] as String?,
      coverUrl: map['cover_url'] as String?,
      durationMs: map['duration_ms'] as int?,
      genre: map['genre'] as String?,
      isOriginal: map['is_original'] as bool?,
      originalReelId: map['original_reel_id'] as String?,
      originalAuthorId: map['original_author_id'] as String?,
      usageCount: map['usage_count'] as int? ?? 0,
      trendingScore: map['trending_score'] as int? ?? 0,
      isExplicit: map['is_explicit'] as bool?,
      isFeatured: map['is_featured'] as bool?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      isSaved: map['is_saved'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) '_id': id,
      'title': title,
      'artist': artist,
      'audio_url': audioUrl,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (durationMs != null) 'duration_ms': durationMs,
      if (genre != null) 'genre': genre,
      if (isOriginal != null) 'is_original': isOriginal,
    };
  }

  String toJson() => json.encode(toMap());

  factory ReelSoundModel.fromJson(String source) =>
      ReelSoundModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
