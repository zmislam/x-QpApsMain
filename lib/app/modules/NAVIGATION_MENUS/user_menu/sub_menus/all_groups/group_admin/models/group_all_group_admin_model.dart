
class GroupAdminsResponse {
  final String message;
  final int status;
  final GroupAdmins? groupAdmins; // Nullable

  GroupAdminsResponse({
    required this.message,
    required this.status,
    this.groupAdmins,
  });

  factory GroupAdminsResponse.fromMap(Map<String, dynamic> map) {
    return GroupAdminsResponse(
      message: map['message'] as String,
      status: map['status'] as int,
      groupAdmins: map['groupAdmins'] != null
          ? GroupAdmins.fromMap(map['groupAdmins'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'groupAdmins': groupAdmins?.toMap(),
    };
  }
}

class GroupAdmins {
  final int count;
  final List<GroupAdminModel> data;

  GroupAdmins({
    required this.count,
    required this.data,
  });

  factory GroupAdmins.fromMap(Map<String, dynamic> map) {
    var list = map['data'] as List<dynamic>;
    List<GroupAdminModel> dataList =
        list.map((i) => GroupAdminModel.fromMap(i as Map<String, dynamic>)).toList();

    return GroupAdmins(
      count: map['count'] as int,
      data: dataList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'data': data.map((i) => i.toMap()).toList(),
    };
  }
}

class GroupAdminModel {
  final String id;
  final GroupId groupId;
  final GroupMemberUserId groupMemberUserId;
  final String status;
  final String role;
  final String? ipAddress;
  final String? createdBy;
  final DateTime? createdDate;
  final String? updateBy;
  final DateTime? updateDate;
  final bool isAccepted;
  final DateTime createdAt;
  final DateTime updatedAt;

  GroupAdminModel({
    required this.id,
    required this.groupId,
    required this.groupMemberUserId,
    required this.status,
    required this.role,
    this.ipAddress,
    this.createdBy,
    this.createdDate,
    this.updateBy,
    this.updateDate,
    required this.isAccepted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupAdminModel.fromMap(Map<String, dynamic> map) {
    return GroupAdminModel(
      id: map['_id'] as String,
      groupId: GroupId.fromMap(map['group_id'] as Map<String, dynamic>),
      groupMemberUserId: GroupMemberUserId.fromMap(
          map['group_member_user_id'] as Map<String, dynamic>),
      status: map['status'] as String,
      role: map['role'] as String,
      ipAddress: map['ip_address'] as String?,
      createdBy: map['created_by'] as String?,
      createdDate: map['created_date'] != null
          ? DateTime.parse(map['created_date'] as String)
          : null,
      updateBy: map['update_by'] as String?,
      updateDate: map['update_Date'] != null
          ? DateTime.parse(map['update_Date'] as String)
          : null,
      isAccepted: map['is_accepted'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_id': groupId.toMap(),
      'group_member_user_id': groupMemberUserId.toMap(),
      'status': status,
      'role': role,
      'ip_address': ipAddress,
      'created_by': createdBy,
      'created_date': createdDate?.toIso8601String(),
      'update_by': updateBy,
      'update_Date': updateDate?.toIso8601String(),
      'is_accepted': isAccepted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class GroupId {
  final String id;
  final String groupCreatedUserId;

  GroupId({
    required this.id,
    required this.groupCreatedUserId,
  });

  factory GroupId.fromMap(Map<String, dynamic> map) {
    return GroupId(
      id: map['_id'] as String,
      groupCreatedUserId: map['group_created_user_id'] as String,
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
  final String id;
  final String firstName;
  final String lastName;
  final String profilePic;
  final String username;

  GroupMemberUserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.username,
  });

  factory GroupMemberUserId.fromMap(Map<String, dynamic> map) {
    return GroupMemberUserId(
      id: map['_id'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      profilePic: map['profile_pic'] as String,
      username: map['username'] as String
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_pic': profilePic,
      'username': username
    };
  }
}
