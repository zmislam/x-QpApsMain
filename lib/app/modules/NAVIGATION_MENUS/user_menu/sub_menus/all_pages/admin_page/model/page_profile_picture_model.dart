class AdminPageProfilePictureModel {
  AdminPageProfilePictureModel({
    this.id,
    this.caption,
    this.media,
    this.videoThumbnail,
    this.postId,
    this.albumId,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.key, // <-- added
  });

  String? id;
  dynamic caption;
  String? media;
  dynamic videoThumbnail;
  String? postId;
  dynamic albumId;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  /// ✅ New key field
  String? key;

  AdminPageProfilePictureModel copyWith({
    String? id,
    dynamic caption,
    String? media,
    dynamic videoThumbnail,
    String? postId,
    dynamic albumId,
    dynamic status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? key, // <-- added
  }) {
    return AdminPageProfilePictureModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      media: media ?? this.media,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      postId: postId ?? this.postId,
      albumId: albumId ?? this.albumId,
      status: status ?? this.status,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      key: key ?? this.key, // <-- added
    );
  }

  factory AdminPageProfilePictureModel.fromMap(Map<String, dynamic> json) {
    return AdminPageProfilePictureModel(
      id: json['_id'],
      caption: json['caption'],
      media: json['media'],
      videoThumbnail: json['video_thumbnail'],
      postId: json['post_id'],
      albumId: json['album_id'],
      status: json['status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updateBy: json['update_by'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
      key: json['key'], // <-- added
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'caption': caption,
    'media': media,
    'video_thumbnail': videoThumbnail,
    'post_id': postId,
    'album_id': albumId,
    'status': status,
    'ip_address': ipAddress,
    'created_by': createdBy,
    'update_by': updateBy,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'key': key, // <-- added
  };

  @override
  String toString() {
    return '$id, $caption, $media, $videoThumbnail, $postId, $albumId, $status, $ipAddress, $createdBy, $updateBy, $createdAt, $updatedAt, $v, $key';
  }
}
