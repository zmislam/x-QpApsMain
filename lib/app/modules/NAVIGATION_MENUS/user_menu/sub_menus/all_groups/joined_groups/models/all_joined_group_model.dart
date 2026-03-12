// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class allGroupModel {
  String? id;
  String? group_name;
  String? group_privacy;
  String? group_cover_pic;
  String? group_description;
  JoinedGroupMember? groupMember;
  allGroupModel({
    this.id,
    this.group_name,
    this.group_privacy,
    this.group_cover_pic,
    this.group_description,
    this.groupMember,
  });

  allGroupModel copyWith({
    String? id,
    String? group_name,
    String? group_privacy,
    String? group_cover_pic,
    String? group_description,
    JoinedGroupMember? groupMember,
  }) {
    return allGroupModel(
      id: id ?? this.id,
      group_name: group_name ?? this.group_name,
      group_privacy: group_privacy ?? this.group_privacy,
      group_cover_pic: group_cover_pic ?? this.group_cover_pic,
      group_description: group_description ?? this.group_description,
      groupMember: groupMember ?? this.groupMember,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'group_name': group_name,
      'group_privacy': group_privacy,
      'group_cover_pic': group_cover_pic,
      'group_description': group_description,
      'groupMember': groupMember?.toMap(),
    };
  }

  factory allGroupModel.fromMap(Map<String, dynamic> map) {
    return allGroupModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      group_name:
          map['group_name'] != null ? map['group_name'] as String : null,
      group_privacy:
          map['group_privacy'] != null ? map['group_privacy'] as String : null,
      group_cover_pic: map['group_cover_pic'] != null
          ? map['group_cover_pic'] as String
          : null,
      group_description: map['group_description'] != null
          ? map['group_description'] as String
          : null,
      groupMember: map['groupMember'] != null
          ? JoinedGroupMember.fromMap(
              map['groupMember'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory allGroupModel.fromJson(String source) =>
      allGroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'allGroupModel(_id: $id, group_name: $group_name, group_privacy: $group_privacy, group_cover_pic: $group_cover_pic, group_description: $group_description, groupMember: $groupMember)';
  }

  @override
  bool operator ==(covariant allGroupModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.group_name == group_name &&
        other.group_privacy == group_privacy &&
        other.group_cover_pic == group_cover_pic &&
        other.group_description == group_description &&
        other.groupMember == groupMember;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        group_name.hashCode ^
        group_privacy.hashCode ^
        group_cover_pic.hashCode ^
        group_description.hashCode ^
        groupMember.hashCode;
  }
}

class JoinedGroupMember {
  int? count;
  JoinedGroupMember({
    this.count,
  });

  JoinedGroupMember copyWith({
    int? count,
  }) {
    return JoinedGroupMember(
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
    };
  }

  factory JoinedGroupMember.fromMap(Map<String, dynamic> map) {
    return JoinedGroupMember(
      count: map['count'] != null ? map['count'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory JoinedGroupMember.fromJson(String source) =>
      JoinedGroupMember.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GroupMember(count: $count)';

  @override
  bool operator ==(covariant JoinedGroupMember other) {
    if (identical(this, other)) return true;

    return other.count == count;
  }

  @override
  int get hashCode => count.hashCode;
}
