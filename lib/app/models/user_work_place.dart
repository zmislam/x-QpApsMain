// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserWorkPlaceModel {
  String? id;
  String? user_id;
  String? org_id;
  int? v;
  String? createdAt;
  String? created_by;
  String? from_date;
  bool? is_working;
  String? org_name;
  String? privacy;
  int? status;
  String? to_date;
  String? update_by;
  String? updatedAt;
  String? username;
  String? designation;
  UserWorkPlaceModel({
    this.id,
    this.user_id,
    this.org_id,
    this.v,
    this.createdAt,
    this.created_by,
    this.from_date,
    this.is_working,
    this.org_name,
    this.privacy,
    this.status,
    this.to_date,
    this.update_by,
    this.updatedAt,
    this.username,
    this.designation,
  });

  UserWorkPlaceModel copyWith({
    String? id,
    String? user_id,
    String? org_id,
    int? v,
    String? createdAt,
    String? created_by,
    String? from_date,
    bool? is_working,
    String? org_name,
    String? privacy,
    int? status,
    String? to_date,
    String? update_by,
    String? updatedAt,
    String? username,
    String? designation,
  }) {
    return UserWorkPlaceModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      org_id: org_id ?? this.org_id,
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      created_by: created_by ?? this.created_by,
      from_date: from_date ?? this.from_date,
      is_working: is_working ?? this.is_working,
      org_name: org_name ?? this.org_name,
      privacy: privacy ?? this.privacy,
      status: status ?? this.status,
      to_date: to_date ?? this.to_date,
      update_by: update_by ?? this.update_by,
      updatedAt: updatedAt ?? this.updatedAt,
      username: username ?? this.username,
      designation: designation ?? this.designation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'user_id': user_id,
      'org_id': org_id,
      '__v': v,
      'createdAt': createdAt,
      'created_by': created_by,
      'from_date': from_date,
      'is_working': is_working,
      'org_name': org_name,
      'privacy': privacy,
      'status': status,
      'to_date': to_date,
      'update_by': update_by,
      'updatedAt': updatedAt,
      'username': username,
      'designation': designation,
    };
  }

  factory UserWorkPlaceModel.fromMap(Map<String, dynamic> map) {
    return UserWorkPlaceModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      org_id: map['org_id'] != null ? map['org_id'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      from_date: map['from_date'] != null ? map['from_date'] as String : null,
      is_working: map['is_working'] != null ? map['is_working'] as bool : null,
      org_name: map['org_name'] != null ? map['org_name'] as String : null,
      privacy: map['privacy'] != null ? map['privacy'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      to_date: map['to_date'] != null ? map['to_date'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      designation:
          map['designation'] != null ? map['designation'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserWorkPlaceModel.fromJson(String source) =>
      UserWorkPlaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserWorkPlaceModel(id: $id, user_id: $user_id, org_id: $org_id, v: $v, createdAt: $createdAt, created_by: $created_by, from_date: $from_date, is_working: $is_working, org_name: $org_name, privacy: $privacy, status: $status, to_date: $to_date, update_by: $update_by, updatedAt: $updatedAt, username: $username)';
  }

  @override
  bool operator ==(covariant UserWorkPlaceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.org_id == org_id &&
        other.v == v &&
        other.createdAt == createdAt &&
        other.created_by == created_by &&
        other.from_date == from_date &&
        other.is_working == is_working &&
        other.org_name == org_name &&
        other.privacy == privacy &&
        other.status == status &&
        other.to_date == to_date &&
        other.update_by == update_by &&
        other.updatedAt == updatedAt &&
        other.username == username;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        org_id.hashCode ^
        v.hashCode ^
        createdAt.hashCode ^
        created_by.hashCode ^
        from_date.hashCode ^
        is_working.hashCode ^
        org_name.hashCode ^
        privacy.hashCode ^
        status.hashCode ^
        to_date.hashCode ^
        update_by.hashCode ^
        updatedAt.hashCode ^
        username.hashCode;
  }
}
