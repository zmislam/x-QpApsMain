// class InviteGroupsModel {
//   String? id;
//   String? groupId;
//   String? userId;
//   String? type;
//   bool? isAccepted;
//   String? acceptedBy;
//   String? declineBy;
//   String? createdBy;
//   String? updateBy;
//   int? v;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   Group? group;
//   InvitedUser? user;
//   List<PrevNotification>? prevNotification;

//   InviteGroupsModel({
//     this.id,
//     this.groupId,
//     this.userId,
//     this.type,
//     this.isAccepted,
//     this.acceptedBy,
//     this.declineBy,
//     this.createdBy,
//     this.updateBy,
//     this.v,
//     this.createdAt,
//     this.updatedAt,
//     this.group,
//     this.user,
//     this.prevNotification,
//   });

//   factory InviteGroupsModel.fromMap(Map<String, dynamic> json) => InviteGroupsModel(
//         id: json['_id'],
//         groupId: json['group_id'],
//         userId: json['user_id'],
//         type: json['type'],
//         isAccepted: json['is_accepted'],
//         acceptedBy: json['accepted_by'],
//         declineBy: json['decline_by'],
//         createdBy: json['created_by'],
//         updateBy: json['update_by'],
//         v: json['__v'],
//         createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//         updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//         group: json['group'] != null ? Group.fromMap(json['group']) : null,
//         user: json['user'] != null ? InvitedUser.fromMap(json['user']) : null,
//         prevNotification: json['prev_notification'] != null
//             ? List<PrevNotification>.from(json['prev_notification'].map((x) => PrevNotification.fromMap(x)))
//             : null,
//       );

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'group_id': groupId,
//         'user_id': userId,
//         'type': type,
//         'is_accepted': isAccepted,
//         'accepted_by': acceptedBy,
//         'decline_by': declineBy,
//         'created_by': createdBy,
//         'update_by': updateBy,
//         '__v': v,
//         'createdAt': createdAt?.toIso8601String(),
//         'updatedAt': updatedAt?.toIso8601String(),
//         'group': group?.toJson(),
//         'user': user?.toJson(),
//         'prev_notification': prevNotification?.map((x) => x.toJson()).toList(),
//       };
// }

// class Group {
//   String? id;
//   String? groupName;
//   String? groupPrivacy;
//   String? groupCoverPic;
//   String? groupDescription;
//   List<GroupMember>? groupMember;

//   Group({
//     this.id,
//     this.groupName,
//     this.groupPrivacy,
//     this.groupCoverPic,
//     this.groupDescription,
//     this.groupMember,
//   });

//   factory Group.fromMap(Map<String, dynamic> json) => Group(
//         id: json['_id'],
//         groupName: json['group_name'],
//         groupPrivacy: json['group_privacy'],
//         groupCoverPic: json['group_cover_pic'],
//         groupDescription: json['group_description'],
//         groupMember: json['groupmember'] != null
//             ? List<GroupMember>.from(json['groupmember'].map((x) => GroupMember.fromMap(x)))
//             : null,
//       );

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'group_name': groupName,
//         'group_privacy': groupPrivacy,
//         'group_cover_pic': groupCoverPic,
//         'group_description': groupDescription,
//         'groupmember': groupMember?.map((x) => x.toJson()).toList(),
//       };
// }

// class GroupMember {
//   String? id;
//   int? count;

//   GroupMember({
//     this.id,
//     this.count,
//   });

//   factory GroupMember.fromMap(Map<String, dynamic> json) => GroupMember(
//         id: json['_id'],
//         count: json['count'],
//       );

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'count': count,
//       };
// }

// class InvitedUser {
//   String? id;
//   String? firstName;
//   String? lastName;
//   String? profilePic;

//   InvitedUser({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.profilePic,
//   });

//   factory InvitedUser.fromMap(Map<String, dynamic> json) => InvitedUser(
//         id: json['_id'],
//         firstName: json['first_name'],
//         lastName: json['last_name'],
//         profilePic: json['profile_pic'],
//       );

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'first_name': firstName,
//         'last_name': lastName,
//         'profile_pic': profilePic,
//       };
// }

// class PrevNotification {
//   String? id;

//   PrevNotification({this.id});

//   factory PrevNotification.fromMap(Map<String, dynamic> json) => PrevNotification(
//         id: json['_id'],
//       );

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//       };
// }
