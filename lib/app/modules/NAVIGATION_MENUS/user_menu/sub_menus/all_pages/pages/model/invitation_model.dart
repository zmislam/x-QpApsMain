class PageInvitationModel {
  PageInvitationModel({
    this.id,
    this.friend,
    this.fullName,
    this.profilePic,
  });

  String? id;
  Friend? friend;
  String? fullName;
  String? profilePic;

  factory PageInvitationModel.fromMap(Map<String, dynamic> json) {
    return PageInvitationModel(
      id: json['_id'],
      friend: json['friend'] == null ? null : Friend.fromJson(json['friend']),
      fullName: json['full_name'],
      profilePic: json['profile_pic'],
    );
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
}
