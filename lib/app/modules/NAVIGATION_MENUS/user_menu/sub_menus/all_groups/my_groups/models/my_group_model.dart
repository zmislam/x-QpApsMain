class MyGroupsModel {
  String? id;
  GroupDetails? groupId;
  MyGroupMemberUser? myGroupMemberUser;
  String? role;

  MyGroupsModel({
    this.id,
    this.groupId,
    this.myGroupMemberUser,
    this.role,
  });

  factory MyGroupsModel.fromMap(Map<String, dynamic> json) {
    return MyGroupsModel(
      id: json['_id'],
      groupId: json['group_id'] != null ? GroupDetails.fromMap(json['group_id']) : null,
      myGroupMemberUser: json['group_member_user_id'] != null
          ? MyGroupMemberUser.fromMap(json['group_member_user_id'])
          : null,
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'group_id': groupId?.toJson(),
        'group_member_user_id': myGroupMemberUser?.toJson(),
        'role': role,
      };

  @override
  String toString() {
    return 'MyGroupsModel(id: $id, groupId: $groupId, myGroupMemberUser: $myGroupMemberUser, role: $role)';
  }
}

class GroupDetails {
  String? id;
  String? groupName;
  String? groupPrivacy;
  String? visibility;
  bool? isPostApprove;
  String? groupCoverPic;
  String? groupDescription;
  String? location;
  String? address;
  String? zipCode;
  String? groupCreatedUserId;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  GroupDetails({
    this.id,
    this.groupName,
    this.groupPrivacy,
    this.visibility,
    this.isPostApprove,
    this.groupCoverPic,
    this.groupDescription,
    this.location,
    this.address,
    this.zipCode,
    this.groupCreatedUserId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupDetails.fromMap(Map<String, dynamic> json) {
    return GroupDetails(
      id: json['_id'],
      groupName: json['group_name'],
      groupPrivacy: json['group_privacy'],
      visibility: json['visibility'],
      isPostApprove: json['is_post_approve'],
      groupCoverPic: json['group_cover_pic'],
      groupDescription: json['group_description'],
      location: json['location'],
      address: json['address'],
      zipCode: json['zip_code'],
      groupCreatedUserId: json['group_created_user_id'],
      createdBy: json['created_by'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'group_name': groupName,
        'group_privacy': groupPrivacy,
        'visibility': visibility,
        'is_post_approve': isPostApprove,
        'group_cover_pic': groupCoverPic,
        'group_description': groupDescription,
        'location': location,
        'address': address,
        'zip_code': zipCode,
        'group_created_user_id': groupCreatedUserId,
        'created_by': createdBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'GroupDetails(id: $id, groupName: $groupName, groupPrivacy: $groupPrivacy, visibility: $visibility, isPostApprove: $isPostApprove, groupCoverPic: $groupCoverPic, groupDescription: $groupDescription, location: $location, address: $address, zipCode: $zipCode, groupCreatedUserId: $groupCreatedUserId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class MyGroupMemberUser {
  String? id;
  String? username;

  MyGroupMemberUser({
    this.id,
    this.username,
  });

  factory MyGroupMemberUser.fromMap(Map<String, dynamic> json) {
    return MyGroupMemberUser(
      id: json['_id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
      };

  @override
  String toString() {
    return 'GroupMemberUser(id: $id, username: $username)';
  }
}
