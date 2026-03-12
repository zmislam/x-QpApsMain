// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:quantum_possibilities_flutter/app/models/chat/participant_model.dart';

class ChatModel {
  String? id;
  String? name;
  bool? isGroupChat;
  List<ParticipantModel>? participants;
  List<LeaveParticipants>? leave_participants;
  String? admin;
  String? page_id;
  String? cover_image;
  bool? isMuted;
  bool? isRequested;
  String? createdAt;
  String? updatedAt;
  int? v;
  PageInfo? pageInfo;
  bool isActive = false;
  bool isRead = false;
  bool? isRestricted;
  int? newMessageCount;
  bool isSelected = false;

  ChatModel({
    this.id,
    this.name,
    this.isGroupChat,
    this.participants,
    this.leave_participants,
    this.admin,
    this.page_id,
    this.cover_image,
    this.isMuted,
    this.isRequested,
    this.isRestricted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.pageInfo,
    this.newMessageCount,
  });

  ChatModel copyWith({
    String? id,
    String? name,
    bool? isGroupChat,
    List<ParticipantModel>? participants,
    List<LeaveParticipants>? leave_participants,
    String? admin,
    String? page_id,
    String? cover_image,
    bool? isMuted,
    bool? isRequested,
    bool? isRestricted,
    String? createdAt,
    String? updatedAt,
    int? v,
    PageInfo? pageInfo,
    int? newMessageCount,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      participants: participants ?? this.participants,
      leave_participants: leave_participants ?? this.leave_participants,
      admin: admin ?? this.admin,
      page_id: page_id ?? this.page_id,
      cover_image: cover_image ?? this.cover_image,
      isMuted: isMuted ?? this.isMuted,
      isRequested: isRequested ?? this.isRequested,
      isRestricted: isRestricted ?? this.isRestricted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      pageInfo: pageInfo ?? this.pageInfo,
      newMessageCount: newMessageCount ?? this.newMessageCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'isGroupChat': isGroupChat,
      'participants': participants?.map((x) => x.toMap()).toList(),
      'leave_participants': leave_participants?.map((x) => x.toMap()).toList(),
      'admin': admin,
      'page_id': page_id,
      'cover_image': cover_image,
      'isMuted': isMuted,
      'isRequested': isRequested,
      'isRestricted': isRestricted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'pageInfo': pageInfo?.toMap()
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        id: map['_id'] != null ? map['_id'] as String : null,
        name: map['name'] != null ? map['name'] as String : null,
        isGroupChat:
            map['isGroupChat'] != null ? map['isGroupChat'] as bool : null,
        participants: map['participants'] != null
            ? (map['participants'] as List)
                .map((e) => ParticipantModel.fromMap(e))
                .toList()
            : null,
        leave_participants: map['leave_participants'] != null
            ? (map['leave_participants'] as List)
                .map((e) => LeaveParticipants.fromMap(e))
                .toList()
            : null,
        admin: map['admin'] != null ? map['admin'] as String : null,
        page_id: map['page_id'] != null ? map['page_id'] as String : null,
        cover_image:
            map['cover_image'] != null ? map['cover_image'] as String : null,
        isMuted: map['isMuted'] != null ? map['isMuted'] as bool : null,
        isRequested:
            map['isRequested'] != null ? map['isRequested'] as bool : null,
        isRestricted:
            map['isRestricted'] != null ? map['isRestricted'] as bool : null,
        createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
        updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
        v: map['__v'] != null ? map['__v'] as int : null,
        pageInfo: map['pageInfo'] != null
            ? PageInfo.fromMap(map['pageInfo'] as Map<String, dynamic>)
            : null);
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, name: $name, isGroupChat: $isGroupChat, participants: $participants, leave_participants: $leave_participants, admin: $admin, page_id: $page_id, cover_image: $cover_image, isMuted: $isMuted, isRequested: $isRequested, isRestricted: $isRestricted, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, pageInfo: $pageInfo)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.isGroupChat == isGroupChat &&
        listEquals(other.participants, participants) &&
        listEquals(other.leave_participants, leave_participants) &&
        other.admin == admin &&
        other.page_id == page_id &&
        other.cover_image == cover_image &&
        other.isMuted == isMuted &&
        other.isRequested == isRequested &&
        other.isRestricted == isRestricted &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v &&
        other.pageInfo == pageInfo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        isGroupChat.hashCode ^
        participants.hashCode ^
        leave_participants.hashCode ^
        admin.hashCode ^
        page_id.hashCode ^
        cover_image.hashCode ^
        isMuted.hashCode ^
        isRequested.hashCode ^
        isRestricted.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode ^
        pageInfo.hashCode;
  }
}

class LeaveParticipants {
  String? user_id;
  String? leave_time;
  LeaveParticipants({
    this.user_id,
    this.leave_time,
  });

  LeaveParticipants copyWith({
    String? user_id,
    String? leave_time,
  }) {
    return LeaveParticipants(
      user_id: user_id ?? this.user_id,
      leave_time: leave_time ?? this.leave_time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': user_id,
      'leave_time': leave_time,
    };
  }

  factory LeaveParticipants.fromMap(Map<String, dynamic> map) {
    return LeaveParticipants(
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      leave_time:
          map['leave_time'] != null ? map['leave_time'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LeaveParticipants.fromJson(String source) =>
      LeaveParticipants.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LeaveParticipants(user_id: $user_id, leave_time: $leave_time)';

  @override
  bool operator ==(covariant LeaveParticipants other) {
    if (identical(this, other)) return true;

    return other.user_id == user_id && other.leave_time == leave_time;
  }

  @override
  int get hashCode => user_id.hashCode ^ leave_time.hashCode;
}

class PageInfo {
  String? id;
  String? page_name;
  String? profile_pic;
  String? page_user_name;
  String? user_id;
  PageInfo({
    this.id,
    this.page_name,
    this.profile_pic,
    this.page_user_name,
    this.user_id,
  });

  PageInfo copyWith({
    String? id,
    String? page_name,
    String? profile_pic,
    String? page_user_name,
    String? user_id,
  }) {
    return PageInfo(
      id: id ?? this.id,
      page_name: page_name ?? this.page_name,
      profile_pic: profile_pic ?? this.profile_pic,
      page_user_name: page_user_name ?? this.page_user_name,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'page_name': page_name,
      'profile_pic': profile_pic,
      'page_user_name': page_user_name,
      'user_id': user_id,
    };
  }

  factory PageInfo.fromMap(Map<String, dynamic> map) {
    return PageInfo(
      id: map['_id'] != null ? map['_id'] as String : null,
      page_name: map['page_name'] != null ? map['page_name'] as String : null,
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      page_user_name: map['page_user_name'] != null
          ? map['page_user_name'] as String
          : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PageInfo.fromJson(String source) =>
      PageInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PageInfo(_id: $id, page_name: $page_name, profile_pic: $profile_pic, page_user_name: $page_user_name, user_id: $user_id)';
  }

  @override
  bool operator ==(covariant PageInfo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.page_name == page_name &&
        other.profile_pic == profile_pic &&
        other.page_user_name == page_user_name &&
        other.user_id == user_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        page_name.hashCode ^
        profile_pic.hashCode ^
        page_user_name.hashCode ^
        user_id.hashCode;
  }
}
