// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quantum_possibilities_flutter/app/models/socail_media_model.dart';

class Websites {
  String? id;
  String? user_id;
   String? social_media_id;
  String? website_url;
  String? privacy;

  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  SocialMedia? socialMedia;
  Websites({
    this.id,
    this.user_id,
     this.social_media_id,
    this.website_url,
    this.privacy,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.socialMedia,
  });

  Websites copyWith(
      {String? id,
      String? user_id,
      String? social_media_id,
      String? website_url,
      String? privacy,
      String? created_by,
      String? update_by,
      String? createdAt,
      String? updatedAt,
      int? v,
      SocialMedia? socialMedia}) {
    return Websites(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
       social_media_id: social_media_id ?? this.social_media_id,
      website_url: website_url ?? this.website_url,
      privacy: privacy ?? this.privacy,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      socialMedia: socialMedia ?? this.socialMedia,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'user_id': user_id,
      'social_media_id': social_media_id,
      'website_url': website_url,
      'privacy': privacy,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'socialMedia': socialMedia?.toMap(),
    };
  }

  factory Websites.fromMap(Map<String, dynamic> map) {
    return Websites(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      social_media_id: map['social_media_id'] != null ? map['social_media_id'] as String : null,
     
      website_url:
          map['website_url'] != null ? map['website_url'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
      socialMedia: map['socialMedia'] != null ? SocialMedia.fromMap(map['socialMedia'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Websites.fromJson(String source) =>
      Websites.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Websites(id: $id, user_id: $user_id,'
         ' social_media_id: $social_media_id,'
        'website_url:$website_url,privacy:$privacy, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, socialMedia: $socialMedia)';
  }

  @override
  bool operator ==(covariant Websites other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
         other.social_media_id == social_media_id &&
        other.website_url == website_url &&
        other.privacy == privacy &&
        other.created_by == created_by &&
        other.update_by == update_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v &&
        other.socialMedia == socialMedia;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        social_media_id.hashCode ^
        website_url.hashCode ^
        privacy.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode ^
        socialMedia.hashCode;
  }
}
