class Pagephotosmodel {
  Pagephotosmodel({
    required this.id,
    required this.caption,
    required this.media,
    required this.videoThumbnail,
    required this.postId,
    required this.albumId,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? caption;
  final String? media;
  final dynamic videoThumbnail;
  final String? postId;
  final dynamic albumId;
  final dynamic status;
  final dynamic ipAddress;
  final dynamic createdBy;
  final dynamic updateBy;
  final int? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pagephotosmodel copyWith({
    String? id,
    String? caption,
    String? media,
    dynamic videoThumbnail,
    String? postId,
    dynamic albumId,
    dynamic status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    int? v,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pagephotosmodel(
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
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Pagephotosmodel.fromMap(Map<String, dynamic> json) {
    return Pagephotosmodel(
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
      v: json['__v'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
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
        '__v': v,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return '$id, $caption, $media, $videoThumbnail, $postId, $albumId, $status, $ipAddress, $createdBy, $updateBy, $v, $createdAt, $updatedAt, ';
  }
}
