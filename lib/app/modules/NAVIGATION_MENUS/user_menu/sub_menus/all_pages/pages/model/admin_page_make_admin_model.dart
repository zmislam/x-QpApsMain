class PageMakeAdminModel {
  PageMakeAdminModel({
    this.id,
    this.friend,
    this.fullName,
    this.profilePic,
  });

  String? id;
  Friend? friend;
  String? fullName;
  String? profilePic;

  PageMakeAdminModel copyWith({
    String? id,
    Friend? friend,
    String? fullName,
    String? profilePic,
  }) {
    return PageMakeAdminModel(
      id: id ?? this.id,
      friend: friend ?? this.friend,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  factory PageMakeAdminModel.fromMap(Map<String, dynamic> json) {
    return PageMakeAdminModel(
      id: json['_id'],
      friend: json['friend'] == null ? null : Friend.fromJson(json['friend']),
      fullName: json['full_name'],
      profilePic: json['profile_pic'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'friend': friend?.toJson(),
        'full_name': fullName,
        'profile_pic': profilePic,
      };

  @override
  String toString() {
    return '$id, $friend, $fullName, $profilePic, ';
  }
}

class Friend {
  Friend({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.profilePic,
  });

  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? profilePic;

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
    return '$id, $firstName, $lastName, $username, $email, $profilePic, ';
  }
}
