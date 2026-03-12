// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quantum_possibilities_flutter/app/models/gender.dart';
import 'package:quantum_possibilities_flutter/app/models/religion.dart';

class UserModel {
  String? websites;
  String? user_nickname;
  String? user_about;
  String? present_town;
  String? id;
  String? page_id;
  String? first_name;
  String? last_name;
  String? username;
  String? pageUserName;
  String? email;
  String? phone;
  String? password;
  String? profile_pic;
  String? cover_pic;
  String? user_status;
  GenderModel? gender;
  ReligionModel? religion;
  String? date_of_birth;
  String? user_bio;
  List<String>? language;
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
  int? v;
  String? lock_profile;
  bool? turn_on_earning_dashboard;

  UserModel({
    this.websites,
    this.user_nickname,
    this.user_about,
    this.present_town,
    this.id,
    this.page_id,
    this.first_name,
    this.last_name,
    this.username,
    this.pageUserName,
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
    this.language,
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
    this.turn_on_earning_dashboard = false, // default false
  });

  UserModel copyWith({
    String? websites,
    String? user_nickname,
    String? user_about,
    String? present_town,
    String? id,
    String? page_id,
    String? first_name,
    String? last_name,
    String? username,
    String? pageUserName,
    String? email,
    String? phone,
    String? password,
    String? profile_pic,
    String? cover_pic,
    String? user_status,
    GenderModel? gender,
    ReligionModel? religion,
    String? date_of_birth,
    String? user_bio,
    List<String>? language,
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
    int? v,
    String? lock_profile,
    bool? turn_on_earning_dashboard,
  }) {
    return UserModel(
      websites: websites ?? this.websites,
      user_nickname: user_nickname ?? this.user_nickname,
      user_about: user_about ?? this.user_about,
      present_town: present_town ?? this.present_town,
      id: id ?? this.id,
      page_id: page_id ?? this.page_id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      username: username ?? this.username,
      pageUserName: pageUserName ?? this.pageUserName,
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
      language: language ?? this.language,
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
      reset_password_token_expires: reset_password_token_expires ?? this.reset_password_token_expires,
      user_role: user_role ?? this.user_role,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      lock_profile: lock_profile ?? this.lock_profile,
      turn_on_earning_dashboard: turn_on_earning_dashboard ?? this.turn_on_earning_dashboard,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'websites': websites,
      'user_nickname': user_nickname,
      'user_about': user_about,
      'present_town': present_town,
      '_id': id,
      'page_id': page_id,
      'first_name': first_name,
      'last_name': last_name ?? '',
      'username': username,
      'page_user_name': pageUserName,
      'email': email,
      'phone': phone,
      'password': password,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'user_status': user_status,
      'gender': gender?.toMap(),
      'religion': religion?.toMap(),
      'date_of_birth': date_of_birth,
      'user_bio': user_bio,
      'language': language,
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
      'turn_on_earning_dashboard': turn_on_earning_dashboard ?? false,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user_nickname: map['user_nickname'] as String?,
      user_about: map['user_about'] as String?,
      present_town: map['present_town'] as String?,
      id: map['_id'] as String?,
      page_id: map['page_id'] as String?,
      first_name: map['first_name'] as String?,
      last_name: map['last_name'] as String? ?? '',
      username: map['username'] as String?,
      pageUserName: map['page_user_name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      password: map['password'] as String?,
      profile_pic: map['profile_pic'] as String?,
      cover_pic: map['cover_pic'] as String?,
      user_status: map['user_status'] as String?,
      gender: map['gender'] != null ? GenderModel.fromMap(map['gender']) : null,
      date_of_birth: map['date_of_birth'] as String?,
      user_bio: map['user_bio'] as String?,
      language: map['language'] != null ? (map['language'] as List).map((e) => e.toString()).toList() : null,
      passport: map['passport'] as String?,
      last_login: map['last_login'] as String?,
      user_2fa_status: map['user_2fa_status'] as String?,
      secondary_email: map['secondary_email'] as String?,
      recovery_email: map['recovery_email'] as String?,
      relation_status: map['relation_status'] as String?,
      home_town: map['home_town'] as String?,
      birth_place: map['birth_place'] as String?,
      blood_group: map['blood_group'] as String?,
      reset_password_token: map['reset_password_token'] as String?,
      reset_password_token_expires: map['reset_password_token_expires'] as String?,
      user_role: map['user_role'] as String?,
      status: map['status'] as String?,
      ip_address: map['ip_address'] as String?,
      created_by: map['created_by'] as String?,
      update_by: map['update_by'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] as int?,
      lock_profile: map['lock_profile'] as String?,
      turn_on_earning_dashboard: map['turn_on_earning_dashboard'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}