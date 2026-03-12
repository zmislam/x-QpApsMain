// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SocialMediaModel {
  String? id;
  String? media_name;
  String? icon;
  String? base_url;
  String? data_status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  SocialMediaModel({
    this.id,
    this.media_name,
    this.icon,
    this.base_url,
    this.data_status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  SocialMediaModel copyWith({
    String? id,
    String? media_name,
    String? icon,
    String? base_url,
    String? data_status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return SocialMediaModel(
      id: id ?? this.id,
      media_name: media_name ?? this.media_name,
      icon: icon ?? this.icon,
      base_url: base_url ?? this.base_url,
      data_status: data_status ?? this.data_status,
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
      'media_name': media_name,
      'icon': icon,
      'base_url': base_url,
      'data_status': data_status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory SocialMediaModel.fromMap(Map<String, dynamic> map) {
    return SocialMediaModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      media_name:
          map['media_name'] != null ? map['media_name'] as String : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
      base_url: map['base_url'] != null ? map['base_url'] as String : null,
      data_status:
          map['data_status'] != null ? map['data_status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialMediaModel.fromJson(String source) =>
      SocialMediaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SocialMediaModel(id: $id, media_name: $media_name, icon: $icon, base_url: $base_url, data_status: $data_status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant SocialMediaModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.media_name == media_name &&
        other.icon == icon &&
        other.base_url == base_url &&
        other.data_status == data_status &&
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
        media_name.hashCode ^
        icon.hashCode ^
        base_url.hashCode ^
        data_status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}
