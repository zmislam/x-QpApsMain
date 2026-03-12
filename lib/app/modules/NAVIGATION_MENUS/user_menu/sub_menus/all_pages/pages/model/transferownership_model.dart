class TransferOwnershipModel {
  TransferOwnershipModel({
    required this.id,
    required this.friend,
    required this.fullName,
    required this.profilePic,
  });

  final String? id;
  final Friend? friend;
  final String? fullName;
  final String? profilePic;

  TransferOwnershipModel copyWith({
    String? id,
    Friend? friend,
    String? fullName,
    String? profilePic,
  }) {
    return TransferOwnershipModel(
      id: id ?? this.id,
      friend: friend ?? this.friend,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  factory TransferOwnershipModel.fromMap(Map<String, dynamic> json) {
    return TransferOwnershipModel(
      id: json['_id'],
      friend: json['friend'] == null ? null : Friend.fromJson(json['friend']),
      fullName: json['full_name'],
      profilePic: json['profile_pic'],
    );
  }

  @override
  String toString() {
    return '$id, $friend, $fullName, $profilePic, ';
  }
}

class Friend {
  Friend({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.profilePic,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? profilePic;

  Friend copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? profilePic,
  }) {
    return Friend(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      profilePic: json['profile_pic'],
    );
  }

  @override
  String toString() {
    return '$id, $firstName, $lastName, $username, $email, $profilePic, ';
  }
}
