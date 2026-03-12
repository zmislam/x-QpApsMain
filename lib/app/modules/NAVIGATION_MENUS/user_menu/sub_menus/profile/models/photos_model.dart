// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PhotoModel {
String? id;
String? caption;
String? media;
String? post_id;
String? status;
String? ip_address;
String? created_by;
String? update_by;
String? createdAt;
String? updatedAt;
int? v;
  PhotoModel({
    this.id,
    this.caption,
    this.media,
    this.post_id,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  PhotoModel copyWith({
    String? id,
    String? caption,
    String? media,
    String? post_id,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      media: media ?? this.media,
      post_id: post_id ?? this.post_id,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'caption': caption,
      'media': media,
      'post_id': post_id,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      caption: map['caption'] != null ? map['caption'] as String : null,
      media: map['media'] != null ? map['media'] as String : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address: map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by: map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhotoModel.fromJson(String source) => PhotoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PhotoModel(id: $id, caption: $caption, media: $media, post_id: $post_id, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant PhotoModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.caption == caption &&
      other.media == media &&
      other.post_id == post_id &&
      other.status == status &&
      other.ip_address == ip_address &&
      other.created_by == created_by &&
      other.update_by == update_by &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      caption.hashCode ^
      media.hashCode ^
      post_id.hashCode ^
      status.hashCode ^
      ip_address.hashCode ^
      created_by.hashCode ^
      update_by.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;
  }
}
