class SearchGroupModel {
  String? id;
  String? groupName;
  String? groupPrivacy;
  String? groupCoverPic;
  String? groupDescription;
  List<SearchedGroupMember>? groupMember;
  int? joinedGroupsCount;

  SearchGroupModel({
    this.id,
    this.groupName,
    this.groupPrivacy,
    this.groupCoverPic,
    this.groupDescription,
    this.groupMember,
    this.joinedGroupsCount,
  });

  factory SearchGroupModel.fromMap(Map<String, dynamic> json) {
    return SearchGroupModel(
      id: json['_id'] as String?,
      groupName: json['group_name'] as String?,
      groupPrivacy: json['group_privacy'] as String?,
      groupCoverPic: json['group_cover_pic'] as String?,
      groupDescription: json['group_description'] as String?,
      groupMember: json['groupMember'] != null
          ? List<SearchedGroupMember>.from(
              (json['groupMember'] as List<dynamic>)
                  .map((e) => SearchedGroupMember.fromMap(e as Map<String, dynamic>)))
          : [],
      joinedGroupsCount: json['joinedGroupsCount'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'group_name': groupName,
      'group_privacy': groupPrivacy,
      'group_cover_pic': groupCoverPic,
      'group_description': groupDescription,
      'groupMember': groupMember?.map((e) => e.toMap()).toList(),
      'joinedGroupsCount': joinedGroupsCount,
    };
  }

  @override
  String toString() {
    return 'Group(id: $id, groupName: $groupName, groupPrivacy: $groupPrivacy, groupCoverPic: $groupCoverPic, groupDescription: $groupDescription, groupMember: $groupMember, joinedGroupsCount: $joinedGroupsCount)';
  }
}

class SearchedGroupMember {
  String? id;
  int? count;

  SearchedGroupMember({
    this.id,
    this.count,
  });

  factory SearchedGroupMember.fromMap(Map<String, dynamic> json) {
    return SearchedGroupMember(
      id: json['_id'] as String?,
      count: json['count'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'count': count,
    };
  }

  @override
  String toString() {
    return 'GroupMember(id: $id, count: $count)';
  }
}

class GroupResponse {
  String? message;
  int? status;
  List<SearchGroupModel>? data;

  GroupResponse({
    this.message,
    this.status,
    this.data,
  });

  factory GroupResponse.fromMap(Map<String, dynamic> json) {
    return GroupResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      data: json['data'] != null
          ? List<SearchGroupModel>.from(
              (json['data'] as List<dynamic>)
                  .map((e) => SearchGroupModel.fromMap(e as Map<String, dynamic>)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'status': status,
      'data': data?.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'GroupResponse(message: $message, status: $status, data: $data)';
  }
}
