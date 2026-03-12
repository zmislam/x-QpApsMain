class FollowingUserModel {
  String? id;
  String? userId;
  FollowerUserId? followerUserId;
  String? followUnfollowStatus;
  int? dataStatus;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int v;

  FollowingUserModel({
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
  });

  FollowingUserModel copyWith({
    String? id,
    String? userId,
    FollowerUserId? followerUserId,
    String? followUnfollowStatus,
    int? dataStatus,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      FollowingUserModel(
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
      );

  factory FollowingUserModel.fromJson(Map<String, dynamic> json) =>
      FollowingUserModel(
        id: json['_id'],
        userId: json['user_id'],
        followerUserId: FollowerUserId.fromJson(json['follower_user_id']),
        followUnfollowStatus: json['follow_unfollow_status'],
        dataStatus: json['data_status'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updateBy: json['update_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
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
      };
}

class FollowerUserId {
  dynamic websites;
  dynamic userNickname;
  dynamic userAbout;
  dynamic presentTown;
  bool? turnOnEarningDashboard;
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? profilePic;
  dynamic coverPic;
  dynamic userStatus;
  String? gender;
  dynamic religion;
  DateTime? dateOfBirth;
  dynamic userBio;
  dynamic language;
  dynamic passport;
  dynamic lastLogin;
  dynamic user2FaStatus;
  dynamic secondaryEmail;
  dynamic recoveryEmail;
  dynamic relationStatus;
  dynamic homeTown;
  dynamic birthPlace;
  dynamic bloodGroup;
  dynamic resetPasswordToken;
  dynamic resetPasswordTokenExpires;
  dynamic userRole;
  dynamic lockProfile;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int v;

  FollowerUserId({
    required this.websites,
    required this.userNickname,
    required this.userAbout,
    required this.presentTown,
    required this.turnOnEarningDashboard,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePic,
    required this.coverPic,
    required this.userStatus,
    required this.gender,
    required this.religion,
    required this.dateOfBirth,
    required this.userBio,
    required this.language,
    required this.passport,
    required this.lastLogin,
    required this.user2FaStatus,
    required this.secondaryEmail,
    required this.recoveryEmail,
    required this.relationStatus,
    required this.homeTown,
    required this.birthPlace,
    required this.bloodGroup,
    required this.resetPasswordToken,
    required this.resetPasswordTokenExpires,
    required this.userRole,
    required this.lockProfile,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  FollowerUserId copyWith({
    dynamic websites,
    dynamic userNickname,
    dynamic userAbout,
    dynamic presentTown,
    bool? turnOnEarningDashboard,
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profilePic,
    dynamic coverPic,
    dynamic userStatus,
    String? gender,
    dynamic religion,
    DateTime? dateOfBirth,
    dynamic userBio,
    dynamic language,
    dynamic passport,
    dynamic lastLogin,
    dynamic user2FaStatus,
    dynamic secondaryEmail,
    dynamic recoveryEmail,
    dynamic relationStatus,
    dynamic homeTown,
    dynamic birthPlace,
    dynamic bloodGroup,
    dynamic resetPasswordToken,
    dynamic resetPasswordTokenExpires,
    dynamic userRole,
    dynamic lockProfile,
    dynamic status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      FollowerUserId(
        websites: websites ?? this.websites,
        userNickname: userNickname ?? this.userNickname,
        userAbout: userAbout ?? this.userAbout,
        presentTown: presentTown ?? this.presentTown,
        turnOnEarningDashboard:
            turnOnEarningDashboard ?? this.turnOnEarningDashboard,
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        profilePic: profilePic ?? this.profilePic,
        coverPic: coverPic ?? this.coverPic,
        userStatus: userStatus ?? this.userStatus,
        gender: gender ?? this.gender,
        religion: religion ?? this.religion,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        userBio: userBio ?? this.userBio,
        language: language ?? this.language,
        passport: passport ?? this.passport,
        lastLogin: lastLogin ?? this.lastLogin,
        user2FaStatus: user2FaStatus ?? this.user2FaStatus,
        secondaryEmail: secondaryEmail ?? this.secondaryEmail,
        recoveryEmail: recoveryEmail ?? this.recoveryEmail,
        relationStatus: relationStatus ?? this.relationStatus,
        homeTown: homeTown ?? this.homeTown,
        birthPlace: birthPlace ?? this.birthPlace,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
        resetPasswordTokenExpires:
            resetPasswordTokenExpires ?? this.resetPasswordTokenExpires,
        userRole: userRole ?? this.userRole,
        lockProfile: lockProfile ?? this.lockProfile,
        status: status ?? this.status,
        ipAddress: ipAddress ?? this.ipAddress,
        createdBy: createdBy ?? this.createdBy,
        updateBy: updateBy ?? this.updateBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory FollowerUserId.fromJson(Map<String, dynamic> json) => FollowerUserId(
        websites: json['websites'],
        userNickname: json['user_nickname'],
        userAbout: json['user_about'],
        presentTown: json['present_town'],
        turnOnEarningDashboard: json['turn_on_earning_dashboard'],
        id: json['_id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        username: json['username'],
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
        profilePic: json['profile_pic'],
        coverPic: json['cover_pic'],
        userStatus: json['user_status'],
        gender: json['gender'],
        religion: json['religion'],
        dateOfBirth: DateTime.parse(json['date_of_birth']),
        userBio: json['user_bio'],
        language: json['language'],
        passport: json['passport'],
        lastLogin: json['last_login'],
        user2FaStatus: json['user_2fa_status'],
        secondaryEmail: json['secondary_email'],
        recoveryEmail: json['recovery_email'],
        relationStatus: json['relation_status'],
        homeTown: json['home_town'],
        birthPlace: json['birth_place'],
        bloodGroup: json['blood_group'],
        resetPasswordToken: json['reset_password_token'],
        resetPasswordTokenExpires: json['reset_password_token_expires'],
        userRole: json['user_role'],
        lockProfile: json['lock_profile'],
        status: json['status'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updateBy: json['update_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        'websites': websites,
        'user_nickname': userNickname,
        'user_about': userAbout,
        'present_town': presentTown,
        'turn_on_earning_dashboard': turnOnEarningDashboard,
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'profile_pic': profilePic,
        'cover_pic': coverPic,
        'user_status': userStatus,
        'gender': gender,
        'religion': religion,
        'date_of_birth': dateOfBirth,
        'user_bio': userBio,
        'language': language,
        'passport': passport,
        'last_login': lastLogin,
        'user_2fa_status': user2FaStatus,
        'secondary_email': secondaryEmail,
        'recovery_email': recoveryEmail,
        'relation_status': relationStatus,
        'home_town': homeTown,
        'birth_place': birthPlace,
        'blood_group': bloodGroup,
        'reset_password_token': resetPasswordToken,
        'reset_password_token_expires': resetPasswordTokenExpires,
        'user_role': userRole,
        'lock_profile': lockProfile,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}
