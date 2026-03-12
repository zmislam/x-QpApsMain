class FollowerUserModel {
  String? id;
  UserId? userId;
  String? followerUserId;
  String? followUnfollowStatus;
  int? dataStatus;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int v;
  bool isFriend;
  bool isFriendRequestSended;

  FollowerUserModel({
    required this.id,
    required this.userId,
    required this.followerUserId,
    required this.followUnfollowStatus,
    required this.dataStatus,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.isFriend,
    required this.isFriendRequestSended,
  });

  FollowerUserModel copyWith({
    String? id,
    UserId? userId,
    String? followerUserId,
    String? followUnfollowStatus,
    int? dataStatus,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    bool? isFriend,
    bool? isFriendRequestSended,
  }) =>
      FollowerUserModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        followerUserId: followerUserId ?? this.followerUserId,
        followUnfollowStatus: followUnfollowStatus ?? this.followUnfollowStatus,
        dataStatus: dataStatus ?? this.dataStatus,
        ipAddress: ipAddress ?? this.ipAddress,
        createdBy: createdBy ?? this.createdBy,
        updateBy: updateBy ?? this.updateBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        isFriend: isFriend ?? this.isFriend,
        isFriendRequestSended:
            isFriendRequestSended ?? this.isFriendRequestSended,
      );

  factory FollowerUserModel.fromJson(Map<String, dynamic> json) =>
      FollowerUserModel(
        id: json['_id'],
        userId: UserId.fromJson(json['user_id']),
        followerUserId: json['follower_user_id'],
        followUnfollowStatus: json['follow_unfollow_status'],
        dataStatus: json['data_status'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updateBy: json['update_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        isFriend: json['isFriend'],
        isFriendRequestSended: json['isFriendRequestSended'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId,
        'follower_user_id': followerUserId,
        'follow_unfollow_status': followUnfollowStatus,
        'data_status': dataStatus,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'isFriend': isFriend,
        'isFriendRequestSended': isFriendRequestSended,
      };
}

class UserId {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePic;

  UserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profilePic,
  });

  UserId copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? profilePic,
  }) =>
      UserId(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        profilePic: profilePic ?? this.profilePic,
      );

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        username: json['username'],
        profilePic: json['profile_pic'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'profile_pic': profilePic,
      };
}
