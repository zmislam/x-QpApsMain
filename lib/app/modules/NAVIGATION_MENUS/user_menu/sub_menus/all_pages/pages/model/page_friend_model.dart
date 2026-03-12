class PageFriendmodel {
  PageFriendmodel({
    this.id,
    this.userId,
    this.connectedUserId,
    this.relationType,
    this.acceptRejectStatus,
    this.dataStatus,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  UserId? userId;
  UserId? connectedUserId;
  dynamic relationType;
  String? acceptRejectStatus;
  int? dataStatus;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PageFriendmodel copyWith({
    String? id,
    UserId? userId,
    UserId? connectedUserId,
    dynamic relationType,
    String? acceptRejectStatus,
    int? dataStatus,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PageFriendmodel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      connectedUserId: connectedUserId ?? this.connectedUserId,
      relationType: relationType ?? this.relationType,
      acceptRejectStatus: acceptRejectStatus ?? this.acceptRejectStatus,
      dataStatus: dataStatus ?? this.dataStatus,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory PageFriendmodel.fromMap(Map<String, dynamic> json) {
    return PageFriendmodel(
      id: json['_id'],
      userId: json['user_id'] == null ? null : UserId.fromJson(json['user_id']),
      connectedUserId: json['connected_user_id'] == null
          ? null
          : UserId.fromJson(json['connected_user_id']),
      relationType: json['relation_type'],
      acceptRejectStatus: json['accept_reject_status'],
      dataStatus: json['data_status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updateBy: json['update_by'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId?.toJson(),
        'connected_user_id': connectedUserId?.toJson(),
        'relation_type': relationType,
        'accept_reject_status': acceptRejectStatus,
        'data_status': dataStatus,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return '$id, $userId, $connectedUserId, $relationType, $acceptRejectStatus, $dataStatus, $ipAddress, $createdBy, $updateBy, $createdAt, $updatedAt, $v, ';
  }

  userAsString() {}
}

class UserId {
  UserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.profilePic,
    required this.gender,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePic;
  final String? gender;

  UserId copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? profilePic,
    String? gender,
  }) {
    return UserId(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      gender: gender ?? this.gender,
    );
  }

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      profilePic: json['profile_pic'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'profile_pic': profilePic,
        'gender': gender,
      };

  @override
  String toString() {
    return '$id, $firstName, $lastName, $username, $profilePic, $gender, ';
  }
}
