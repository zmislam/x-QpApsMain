// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:quantum_possibilities_flutter/app/models/educational_work_place.dart';
import 'package:quantum_possibilities_flutter/app/models/email_list_model.dart';
import 'package:quantum_possibilities_flutter/app/models/gender.dart';
import 'package:quantum_possibilities_flutter/app/models/phone_list_model.dart';
import 'package:quantum_possibilities_flutter/app/models/privacy_model.dart';
import 'package:quantum_possibilities_flutter/app/models/websites.dart';
import 'language.dart';
import 'user_work_place.dart';

class ProfileModel {
  String? id;
  String? first_name;
  String? last_name;
  String? present_town;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? profile_pic;
  String? cover_pic;
  String? user_status;
  GenderModel? gender;
  String? religion;
  String? date_of_birth;
  String? user_bio;
  String? passport;
  String? last_login;
  String? user_2fa_status;
  String? secondary_email;
  String? recovery_email;
  String? relation_status;
  String? home_town;
  String? birth_place;
  String? blood_group;
  String? reset_password_token;
  String? reset_password_token_expires;
  String? user_role;
  String? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  String? v;
  String? lock_profile;
  List<EmailListModel>? email_list = [];
  List<PhoneListModel>? phone_list = [];
  List<LanguageModel>? language = [];
  List<Websites>? websites = [];
  String? user_about;
  String? user_nickname;
  List<EducationalWorkPlace>? educationWorkplaces = [];
  List<UserWorkPlaceModel>? userWorkplaces = [];
  String? fullName;
  int? postsCount;
  int? followersCount;
  int? followingCount;
  PrivacyModel? privacy;
  bool? isFriend;
  bool? hasSentRequest;
  bool? isFollower;
  bool? turn_on_earning_dashboard;

  // 🆕 Newly added fields
  String? page_id;
  String? email_privacy;
  String? date_of_birth_show_type;
  String? country;
  bool? isProfileVerified;
  int? otp;
  String? inactivation_note;
  bool? trusted_seller;
  String? user_prefer_language;
  bool? isDeleted;
  String? monetization;

  ProfileModel({
    this.id,
    this.first_name,
    this.last_name,
    this.present_town,
    this.username,
    this.email,
    this.phone,
    this.password,
    this.profile_pic,
    this.cover_pic,
    this.user_status,
    this.gender,
    this.religion,
    this.date_of_birth,
    this.user_bio,
    this.passport,
    this.last_login,
    this.user_2fa_status,
    this.secondary_email,
    this.recovery_email,
    this.relation_status,
    this.home_town,
    this.birth_place,
    this.blood_group,
    this.reset_password_token,
    this.reset_password_token_expires,
    this.user_role,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lock_profile,
    this.email_list,
    this.phone_list,
    this.language,
    this.websites,
    this.user_about,
    this.user_nickname,
    this.educationWorkplaces,
    this.userWorkplaces,
    this.fullName,
    this.postsCount,
    this.followersCount,
    this.followingCount,
    this.privacy,
    this.isFriend,
    this.hasSentRequest,
    this.isFollower,
    this.turn_on_earning_dashboard = false,

    // 🆕 new fields initialized
    this.page_id,
    this.email_privacy,
    this.date_of_birth_show_type,
    this.country,
    this.isProfileVerified,
    this.otp,
    this.inactivation_note,
    this.trusted_seller,
    this.user_prefer_language,
    this.isDeleted,
    this.monetization,
  });

  ProfileModel copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? present_town,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profile_pic,
    String? cover_pic,
    String? user_status,
    GenderModel? gender,
    String? religion,
    String? date_of_birth,
    String? user_bio,
    String? passport,
    String? last_login,
    String? user_2fa_status,
    String? secondary_email,
    String? recovery_email,
    String? relation_status,
    String? home_town,
    String? birth_place,
    String? blood_group,
    String? reset_password_token,
    String? reset_password_token_expires,
    String? user_role,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    String? v,
    String? lock_profile,
    List<EmailListModel>? email_list,
    List<PhoneListModel>? phone_list,
    List<LanguageModel>? language,
    List<Websites>? websites,
    String? user_about,
    String? user_nickname,
    List<EducationalWorkPlace>? educationWorkplaces,
    List<UserWorkPlaceModel>? userWorkplaces,
    String? fullName,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    PrivacyModel? privacy,
    bool? isFriend,
    bool? hasSentRequest,
    bool? isFollower,
    bool? turn_on_earning_dashboard,

