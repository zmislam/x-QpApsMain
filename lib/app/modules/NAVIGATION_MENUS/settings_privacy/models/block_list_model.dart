class Blocklist {
  String? id;
  String? blockedFrom;
  BlockedTo? blockedTo;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  Blocklist({
    this.id,
    this.blockedFrom,
    this.blockedTo,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Blocklist.fromMap(Map<String, dynamic> map) {
    return Blocklist(
      id: map['_id'] as String?,
      blockedFrom: map['blocked_from'] as String?,
      blockedTo: map['blocked_to'] != null
          ? BlockedTo.fromMap(map['blocked_to'])
          : null,
      createdBy: map['created_by'] as String?,
      updatedBy: map['update_by'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] is int ? map['__v'] as int : int.tryParse(map['__v'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'blocked_from': blockedFrom,
      'blocked_to': blockedTo?.toMap(),
      'created_by': createdBy,
      'update_by': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class BlockedTo {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? emailPrivacy;
  String? dateOfBirthShowType;
  String? country;
  bool? isProfileVerified;
  String? otp;
  bool? turnOnEarningDashboard;
  String? inactivationNote;
  String? phone;
  List<String>? phoneList;
  String? password;
  String? profilePic;
  String? coverPic;
  String? userStatus;
  String? gender;
  String? religion;
  String? dateOfBirth;
  String? userBio;
  List<String>? language;
  String? passport;
  String? lastLogin;
  bool? user2faStatus;
  String? secondaryEmail;
  String? recoveryEmail;
  String? relationStatus;
  String? homeTown;
  String? birthPlace;
  String? bloodGroup;
  String? resetPasswordToken;
  String? websites;
  String? userNickname;
  String? userAbout;
  String? presentTown;
  String? resetPasswordTokenExpires;
  String? userRole;
  String? lockProfile;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  bool? trustedSeller;

  BlockedTo({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.emailPrivacy,
    this.dateOfBirthShowType,
    this.country,
    this.isProfileVerified,
    this.otp,
    this.turnOnEarningDashboard,
    this.inactivationNote,
    this.phone,
    this.phoneList,
    this.password,
    this.profilePic,
    this.coverPic,
    this.userStatus,
    this.gender,
    this.religion,
    this.dateOfBirth,
    this.userBio,
    this.language,
    this.passport,
    this.lastLogin,
    this.user2faStatus,
    this.secondaryEmail,
    this.recoveryEmail,
    this.relationStatus,
    this.homeTown,
    this.birthPlace,
    this.bloodGroup,
    this.resetPasswordToken,
    this.websites,
    this.userNickname,
    this.userAbout,
    this.presentTown,
    this.resetPasswordTokenExpires,
    this.userRole,
    this.lockProfile,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.trustedSeller,
  });

  factory BlockedTo.fromMap(Map<String, dynamic> map) {
    return BlockedTo(
      id: _castToString(map['_id']),
      firstName: _castToString(map['first_name']),
      lastName: _castToString(map['last_name']),
      username: _castToString(map['username']),
      email: _castToString(map['email']),
      emailPrivacy: _castToString(map['email_privacy']),
      dateOfBirthShowType: _castToString(map['date_of_birth_show_type']),
      country: _castToString(map['country']),
      isProfileVerified: map['isProfileVerified'] as bool?,
      otp: _castToString(map['otp']),
      turnOnEarningDashboard: map['turn_on_earning_dashboard'] as bool?,
      inactivationNote: _castToString(map['inactivation_note']),
      phone: _castToString(map['phone']),
      phoneList: map['phone_list'] != null
          ? List<String>.from(map['phone_list'])
          : null,
      password: _castToString(map['password']),
      profilePic: _castToString(map['profile_pic']),
      coverPic: _castToString(map['cover_pic']),
      userStatus: _castToString(map['user_status']),
      gender: _castToString(map['gender']),
      religion: _castToString(map['religion']),
      dateOfBirth: _castToString(map['date_of_birth']),
      userBio: _castToString(map['user_bio']),
      language: map['language'] != null
          ? List<String>.from(map['language'])
          : null,
      passport: _castToString(map['passport']),
      lastLogin: _castToString(map['last_login']),
      user2faStatus: map['user_2fa_status'] as bool?,
      secondaryEmail: _castToString(map['secondary_email']),
      recoveryEmail: _castToString(map['recovery_email']),
      relationStatus: _castToString(map['relation_status']),
      homeTown: _castToString(map['home_town']),
      birthPlace: _castToString(map['birth_place']),
      bloodGroup: _castToString(map['blood_group']),
      resetPasswordToken: _castToString(map['reset_password_token']),
      websites: _castToString(map['websites']),
      userNickname: _castToString(map['user_nickname']),
      userAbout: _castToString(map['user_about']),
      presentTown: _castToString(map['present_town']),
      resetPasswordTokenExpires: _castToString(map['reset_password_token_expires']),
      userRole: _castToString(map['user_role']),
      lockProfile: map['lock_profile'] as String?,
      status: _castToString(map['status']),
      ipAddress: _castToString(map['ip_address']),
      createdBy: _castToString(map['created_by']),
      updatedBy: _castToString(map['update_by']),
      createdAt: _castToString(map['createdAt']),
      updatedAt: _castToString(map['updatedAt']),
      v: map['__v'] is int ? map['__v'] as int : int.tryParse(map['__v'].toString()) ?? 0,
      trustedSeller: map['trusted_seller'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'email_privacy': emailPrivacy,
      'date_of_birth_show_type': dateOfBirthShowType,
      'country': country,
      'isProfileVerified': isProfileVerified,
      'otp': otp,
      'turn_on_earning_dashboard': turnOnEarningDashboard,
      'inactivation_note': inactivationNote,
      'phone': phone,
      'phone_list': phoneList,
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
      'user_2fa_status': user2faStatus,
      'secondary_email': secondaryEmail,
      'recovery_email': recoveryEmail,
      'relation_status': relationStatus,
      'home_town': homeTown,
      'birth_place': birthPlace,
      'blood_group': bloodGroup,
      'reset_password_token': resetPasswordToken,
      'websites': websites,
      'user_nickname': userNickname,
      'user_about': userAbout,
      'present_town': presentTown,
      'reset_password_token_expires': resetPasswordTokenExpires,
      'user_role': userRole,
      'lock_profile': lockProfile,
      'status': status,
      'ip_address': ipAddress,
      'created_by': createdBy,
      'update_by': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'trusted_seller': trustedSeller,
    };
  }

  // Helper function to safely cast a value to a String
  static String? _castToString(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }
}
