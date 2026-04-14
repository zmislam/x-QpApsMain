/// Reel draft model — represents an in-progress reel before publishing.
/// Holds recorded segment paths, gallery selections, and recording metadata.
class ReelDraftModel {
  final String? id;
  final List<String> segments;
  final List<String> galleryFiles;
  final int? durationLimit;
  final double? speed;
  final String? description;
  final String? soundId;
  final String? thumbnailPath;
  final Map<String, dynamic>? editingState;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReelDraftModel({
    this.id,
    this.segments = const [],
    this.galleryFiles = const [],
    this.durationLimit,
    this.speed,
    this.description,
    this.soundId,
    this.thumbnailPath,
    this.editingState,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      'segments': segments,
      'gallery_files': galleryFiles,
      if (durationLimit != null) 'duration_limit': durationLimit,
      if (speed != null) 'speed': speed,
      if (description != null) 'description': description,
      if (soundId != null) 'sound_id': soundId,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (editingState != null) 'editing_state': editingState,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  factory ReelDraftModel.fromMap(Map<String, dynamic> map) {
    return ReelDraftModel(
      id: map['_id'] as String?,
      segments: (map['segments'] as List?)?.cast<String>() ?? [],
      galleryFiles: (map['gallery_files'] as List?)?.cast<String>() ?? [],
      durationLimit: map['duration_limit'] as int?,
      speed: (map['speed'] as num?)?.toDouble(),
      description: map['description'] as String?,
      soundId: map['sound_id'] as String?,
      thumbnailPath: map['thumbnail_path'] as String?,
      editingState: map['editing_state'] as Map<String, dynamic>?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
    );
  }

  String toJson() => toMap().toString();
  factory ReelDraftModel.fromJson(Map<String, dynamic> json) =>
      ReelDraftModel.fromMap(json);

  ReelDraftModel copyWith({
    String? id,
    List<String>? segments,
    List<String>? galleryFiles,
    int? durationLimit,
    double? speed,
    String? description,
    String? soundId,
    String? thumbnailPath,
    Map<String, dynamic>? editingState,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReelDraftModel(
      id: id ?? this.id,
      segments: segments ?? this.segments,
      galleryFiles: galleryFiles ?? this.galleryFiles,
      durationLimit: durationLimit ?? this.durationLimit,
      speed: speed ?? this.speed,
      description: description ?? this.description,
      soundId: soundId ?? this.soundId,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      editingState: editingState ?? this.editingState,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
