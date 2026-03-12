// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class StoryMergeModel {
  String? cover_pic;
  String? createdAt;
  String? created_by;
  String? date_of_birth;
  String? email;
  String? first_name;
  String? last_name;
  String? page_id;
  String? phone;
  String? profile_pic;
  String? updatedAt;
  String? username;
  String? id;
  List<StoryItemModel>? stories;
  int? v;
  StoryMergeModel({
    this.cover_pic,
    this.createdAt,
    this.created_by,
    this.date_of_birth,
    this.email,
    this.first_name,
    this.last_name,
    this.phone,
    this.profile_pic,
    this.updatedAt,
    this.username,
    this.id,
    this.stories,
    this.page_id,
    this.v,
  });

  StoryMergeModel copyWith({
    String? cover_pic,
    String? createdAt,
    String? created_by,
    String? date_of_birth,
    String? email,
    String? first_name,
    String? last_name,
    String? phone,
    String? profile_pic,
    String? updatedAt,
    String? page_id,
    String? username,
    String? id,
    List<StoryItemModel>? stories,
    int? v,
  }) {
    return StoryMergeModel(
      cover_pic: cover_pic ?? this.cover_pic,
      createdAt: createdAt ?? this.createdAt,
      created_by: created_by ?? this.created_by,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      email: email ?? this.email,
      page_id: page_id ?? this.page_id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      phone: phone ?? this.phone,
      profile_pic: profile_pic ?? this.profile_pic,
      updatedAt: updatedAt ?? this.updatedAt,
      username: username ?? this.username,
      id: id ?? this.id,
      stories: stories ?? this.stories,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cover_pic': cover_pic,
      'createdAt': createdAt,
      'created_by': created_by,
      'date_of_birth': date_of_birth,
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'page_id': page_id,
      'phone': phone,
      'profile_pic': profile_pic,
      'updatedAt': updatedAt,
      'username': username,
      'id': id,
      'stories': stories?.map((x) => x.toMap()).toList(),
      'v': v,
    };
  }

  factory StoryMergeModel.fromMap(Map<String, dynamic> map) {
    return StoryMergeModel(
      cover_pic: map['cover_pic'] != null ? map['cover_pic'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      date_of_birth:
          map['date_of_birth'] != null ? map['date_of_birth'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      page_id: map['page_id'] != null ? map['page_id'] as String : '',
      phone: map['phone'] != null ? map['phone'] as String : null,
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      stories: map['stories'] != null
          ? (map['stories'] as List)
              .map((e) => StoryItemModel.fromMap(e))
              .toList()
          : null,
      v: map['v'] != null ? map['v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryMergeModel.fromJson(String source) =>
      StoryMergeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoryMergeModel(cover_pic: $cover_pic, createdAt: $createdAt, created_by: $created_by, date_of_birth: $date_of_birth, email: $email, first_name: $first_name, last_name: $last_name, phone: $phone, profile_pic: $profile_pic, updatedAt: $updatedAt, username: $username, id: $id, stories: $stories, v: $v)';
  }

  @override
  bool operator ==(covariant StoryMergeModel other) {
    if (identical(this, other)) return true;

    return other.cover_pic == cover_pic &&
        other.createdAt == createdAt &&
        other.created_by == created_by &&
        other.date_of_birth == date_of_birth &&
        other.email == email &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.phone == phone &&
        other.profile_pic == profile_pic &&
        other.updatedAt == updatedAt &&
        other.username == username &&
        other.id == id &&
        listEquals(other.stories, stories) &&
        other.v == v;
  }

  @override
  int get hashCode {
    return cover_pic.hashCode ^
        createdAt.hashCode ^
        created_by.hashCode ^
        date_of_birth.hashCode ^
        email.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        phone.hashCode ^
        profile_pic.hashCode ^
        updatedAt.hashCode ^
        username.hashCode ^
        id.hashCode ^
        stories.hashCode ^
        v.hashCode;
  }
}

class StoryItemModel {
  String? createdAt;
  String? created_by;
  String? feeling_id;
  String? id;
  String? media;
  String? updatedAt;
  String? updated_by;
  String? user_id;
  int? viewersCount;
  int? v;
  MusicInfoModel? music_info;
  List<ViewerModel>? viewersList;

  StoryItemModel({
    this.createdAt,
    this.created_by,
    this.feeling_id,
    this.id,
    this.media,
    this.updatedAt,
    this.updated_by,
    this.user_id,
    this.viewersCount,
    this.v,
    this.music_info,
    this.viewersList,
  });

  StoryItemModel copyWith({
    String? createdAt,
    String? created_by,
    String? feeling_id,
    String? id,
    String? media,
    String? updatedAt,
    String? updated_by,
    String? user_id,
    int? viewersCount,
    int? v,
  }) {
    return StoryItemModel(
      createdAt: createdAt ?? this.createdAt,
      created_by: created_by ?? this.created_by,
      feeling_id: feeling_id ?? this.feeling_id,
      id: id ?? this.id,
      media: media ?? this.media,
      updatedAt: updatedAt ?? this.updatedAt,
      updated_by: updated_by ?? this.updated_by,
      user_id: user_id ?? this.user_id,
      viewersCount: viewersCount ?? this.viewersCount,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdAt': createdAt,
      'created_by': created_by,
      'feeling_id': feeling_id,
      '_id': id,
      'media': media,
      'updatedAt': updatedAt,
      'updated_by': updated_by,
      'user_id': user_id,
      'viewersCount': viewersCount,
      '__v': v,
    };
  }

  factory StoryItemModel.fromMap(Map<String, dynamic> map) {
    return StoryItemModel(
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      feeling_id:
          map['feeling_id'] != null ? map['feeling_id'] as String : null,
      id: map['_id'] != null ? map['_id'] as String : null,
      media: map['media'] != null ? map['media'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      viewersCount:
          map['viewersCount'] != null ? map['viewersCount'] as int : null,
      music_info: map['music_info'] != null
          ? MusicInfoModel.fromMap(map['music_info'])
          : null,
      viewersList: map['viewersList'] != null
          ? (map['viewersList'] as List)
              .map((e) => ViewerModel.fromMap(e))
              .toList()
          : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryItemModel.fromJson(String source) =>
      StoryItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoryItemModel(createdAt: $createdAt, created_by: $created_by, feeling_id: $feeling_id, id: $id, media: $media, updatedAt: $updatedAt, updated_by: $updated_by, user_id: $user_id, viewersCount: $viewersCount, v: $v)';
  }

  @override
  bool operator ==(covariant StoryItemModel other) {
    if (identical(this, other)) return true;

    return other.createdAt == createdAt &&
        other.created_by == created_by &&
        other.feeling_id == feeling_id &&
        other.id == id &&
        other.media == media &&
        other.updatedAt == updatedAt &&
        other.updated_by == updated_by &&
        other.user_id == user_id &&
        other.viewersCount == viewersCount &&
        other.v == v;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        created_by.hashCode ^
        feeling_id.hashCode ^
        id.hashCode ^
        media.hashCode ^
        updatedAt.hashCode ^
        updated_by.hashCode ^
        user_id.hashCode ^
        viewersCount.hashCode ^
        v.hashCode;
  }
}

class MusicInfoModel {
  String? audio_file;
  String? artist_name;
  String? titile;
  MusicInfoModel({
    this.audio_file,
    this.artist_name,
    this.titile,
  });

  MusicInfoModel copyWith({
    String? audio_file,
    String? artist_name,
    String? titile,
  }) {
    return MusicInfoModel(
      audio_file: audio_file ?? this.audio_file,
      artist_name: artist_name ?? this.artist_name,
      titile: titile ?? this.titile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'audio_file': audio_file,
      'artist_name': artist_name,
      'title': titile,
    };
  }

  factory MusicInfoModel.fromMap(Map<String, dynamic> map) {
    return MusicInfoModel(
      audio_file:
          map['audio_file'] != null ? map['audio_file'] as String : null,
      artist_name:
          map['artist_name'] != null ? map['artist_name'] as String : null,
      titile: map['title'] != null ? map['title'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicInfoModel.fromJson(String source) =>
      MusicInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MusicInfoModel(audio_file: $audio_file, artist_name: $artist_name, titile: $titile)';

  @override
  bool operator ==(covariant MusicInfoModel other) {
    if (identical(this, other)) return true;

    return other.audio_file == audio_file &&
        other.artist_name == artist_name &&
        other.titile == titile;
  }

  @override
  int get hashCode =>
      audio_file.hashCode ^ artist_name.hashCode ^ titile.hashCode;
}

class ViewerModel {
  String? first_name;
  String? last_name;
  String? profile_pic;
  List<StoryReactionModel>? reactions;
  ViewerModel({
    this.first_name,
    this.last_name,
    this.profile_pic,
    this.reactions,
  });

  factory ViewerModel.fromMap(Map<String, dynamic> map) {
    return ViewerModel(
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      reactions: map['reactions'] != null
          ? (map['reactions'] as List)
              .map((e) => StoryReactionModel.fromMap(e))
              .toList()
          : null,
    );
  }

  factory ViewerModel.fromJson(String source) =>
      ViewerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class StoryReactionModel {
  String? reaction_type;
  StoryReactionModel({
    this.reaction_type,
  });

  factory StoryReactionModel.fromMap(Map<String, dynamic> map) {
    return StoryReactionModel(
      reaction_type:
          map['reaction_type'] != null ? map['reaction_type'] as String : null,
    );
  }

  factory StoryReactionModel.fromJson(String source) =>
      StoryReactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
