// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class StoryModelMerge {
  String? id;
  String? first_name;
  String? last_name;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? profile_pic;
  String? cover_pic;
  String? user_status;
  String? gender;
  String? religion;
  String? date_of_birth;
  List<Stories>? stories;
  StoryModelMerge({
    this.id,
    this.first_name,
    this.last_name,
    this.username,
    this.email,
    this.phone,
    this.password,
    this.profile_pic,
    this.cover_pic,
    this.user_status,
    this.gender,
    this.religion,
    this.date_of_birth,
    this.stories,
  });

  StoryModelMerge copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profile_pic,
    String? cover_pic,
    String? user_status,
    String? gender,
    String? religion,
    String? date_of_birth,
    List<Stories>? stories,
  }) {
    return StoryModelMerge(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profile_pic: profile_pic ?? this.profile_pic,
      cover_pic: cover_pic ?? this.cover_pic,
      user_status: user_status ?? this.user_status,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      stories: stories ?? this.stories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'user_status': user_status,
      'gender': gender,
      'religion': religion,
      'date_of_birth': date_of_birth,
      'stories': stories?.map((x) => x.toMap()).toList(),
    };
  }

  factory StoryModelMerge.fromMap(Map<String, dynamic> map) {
    return StoryModelMerge(
      id: map['_id'] != null ? map['_id'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      cover_pic: map['cover_pic'] != null ? map['cover_pic'] as String : null,
      user_status:
          map['user_status'] != null ? map['user_status'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      date_of_birth:
          map['date_of_birth'] != null ? map['date_of_birth'] as String : null,
      stories: map['stories'] != null
          ? List<Stories>.from(
              (map['stories'] as List<int>).map<Stories?>(
                (x) => Stories.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModelMerge.fromJson(String source) =>
      StoryModelMerge.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoryModelMerge(id: $id, first_name: $first_name, last_name: $last_name, username: $username, email: $email, phone: $phone, password: $password, profile_pic: $profile_pic, cover_pic: $cover_pic, user_status: $user_status, gender: $gender, religion: $religion, date_of_birth: $date_of_birth, stories: $stories)';
  }

  @override
  bool operator ==(covariant StoryModelMerge other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.profile_pic == profile_pic &&
        other.cover_pic == cover_pic &&
        other.user_status == user_status &&
        other.gender == gender &&
        other.religion == religion &&
        other.date_of_birth == date_of_birth &&
        listEquals(other.stories, stories);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        profile_pic.hashCode ^
        cover_pic.hashCode ^
        user_status.hashCode ^
        gender.hashCode ^
        religion.hashCode ^
        date_of_birth.hashCode ^
        stories.hashCode;
  }
}

class Stories {
  String? id;
  String? title;
  String? color;
  String? text_color;
  String? font_family;
  String? font_size;
  String? media;
  String? text_position;
  String? text_alignment;
  String? user_id;
  String? privacy_id;
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
  int? viewersCount;
  List<Viewers> viewers;

  Stories({
    this.id,
    this.title,
    this.color,
    this.text_color,
    this.font_family,
    this.font_size,
    this.media,
    this.text_position,
    this.text_alignment,
    this.user_id,
    this.privacy_id,
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
    this.viewersCount,
    required this.viewers,
  });

  Stories copyWith({
    String? id,
    String? title,
    String? color,
    String? text_color,
    String? font_family,
    String? font_size,
    String? media,
    String? text_position,
    String? text_alignment,
    String? user_id,
    String? privacy_id,
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
    int? viewersCount,
    List<Viewers>? viewers,
  }) {
    return Stories(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      text_color: text_color ?? this.text_color,
      font_family: font_family ?? this.font_family,
      font_size: font_size ?? this.font_size,
      media: media ?? this.media,
      text_position: text_position ?? this.text_position,
      text_alignment: text_alignment ?? this.text_alignment,
      user_id: user_id ?? this.user_id,
      privacy_id: privacy_id ?? this.privacy_id,
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
      viewersCount: viewersCount ?? this.viewersCount,
      viewers: viewers ?? this.viewers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'title': title,
      'color': color,
      'text_color': text_color,
      'font_family': font_family,
      'font_size': font_size,
      'media': media,
      'text_position': text_position,
      'text_alignment': text_alignment,
      'user_id': user_id,
      'privacy_id': privacy_id,
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
      'viewersCount': viewersCount,
      'viewers': viewers.map((x) => x.toMap()).toList(),
    };
  }

  factory Stories.fromMap(Map<String, dynamic> map) {
    return Stories(
      id: map['_id'] != null ? map['_id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      color: map['color'] != null ? map['color'] as String : null,
      text_color:
          map['text_color'] != null ? map['text_color'] as String : null,
      font_family:
          map['font_family'] != null ? map['font_family'] as String : null,
      font_size: map['font_size'] != null ? map['font_size'] as String : null,
      media: map['media'] != null ? map['media'] as String : null,
      text_position:
          map['text_position'] != null ? map['text_position'] as String : null,
      text_alignment: map['text_alignment'] != null
          ? map['text_alignment'] as String
          : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      privacy_id:
          map['privacy_id'] != null ? map['privacy_id'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      location_id:
          map['location_id'] != null ? map['location_id'] as String : null,
      feeling_id:
          map['feeling_id'] != null ? map['feeling_id'] as String : null,
      activity_id:
          map['activity_id'] != null ? map['activity_id'] as String : null,
      sub_activity_id: map['sub_activity_id'] != null
          ? map['sub_activity_id'] as String
          : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      viewersCount:
          map['viewersCount'] != null ? map['viewersCount'] as int : null,
      viewers: List<Viewers>.from(
        (map['viewers'] as List<int>).map<Viewers>(
          (x) => Viewers.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Stories.fromJson(String source) =>
      Stories.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Stories(id: $id, title: $title, color: $color, text_color: $text_color, font_family: $font_family, font_size: $font_size, media: $media, text_position: $text_position, text_alignment: $text_alignment, user_id: $user_id, privacy_id: $privacy_id, status: $status, location_id: $location_id, feeling_id: $feeling_id, activity_id: $activity_id, sub_activity_id: $sub_activity_id, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, viewersCount: $viewersCount, viewers: $viewers)';
  }

  @override
  bool operator ==(covariant Stories other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.color == color &&
        other.text_color == text_color &&
        other.font_family == font_family &&
        other.font_size == font_size &&
        other.media == media &&
        other.text_position == text_position &&
        other.text_alignment == text_alignment &&
        other.user_id == user_id &&
        other.privacy_id == privacy_id &&
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
        other.viewersCount == viewersCount &&
        listEquals(other.viewers, viewers);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        color.hashCode ^
        text_color.hashCode ^
        font_family.hashCode ^
        font_size.hashCode ^
        media.hashCode ^
        text_position.hashCode ^
        text_alignment.hashCode ^
        user_id.hashCode ^
        privacy_id.hashCode ^
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
        viewersCount.hashCode ^
        viewers.hashCode;
  }
}

class Viewers {
  String? username;
  String? first_name;
  String? last_name;
  String? profile_pic;
  String? status;
  Viewers({
    this.username,
    this.first_name,
    this.last_name,
    this.profile_pic,
    this.status,
  });

  Viewers copyWith({
    String? username,
    String? first_name,
    String? last_name,
    String? profile_pic,
    String? status,
  }) {
    return Viewers(
      username: username ?? this.username,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      profile_pic: profile_pic ?? this.profile_pic,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'first_name': first_name,
      'last_name': last_name,
      'profile_pic': profile_pic,
      'status': status,
    };
  }

  factory Viewers.fromMap(Map<String, dynamic> map) {
    return Viewers(
      username: map['username'] != null ? map['username'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Viewers.fromJson(String source) =>
      Viewers.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Viewers(username: $username, first_name: $first_name, last_name: $last_name, profile_pic: $profile_pic, status: $status)';
  }

  @override
  bool operator ==(covariant Viewers other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.profile_pic == profile_pic &&
        other.status == status;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        profile_pic.hashCode ^
        status.hashCode;
  }
}
