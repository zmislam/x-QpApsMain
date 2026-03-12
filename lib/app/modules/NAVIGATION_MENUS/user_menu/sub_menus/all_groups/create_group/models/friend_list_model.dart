class FriendListModel {
  int? status;
  List<FriendResultModel>? result;
  int? friendCount;
  String? message;

  FriendListModel({
    this.status,
    this.result,
    this.friendCount,
    this.message,
  });

  // fromMap constructor
  factory FriendListModel.fromMap(Map<String, dynamic> map) {
    return FriendListModel(
      status: map['status'],
      result: map['result'] != null
          ? List<FriendResultModel>.from(map['result'].map((x) => FriendResultModel.fromMap(x)))
          : null,
      friendCount: map['friendCount'],
      message: map['message'],
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'result': result != null
          ? List<dynamic>.from(result!.map((x) => x.toMap()))
          : null,
      'friendCount': friendCount,
      'message': message,
    };
  }
}

class FriendResultModel {
  String? id;
  FriendDetails? friend;
  String? fullName;
  String? profilePic;

  FriendResultModel({
    this.id,
    this.friend,
    this.fullName,
    this.profilePic,
  });

  // fromMap constructor
  factory FriendResultModel.fromMap(Map<String, dynamic> map) {
    return FriendResultModel(
      id: map['_id']??'',
      friend: map['friend'] != null ? FriendDetails.fromMap(map['friend']) : null,
      fullName: map['full_name']??'',
      profilePic: map['profile_pic']??'',
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'friend': friend?.toMap(),
      'full_name': fullName,
      'profile_pic': profilePic,
    };
  }
}

class FriendDetails {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? profilePic;

  FriendDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.profilePic,
  });

  // fromMap constructor
  factory FriendDetails.fromMap(Map<String, dynamic> map) {
    return FriendDetails(
      id: map['_id'] ??'',
      firstName: map['first_name']??'',
      lastName: map['last_name']??'',
      username: map['username']??'',
      email: map['email']??'',
      profilePic: map['profile_pic']??'',
    );
  }

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'profile_pic': profilePic,
    };
  }
}
