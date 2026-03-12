class FileItem {
  String? id;
  String? caption;
  String? media;
  String? videoThumbnail;
  String? postId;
  String? albumId;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updateBy;
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
    this.updateBy,
    this.version,
    this.createdAt,
    this.updatedAt,
  });

  factory FileItem.fromMap(Map<String, dynamic> json) {
    return FileItem(
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
      version: json['__v'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
        '__v': version,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'FileItem(id: $id, caption: $caption, media: $media, videoThumbnail: $videoThumbnail, postId: $postId, albumId: $albumId, status: $status, ipAddress: $ipAddress, createdBy: $createdBy, updateBy: $updateBy, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class MediaResponse {
  int? status;
  List<FileItem>? result;

  MediaResponse({
    this.status,
    this.result,
  });

  factory MediaResponse.fromMap(Map<String, dynamic> json) {
    return MediaResponse(
      status: json['status'],
      result: json['result'] == null
          ? []
          : List<FileItem>.from(
              json['result']!.map((x) => FileItem.fromMap(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'result': result?.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() => 'MediaResponse(status: $status, result: $result)';
}
