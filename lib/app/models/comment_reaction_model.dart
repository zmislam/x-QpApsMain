// To parse this JSON data, do
//
//     final commentReactionModel = commentReactionModelFromJson(jsonString);

import 'dart:convert';

CommentReactionModel commentReactionModelFromJson(String str) =>
    CommentReactionModel.fromJson(json.decode(str));

String commentReactionModelToJson(CommentReactionModel data) =>
    json.encode(data.toJson());

class CommentReactionModel {
  int? status;
  List<CommentReactions>? reactions;

  CommentReactionModel({
    this.status,
    this.reactions,
  });

  factory CommentReactionModel.fromJson(Map<String, dynamic> json) =>
      CommentReactionModel(
        status: json['status'],
        reactions: json['reactions'] == null
            ? []
            : List<CommentReactions>.from(
            json['reactions'].map((x) => CommentReactions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'reactions': reactions == null
        ? []
        : List<dynamic>.from(reactions!.map((x) => x.toJson())),
  };

  CommentReactionModel copyWith({
    int? status,
    List<CommentReactions>? reactions,
  }) {
    return CommentReactionModel(
      status: status ?? this.status,
      reactions: reactions ?? this.reactions,
    );
  }
}

class CommentReactions {
  String id;
  String postId;
  dynamic postSingleItemId;
  UserId userId;
  String commentId;
  dynamic commentRepliesId;
  String reactionType;
  int v;

  CommentReactions({
    required this.id,
    required this.postId,
    required this.postSingleItemId,
    required this.userId,
    required this.commentId,
    required this.commentRepliesId,
    required this.reactionType,
    required this.v,
  });

  factory CommentReactions.fromJson(Map<String, dynamic> json) =>
      CommentReactions(
        id: json['_id'] ?? '',
        postId: json['post_id'] ?? '',
        postSingleItemId: json['post_single_item_id'],
        userId: UserId.fromJson(json['user_id'] ?? {}),
        commentId: json['comment_id'] ?? '',
        commentRepliesId: json['comment_replies_id'],
        reactionType: json['reaction_type'] ?? '',
        v: json['__v'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'post_id': postId,
    'post_single_item_id': postSingleItemId,
    'user_id': userId.toJson(),
    'comment_id': commentId,
    'comment_replies_id': commentRepliesId,
    'reaction_type': reactionType,
    '__v': v,
  };

  CommentReactions copyWith({
    String? id,
    String? postId,
    dynamic postSingleItemId,
    UserId? userId,
    String? commentId,
    dynamic commentRepliesId,
    String? reactionType,
    int? v,
  }) {
    return CommentReactions(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      postSingleItemId: postSingleItemId ?? this.postSingleItemId,
      userId: userId ?? this.userId,
      commentId: commentId ?? this.commentId,
      commentRepliesId: commentRepliesId ?? this.commentRepliesId,
      reactionType: reactionType ?? this.reactionType,
      v: v ?? this.v,
    );
  }
}

class UserId {
  String id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phone;
  String password;
  String profilePic;

  UserId({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.profilePic,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json['_id'] ?? '',
    firstName: json['first_name'] ?? '',
    lastName: json['last_name'] ?? '',
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    password: json['password'] ?? '',
    profilePic: json['profile_pic'] ?? '',
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
  };

  UserId copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profilePic,
  }) {
    return UserId(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
