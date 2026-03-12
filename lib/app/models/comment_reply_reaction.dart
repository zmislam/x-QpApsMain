// To parse this JSON data, do
//
//     final commentReplyReactionModel = commentReplyReactionModelFromJson(jsonString);

import 'dart:convert';

CommentReplyReactionModel commentReplyReactionModelFromJson(String str) => CommentReplyReactionModel.fromJson(json.decode(str));

String commentReplyReactionModelToJson(CommentReplyReactionModel data) => json.encode(data.toJson());

class CommentReplyReactionModel {
  int? status;
  List<ReplyReactions>? reactions;

  CommentReplyReactionModel({
    this.status,
    this.reactions,
  });

  factory CommentReplyReactionModel.fromJson(Map<String, dynamic> json) => CommentReplyReactionModel(
        status: json['status'],
        reactions: List<ReplyReactions>.from(json['reactions'].map((x) => ReplyReactions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'reactions': List<dynamic>.from(reactions!.map((x) => x.toJson())),
      };
}

class ReplyReactions {
  String? id;
  String? postId;
  dynamic postSingleItemId;
  ReplyUserId? userId;
  String? commentId;
  String? commentRepliesId;
  String? reactionType;
  int? v;

  ReplyReactions({
    this.id,
    this.postId,
    this.postSingleItemId,
    this.userId,
    this.commentId,
    this.commentRepliesId,
    this.reactionType,
    this.v,
  });

  factory ReplyReactions.fromJson(Map<String, dynamic> json) => ReplyReactions(
        id: json['_id'],
        postId: json['post_id'],
        postSingleItemId: json['post_single_item_id'],
        userId: ReplyUserId.fromJson(json['user_id']),
        commentId: json['comment_id'],
        commentRepliesId: json['comment_replies_id'],
        reactionType: json['reaction_type'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'post_id': postId,
        'post_single_item_id': postSingleItemId,
        'user_id': userId,
        'comment_id': commentId,
        'comment_replies_id': commentRepliesId,
        'reaction_type': reactionType,
        '__v': v,
      };
}

class ReplyUserId {
  dynamic websites;
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
  dynamic status;
  dynamic ipAddress;
  dynamic createdBy;
  dynamic updateBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? lockProfile;
  List<dynamic>? emailList;
  List<String>? phoneList;
  String? userAbout;
  String? userNickname;
  String? presentTown;

  ReplyUserId({
    this.websites,
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
  });

  factory ReplyUserId.fromJson(Map<String, dynamic> json) => ReplyUserId(
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
        dateOfBirth: DateTime.parse(json['date_of_birth'] ?? DateTime.now().toString()),
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
        emailList: json['email_list'] != null ? List<dynamic>.from(json['email_list'].map((x) => x)) : [],
        phoneList: json['phone_list'] != null ? List<String>.from(json['phone_list'].map((x) => x)) : [],
        userAbout: json['user_about'],
        userNickname: json['user_nickname'],
        presentTown: json['present_town'],
      );

  Map<String, dynamic> toJson() => {
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
        'status': status,
        'ip_address': ipAddress,
        'created_by': createdBy,
        'update_by': updateBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
        'lock_profile': lockProfile,
        // 'email_list': List<dynamic>.from(emailList.map((x) => x)),
        // 'phone_list': List<dynamic>.from(phoneList.map((x) => x)),
        'user_about': userAbout,
        'user_nickname': userNickname,
        'present_town': presentTown,
      };
}
