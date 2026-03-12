class GroupMemberRequestListModel {
  final String id;
  final String groupId;
  final String userId;
  final String type;
  final bool isAccepted;
  final String? acceptedBy;
  final String? declineBy;
  final String createdBy;
  final String? updateBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final GroupDetailsInfo group;
  final GroupMemberRequestedUser user;
  final List<PrevNotification> prevNotification;

  GroupMemberRequestListModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.type,
    required this.isAccepted,
    this.acceptedBy,
    this.declineBy,
    required this.createdBy,
    this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.group,
    required this.user,
    required this.prevNotification,
  });

  factory GroupMemberRequestListModel.fromMap(Map<String, dynamic> map) {
    return GroupMemberRequestListModel(
      id: map['_id'] ?? '',
      groupId: map['group_id'] ?? '',
      userId: map['user_id'] ?? '',
      type: map['type'] ?? '',
      isAccepted: map['is_accepted'] ?? false,
      acceptedBy: map['accepted_by'],
      declineBy: map['decline_by'],
      createdBy: map['created_by'] ?? '',
      updateBy: map['update_by'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toString()),
      version: map['__v'] ?? 0,
      group: GroupDetailsInfo.fromMap(map['group'] ?? {}),
      user: GroupMemberRequestedUser.fromMap(map['user'] ?? {}),
      prevNotification: (map['prev_notification'] as List<dynamic>? ?? [])
          .map((item) => PrevNotification.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_id': groupId,
      'user_id': userId,
      'type': type,
      'is_accepted': isAccepted,
      'accepted_by': acceptedBy,
      'decline_by': declineBy,
      'created_by': createdBy,
      'update_by': updateBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
      'group': group.toMap(),
      'user': user.toMap(),
      'prev_notification': prevNotification.map((item) => item.toMap()).toList(),
    };
  }
}

class GroupDetailsInfo {
  final String id;
  final String groupName;
  final String groupPrivacy;
  final String groupCoverPic;
  final String groupDescription;
  final List<GroupMember> groupMember;

  GroupDetailsInfo({
    required this.id,
    required this.groupName,
    required this.groupPrivacy,
    required this.groupCoverPic,
    required this.groupDescription,
    required this.groupMember,
  });

  factory GroupDetailsInfo.fromMap(Map<String, dynamic> map) {
    return GroupDetailsInfo(
      id: map['_id'] ?? '',
      groupName: map['group_name'] ?? '',
      groupPrivacy: map['group_privacy'] ?? '',
      groupCoverPic: map['group_cover_pic'] ?? '',
      groupDescription: map['group_description'] ?? '',
      groupMember: (map['groupmember'] as List<dynamic>? ?? [])
          .map((item) => GroupMember.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_name': groupName,
      'group_privacy': groupPrivacy,
      'group_cover_pic': groupCoverPic,
      'group_description': groupDescription,
      'groupmember': groupMember.map((item) => item.toMap()).toList(),
    };
  }
}

class GroupMember {
  final String id;
  final int count;

  GroupMember({
    required this.id,
    required this.count,
  });

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    return GroupMember(
      id: map['_id'] ?? '',
      count: map['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'count': count,
    };
  }
}

class GroupMemberRequestedUser {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profilePic;
  final String? username;

  GroupMemberRequestedUser({
     this.id,
     this.firstName,
     this.lastName,
     this.profilePic,
     this.username
  });

  factory GroupMemberRequestedUser.fromMap(Map<String, dynamic> map) {
    return GroupMemberRequestedUser(
      id: map['_id'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      profilePic: map['profile_pic'] ?? '',
      username: map['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_pic': profilePic,
      'username': username,
    };
  }
}

class PrevNotification {
  final String id;

  PrevNotification({required this.id});

  factory PrevNotification.fromMap(Map<String, dynamic> map) {
    return PrevNotification(
      id: map['_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
    };
  }
}
