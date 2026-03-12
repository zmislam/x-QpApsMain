// To parse this JSON data, do
//
//     final profileUserData = profileUserDataFromJson(jsonString);

import 'dart:convert';

ProfileUserData profileUserDataFromJson(String str) =>
    ProfileUserData.fromJson(json.decode(str));

String profileUserDataToJson(ProfileUserData data) =>
    json.encode(data.toJson());

class ProfileUserData {
  int? status;
  UserInfo? userInfo;

  ProfileUserData({
    this.status,
    this.userInfo,
  });

  factory ProfileUserData.fromJson(Map<String, dynamic> json) =>
      ProfileUserData(
        status: json['status'],
        userInfo: UserInfo.fromJson(json['userInfo']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'userInfo': userInfo?.toJson(),
      };
}

class UserInfo {
  String id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phone;
  String password;
  String profilePic;
  String coverPic;
  dynamic userStatus;
  Gender gender;
  String religion;
  DateTime dateOfBirth;
  String userBio;
  dynamic language;
  dynamic passport;
  String lastLogin;
  dynamic user2FaStatus;
  dynamic secondaryEmail;
  dynamic recoveryEmail;
  dynamic relationStatus;
  String homeTown;
  String birthPlace;
  dynamic bloodGroup;
  String resetPasswordToken;
  String resetPasswordTokenExpires;
  dynamic userRole;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String lockProfile;
  List<dynamic> emailList;
  List<String> phoneList;
  String userAbout;
  String userNickname;
  List<dynamic> websites;
  List<EducationWorkplace> educationWorkplaces;
  List<UserWorkplace> userWorkplaces;
  String fullName;
  int postsCount;
  int followersCount;
  int followingCount;
  Privacy privacy;

