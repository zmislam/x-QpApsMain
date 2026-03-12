class AllGroupModel {
  String? id;
  String? groupName;
  String? groupPrivacy;
  String? groupCoverPic;
  String? groupDescription;
  String? location; 
  String? postApproveBy;
  // List<GroupMember> groupMember;
  int joinedGroupsCount;

  AllGroupModel({
    this.id ,
    this.groupName ,
    this.groupPrivacy ,
    this.groupCoverPic ,
    this.groupDescription ,
    this.location , 
    this.postApproveBy ='',
    // this.groupMember = const [],
    this.joinedGroupsCount = 0,
  });

  AllGroupModel copyWith({
    String? id,
    String? groupName,
    String? groupPrivacy,
    String? groupCoverPic,
    String? groupDescription,
    String? location,
    String? postApproveBy,
    // List<GroupMember>? groupMember,
    int? joinedGroupsCount,
  }) {
    return AllGroupModel(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      groupPrivacy: groupPrivacy ?? this.groupPrivacy,
      groupCoverPic: groupCoverPic ?? this.groupCoverPic,
      groupDescription: groupDescription ?? this.groupDescription,
      location: location ?? this.location, 
      postApproveBy: postApproveBy ?? this.postApproveBy,
      // groupMember: groupMember ?? this.groupMember,
      joinedGroupsCount: joinedGroupsCount ?? this.joinedGroupsCount,
    );
  }

  factory AllGroupModel.fromMap(Map<String, dynamic> json) {
    return AllGroupModel(
      id: json['_id'] ?? '',
      groupName: json['group_name'] ?? '',
      groupPrivacy: json['group_privacy'] ?? '',
      groupCoverPic: json['group_cover_pic'] ?? '',
      groupDescription: json['group_description'] ?? '',
      location: json['location'] ?? '', 
      postApproveBy: json['post_approve_by'] ?? '', 
      // groupMember: json['groupMember'] == null
      //     ? []
      //     : List<GroupMember>.from(
      //         json['groupMember']!.map((x) => GroupMember.fromMap(x))),
      joinedGroupsCount: json['joinedGroupsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'group_name': groupName,
        'group_privacy': groupPrivacy,
        'group_cover_pic': groupCoverPic,
        'group_description': groupDescription,
        'location': location, 
        'post_approve_by':postApproveBy,
        // 'groupMember': groupMember.map((x) => x.toJson()).toList(),
        'joinedGroupsCount': joinedGroupsCount,
      };

  @override
  String toString() {
    return 'AllGroupModel(id: $id, groupName: $groupName, groupPrivacy: $groupPrivacy, groupCoverPic: $groupCoverPic, groupDescription: $groupDescription, location: $location, post_approve_by: $postApproveBy, joinedGroupsCount: $joinedGroupsCount)';
  }
}

class GroupListResponse {
  String? message;
  int? status;
  List<AllGroupModel> data;

  GroupListResponse({
    this.message ,
    this.status ,
    this.data = const [],
  });

  factory GroupListResponse.fromMap(Map<String, dynamic> json) {
    return GroupListResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: json['data'] == null
          ? []
          : List<AllGroupModel>.from(
              json['data']!.map((x) => AllGroupModel.fromMap(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
        'data': data.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() =>
      'GroupListResponse(message: $message, status: $status, data: $data)';
}
