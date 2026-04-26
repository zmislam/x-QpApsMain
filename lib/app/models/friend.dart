import 'dart:convert';

FriendModel friendModelFromJson(String str) =>
    FriendModel.fromJson(json.decode(str));

String friendModelToJson(FriendModel data) => json.encode(data.toJson());

class FriendModel {
  String? id;
  Friend? friend;
  String? fullName;
  String? profilePic;

  FriendModel({
    required this.id,
    required this.friend,
    required this.fullName,
    required this.profilePic,
  });

  FriendModel copyWith({
    String? id,
    Friend? friend,
    String? fullName,
    String? profilePic,
  }) =>
      FriendModel(
        id: id ?? this.id,
        friend: friend ?? this.friend,
        fullName: fullName ?? this.fullName,
        profilePic: profilePic ?? this.profilePic,
      );

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    final rawFriend = json['friend'];
    final Map<String, dynamic>? friendJson =
        rawFriend is Map ? Map<String, dynamic>.from(rawFriend) : null;

    return FriendModel(
      id: json['_id']?.toString(),
      friend: friendJson != null ? Friend.fromJson(friendJson) : null,
      fullName: json['full_name']?.toString(),
      profilePic: json['profile_pic']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'friend': friend,
        'full_name': fullName,
        'profile_pic': profilePic,
      };

  @override
  String toString() {
    return fullName??'';
  }

  @override
  int get hashCode {
    return id.hashCode ^
        friend.hashCode ^
        fullName.hashCode ^
        profilePic.hashCode;
  }

  @override
  bool operator ==(covariant FriendModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.friend == friend &&
        other.fullName == fullName &&
        other.profilePic == profilePic;
  }
}

class Friend {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? profilePic;

  Friend({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.profilePic,
  });

  Friend copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? profilePic,
  }) =>
      Friend(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        profilePic: profilePic ?? this.profilePic,
      );

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        id: json['_id']?.toString(),
        firstName: json['first_name']?.toString(),
        lastName: json['last_name']?.toString(),
        username: json['username']?.toString(),
        email: json['email']?.toString(),
        profilePic: json['profile_pic']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'profile_pic': profilePic,
      };

  @override
  String toString() {
    return 'Friend(id: $id, first_name: $firstName, last_name: $lastName, username: $username, email: $email, profile_pic: $profilePic)';
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        username.hashCode ^
        email.hashCode ^
        profilePic.hashCode;
  }

  @override
  bool operator ==(covariant Friend other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.username == username &&
        other.profilePic == profilePic &&
        other.email == email;
  }
}