    // 🆕 New fields
    String? page_id,
    String? email_privacy,
    String? date_of_birth_show_type,
    String? country,
    bool? isProfileVerified,
    int? otp,
    String? inactivation_note,
    bool? trusted_seller,
    String? user_prefer_language,
    bool? isDeleted,
    String? monetization,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      present_town: present_town ?? this.present_town,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profile_pic: profile_pic ?? this.profile_pic,
      cover_pic: cover_pic ?? this.cover_pic,
      user_status: user_status ?? this.user_status,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      user_bio: user_bio ?? this.user_bio,
      passport: passport ?? this.passport,
      last_login: last_login ?? this.last_login,
      user_2fa_status: user_2fa_status ?? this.user_2fa_status,
      secondary_email: secondary_email ?? this.secondary_email,
      recovery_email: recovery_email ?? this.recovery_email,
      relation_status: relation_status ?? this.relation_status,
      home_town: home_town ?? this.home_town,
      birth_place: birth_place ?? this.birth_place,
      blood_group: blood_group ?? this.blood_group,
      reset_password_token: reset_password_token ?? this.reset_password_token,
      reset_password_token_expires:
      reset_password_token_expires ?? this.reset_password_token_expires,
      user_role: user_role ?? this.user_role,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      lock_profile: lock_profile ?? this.lock_profile,
      email_list: email_list ?? this.email_list,
      phone_list: phone_list ?? this.phone_list,
      language: language ?? this.language,
      websites: websites ?? this.websites,
      user_about: user_about ?? this.user_about,
      user_nickname: user_nickname ?? this.user_nickname,
      educationWorkplaces: educationWorkplaces ?? this.educationWorkplaces,
      userWorkplaces: userWorkplaces ?? this.userWorkplaces,
      fullName: fullName ?? this.fullName,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      privacy: privacy ?? this.privacy,
      isFriend: isFriend ?? this.isFriend,
      hasSentRequest: hasSentRequest ?? this.hasSentRequest,
      isFollower: isFollower ?? this.isFollower,
      turn_on_earning_dashboard:
      turn_on_earning_dashboard ?? this.turn_on_earning_dashboard,

      // 🆕 new fields
      page_id: page_id ?? this.page_id,
      email_privacy: email_privacy ?? this.email_privacy,
      date_of_birth_show_type:
      date_of_birth_show_type ?? this.date_of_birth_show_type,
      country: country ?? this.country,
      isProfileVerified: isProfileVerified ?? this.isProfileVerified,
      otp: otp ?? this.otp,
      inactivation_note: inactivation_note ?? this.inactivation_note,
      trusted_seller: trusted_seller ?? this.trusted_seller,
      user_prefer_language: user_prefer_language ?? this.user_prefer_language,
      isDeleted: isDeleted ?? this.isDeleted,
      monetization: monetization ?? this.monetization,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'present_town': present_town,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'user_status': user_status,
      'gender': gender?.toMap(),
      'religion': religion,
      'date_of_birth': date_of_birth,
      'user_bio': user_bio,
      'passport': passport,
      'last_login': last_login,
      'user_2fa_status': user_2fa_status,
      'secondary_email': secondary_email,
      'recovery_email': recovery_email,
      'relation_status': relation_status,
      'home_town': home_town,
      'birth_place': birth_place,
      'blood_group': blood_group,
      'reset_password_token': reset_password_token,
      'reset_password_token_expires': reset_password_token_expires,
      'user_role': user_role,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'lock_profile': lock_profile,
      'email_list': email_list?.map((x) => x.toMap()).toList(),
      'phone_list': phone_list?.map((x) => x.toMap()).toList(),
      'language': language?.map((x) => x.toMap()).toList(),
      'websites': websites?.map((x) => x.toMap()).toList(),
      'user_about': user_about,
      'user_nickname': user_nickname,
      'educationWorkplaces':
      educationWorkplaces?.map((x) => x.toMap()).toList(),
      'userWorkplaces': userWorkplaces?.map((x) => x.toMap()).toList(),
      'fullName': fullName,
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'privacy': privacy?.toMap(),
      'isFriend': isFriend,
      'hasSentRequest': hasSentRequest,
      'isFollower': isFollower,
      'turn_on_earning_dashboard': turn_on_earning_dashboard ?? false,

