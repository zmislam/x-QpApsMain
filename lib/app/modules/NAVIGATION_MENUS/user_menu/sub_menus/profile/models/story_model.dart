// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProfilrStoryModel {

String? id;
String? title;
String? color;
String? font_family;
String? media;
String? user_id;
String? status;
String? location_id;
String? feeling_id;
String? activity_id;
String? sub_activity_id;
String? ip_address;
String? created_by;
String? updated_by;
String? createdAt;
String? updatedAt;
int? v;
List<Viewers>? viewers; 
int? viewersCount;
  ProfilrStoryModel({
    this.id,
    this.title,
    this.color,
    this.font_family,
    this.media,
    this.user_id,
    this.status,
    this.location_id,
    this.feeling_id,
    this.activity_id,
    this.sub_activity_id,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.viewers,
    this.viewersCount,
  });





   
          
       


  ProfilrStoryModel copyWith({
    String? id,
    String? title,
    String? color,
    String? font_family,
    String? media,
    String? user_id,
    String? status,
    String? location_id,
    String? feeling_id,
    String? activity_id,
    String? sub_activity_id,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    int? v,
    List<Viewers>? viewers,
    int? viewersCount,
  }) {
    return ProfilrStoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      font_family: font_family ?? this.font_family,
      media: media ?? this.media,
      user_id: user_id ?? this.user_id,
      status: status ?? this.status,
      location_id: location_id ?? this.location_id,
      feeling_id: feeling_id ?? this.feeling_id,
      activity_id: activity_id ?? this.activity_id,
      sub_activity_id: sub_activity_id ?? this.sub_activity_id,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      viewers: viewers ?? this.viewers,
      viewersCount: viewersCount ?? this.viewersCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'color': color,
      'font_family': font_family,
      'media': media,
      'user_id': user_id,
      'status': status,
      'location_id': location_id,
      'feeling_id': feeling_id,
      'activity_id': activity_id,
      'sub_activity_id': sub_activity_id,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
      // 'viewers': viewers.map((x) => x?.toMap()).toList(),
      'viewersCount': viewersCount,
    };
  }

  factory ProfilrStoryModel.fromMap(Map<String, dynamic> map) {
    return ProfilrStoryModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      font_family: map['font_family'] != null ? map['font_family'] as String : null,
      media: map['media'] != null ? map['media'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      location_id: map['location_id'] != null ? map['location_id'] as String : null,
      feeling_id: map['feeling_id'] != null ? map['feeling_id'] as String : null,
      activity_id: map['activity_id'] != null ? map['activity_id'] as String : null,
      sub_activity_id: map['sub_activity_id'] != null ? map['sub_activity_id'] as String : null,
      ip_address: map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by: map['created_by'] != null ? map['created_by'] as String : null,
      updated_by: map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['v'] != null ? map['v'] as int : null,
      viewers: map['viewers'] != null ? ( map['viewers']as List).map((e) => Viewers.fromMap(e)).toList(): null,
      viewersCount: map['viewersCount'] != null ? map['viewersCount'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfilrStoryModel.fromJson(String source) => ProfilrStoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoryModel(id: $id, title: $title, color: $color, font_family: $font_family, media: $media, user_id: $user_id, status: $status, location_id: $location_id, feeling_id: $feeling_id, activity_id: $activity_id, sub_activity_id: $sub_activity_id, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, viewers: $viewers, viewersCount: $viewersCount)';
  }

  @override
  bool operator ==(covariant ProfilrStoryModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.color == color &&
      other.font_family == font_family &&
      other.media == media &&
      other.user_id == user_id &&
      other.status == status &&
      other.location_id == location_id &&
      other.feeling_id == feeling_id &&
      other.activity_id == activity_id &&
      other.sub_activity_id == sub_activity_id &&
      other.ip_address == ip_address &&
      other.created_by == created_by &&
      other.updated_by == updated_by &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.v == v &&
      listEquals(other.viewers, viewers) &&
      other.viewersCount == viewersCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      color.hashCode ^
      font_family.hashCode ^
      media.hashCode ^
      user_id.hashCode ^
      status.hashCode ^
      location_id.hashCode ^
      feeling_id.hashCode ^
      activity_id.hashCode ^
      sub_activity_id.hashCode ^
      ip_address.hashCode ^
      created_by.hashCode ^
      updated_by.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode ^
      viewers.hashCode ^
      viewersCount.hashCode;
  }
}



class Viewers {

String? id;
String? user_id;
String? story_id;
String? status;
String? ip_address;
String? created_by;
String? updated_by;
String? createdAt;
String? updatedAt;
int? v;
  Viewers({
    this.id,
    this.user_id,
    this.story_id,
    this.status,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });





  Viewers copyWith({
    String? id,
    String? user_id,
    String? story_id,
    String? status,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return Viewers(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      story_id: story_id ?? this.story_id,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'user_id': user_id,
      'story_id': story_id,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory Viewers.fromMap(Map<String, dynamic> map) {
    return Viewers(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      story_id: map['story_id'] != null ? map['story_id'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address: map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by: map['created_by'] != null ? map['created_by'] as String : null,
      updated_by: map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Viewers.fromJson(String source) => Viewers.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Viewers(id: $id, user_id: $user_id, story_id: $story_id, status: $status, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant Viewers other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user_id == user_id &&
      other.story_id == story_id &&
      other.status == status &&
      other.ip_address == ip_address &&
      other.created_by == created_by &&
      other.updated_by == updated_by &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user_id.hashCode ^
      story_id.hashCode ^
      status.hashCode ^
      ip_address.hashCode ^
      created_by.hashCode ^
      updated_by.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;
  }
}
