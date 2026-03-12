// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quantum_possibilities_flutter/app/models/user_id.dart';

class ReactionModel {
  String? id;
  String? reaction_type;
  UserIdModel? user_id;
  String? post_id;
  String? post_single_item_id;
  String? status;
  String? ip_address;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  ReactionModel({
    this.id,
    this.reaction_type,
    this.user_id,
    this.post_id,
    this.post_single_item_id,
    this.status,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ReactionModel copyWith({
    String? id,
    String? reaction_type,
    UserIdModel? user_id,
    String? post_id,
    String? post_single_item_id,
    String? status,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return ReactionModel(
      id: id ?? this.id,
      reaction_type: reaction_type ?? this.reaction_type,
      user_id: user_id ?? this.user_id,
      post_id: post_id ?? this.post_id,
      post_single_item_id: post_single_item_id ?? this.post_single_item_id,
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
      'reaction_type': reaction_type,
      'user_id': user_id?.toMap(),
      'post_id': post_id,
      'post_single_item_id': post_single_item_id,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory ReactionModel.fromMap(Map<String, dynamic> map) {
    return ReactionModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      reaction_type:
          map['reaction_type'] != null ? map['reaction_type'] as String : null,
      user_id: map['user_id'] != null
          ? UserIdModel.fromMap(map['user_id'] as Map<String, dynamic>)
          : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      post_single_item_id: map['post_single_item_id'] != null
          ? map['post_single_item_id'] as String
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReactionModel.fromJson(String source) =>
      ReactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReactionModel(id: $id, reaction_type: $reaction_type, userIdModel: $user_id, post_id: $post_id, post_single_item_id: $post_single_item_id, status: $status, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant ReactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.reaction_type == reaction_type &&
        other.user_id == user_id &&
        other.post_id == post_id &&
        other.post_single_item_id == post_single_item_id &&
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
        reaction_type.hashCode ^
        user_id.hashCode ^
        post_id.hashCode ^
        post_single_item_id.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}
