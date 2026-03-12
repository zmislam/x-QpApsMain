class FriendListModel {
  int? status;
  String? message;
  List<FriendListResult>? results;
  int? friendCount;

  FriendListModel({
    this.status,
    this.message,
    this.results,
    this.friendCount,
  });

  factory FriendListModel.fromMap(Map<String, dynamic> json) {
    return FriendListModel(
      status: json['status'],
      message: json['message'],
      results: json['results'] != null
          ? (json['results'] as List)
              .map((v) => FriendListResult.fromMap(v))
              .toList()
          : null,
      friendCount: json['friendCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'results': results?.map((v) => v.toJson()).toList(),
        'friendCount': friendCount,
      };

  @override
  String toString() {
    return 'FriendListModel(status: $status, message: $message, results: $results, friendCount: $friendCount)';
  }
}

class FriendListResult {
  String? id;
  FriendListUserId? userId;
  FriendListUserId? connectedUserId;
  String? relationType;
  String? acceptRejectStatus;
  int? dataStatus;
  String? ipAddress;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? version;

  FriendListResult({
    this.id,
    this.userId,
    this.connectedUserId,
    this.relationType,
    this.acceptRejectStatus,
    this.dataStatus,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory FriendListResult.fromMap(Map<String, dynamic> json) {
    return FriendListResult(
      id: json['_id'],
      userId: json['user_id'] != null ? FriendListUserId.fromMap(json['user_id']) : null,
      connectedUserId: json['connected_user_id'] != null
          ? FriendListUserId.fromMap(json['connected_user_id'])
          : null,
      relationType: json['relation_type'],
      acceptRejectStatus: json['accept_reject_status'],
      dataStatus: json['data_status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updatedBy: json['update_by'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      version: json['__v'],
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
        'update_by': updatedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': version,
      };

  @override
  String toString() {
    return 'FriendListResult(id: $id, userId: $userId, connectedUserId: $connectedUserId, relationType: $relationType, acceptRejectStatus: $acceptRejectStatus, dataStatus: $dataStatus, ipAddress: $ipAddress, createdBy: $createdBy, updatedBy: $updatedBy, createdAt: $createdAt, updatedAt: $updatedAt, version: $version)';
  }
}

class FriendListUserId {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? profilePic;
  String? gender;

  FriendListUserId({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
    this.gender,
  });

  factory FriendListUserId.fromMap(Map<String, dynamic> json) {
    return FriendListUserId(
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
    return 'FriendListUserId(id: $id, firstName: $firstName, lastName: $lastName, username: $username, profilePic: $profilePic, gender: $gender)';
  }
}
