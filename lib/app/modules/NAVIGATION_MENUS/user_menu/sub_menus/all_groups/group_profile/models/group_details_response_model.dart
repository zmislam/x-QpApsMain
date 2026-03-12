class GroupDetailsResponse {
  final String? message;
  final int? status;
  final GroupMembers? groupMembers;
  final bool? isMember;
  final String? groupOwnerId;
  final GroupDetailsModel? groupDetailsModel;
  final List<GroupMedia>? groupMedia;

  GroupDetailsResponse({
    this.message,
    this.status,
    this.groupMembers,
    this.isMember,
    this.groupOwnerId,
    this.groupDetailsModel,
    this.groupMedia,
  });

  factory GroupDetailsResponse.fromMap(Map<String, dynamic> map) {
    return GroupDetailsResponse(
      message: map['message'] as String?,
      status: map['status'] as int?,
      groupMembers: map['groupMembers'] != null
          ? GroupMembers.fromMap(map['groupMembers'] as Map<String, dynamic>)
          : null,
      isMember: map['isMember'] as bool?,
      groupOwnerId: map['groupOwner_id'] as String?,
      groupDetailsModel: map['groupDetails'] != null
          ? GroupDetailsModel.fromMap(map['groupDetails'] as Map<String, dynamic>)
          : null,
      groupMedia: map['groupMedia'] != null
          ? List<GroupMedia>.from(
              (map['groupMedia'] as List<dynamic>).map((media) => GroupMedia.fromMap(media as Map<String, dynamic>)),
            )
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'groupMembers': groupMembers?.toMap(),
      'isMember': isMember,
      'groupOwner_id': groupOwnerId,
      'groupDetails': groupDetailsModel?.toMap(),
      'groupMedia': groupMedia?.map((media) => media.toMap()).toList(),
    };
  }
}

class GroupMembers {
  final int? active;

  GroupMembers({this.active});

  factory GroupMembers.fromMap(Map<String, dynamic> map) {
    return GroupMembers(
      active: map['active'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'active': active,
    };
  }
}

class GroupDetailsModel {
  final String? id;
  final GroupIdModel? groupIdModel;
  final String? status;
  final String? role;

  GroupDetailsModel({
    this.id,
    this.groupIdModel,
    this.status,
    this.role,
  });

  factory GroupDetailsModel.fromMap(Map<String, dynamic> map) {
    return GroupDetailsModel(
      id: map['_id'] as String?,
      groupIdModel: map['group_id'] != null
          ? GroupIdModel.fromMap(map['group_id'] as Map<String, dynamic>)
          : null,
      status: map['status'] as String?,
      role: map['role'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_id': groupIdModel?.toMap(),
      'status': status,
      'role': role,
    };
  }
}

class GroupIdModel {
  final String? id;
  final String? groupName;
  final String? groupPrivacy;
  final String? visibility;
  final String? groupCoverPic;
  final String? groupDescription;
  final String? postApproveBy;
  final int? joinedGroupsCount;
  final String? location;
  final String? address;
  final String? zipCode;
  final String? groupCreatedUserId;
  final String? createdAt;
  final String? updatedAt;

  GroupIdModel({
    this.id,
    this.groupName,
    this.groupPrivacy,
    this.visibility,
    this.groupCoverPic,
    this.groupDescription,
    this.postApproveBy,
    this.joinedGroupsCount,
    this.location,
    this.address,
    this.zipCode,
    this.groupCreatedUserId,
    this.createdAt,
    this.updatedAt,
  });

  factory GroupIdModel.fromMap(Map<String, dynamic> map) {
    return GroupIdModel(
      id: map['_id'] as String?,
      groupName: map['group_name'] as String?,
      groupPrivacy: map['group_privacy'] as String?,
      visibility: map['visibility'] as String?,
      groupCoverPic: map['group_cover_pic'] as String?,
      groupDescription: map['group_description'] as String?,
      postApproveBy: map['post_approve_by'] as String?,
      joinedGroupsCount: map['joinedGroupsCount'] as int?,
      location: map['location'] as String?,
      address: map['address'] as String?,
      zipCode: map['zip_code'] as String?,
      groupCreatedUserId: map['group_created_user_id'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_name': groupName,
      'group_privacy': groupPrivacy,
      'joinedGroupsCount': joinedGroupsCount,
      'visibility': visibility,
      'group_cover_pic': groupCoverPic,
      'group_description': groupDescription,
      'post_approve_by':postApproveBy,
      'location': location,
      'address': address,
      'zip_code': zipCode,
      'group_created_user_id': groupCreatedUserId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class GroupMedia {
  final String? id;
  final String? caption;
  final String? media;
  final String? createdAt;

  GroupMedia({
    this.id,
    this.caption,
    this.media,
    this.createdAt,
  });

  factory GroupMedia.fromMap(Map<String, dynamic> map) {
    return GroupMedia(
      id: map['_id'] as String?,
      caption: map['caption'] as String?,
      media: map['media'] as String?,
      createdAt: map['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'caption': caption,
      'media': media,
      'createdAt': createdAt,
    };
  }
}
