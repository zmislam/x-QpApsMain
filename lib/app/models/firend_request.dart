// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quantum_possibilities_flutter/app/models/user_id.dart';

class FriendRequestModel {
  String? id;
  UserIdModel? user_id;
  UserIdModel? connected_user_id;
  String? relation_type;
  String? accept_reject_status;
  int? data_status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  FriendRequestModel({
    this.id,
    this.user_id,
    this.connected_user_id,
    this.relation_type,
    this.accept_reject_status,
    this.data_status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  FriendRequestModel copyWith({
    String? id,
    UserIdModel? user_id,
    UserIdModel? connected_user_id,
    String? relation_type,
    String? accept_reject_status,
    int? data_status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return FriendRequestModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      connected_user_id: connected_user_id ?? this.connected_user_id,
      relation_type: relation_type ?? this.relation_type,
      accept_reject_status: accept_reject_status ?? this.accept_reject_status,
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
      'user_id': user_id?.toMap(),
      'connected_user_id': connected_user_id?.toMap(),
      'relation_type': relation_type,
      'accept_reject_status': accept_reject_status,
      'data_status': data_status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory FriendRequestModel.fromMap(Map<String, dynamic> map) {
    return FriendRequestModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null
          ? UserIdModel.fromMap(map['user_id'] as Map<String, dynamic>)
          : null,
      connected_user_id: map['connected_user_id'] != null
          ? UserIdModel.fromMap(
              map['connected_user_id'] as Map<String, dynamic>)
          : null,
      relation_type:
          map['relation_type'] != null ? map['relation_type'] as String : null,
      accept_reject_status: map['accept_reject_status'] != null
          ? map['accept_reject_status'] as String
          : null,
      data_status:
          map['data_status'] != null ? map['data_status'] as int : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['v'] != null ? map['v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendRequestModel.fromJson(String source) =>
      FriendRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendRequestModel(id: $id, user_id: $user_id, connected_user_id: $connected_user_id, relation_type: $relation_type, accept_reject_status: $accept_reject_status, data_status: $data_status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant FriendRequestModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.connected_user_id == connected_user_id &&
        other.relation_type == relation_type &&
        other.accept_reject_status == accept_reject_status &&
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
        user_id.hashCode ^
        connected_user_id.hashCode ^
        relation_type.hashCode ^
        accept_reject_status.hashCode ^
        data_status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}