  UserInfo({
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
    required this.websites,
    required this.educationWorkplaces,
    required this.userWorkplaces,
    required this.fullName,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.privacy,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
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
        gender: Gender.fromJson(json['gender']),
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
        status: json['status'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updateBy: json['update_by'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        lockProfile: json['lock_profile'],
        emailList: List<dynamic>.from(json['email_list'].map((x) => x)),
        phoneList: List<String>.from(json['phone_list'].map((x) => x)),
        userAbout: json['user_about'],
        userNickname: json['user_nickname'],
        websites: List<dynamic>.from(json['websites'].map((x) => x)),
        educationWorkplaces: List<EducationWorkplace>.from(
            json['educationWorkplaces']
                .map((x) => EducationWorkplace.fromJson(x))),
        userWorkplaces: List<UserWorkplace>.from(
            json['userWorkplaces'].map((x) => UserWorkplace.fromJson(x))),
        fullName: json['fullName'],
        postsCount: json['postsCount'],
        followersCount: json['followersCount'],
        followingCount: json['followingCount'],
        privacy: Privacy.fromJson(json['privacy']),
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
        'gender': gender.toJson(),
        'religion': religion,
        'date_of_birth': dateOfBirth.toIso8601String(),
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
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
        'lock_profile': lockProfile,
        'email_list': List<dynamic>.from(emailList.map((x) => x)),
        'phone_list': List<dynamic>.from(phoneList.map((x) => x)),
        'user_about': userAbout,
        'user_nickname': userNickname,
        'websites': List<dynamic>.from(websites.map((x) => x)),
        'educationWorkplaces':
            List<dynamic>.from(educationWorkplaces.map((x) => x.toJson())),
        'userWorkplaces':
            List<dynamic>.from(userWorkplaces.map((x) => x.toJson())),
        'fullName': fullName,
        'postsCount': postsCount,
        'followersCount': followersCount,
        'followingCount': followingCount,
        'privacy': privacy.toJson(),
      };
}

class EducationWorkplace {
  String id;
  String userId;
  String username;
  String designation;
  dynamic instituteTypeId;
  dynamic instituteId;
  String instituteName;
  bool isStudying;
  DateTime startDate;
  dynamic endDate;
  dynamic description;
  String privacy;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  EducationWorkplace({
    required this.id,
    required this.userId,
    required this.username,
    required this.designation,
    required this.instituteTypeId,
    required this.instituteId,
    required this.instituteName,
    required this.isStudying,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.privacy,
    required this.status,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory EducationWorkplace.fromJson(Map<String, dynamic> json) =>
      EducationWorkplace(
        id: json['_id'],
        userId: json['user_id'],
        username: json['username'],
        designation: json['designation'],
        instituteTypeId: json['institute_type_id'],
        instituteId: json['institute_id'],
        instituteName: json['institute_name'],
        isStudying: json['is_studying'],
        startDate: DateTime.parse(json['startDate']),
        endDate: json['endDate'],
        description: json['description'],
        privacy: json['privacy'],
        status: json['status'],
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
        'username': username,
        'designation': designation,
        'institute_type_id': instituteTypeId,
        'institute_id': instituteId,
        'institute_name': instituteName,
        'is_studying': isStudying,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate,
        'description': description,
        'privacy': privacy,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}

class Gender {
  String id;
  String genderName;
  dynamic dataStatus;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Gender({
    required this.id,
    required this.genderName,
    required this.dataStatus,
    required this.ipAddress,
    required this.createdBy,
    required this.updateBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
        id: json['_id'],
        genderName: json['gender_name'],
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
        'gender_name': genderName,
        'data_status': dataStatus,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
      };
}

class Privacy {
  String gender;
  String about;
  String nickname;

  Privacy({
    required this.gender,
    required this.about,
    required this.nickname,
  });

  factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
        gender: json['gender'],
        about: json['about'],
        nickname: json['nickname'],
      );

  Map<String, dynamic> toJson() => {
        'gender': gender,
        'about': about,
        'nickname': nickname,
      };
}

class UserWorkplace {
  String id;
  String orgId;
  String userId;
  int v;
  DateTime createdAt;
  dynamic createdBy;
  String designation;
  DateTime fromDate;
  bool isWorking;
  String orgName;
  String privacy;
  dynamic status;
  DateTime toDate;
  dynamic updateBy;
  DateTime updatedAt;
  String username;

  UserWorkplace({
    required this.id,
    required this.orgId,
    required this.userId,
    required this.v,
    required this.createdAt,
    required this.createdBy,
    required this.designation,
    required this.fromDate,
    required this.isWorking,
    required this.orgName,
    required this.privacy,
    required this.status,
    required this.toDate,
    required this.updateBy,
    required this.updatedAt,
    required this.username,
  });

  factory UserWorkplace.fromJson(Map<String, dynamic> json) => UserWorkplace(
        id: json['_id'],
        orgId: json['org_id'],
        userId: json['user_id'],
        v: json['__v'],
        createdAt: DateTime.parse(json['createdAt']),
        createdBy: json['created_by'],
        designation: json['designation'],
        fromDate: DateTime.parse(json['from_date']),
        isWorking: json['is_working'],
        orgName: json['org_name'],
        privacy: json['privacy'],
        status: json['status'],
        toDate: DateTime.parse(json['to_date']),
        updateBy: json['update_by'],
        updatedAt: DateTime.parse(json['updatedAt']),
        username: json['username'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'org_id': orgId,
        'user_id': userId,
        '__v': v,
        'createdAt': createdAt.toIso8601String(),
        'created_by': createdBy,
        'designation': designation,
        'from_date': fromDate.toIso8601String(),
        'is_working': isWorking,
        'org_name': orgName,
        'privacy': privacy,
        'status': status,
        'to_date': toDate.toIso8601String(),
        'update_by': updateBy,
        'updatedAt': updatedAt.toIso8601String(),
        'username': username,
      };
}




// To parse this JSON data, do
//
//     final profileUserData = profileUserDataFromJson(jsonString);

// import 'dart:convert';
//
// ProfileUserData profileUserDataFromJson(String str) => ProfileUserData.fromJson(json.decode(str));
//
// String profileUserDataToJson(ProfileUserData data) => json.encode(data.toJson());
//
// class ProfileUserData {
//   int? status;
//   UserInfo? userInfo;
//
//   ProfileUserData({
//      this.status,
//      this.userInfo,
//   });
//
//   factory ProfileUserData.fromJson(Map<String, dynamic> json) => ProfileUserData(
//     status: json["status"],
//     userInfo: UserInfo.fromJson(json["userInfo"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "userInfo": userInfo?.toJson(),
//   };
// }
//
// class UserInfo {
//   String id;
//   String firstName;
//   String lastName;
//   String username;
//   String email;
//   String phone;
//   String password;
//   String profilePic;
//   String coverPic;
//   dynamic userStatus;
//   Gender gender;
//   dynamic religion;
//   DateTime dateOfBirth;
//   String userBio;
//   List<String> language;
//   dynamic passport;
//   String lastLogin;
//   dynamic user2FaStatus;
//   dynamic secondaryEmail;
//   dynamic recoveryEmail;
//   String relationStatus;
//   String homeTown;
//   dynamic birthPlace;
//   dynamic bloodGroup;
//   String resetPasswordToken;
//   String resetPasswordTokenExpires;
//   dynamic userRole;
//   dynamic lockProfile;
//   dynamic status;
//   dynamic ipAddress;
//   dynamic createdBy;
//   dynamic updateBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//   String presentTown;
//   List<dynamic> phoneList;
//   List<String> emailList;
//   String userAbout;
//   String userNickname;
//   List<Website> websites;
//   List<EducationWorkplace> educationWorkplaces;
//   List<UserWorkplace> userWorkplaces;
//   String fullName;
//   int postsCount;
//   int followersCount;
//   int followingCount;
//   Privacy privacy;
//
//   UserInfo({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.username,
//     required this.email,
//     required this.phone,
//     required this.password,
//     required this.profilePic,
//     required this.coverPic,
//     required this.userStatus,
//     required this.gender,
//     required this.religion,
//     required this.dateOfBirth,
//     required this.userBio,
//     required this.language,
//     required this.passport,
//     required this.lastLogin,
//     required this.user2FaStatus,
//     required this.secondaryEmail,
//     required this.recoveryEmail,
//     required this.relationStatus,
//     required this.homeTown,
//     required this.birthPlace,
//     required this.bloodGroup,
//     required this.resetPasswordToken,
//     required this.resetPasswordTokenExpires,
//     required this.userRole,
//     required this.lockProfile,
//     required this.status,
//     required this.ipAddress,
//     required this.createdBy,
//     required this.updateBy,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.presentTown,
//     required this.phoneList,
//     required this.emailList,
//     required this.userAbout,
//     required this.userNickname,
//     required this.websites,
//     required this.educationWorkplaces,
//     required this.userWorkplaces,
//     required this.fullName,
//     required this.postsCount,
//     required this.followersCount,
//     required this.followingCount,
//     required this.privacy,
//   });
//
//   factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
//     id: json["_id"],
//     firstName: json["first_name"],
//     lastName: json["last_name"],
//     username: json["username"],
//     email: json["email"],
//     phone: json["phone"],
//     password: json["password"],
//     profilePic: json["profile_pic"],
//     coverPic: json["cover_pic"],
//     userStatus: json["user_status"],
//     gender: Gender.fromJson(json["gender"]),
//     religion: json["religion"],
//     dateOfBirth: DateTime.parse(json["date_of_birth"]),
//     userBio: json["user_bio"],
//     language: List<String>.from(json["language"].map((x) => x)),
//     passport: json["passport"],
//     lastLogin: json["last_login"],
//     user2FaStatus: json["user_2fa_status"],
//     secondaryEmail: json["secondary_email"],
//     recoveryEmail: json["recovery_email"],
//     relationStatus: json["relation_status"],
//     homeTown: json["home_town"],
//     birthPlace: json["birth_place"],
//     bloodGroup: json["blood_group"],
//     resetPasswordToken: json["reset_password_token"],
//     resetPasswordTokenExpires: json["reset_password_token_expires"],
//     userRole: json["user_role"],
//     lockProfile: json["lock_profile"],
//     status: json["status"],
//     ipAddress: json["ip_address"],
//     createdBy: json["created_by"],
//     updateBy: json["update_by"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     presentTown: json["present_town"],
//     phoneList: List<dynamic>.from(json["phone_list"].map((x) => x)),
//     emailList: List<String>.from(json["email_list"].map((x) => x)),
//     userAbout: json["user_about"],
//     userNickname: json["user_nickname"],
//     websites: List<Website>.from(json["websites"].map((x) => Website.fromJson(x))),
//     educationWorkplaces: List<EducationWorkplace>.from(json["educationWorkplaces"].map((x) => EducationWorkplace.fromJson(x))),
//     userWorkplaces: List<UserWorkplace>.from(json["userWorkplaces"].map((x) => UserWorkplace.fromJson(x))),
//     fullName: json["fullName"],
//     postsCount: json["postsCount"],
//     followersCount: json["followersCount"],
//     followingCount: json["followingCount"],
//     privacy: Privacy.fromJson(json["privacy"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "first_name": firstName,
//     "last_name": lastName,
//     "username": username,
//     "email": email,
//     "phone": phone,
//     "password": password,
//     "profile_pic": profilePic,
//     "cover_pic": coverPic,
//     "user_status": userStatus,
//     "gender": gender.toJson(),
//     "religion": religion,
//     "date_of_birth": dateOfBirth.toIso8601String(),
//     "user_bio": userBio,
//     "language": List<dynamic>.from(language.map((x) => x)),
//     "passport": passport,
//     "last_login": lastLogin,
//     "user_2fa_status": user2FaStatus,
//     "secondary_email": secondaryEmail,
//     "recovery_email": recoveryEmail,
//     "relation_status": relationStatus,
//     "home_town": homeTown,
//     "birth_place": birthPlace,
//     "blood_group": bloodGroup,
//     "reset_password_token": resetPasswordToken,
//     "reset_password_token_expires": resetPasswordTokenExpires,
//     "user_role": userRole,
//     "lock_profile": lockProfile,
//     "status": status,
//     "ip_address": ipAddress,
//     "created_by": createdBy,
//     "update_by": updateBy,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//     "present_town": presentTown,
//     "phone_list": List<dynamic>.from(phoneList.map((x) => x)),
//     "email_list": List<dynamic>.from(emailList.map((x) => x)),
//     "user_about": userAbout,
//     "user_nickname": userNickname,
//     "websites": List<dynamic>.from(websites.map((x) => x.toJson())),
//     "educationWorkplaces": List<dynamic>.from(educationWorkplaces.map((x) => x.toJson())),
//     "userWorkplaces": List<dynamic>.from(userWorkplaces.map((x) => x.toJson())),
//     "fullName": fullName,
//     "postsCount": postsCount,
//     "followersCount": followersCount,
//     "followingCount": followingCount,
//     "privacy": privacy.toJson(),
//   };
// }
//
// class EducationWorkplace {
//   String id;
//   String userId;
//   String username;
//   dynamic instituteTypeId;
//   dynamic instituteId;
//   String instituteName;
//   bool? isStuyding;
//   DateTime startDate;
//   DateTime? endDate;
//   dynamic description;
//   dynamic status;
//   dynamic ipAddress;
//   dynamic createdBy;
//   dynamic updateBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//   bool? isStudying;
//   String? privacy;
//
//   EducationWorkplace({
//     required this.id,
//     required this.userId,
//     required this.username,
//     required this.instituteTypeId,
//     required this.instituteId,
//     required this.instituteName,
//     this.isStuyding,
//     required this.startDate,
//     required this.endDate,
//     required this.description,
//     required this.status,
//     required this.ipAddress,
//     required this.createdBy,
//     required this.updateBy,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     this.isStudying,
//     this.privacy,
//   });
//
//   factory EducationWorkplace.fromJson(Map<String, dynamic> json) => EducationWorkplace(
//     id: json["_id"],
//     userId: json["user_id"],
//     username: json["username"],
//     instituteTypeId: json["institute_type_id"],
//     instituteId: json["institute_id"],
//     instituteName: json["institute_name"],
//     isStuyding: json["is_Stuyding"],
//     startDate: DateTime.parse(json["startDate"]),
//     endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
//     description: json["description"],
//     status: json["status"],
//     ipAddress: json["ip_address"],
//     createdBy: json["created_by"],
//     updateBy: json["update_by"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     isStudying: json["is_studying"],
//     privacy: json["privacy"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "user_id": userId,
//     "username": username,
//     "institute_type_id": instituteTypeId,
//     "institute_id": instituteId,
//     "institute_name": instituteName,
//     "is_Stuyding": isStuyding,
//     "startDate": startDate.toIso8601String(),
//     "endDate": endDate?.toIso8601String(),
//     "description": description,
//     "status": status,
//     "ip_address": ipAddress,
//     "created_by": createdBy,
//     "update_by": updateBy,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//     "is_studying": isStudying,
//     "privacy": privacy,
//   };
// }
//
// class Gender {
//   String id;
//   String genderName;
//   String dataStatus;
//   String ipAddress;
//   String createdBy;
//   String updateBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//
//   Gender({
//     required this.id,
//     required this.genderName,
//     required this.dataStatus,
//     required this.ipAddress,
//     required this.createdBy,
//     required this.updateBy,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory Gender.fromJson(Map<String, dynamic> json) => Gender(
//     id: json["_id"],
//     genderName: json["gender_name"],
//     dataStatus: json["data_status"],
//     ipAddress: json["ip_address"],
//     createdBy: json["created_by"],
//     updateBy: json["update_by"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "gender_name": genderName,
//     "data_status": dataStatus,
//     "ip_address": ipAddress,
//     "created_by": createdBy,
//     "update_by": updateBy,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//   };
// }
//
// class Privacy {
//   String gender;
//   String dob;
//   String about;
//   String homeTown;
//   String presentTown;
//   String relationship;
//   String nickname;
//   String userBio;
//
//   Privacy({
//     required this.gender,
//     required this.dob,
//     required this.about,
//     required this.homeTown,
//     required this.presentTown,
//     required this.relationship,
//     required this.nickname,
//     required this.userBio,
//   });
//
//   factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
//     gender: json["gender"],
//     dob: json["dob"],
//     about: json["about"],
//     homeTown: json["home_town"],
//     presentTown: json["present_town"],
//     relationship: json["relationship"],
//     nickname: json["nickname"],
//     userBio: json["user_bio"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "gender": gender,
//     "dob": dob,
//     "about": about,
//     "home_town": homeTown,
//     "present_town": presentTown,
//     "relationship": relationship,
//     "nickname": nickname,
//     "user_bio": userBio,
//   };
// }
//
// class UserWorkplace {
//   String id;
//   String orgId;
//   String userId;
//   int v;
//   DateTime createdAt;
//   dynamic createdBy;
//   DateTime fromDate;
//   bool isWorking;
//   String orgName;
//   String privacy;
//   int status;
//   dynamic toDate;
//   dynamic updateBy;
//   DateTime updatedAt;
//   String username;
//
//   UserWorkplace({
//     required this.id,
//     required this.orgId,
//     required this.userId,
//     required this.v,
//     required this.createdAt,
//     required this.createdBy,
//     required this.fromDate,
//     required this.isWorking,
//     required this.orgName,
//     required this.privacy,
//     required this.status,
//     required this.toDate,
//     required this.updateBy,
//     required this.updatedAt,
//     required this.username,
//   });
//
//   factory UserWorkplace.fromJson(Map<String, dynamic> json) => UserWorkplace(
//     id: json["_id"],
//     orgId: json["org_id"],
//     userId: json["user_id"],
//     v: json["__v"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     createdBy: json["created_by"],
//     fromDate: DateTime.parse(json["from_date"]),
//     isWorking: json["is_working"],
//     orgName: json["org_name"],
//     privacy: json["privacy"],
//     status: json["status"],
//     toDate: json["to_date"],
//     updateBy: json["update_by"],
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     username: json["username"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "org_id": orgId,
//     "user_id": userId,
//     "__v": v,
//     "createdAt": createdAt.toIso8601String(),
//     "created_by": createdBy,
//     "from_date": fromDate.toIso8601String(),
//     "is_working": isWorking,
//     "org_name": orgName,
//     "privacy": privacy,
//     "status": status,
//     "to_date": toDate,
//     "update_by": updateBy,
//     "updatedAt": updatedAt.toIso8601String(),
//     "username": username,
//   };
// }
//
// class Website {
//   String id;
//   String userId;
//   String socialMediaId;
//   String websiteUrl;
//   dynamic createdBy;
//   dynamic updateBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//   String privacy;
//   SocialMedia socialMedia;
//
//   Website({
//     required this.id,
//     required this.userId,
//     required this.socialMediaId,
//     required this.websiteUrl,
//     required this.createdBy,
//     required this.updateBy,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.privacy,
//     required this.socialMedia,
//   });
//
//   factory Website.fromJson(Map<String, dynamic> json) => Website(
//     id: json["_id"],
//     userId: json["user_id"],
//     socialMediaId: json["social_media_id"],
//     websiteUrl: json["website_url"],
//     createdBy: json["created_by"],
//     updateBy: json["update_by"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     privacy: json["privacy"],
//     socialMedia: SocialMedia.fromJson(json["socialMedia"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "user_id": userId,
//     "social_media_id": socialMediaId,
//     "website_url": websiteUrl,
//     "created_by": createdBy,
//     "update_by": updateBy,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//     "privacy": privacy,
//     "socialMedia": socialMedia.toJson(),
//   };
// }
//
// class SocialMedia {
//   String id;
//   String mediaName;
//   dynamic icon;
//   String baseUrl;
//   String dataStatus;
//   dynamic ipAddress;
//   dynamic createdBy;
//   dynamic updateBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//
//   SocialMedia({
//     required this.id,
//     required this.mediaName,
//     required this.icon,
//     required this.baseUrl,
//     required this.dataStatus,
//     required this.ipAddress,
//     required this.createdBy,
//     required this.updateBy,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory SocialMedia.fromJson(Map<String, dynamic> json) => SocialMedia(
//     id: json["_id"],
//     mediaName: json["media_name"],
//     icon: json["icon"],
//     baseUrl: json["base_url"],
//     dataStatus: json["data_status"],
//     ipAddress: json["ip_address"],
//     createdBy: json["created_by"],
//     updateBy: json["update_by"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "media_name": mediaName,
//     "icon": icon,
//     "base_url": baseUrl,
//     "data_status": dataStatus,
//     "ip_address": ipAddress,
//     "created_by": createdBy,
//     "update_by": updateBy,
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "__v": v,
//   };
// }