      // 🆕 new
      'page_id': page_id,
      'email_privacy': email_privacy,
      'date_of_birth_show_type': date_of_birth_show_type,
      'country': country,
      'isProfileVerified': isProfileVerified,
      'otp': otp,
      'inactivation_note': inactivation_note,
      'trusted_seller': trusted_seller,
      'user_prefer_language': user_prefer_language,
      'isDeleted': isDeleted,
      'monetization': monetization,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['_id'],
      first_name: map['first_name'],
      last_name: map['last_name'],
      present_town: map['present_town'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      profile_pic: map['profile_pic'],
      cover_pic: map['cover_pic'],
      user_status: map['user_status'],
      gender: map['gender'] != null ? GenderModel.fromMap(map['gender']) : null,
      religion: map['religion'],
      date_of_birth: map['date_of_birth'],
      user_bio: map['user_bio'],
      passport: map['passport'],
      last_login: map['last_login'],
      user_2fa_status: map['user_2fa_status'],
      secondary_email: map['secondary_email'],
      recovery_email: map['recovery_email'],
      relation_status: map['relation_status'],
      home_town: map['home_town'],
      birth_place: map['birth_place'],
      blood_group: map['blood_group'],
      user_role: map['user_role'],
      status: map['status'],
      ip_address: map['ip_address'],
      created_by: map['created_by'],
      update_by: map['update_by'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      v: map['__v']?.toString(),
      lock_profile: map['lock_profile'],
      email_list: (map['email_list'] as List?)
          ?.map((e) => EmailListModel.fromMap(e))
          .toList(),
      phone_list: (map['phone_list'] as List?)
          ?.map((e) => PhoneListModel.fromMap(e))
          .toList(),
      language: (map['language'] as List?)
          ?.map((e) => LanguageModel.fromMap(e))
          .toList(),
      websites: (map['websites'] as List?)
          ?.map((e) => Websites.fromMap(e))
          .toList(),
      educationWorkplaces: (map['educationWorkplaces'] as List?)
          ?.map((e) => EducationalWorkPlace.fromMap(e))
          .toList(),
      userWorkplaces: (map['userWorkplaces'] as List?)
          ?.map((e) => UserWorkPlaceModel.fromMap(e))
          .toList(),
      fullName: map['fullName'],
      postsCount: map['postsCount'],
      followersCount: map['followersCount'],
      followingCount: map['followingCount'],
      privacy:
      map['privacy'] != null ? PrivacyModel.fromMap(map['privacy']) : null,
      turn_on_earning_dashboard:
      map['turn_on_earning_dashboard'] ?? false,

      // 🆕 new fields
      page_id: map['page_id'],
      email_privacy: map['email_privacy'],
      date_of_birth_show_type: map['date_of_birth_show_type'],
      country: map['country'],
      isProfileVerified: map['isProfileVerified'],
      otp: map['otp'],
      inactivation_note: map['inactivation_note'],
      trusted_seller: map['trusted_seller'],
      user_prefer_language: map['user_prefer_language'],
      isDeleted: map['isDeleted'],
      monetization: map['monetization'],
    );
  }

  String toJson() => json.encode(toMap());
  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));
}
