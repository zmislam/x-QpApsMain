// To parse this JSON data, do
//
//     final helpReplyModel = helpReplyModelFromJson(jsonString);

import 'dart:convert';

HelpReplyModel helpReplyModelFromJson(String str) =>
    HelpReplyModel.fromJson(json.decode(str));

String helpReplyModelToJson(HelpReplyModel data) => json.encode(data.toJson());

class HelpReplyModel {
  String? id;
  String? helpId;
  String? description;
  dynamic administrationId;
  String? userId;
  List<dynamic>? photos;
  String? createdAt;
  String? updatedAt;
  int? v;
  List<Userinfo>? userinfo;

  HelpReplyModel({
    this.id,
    this.helpId,
    this.description,
    this.administrationId,
    this.userId,
    this.photos,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.userinfo,
  });

  HelpReplyModel copyWith({
    String? id,
    String? helpId,
    String? description,
    dynamic administrationId,
    String? userId,
    List<dynamic>? photos,
    String? createdAt,
    String? updatedAt,
    int? v,
    List<Userinfo>? userinfo,
  }) =>
      HelpReplyModel(
        id: id ?? this.id,
        helpId: helpId ?? this.helpId,
        description: description ?? this.description,
        administrationId: administrationId ?? this.administrationId,
        userId: userId ?? this.userId,
        photos: photos ?? this.photos,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        userinfo: userinfo ?? this.userinfo,
      );

  factory HelpReplyModel.fromJson(Map<String, dynamic> json) => HelpReplyModel(
        id: json['_id'],
        helpId: json['help_id'],
        description: json['description'],
        administrationId: json['administration_id'],
        userId: json['user_id'],
        photos: json['photos'] == null
            ? []
            : List<dynamic>.from(json['photos']!.map((x) => x)),
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        v: json['__v'],
        userinfo: json['userinfo'] == null
            ? []
            : List<Userinfo>.from(
                json['userinfo']!.map((x) => Userinfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'help_id': helpId,
        'description': description,
        'administration_id': administrationId,
        'user_id': userId,
        'photos':
            photos == null ? [] : List<dynamic>.from(photos!.map((x) => x)),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'userinfo': userinfo == null
            ? []
            : List<dynamic>.from(userinfo!.map((x) => x.toJson())),
      };
}

class Userinfo {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? profilePic;
  String? coverPic;
  dynamic userStatus;
  String? gender;
  String? religion;
  DateTime? dateOfBirth;
  String? userBio;
  dynamic language;
  dynamic passport;
  String? lastLogin;
  dynamic user2FaStatus;
  dynamic secondaryEmail;
  dynamic recoveryEmail;
  String? relationStatus;
  String? homeTown;
  String? birthPlace;
  dynamic bloodGroup;
  String? resetPasswordToken;
  String? resetPasswordTokenExpires;
  dynamic userRole;
  String? status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? lockProfile;
  List<String>? emailList;
  List<dynamic>? phoneList;
  String? userAbout;
  String? userNickname;
  String? presentTown;
  bool? turnOnEarningDashboard;
  String? dateOfBirthShowType;
  String? emailPrivacy;
  bool? isProfileVerified;
  String? inactivationNote;

  Userinfo({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phone,
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
    this.user2FaStatus,
    this.secondaryEmail,
    this.recoveryEmail,
    this.relationStatus,
    this.homeTown,
    this.birthPlace,
    this.bloodGroup,
    this.resetPasswordToken,
    this.resetPasswordTokenExpires,
    this.userRole,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lockProfile,
    this.emailList,
    this.phoneList,
    this.userAbout,
    this.userNickname,
    this.presentTown,
    this.turnOnEarningDashboard,
    this.dateOfBirthShowType,
    this.emailPrivacy,
    this.isProfileVerified,
    this.inactivationNote,
  });

  Userinfo copyWith({
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
  }) =>
      Userinfo(
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

  factory Userinfo.fromJson(Map<String, dynamic> json) => Userinfo(
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
        dateOfBirth: json['date_of_birth'] == null
            ? null
            : DateTime.parse(json['date_of_birth']),
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
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
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

  Map<String, dynamic> toJson() => {
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
        'email_list': emailList == null
            ? []
            : List<dynamic>.from(emailList!.map((x) => x)),
        'phone_list': phoneList == null
            ? []
            : List<dynamic>.from(phoneList!.map((x) => x)),
        'user_about': userAbout,
        'user_nickname': userNickname,
        'present_town': presentTown,
        'turn_on_earning_dashboard': turnOnEarningDashboard,
        'date_of_birth_show_type': dateOfBirthShowType,
        'email_privacy': emailPrivacy,
        'isProfileVerified': isProfileVerified,
        'inactivation_note': inactivationNote,
      };
}
