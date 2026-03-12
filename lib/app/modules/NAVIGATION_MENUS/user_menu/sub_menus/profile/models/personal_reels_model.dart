import 'dart:convert';

class VideoReel {
  String? id;
  String? description;
  String? userId;
  String? video;
  String? reelsPrivacy;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updatedBy;
  String? video_thumbnail;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? viewCount;

  VideoReel({
    this.id,
    this.description,
    this.userId,
    this.video,
    this.reelsPrivacy,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.video_thumbnail,
    this.createdAt,
    this.updatedAt,
    this.viewCount,
  });

  // fromMap constructor with nullable properties
  factory VideoReel.fromMap(Map<String, dynamic> map) {
    return VideoReel(
      id: map['_id'] as String?,
      description: map['description'] as String?, 
      userId: map['user_id'] as String?,
      video: map['video'] as String?, 
      reelsPrivacy: map['reels_privacy'] as String?, 
      status: map['status'] as String?, 
      ipAddress: map['ip_address'] as String?, 
      createdBy: map['created_by'] as String?, 
      updatedBy: map['updated_by'] as String?, 
      video_thumbnail: map['video_thumbnail'] as String?, 
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      viewCount: map['view_count'] as int?, 
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'description': description,
      'user_id': userId,
      'video': video,
      'reels_privacy': reelsPrivacy,
      'status': status,
      'ip_address': ipAddress,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'video_thumbnail': video_thumbnail,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'view_count': viewCount,
    };
  }

  // fromJson helper method
  factory VideoReel.fromJson(String source) =>
      VideoReel.fromMap(json.decode(source));

  // toJson helper method
  String toJson() => json.encode(toMap());
}
