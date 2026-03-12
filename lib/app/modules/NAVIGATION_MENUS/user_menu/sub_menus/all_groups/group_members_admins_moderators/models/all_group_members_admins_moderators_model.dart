
class AllGroupMembersAdminsModeratorsModel {
  final String? message;
  final int? status;
  final AllGroupMembers? groupMembers;

  AllGroupMembersAdminsModeratorsModel({
    required this.message,
    required this.status,
    required this.groupMembers,
  });

  factory AllGroupMembersAdminsModeratorsModel.fromMap(Map<String, dynamic> map) {
    return AllGroupMembersAdminsModeratorsModel(
      message: map['message'] ?? '',
      status: map['status'] ?? 0,
      groupMembers: AllGroupMembers.fromMap(map['groupMembers'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'groupMembers': groupMembers?.toMap(),
    };
  }

  @override
  int get hashCode =>
      message.hashCode ^ status.hashCode ^ groupMembers.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AllGroupMembersAdminsModeratorsModel &&
        other.message == message &&
        other.status == status &&
        other.groupMembers == groupMembers;
  }
}

class AllGroupMembers {
  final int? count;
  final List<GroupMemberList>? data;

  AllGroupMembers({
    required this.count,
    required this.data,
  });

  factory AllGroupMembers.fromMap(Map<String, dynamic> map) {
    return AllGroupMembers(
      count: map['count'] ?? 0,
      data: List<GroupMemberList>.from(
          map['data']?.map((x) => GroupMemberList.fromMap(x)) ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  @override
  int get hashCode => count.hashCode ^ data.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AllGroupMembers &&
        other.count == count &&
        other.data == data;
  }
}

class GroupMemberList {
  final String? id;
  final GroupCreated? groupId;
  final GroupUser? groupMemberUserId;
  final String? status;
  final String? role;
  final bool? isAccepted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GroupMemberList({
    required this.id,
    required this.groupId,
    required this.groupMemberUserId,
    required this.status,
    required this.role,
    required this.isAccepted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupMemberList.fromMap(Map<String, dynamic> map) {
    return GroupMemberList(
      id: map['_id'] ?? '',
      groupId: GroupCreated.fromMap(map['group_id'] ?? {}),
      groupMemberUserId: GroupUser.fromMap(map['group_member_user_id'] ?? {}),
      status: map['status'] ?? '',
      role: map['role'] ?? '',
      isAccepted: map['is_accepted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_id': groupId?.toMap(),
      'group_member_user_id': groupMemberUserId?.toMap(),
      'status': status,
      'role': role,
      'is_accepted': isAccepted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  int get hashCode =>
      id.hashCode ^
      groupId.hashCode ^
      groupMemberUserId.hashCode ^
      status.hashCode ^
      role.hashCode ^
      isAccepted.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupMemberList &&
        other.id == id &&
        other.groupId == groupId &&
        other.groupMemberUserId == groupMemberUserId &&
        other.status == status &&
        other.role == role &&
        other.isAccepted == isAccepted &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
}

class GroupCreated {
  final String? id;
  final String? groupCreatedUserId;

  GroupCreated({
    required this.id,
    required this.groupCreatedUserId,
  });

  factory GroupCreated.fromMap(Map<String, dynamic> map) {
    return GroupCreated(
      id: map['_id'] ?? '',
      groupCreatedUserId: map['group_created_user_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_created_user_id': groupCreatedUserId,
    };
  }

  @override
  int get hashCode => id.hashCode ^ groupCreatedUserId.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupCreated &&
        other.id == id &&
        other.groupCreatedUserId == groupCreatedUserId;
  }
}

class GroupUser {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePic;

  GroupUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profilePic,
  });

  factory GroupUser.fromMap(Map<String, dynamic> map) {
    return GroupUser(
      id: map['_id'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profile_pic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'profile_pic': profilePic,
    };
  }

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      username.hashCode ^
      profilePic.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupUser &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username &&
        other.profilePic == profilePic;
  }
}
