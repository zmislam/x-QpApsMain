
class GroupMembersResponse {
  final String? message;
  final int? status;
  final GroupMembers? groupMembers;

  GroupMembersResponse({
    this.message,
    this.status,
    this.groupMembers,
  });

  factory GroupMembersResponse.fromMap(Map<String, dynamic> map) {
    return GroupMembersResponse(
      message: map['message'] as String?,
      status: map['status'] as int?,
      groupMembers: map['groupMembers'] != null
          ? GroupMembers.fromMap(map['groupMembers'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'groupMembers': groupMembers?.toMap(),
    };
  }
}

class GroupMembers {
  final int? count;
  final List<GroupMembersModel>? data;

  GroupMembers({
    this.count,
    this.data,
  });

  factory GroupMembers.fromMap(Map<String, dynamic> map) {
    var list = map['data'] as List?;
    List<GroupMembersModel>? dataList = list?.map((i) => GroupMembersModel.fromMap(i as Map<String, dynamic>)).toList();

    return GroupMembers(
      count: map['count'] as int?,
      data: dataList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'data': data?.map((i) => i.toMap()).toList(),
    };
  }
}

class GroupMembersModel {
  final String? id;
  final GroupId? groupId;
  final GroupMemberUserId? groupMemberUserId;
  final String? status;
  final String? role;
  final String? ipAddress;
  final String? createdBy;
  final DateTime? createdDate;
  final String? updateBy;
  final DateTime? updateDate;
  final bool? isAccepted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GroupMembersModel({
    this.id,
    this.groupId,
    this.groupMemberUserId,
    this.status,
    this.role,
    this.ipAddress,
    this.createdBy,
    this.createdDate,
    this.updateBy,
    this.updateDate,
    this.isAccepted,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupMembersModel.fromMap(Map<String, dynamic> map) {
    return GroupMembersModel(
      id: map['_id'] as String?,
      groupId: map['group_id'] != null
          ? GroupId.fromMap(map['group_id'] as Map<String, dynamic>)
          : null,
      groupMemberUserId: map['group_member_user_id'] != null
          ? GroupMemberUserId.fromMap(map['group_member_user_id'] as Map<String, dynamic>)
          : null,
      status: map['status'] as String?,
      role: map['role'] as String?,
      ipAddress: map['ip_address'] as String?,
      createdBy: map['created_by'] as String?,
      createdDate: map['created_date'] != null ? DateTime.parse(map['created_date']) : null,
      updateBy: map['update_by'] as String?,
      updateDate: map['update_Date'] != null ? DateTime.parse(map['update_Date']) : null,
      isAccepted: map['is_accepted'] as bool?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_id': groupId?.toMap(),
      'group_member_user_id': groupMemberUserId?.toMap(),
      'status': status,
      'role': role,
      'ip_address': ipAddress,
      'created_by': createdBy,
      'created_date': createdDate?.toIso8601String(),
      'update_by': updateBy,
      'update_Date': updateDate?.toIso8601String(),
      'is_accepted': isAccepted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class GroupId {
  final String? id;
  final String? groupCreatedUserId;

  GroupId({
    this.id,
    this.groupCreatedUserId,
  });

  factory GroupId.fromMap(Map<String, dynamic> map) {
    return GroupId(
      id: map['_id'] as String?,
      groupCreatedUserId: map['group_created_user_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_created_user_id': groupCreatedUserId,
    };
  }
}

class GroupMemberUserId {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePic;

  GroupMemberUserId({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
  });

  factory GroupMemberUserId.fromMap(Map<String, dynamic> map) {
    return GroupMemberUserId(
      id: map['_id'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      username: map['username'] as String?,
      profilePic: map['profile_pic'] as String?,
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
}
