// To parse this JSON data, do
//
//     final storyReactionModel = storyReactionModelFromJson(jsonString);

import 'dart:convert';

StoryReactionModel storyReactionModelFromJson(String str) =>
    StoryReactionModel.fromJson(json.decode(str));

String storyReactionModelToJson(StoryReactionModel data) =>
    json.encode(data.toJson());

class ViewersList {
  StoryReactionModel? userId;
  String? username;
  String? firstName;
  String? lastName;
  String? profilePic;
  dynamic status;
  List<dynamic>? reactions;

  ViewersList({
    this.userId,
    this.username,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.status,
    this.reactions,
  });

  factory ViewersList.fromJson(Map<String, dynamic> json) => ViewersList(
        userId: json['user_id'] == null
            ? null
            : StoryReactionModel.fromJson(json['user_id']),
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        profilePic: json['profile_pic'],
        status: json['status'],
        reactions: json['reactions'] == null
            ? []
            : List<dynamic>.from(json['reactions']!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId?.toJson(),
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'profile_pic': profilePic,
        'status': status,
        'reactions': reactions == null
            ? []
            : List<dynamic>.from(reactions!.map((x) => x)),
      };
}

class Story {
  String? id;
  dynamic title;
  dynamic color;
  dynamic textColor;
  dynamic fontFamily;
  dynamic fontSize;
  String? media;
  dynamic textPosition;
  dynamic textAlignment;
  String? userId;
  dynamic privacyId;
  dynamic status;
  dynamic locationId;
  dynamic feelingId;
  dynamic activityId;
  dynamic subActivityId;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? storyId;
  int? viewersCount;
  List<ViewersList>? viewersList;

  Story({
    this.id,
    this.title,
    this.color,
    this.textColor,
    this.fontFamily,
    this.fontSize,
    this.media,
    this.textPosition,
    this.textAlignment,
    this.userId,
    this.privacyId,
    this.status,
    this.locationId,
    this.feelingId,
    this.activityId,
    this.subActivityId,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.storyId,
    this.viewersCount,
    this.viewersList,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json['_id'],
        title: json['title'],
        color: json['color'],
        textColor: json['text_color'],
        fontFamily: json['font_family'],
        fontSize: json['font_size'],
        media: json['media'],
        textPosition: json['text_position'],
        textAlignment: json['text_alignment'],
        userId: json['user_id'],
        privacyId: json['privacy_id'],
        status: json['status'],
        locationId: json['location_id'],
        feelingId: json['feeling_id'],
        activityId: json['activity_id'],
        subActivityId: json['sub_activity_id'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        v: json['__v'],
        storyId: json['id'],
        viewersCount: json['viewersCount'],
        viewersList: json['viewersList'] == null
            ? []
            : List<ViewersList>.from(
                json['viewersList']!.map((x) => ViewersList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'color': color,
        'text_color': textColor,
        'font_family': fontFamily,
        'font_size': fontSize,
        'media': media,
        'text_position': textPosition,
        'text_alignment': textAlignment,
        'user_id': userId,
        'privacy_id': privacyId,
        'status': status,
        'location_id': locationId,
        'feeling_id': feelingId,
        'activity_id': activityId,
        'sub_activity_id': subActivityId,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'id': storyId,
        'viewersCount': viewersCount,
        'viewersList': viewersList == null
            ? []
            : List<dynamic>.from(viewersList!.map((x) => x.toJson())),
      };
}

class StoryReactionModel {
  dynamic websites;
  String? userNickname;
  String? userAbout;
  String? presentTown;
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
  String? lockProfile;
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<String>? emailList;
  List<dynamic>? phoneList;
  List<Story>? stories;

  StoryReactionModel({
    this.websites,
    this.userNickname,
    this.userAbout,
    this.presentTown,
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
    this.lockProfile,
    this.status,
    this.ipAddress,
    this.createdBy,
    this.updateBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.emailList,
    this.phoneList,
    this.stories,
  });

  factory StoryReactionModel.fromJson(Map<String, dynamic> json) =>
      StoryReactionModel(
        websites: json['websites'],
        userNickname: json['user_nickname'],
        userAbout: json['user_about'],
        presentTown: json['present_town'],
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
        lockProfile: json['lock_profile'],
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
        emailList: json['email_list'] == null
            ? []
            : List<String>.from(json['email_list']!.map((x) => x)),
        phoneList: json['phone_list'] == null
            ? []
            : List<dynamic>.from(json['phone_list']!.map((x) => x)),
        stories: json['stories'] == null
            ? []
            : List<Story>.from(json['stories']!.map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'websites': websites,
        'user_nickname': userNickname,
        'user_about': userAbout,
        'present_town': presentTown,
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
        'lock_profile': lockProfile,
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'email_list': emailList == null
            ? []
            : List<dynamic>.from(emailList!.map((x) => x)),
        'phone_list': phoneList == null
            ? []
            : List<dynamic>.from(phoneList!.map((x) => x)),
        'stories': stories == null
            ? []
            : List<dynamic>.from(stories!.map((x) => x.toJson())),
      };
}
