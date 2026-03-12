class VideoModel {
  VideoModel({
    this.id,
    this.caption,
    this.media,
    this.postId,
    this.albumId,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.videoThumbnail,
    this.key, // <-- added
  });

  String? id;
  String? caption;
  String? media;
  String? postId;
  String? albumId;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updateBy;
  int? v;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? videoThumbnail;

  /// ✅ New field
  String? key;

  VideoModel copyWith({
    String? id,
    String? caption,
    String? media,
    String? postId,
    String? albumId,
    String? status,
    String? ipAddress,
    String? createdBy,
    String? updateBy,
    int? v,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? videoThumbnail,
    String? key, // <-- added
  }) {
    return VideoModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      media: media ?? this.media,
      postId: postId ?? this.postId,
      albumId: albumId ?? this.albumId,
      status: status ?? this.status,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      key: key ?? this.key, // <-- added
    );
  }

  factory VideoModel.fromMap(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'],
      caption: json['caption'],
      media: json['media'],
      postId: json['post_id'],
      albumId: json['album_id'],
      status: json['status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updateBy: json['update_by'],
      v: json['__v'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      videoThumbnail: json['video_thumbnail'],
      key: json['key'], // <-- added
    );
  }

  @override
  String toString() {
    return '$id, $caption, $media, $postId, $albumId, $status, $ipAddress, $createdBy, $updateBy, $v, $createdAt, $updatedAt, $videoThumbnail, $key';
  }
}
