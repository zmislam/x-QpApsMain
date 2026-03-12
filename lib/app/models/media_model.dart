// To parse this JSON data, do
//
//     final mediaModel = mediaModelFromJson(jsonString);

import 'dart:convert';

MediaModel mediaModelFromJson(String str) =>
    MediaModel.fromJson(json.decode(str));

String mediaModelToJson(MediaModel data) => json.encode(data.toJson());

class MediaModel {
  String? id;
  String? caption;
  String? media;
  String? videoThumbnail;
  String? postId;
  dynamic albumId;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  int? v;
  String? createdAt;

  MediaModel({
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
    this.v,
    this.createdAt,
  });

  MediaModel copyWith({
    String? id,
    String? caption,
    String? media,
    String? videoThumbnail,
    String? postId,
    dynamic albumId,
    dynamic status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    int? v,
    String? createdAt,
  }) =>
      MediaModel(
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
      );

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
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
        createdAt: json['createdAt'],
      );

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
        'createdAt': createdAt,
      };
}
