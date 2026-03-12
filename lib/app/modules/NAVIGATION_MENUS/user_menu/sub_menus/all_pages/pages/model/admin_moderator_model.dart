class AdminModeratorModel {
  AdminModeratorModel({
    required this.id,
    required this.pageId,
    required this.userId,
    required this.userRole,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? pageId;
  final UserId? userId;
  final String? userRole;
  final dynamic ipAddress;
  final String? createdBy;
  final dynamic updateBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  AdminModeratorModel copyWith({
    String? id,
    String? pageId,
    UserId? userId,
    String? userRole,
    dynamic ipAddress,
    String? createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return AdminModeratorModel(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory AdminModeratorModel.fromMap(Map<String, dynamic> json) {
    return AdminModeratorModel(
      id: json['_id'],
      pageId: json['page_id'],
      userId: json['user_id'] == null ? null : UserId.fromMap(json['user_id']),
      userRole: json['user_role'],
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
        'page_id': pageId,
        'user_id': userId?.toJson(),
        'user_role': userRole,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  @override
  String toString() {
    return '$id, $pageId, $userId, $userRole, $ipAddress, $createdBy, $updateBy, $createdAt, $updatedAt, $v, ';
  }
}

class UserId {
  UserId({
    required this.country,
    required this.websites,
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
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.lockProfile,
    required this.emailList,
    required this.phoneList,
    required this.userAbout,
    required this.userNickname,
    required this.presentTown,
    required this.turnOnEarningDashboard,
    required this.dateOfBirthShowType,
    required this.emailPrivacy,
    required this.isProfileVerified,
    required this.inactivationNote,
  });

  final dynamic country;
  final dynamic websites;
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? phone;
  final String? password;
  final String? profilePic;
  final String? coverPic;
  final dynamic userStatus;
  final String? gender;
  final String? religion;
  final DateTime? dateOfBirth;
  final String? userBio;
  final dynamic language;
  final dynamic passport;
  final String? lastLogin;
  final dynamic user2FaStatus;
  final dynamic secondaryEmail;
  final dynamic recoveryEmail;
  final String? relationStatus;
  final String? homeTown;
  final String? birthPlace;
  final dynamic bloodGroup;
  final String? resetPasswordToken;
  final String? resetPasswordTokenExpires;
  final dynamic userRole;
  final String? status;
  final dynamic ipAddress;
  final dynamic createdBy;
  final dynamic updateBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? lockProfile;
  final List<String> emailList;
  final List<dynamic> phoneList;
  final String? userAbout;
  final String? userNickname;
  final String? presentTown;
  final bool? turnOnEarningDashboard;
  final String? dateOfBirthShowType;
  final String? emailPrivacy;
  final bool? isProfileVerified;
  final String? inactivationNote;

  UserId copyWith({
    dynamic country,
    dynamic websites,
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profilePic,
    String? coverPic,
    dynamic userStatus,
    String? gender,
    String? religion,
    DateTime? dateOfBirth,
    String? userBio,
    dynamic language,
    dynamic passport,
    String? lastLogin,
    dynamic user2FaStatus,
    dynamic secondaryEmail,
    dynamic recoveryEmail,
    String? relationStatus,
    String? homeTown,
    String? birthPlace,
    dynamic bloodGroup,
    String? resetPasswordToken,
    String? resetPasswordTokenExpires,
    dynamic userRole,
    String? status,
    dynamic ipAddress,
    dynamic createdBy,
    dynamic updateBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? lockProfile,
    List<String>? emailList,
    List<dynamic>? phoneList,
    String? userAbout,
    String? userNickname,
    String? presentTown,
    bool? turnOnEarningDashboard,
    String? dateOfBirthShowType,
    String? emailPrivacy,
    bool? isProfileVerified,
    String? inactivationNote,
  }) {
    return UserId(
      country: country ?? this.country,
      websites: websites ?? this.websites,
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
      status: status ?? this.status,
      ipAddress: ipAddress ?? this.ipAddress,
      createdBy: createdBy ?? this.createdBy,
      updateBy: updateBy ?? this.updateBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      lockProfile: lockProfile ?? this.lockProfile,
      emailList: emailList ?? this.emailList,
      phoneList: phoneList ?? this.phoneList,
      userAbout: userAbout ?? this.userAbout,
      userNickname: userNickname ?? this.userNickname,
      presentTown: presentTown ?? this.presentTown,
      turnOnEarningDashboard:
          turnOnEarningDashboard ?? this.turnOnEarningDashboard,
      dateOfBirthShowType: dateOfBirthShowType ?? this.dateOfBirthShowType,
      emailPrivacy: emailPrivacy ?? this.emailPrivacy,
      isProfileVerified: isProfileVerified ?? this.isProfileVerified,
      inactivationNote: inactivationNote ?? this.inactivationNote,
    );
  }

  factory UserId.fromMap(Map<String, dynamic> json) {
    return UserId(
      country: json['country'],
      websites: json['websites'],
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
      dateOfBirth: DateTime.tryParse(json['date_of_birth'] ?? ''),
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
      status: json['status'],
      ipAddress: json['ip_address'],
      createdBy: json['created_by'],
      updateBy: json['update_by'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: json['__v'],
      lockProfile: json['lock_profile'],
      emailList: json['email_list'] == null
          ? []
          : List<String>.from(json['email_list']!.map((x) => x)),
      phoneList: json['phone_list'] == null
          ? []
          : List<dynamic>.from(json['phone_list']!.map((x) => x)),
      userAbout: json['user_about'],
      userNickname: json['user_nickname'],
      presentTown: json['present_town'],
      turnOnEarningDashboard: json['turn_on_earning_dashboard'],
      dateOfBirthShowType: json['date_of_birth_show_type'],
      emailPrivacy: json['email_privacy'],
      isProfileVerified: json['isProfileVerified'],
      inactivationNote: json['inactivation_note'],
    );
  }

  Map<String, dynamic> toJson() => {
        'country': country,
        'websites': websites,
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
        'date_of_birth': dateOfBirth?.toIso8601String(),
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
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'lock_profile': lockProfile,
        'email_list': emailList.map((x) => x).toList(),
        'phone_list': phoneList.map((x) => x).toList(),
        'user_about': userAbout,
        'user_nickname': userNickname,
        'present_town': presentTown,
        'turn_on_earning_dashboard': turnOnEarningDashboard,
        'date_of_birth_show_type': dateOfBirthShowType,
        'email_privacy': emailPrivacy,
        'isProfileVerified': isProfileVerified,
        'inactivation_note': inactivationNote,
      };

  @override
  String toString() {
    return '$country, $websites, $id, $firstName, $lastName, $username, $email, $phone, $password, $profilePic, $coverPic, $userStatus, $gender, $religion, $dateOfBirth, $userBio, $language, $passport, $lastLogin, $user2FaStatus, $secondaryEmail, $recoveryEmail, $relationStatus, $homeTown, $birthPlace, $bloodGroup, $resetPasswordToken, $resetPasswordTokenExpires, $userRole, $status, $ipAddress, $createdBy, $updateBy, $createdAt, $updatedAt, $v, $lockProfile, $emailList, $phoneList, $userAbout, $userNickname, $presentTown, $turnOnEarningDashboard, $dateOfBirthShowType, $emailPrivacy, $isProfileVerified, $inactivationNote, ';
  }
}
