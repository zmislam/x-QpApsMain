// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/reels/model/reels_comment_reaction_user_model.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/reels/model/reels_comment_reply_model.dart';

class ReelsCommentModel {
  String? id;
  String? comment_name;
  String? post_id;
  String? post_single_item_id;
  ReelsUserIdModel? user_id;
  String? comment_type;
  bool? comment_edited;
  String? image_or_video;
  String? link;
  String? link_image;
  String? link_title;
  String? status;
  String? ip_address;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  String? key;
  List<ReelsCommentReactionModel>? comment_reactions;
  List<ReelsCommentReplyModel>? replies;

  int? v;
  ReelsCommentModel({
    this.id,
    this.comment_name,
    this.post_id,
    this.post_single_item_id,
    this.user_id,
    this.comment_type,
    this.comment_edited,
    this.image_or_video,
    this.link,
    this.link_image,
    this.link_title,
    this.status,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.key,
    this.comment_reactions,
    this.replies,
    this.v,
  });

  ReelsCommentModel copyWith({
    String? id,
    String? comment_name,
    String? post_id,
    String? post_single_item_id,
    ReelsUserIdModel? user_id,
    String? comment_type,
    bool? comment_edited,
    String? image_or_video,
    String? link,
    String? link_image,
    String? link_title,
    String? status,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    String? key,
    List<ReelsCommentReactionModel>? comment_reactions,
    List<ReelsCommentReplyModel>? replies,
    int? v,
  }) {
    return ReelsCommentModel(
      id: id ?? this.id,
      comment_name: comment_name ?? this.comment_name,
      post_id: post_id ?? this.post_id,
      post_single_item_id: post_single_item_id ?? this.post_single_item_id,
      user_id: user_id ?? this.user_id,
      comment_type: comment_type ?? this.comment_type,
      comment_edited: comment_edited ?? this.comment_edited,
      image_or_video: image_or_video ?? this.image_or_video,
      link: link ?? this.link,
      link_image: link_image ?? this.link_image,
      link_title: link_title ?? this.link_title,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      key: key ?? this.key,
      comment_reactions: comment_reactions ?? this.comment_reactions,
      replies: replies ?? this.replies,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'comment_name': comment_name,
      'post_id': post_id,
      'post_single_item_id': post_single_item_id,
      'user_id': user_id?.toMap(),
      'comment_type': comment_type,
      'comment_edited': comment_edited,
      'image_or_video': image_or_video,
      'link': link,
      'link_image': link_image,
      'link_title': link_title,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'key': key,
      'comment_reactions': comment_reactions?.map((x) => x.toMap()).toList(),
      'replies': replies?.map((x) => x.toMap()).toList(),
      '__v': v,
    };
  }

  factory ReelsCommentModel.fromMap(Map<String, dynamic> map) {
    return ReelsCommentModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      comment_name:
          map['comment_name'] != null ? map['comment_name'] as String : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      post_single_item_id: map['post_single_item_id'] != null
          ? map['post_single_item_id'] as String
          : null,
      user_id: map['user_id'] != null
          ? map['user_id'] is String
              ? ReelsUserIdModel(
                  id: map['user_id']
                      as String) // If it's a String, create a ReelsUserIdModel with the String as the ID.
              : ReelsUserIdModel.fromMap(map['user_id'] as Map<String,
                  dynamic>) // If it's a Map, parse it into a ReelsUserIdModel.
          : null, // If 'user_id' is null, return null.
      comment_type:
          map['comment_type'] != null ? map['comment_type'] as String : null,
      comment_edited:
          map['comment_edited'] != null ? map['comment_edited'] as bool : null,
      image_or_video: map['image_or_video'] != null
          ? map['image_or_video'] as String
          : null,
      link: map['link'] != null ? map['link'] as String : null,
      link_image:
          map['link_image'] != null ? map['link_image'] as String : null,
      link_title:
          map['link_title'] != null ? map['link_title'] as String : null,

      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      key: map['key'] != null ? map['key'] as String : null,
      comment_reactions: map['comment_reactions'] != null
          ? (map['comment_reactions'] as List)
              .map((e) => ReelsCommentReactionModel.fromMap(e))
              .toList()
          : null,
      replies: map['replies'] != null
          ? (map['replies'] as List)
              .map((e) => ReelsCommentReplyModel.fromMap(e))
              .toList()
          : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsCommentModel.fromJson(String source) =>
      ReelsCommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelsCommentModel(id: $id, comment_name: $comment_name, post_id: $post_id, post_single_item_id: $post_single_item_id, user_id: $user_id, comment_type: $comment_type, comment_edited: $comment_edited, image_or_video: $image_or_video, link:$link, link_image:$link_image, link_title:$link_title: $status, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, key: $key, comment_reactions: $comment_reactions, replies:$replies, v: $v)';
  }

  @override
  bool operator ==(covariant ReelsCommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.comment_name == comment_name &&
        other.post_id == post_id &&
        other.post_single_item_id == post_single_item_id &&
        other.user_id == user_id &&
        other.comment_type == comment_type &&
        other.comment_edited == comment_edited &&
        other.image_or_video == image_or_video &&
        other.link == link &&
        other.link_image == link_image &&
        other.link_title == link_title &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.updated_by == updated_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.key == key &&
        listEquals(other.comment_reactions, comment_reactions) &&
        listEquals(other.replies, replies) &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        comment_name.hashCode ^
        post_id.hashCode ^
        post_single_item_id.hashCode ^
        user_id.hashCode ^
        comment_type.hashCode ^
        comment_edited.hashCode ^
        image_or_video.hashCode ^
        link.hashCode ^
        link_image.hashCode ^
        link_title.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        key.hashCode ^
        comment_reactions.hashCode ^
        replies.hashCode ^
        v.hashCode;
  }
}

class ReelsUserIdModel {
  String? id;
  String? first_name;
  String? last_name;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? profile_pic;
  String? cover_pic;
  String? user_status;
  String? gender;
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
  String? user_nickname;
  String? user_about;
  String? present_town;
  String? reset_password_token_expires;
  String? user_role;
  String? lock_profile;
  String? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? date_of_birth_show_type;
  ReelsUserIdModel({
    this.id,
    this.first_name,
    this.last_name,
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
    this.user_nickname,
    this.user_about,
    this.present_town,
    this.reset_password_token_expires,
    this.user_role,
    this.lock_profile,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.date_of_birth_show_type,
  });

  ReelsUserIdModel copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profile_pic,
    String? cover_pic,
    String? user_status,
    String? gender,
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
    String? user_nickname,
    String? user_about,
    String? present_town,
    String? reset_password_token_expires,
    String? user_role,
    String? lock_profile,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
    String? date_of_birth_show_type,
  }) {
    return ReelsUserIdModel(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
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
      user_nickname: user_nickname ?? this.user_nickname,
      user_about: user_about ?? this.user_about,
      present_town: present_town ?? this.present_town,
      reset_password_token_expires:
          reset_password_token_expires ?? this.reset_password_token_expires,
      user_role: user_role ?? this.user_role,
      lock_profile: lock_profile ?? this.lock_profile,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      date_of_birth_show_type:
          date_of_birth_show_type ?? this.date_of_birth_show_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'user_status': user_status,
      'gender': gender,
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
      'user_nickname': user_nickname,
      'user_about': user_about,
      'present_town': present_town,
      'reset_password_token_expires': reset_password_token_expires,
      'user_role': user_role,
      'lock_profile': lock_profile,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'date_of_birth_show_type': date_of_birth_show_type,
    };
  }

  factory ReelsUserIdModel.fromMap(Map<String, dynamic> map) {
    return ReelsUserIdModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      cover_pic: map['cover_pic'] != null ? map['cover_pic'] as String : null,
      user_status:
          map['user_status'] != null ? map['user_status'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      date_of_birth:
          map['date_of_birth'] != null ? map['date_of_birth'] as String : null,
      user_bio: map['user_bio'] != null ? map['user_bio'] as String : null,
      passport: map['passport'] != null ? map['passport'] as String : null,
      last_login:
          map['last_login'] != null ? map['last_login'] as String : null,
      user_2fa_status: map['user_2fa_status'] != null
          ? map['user_2fa_status'] as String
          : null,
      secondary_email: map['secondary_email'] != null
          ? map['secondary_email'] as String
          : null,
      recovery_email: map['recovery_email'] != null
          ? map['recovery_email'] as String
          : null,
      relation_status: map['relation_status'] != null
          ? map['relation_status'] as String
          : null,
      home_town: map['home_town'] != null ? map['home_town'] as String : null,
      birth_place:
          map['birth_place'] != null ? map['birth_place'] as String : null,
      blood_group:
          map['blood_group'] != null ? map['blood_group'] as String : null,
      reset_password_token: map['reset_password_token'] != null
          ? map['reset_password_token'] as String
          : null,
      user_nickname:
          map['user_nickname'] != null ? map['user_nickname'] as String : null,
      user_about:
          map['user_about'] != null ? map['user_about'] as String : null,
      present_town:
          map['present_town'] != null ? map['present_town'] as String : null,
      reset_password_token_expires: map['reset_password_token_expires'] != null
          ? map['reset_password_token_expires'] as String
          : null,
      user_role: map['user_role'] != null ? map['user_role'] as String : null,
      lock_profile:
          map['lock_profile'] != null ? map['lock_profile'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
      date_of_birth_show_type: map['date_of_birth_show_type'] != null
          ? map['date_of_birth_show_type'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsUserIdModel.fromJson(String source) =>
      ReelsUserIdModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelsUserIdModel(id: $id, first_name: $first_name, last_name: $last_name, username: $username, email: $email, phone: $phone, password: $password, profile_pic: $profile_pic, cover_pic: $cover_pic, user_status: $user_status, gender: $gender, religion: $religion, date_of_birth: $date_of_birth, user_bio: $user_bio, passport: $passport, last_login: $last_login, user_2fa_status: $user_2fa_status, secondary_email: $secondary_email, recovery_email: $recovery_email, relation_status: $relation_status, home_town: $home_town, birth_place: $birth_place, blood_group: $blood_group, reset_password_token: $reset_password_token, user_nickname: $user_nickname, user_about: $user_about, present_town: $present_town, reset_password_token_expires: $reset_password_token_expires, user_role: $user_role, lock_profile: $lock_profile, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, date_of_birth_show_type: $date_of_birth_show_type)';
  }

  @override
  bool operator ==(covariant ReelsUserIdModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.profile_pic == profile_pic &&
        other.cover_pic == cover_pic &&
        other.user_status == user_status &&
        other.gender == gender &&
        other.religion == religion &&
        other.date_of_birth == date_of_birth &&
        other.user_bio == user_bio &&
        other.passport == passport &&
        other.last_login == last_login &&
        other.user_2fa_status == user_2fa_status &&
        other.secondary_email == secondary_email &&
        other.recovery_email == recovery_email &&
        other.relation_status == relation_status &&
        other.home_town == home_town &&
        other.birth_place == birth_place &&
        other.blood_group == blood_group &&
        other.reset_password_token == reset_password_token &&
        other.user_nickname == user_nickname &&
        other.user_about == user_about &&
        other.present_town == present_town &&
        other.reset_password_token_expires == reset_password_token_expires &&
        other.user_role == user_role &&
        other.lock_profile == lock_profile &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.update_by == update_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v &&
        other.date_of_birth_show_type == date_of_birth_show_type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        profile_pic.hashCode ^
        cover_pic.hashCode ^
        user_status.hashCode ^
        gender.hashCode ^
        religion.hashCode ^
        date_of_birth.hashCode ^
        user_bio.hashCode ^
        passport.hashCode ^
        last_login.hashCode ^
        user_2fa_status.hashCode ^
        secondary_email.hashCode ^
        recovery_email.hashCode ^
        relation_status.hashCode ^
        home_town.hashCode ^
        birth_place.hashCode ^
        blood_group.hashCode ^
        reset_password_token.hashCode ^
        user_nickname.hashCode ^
        user_about.hashCode ^
        present_town.hashCode ^
        reset_password_token_expires.hashCode ^
        user_role.hashCode ^
        lock_profile.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode ^
        date_of_birth_show_type.hashCode;
  }
}

class ReelsCommentReactionModel {
  String? id;
  String? post_id;
  String? post_single_item_id;
  CommentReactedUserIdModel? user_id;
  String? comment_id;
  String? comment_replies_id;
  String? reaction_type;
  int? v;
  ReelsCommentReactionModel({
    this.id,
    this.post_id,
    this.post_single_item_id,
    this.user_id,
    this.comment_id,
    this.comment_replies_id,
    this.reaction_type,
    this.v,
  });

  ReelsCommentReactionModel copyWith({
    String? id,
    String? post_id,
    String? post_single_item_id,
    CommentReactedUserIdModel? user_id,
    String? comment_id,
    String? comment_replies_id,
    String? reaction_type,
    int? v,
  }) {
    return ReelsCommentReactionModel(
      id: id ?? this.id,
      post_id: post_id ?? this.post_id,
      post_single_item_id: post_single_item_id ?? this.post_single_item_id,
      user_id: user_id ?? this.user_id,
      comment_id: comment_id ?? this.comment_id,
      comment_replies_id: comment_replies_id ?? this.comment_replies_id,
      reaction_type: reaction_type ?? this.reaction_type,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'post_id': post_id,
      'post_single_item_id': post_single_item_id,
      'user_id': user_id,
      'comment_id': comment_id,
      'comment_replies_id': comment_replies_id,
      'reaction_type': reaction_type,
      '__v': v,
    };
  }

  factory ReelsCommentReactionModel.fromMap(Map<String, dynamic> map) {
    return ReelsCommentReactionModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      post_single_item_id: map['post_single_item_id'] != null
          ? map['post_single_item_id'] as String
          : null,
      // user_id: map['user_id'] != null ? CommentReactedUserIdModel.fromMap(map['user_id']) : null,
      user_id: map['user_id'] != null
          ? CommentReactedUserIdModel.fromMap(
              map['user_id'] as Map<String, dynamic>)
          : null,
      comment_id:
          map['comment_id'] != null ? map['comment_id'] as String : null,
      comment_replies_id: map['comment_replies_id'] != null
          ? map['comment_replies_id'] as String
          : null,
      reaction_type:
          map['reaction_type'] != null ? map['reaction_type'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsCommentReactionModel.fromJson(String source) =>
      ReelsCommentReactionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelsCommentReactionModel(id: $id, post_id: $post_id, post_single_item_id: $post_single_item_id, user_id: $user_id, comment_id: $comment_id, comment_replies_id: $comment_replies_id, reaction_type: $reaction_type, v: $v)';
  }

  @override
  bool operator ==(covariant ReelsCommentReactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.post_id == post_id &&
        other.post_single_item_id == post_single_item_id &&
        other.user_id == user_id &&
        other.comment_id == comment_id &&
        other.comment_replies_id == comment_replies_id &&
        other.reaction_type == reaction_type &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        post_id.hashCode ^
        post_single_item_id.hashCode ^
        user_id.hashCode ^
        comment_id.hashCode ^
        comment_replies_id.hashCode ^
        reaction_type.hashCode ^
        v.hashCode;
  }
}

class CommentReplayModel {
  String? id;
  String? post_id;
  String? comment_id;
  ReplayUserIdModel? replies_user_id;
  List<ReplayReactionModel>? replies_comment_reactions;
  String? replies_comment_name;
  String? comment_type;
  bool? comment_edited;
  String? image_or_video;
  String? status;
  String? ip_address;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  CommentReplayModel({
    this.id,
    this.post_id,
    this.comment_id,
    this.replies_user_id,
    this.replies_comment_reactions,
    this.replies_comment_name,
    this.comment_type,
    this.comment_edited,
    this.image_or_video,
    this.status,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  CommentReplayModel copyWith({
    String? id,
    String? post_id,
    String? comment_id,
    ReplayUserIdModel? replies_user_id,
    List<ReplayReactionModel>? replies_comment_reactions,
    String? replies_comment_name,
    String? comment_type,
    bool? comment_edited,
    String? image_or_video,
    String? status,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return CommentReplayModel(
      id: id ?? this.id,
      post_id: post_id ?? this.post_id,
      comment_id: comment_id ?? this.comment_id,
      replies_user_id: replies_user_id ?? this.replies_user_id,
      replies_comment_reactions:
          replies_comment_reactions ?? this.replies_comment_reactions,
      replies_comment_name: replies_comment_name ?? this.replies_comment_name,
      comment_type: comment_type ?? this.comment_type,
      comment_edited: comment_edited ?? this.comment_edited,
      image_or_video: image_or_video ?? this.image_or_video,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'post_id': post_id,
      'comment_id': comment_id,
      'replies_user_id': replies_user_id?.toMap(),
      'replies_comment_reactions':
          replies_comment_reactions?.map((x) => x.toMap()).toList(),
      'replies_comment_name': replies_comment_name,
      'comment_type': comment_type,
      'comment_edited': comment_edited,
      'image_or_video': image_or_video,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory CommentReplayModel.fromMap(Map<String, dynamic> map) {
    return CommentReplayModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      comment_id:
          map['comment_id'] != null ? map['comment_id'] as String : null,
      replies_user_id: map['replies_user_id'] != null
          ? ReplayUserIdModel.fromMap(
              map['replies_user_id'] as Map<String, dynamic>)
          : null,
      replies_comment_reactions: map['replies_comment_reactions'] != null
          ? (map['replies_comment_reactions'] as List)
              .map((e) => ReplayReactionModel.fromMap(e))
              .toList()
          : null,
      replies_comment_name: map['replies_comment_name'] != null
          ? map['replies_comment_name'] as String
          : null,
      comment_type:
          map['comment_type'] != null ? map['comment_type'] as String : null,
      comment_edited:
          map['comment_edited'] != null ? map['comment_edited'] as bool : null,
      image_or_video: map['image_or_video'] != null
          ? map['image_or_video'] as String
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentReplayModel.fromJson(String source) =>
      CommentReplayModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentReplayModel(id: $id, post_id: $post_id, comment_id: $comment_id, replies_user_id: $replies_user_id, replies_comment_reactions: $replies_comment_reactions, replies_comment_name: $replies_comment_name, comment_type: $comment_type, comment_edited: $comment_edited, image_or_video: $image_or_video, status: $status, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant CommentReplayModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.post_id == post_id &&
        other.comment_id == comment_id &&
        other.replies_user_id == replies_user_id &&
        listEquals(
            other.replies_comment_reactions, replies_comment_reactions) &&
        other.replies_comment_name == replies_comment_name &&
        other.comment_type == comment_type &&
        other.comment_edited == comment_edited &&
        other.image_or_video == image_or_video &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.updated_by == updated_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        post_id.hashCode ^
        comment_id.hashCode ^
        replies_user_id.hashCode ^
        replies_comment_reactions.hashCode ^
        replies_comment_name.hashCode ^
        comment_type.hashCode ^
        comment_edited.hashCode ^
        image_or_video.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        updated_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}

class ReplayUserIdModel {
  String? id;
  String? first_name;
  String? last_name;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? profile_pic;
  String? cover_pic;
  String? user_status;
  String? gender;
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
  String? user_nickname;
  String? user_about;
  String? present_town;
  String? reset_password_token_expires;
  String? user_role;
  String? lock_profile;
  String? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? date_of_birth_show_type;
  ReplayUserIdModel({
    this.id,
    this.first_name,
    this.last_name,
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
    this.user_nickname,
    this.user_about,
    this.present_town,
    this.reset_password_token_expires,
    this.user_role,
    this.lock_profile,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.date_of_birth_show_type,
  });

  ReplayUserIdModel copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? username,
    String? email,
    String? phone,
    String? password,
    String? profile_pic,
    String? cover_pic,
    String? user_status,
    String? gender,
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
    String? user_nickname,
    String? user_about,
    String? present_town,
    String? reset_password_token_expires,
    String? user_role,
    String? lock_profile,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
    String? date_of_birth_show_type,
  }) {
    return ReplayUserIdModel(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
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
      user_nickname: user_nickname ?? this.user_nickname,
      user_about: user_about ?? this.user_about,
      present_town: present_town ?? this.present_town,
      reset_password_token_expires:
          reset_password_token_expires ?? this.reset_password_token_expires,
      user_role: user_role ?? this.user_role,
      lock_profile: lock_profile ?? this.lock_profile,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      date_of_birth_show_type:
          date_of_birth_show_type ?? this.date_of_birth_show_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'user_status': user_status,
      'gender': gender,
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
      'user_nickname': user_nickname,
      'user_about': user_about,
      'present_town': present_town,
      'reset_password_token_expires': reset_password_token_expires,
      'user_role': user_role,
      'lock_profile': lock_profile,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'date_of_birth_show_type': date_of_birth_show_type,
    };
  }

  factory ReplayUserIdModel.fromMap(Map<String, dynamic> map) {
    return ReplayUserIdModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      profile_pic:
          map['profile_pic'] != null ? map['profile_pic'] as String : null,
      cover_pic: map['cover_pic'] != null ? map['cover_pic'] as String : null,
      user_status:
          map['user_status'] != null ? map['user_status'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      date_of_birth:
          map['date_of_birth'] != null ? map['date_of_birth'] as String : null,
      user_bio: map['user_bio'] != null ? map['user_bio'] as String : null,
      passport: map['passport'] != null ? map['passport'] as String : null,
      last_login:
          map['last_login'] != null ? map['last_login'] as String : null,
      user_2fa_status: map['user_2fa_status'] != null
          ? map['user_2fa_status'] as String
          : null,
      secondary_email: map['secondary_email'] != null
          ? map['secondary_email'] as String
          : null,
      recovery_email: map['recovery_email'] != null
          ? map['recovery_email'] as String
          : null,
      relation_status: map['relation_status'] != null
          ? map['relation_status'] as String
          : null,
      home_town: map['home_town'] != null ? map['home_town'] as String : null,
      birth_place:
          map['birth_place'] != null ? map['birth_place'] as String : null,
      blood_group:
          map['blood_group'] != null ? map['blood_group'] as String : null,
      reset_password_token: map['reset_password_token'] != null
          ? map['reset_password_token'] as String
          : null,
      user_nickname:
          map['user_nickname'] != null ? map['user_nickname'] as String : null,
      user_about:
          map['user_about'] != null ? map['user_about'] as String : null,
      present_town:
          map['present_town'] != null ? map['present_town'] as String : null,
      reset_password_token_expires: map['reset_password_token_expires'] != null
          ? map['reset_password_token_expires'] as String
          : null,
      user_role: map['user_role'] != null ? map['user_role'] as String : null,
      lock_profile:
          map['lock_profile'] != null ? map['lock_profile'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
      date_of_birth_show_type: map['date_of_birth_show_type'] != null
          ? map['date_of_birth_show_type'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplayUserIdModel.fromJson(String source) =>
      ReplayUserIdModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReplayUserIdModel(id: $id, first_name: $first_name, last_name: $last_name, username: $username, email: $email, phone: $phone, password: $password, profile_pic: $profile_pic, cover_pic: $cover_pic, user_status: $user_status, gender: $gender, religion: $religion, date_of_birth: $date_of_birth, user_bio: $user_bio, passport: $passport, last_login: $last_login, user_2fa_status: $user_2fa_status, secondary_email: $secondary_email, recovery_email: $recovery_email, relation_status: $relation_status, home_town: $home_town, birth_place: $birth_place, blood_group: $blood_group, reset_password_token: $reset_password_token, user_nickname: $user_nickname, user_about: $user_about, present_town: $present_town, reset_password_token_expires: $reset_password_token_expires, user_role: $user_role, lock_profile: $lock_profile, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, date_of_birth_show_type: $date_of_birth_show_type)';
  }

  @override
  bool operator ==(covariant ReplayUserIdModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.profile_pic == profile_pic &&
        other.cover_pic == cover_pic &&
        other.user_status == user_status &&
        other.gender == gender &&
        other.religion == religion &&
        other.date_of_birth == date_of_birth &&
        other.user_bio == user_bio &&
        other.passport == passport &&
        other.last_login == last_login &&
        other.user_2fa_status == user_2fa_status &&
        other.secondary_email == secondary_email &&
        other.recovery_email == recovery_email &&
        other.relation_status == relation_status &&
        other.home_town == home_town &&
        other.birth_place == birth_place &&
        other.blood_group == blood_group &&
        other.reset_password_token == reset_password_token &&
        other.user_nickname == user_nickname &&
        other.user_about == user_about &&
        other.present_town == present_town &&
        other.reset_password_token_expires == reset_password_token_expires &&
        other.user_role == user_role &&
        other.lock_profile == lock_profile &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.update_by == update_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v &&
        other.date_of_birth_show_type == date_of_birth_show_type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        profile_pic.hashCode ^
        cover_pic.hashCode ^
        user_status.hashCode ^
        gender.hashCode ^
        religion.hashCode ^
        date_of_birth.hashCode ^
        user_bio.hashCode ^
        passport.hashCode ^
        last_login.hashCode ^
        user_2fa_status.hashCode ^
        secondary_email.hashCode ^
        recovery_email.hashCode ^
        relation_status.hashCode ^
        home_town.hashCode ^
        birth_place.hashCode ^
        blood_group.hashCode ^
        reset_password_token.hashCode ^
        user_nickname.hashCode ^
        user_about.hashCode ^
        present_town.hashCode ^
        reset_password_token_expires.hashCode ^
        user_role.hashCode ^
        lock_profile.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode ^
        date_of_birth_show_type.hashCode;
  }
}

class ReplayReactionModel {
  String? id;
  String? post_id;
  String? post_single_item_id;
  String? user_id;
  String? comment_id;
  String? comment_replies_id;
  String? reaction_type;
  int? v;
  ReplayReactionModel({
    this.id,
    this.post_id,
    this.post_single_item_id,
    this.user_id,
    this.comment_id,
    this.comment_replies_id,
    this.reaction_type,
    this.v,
  });

  ReplayReactionModel copyWith({
    String? id,
    String? post_id,
    String? post_single_item_id,
    String? user_id,
    String? comment_id,
    String? comment_replies_id,
    String? reaction_type,
    int? v,
  }) {
    return ReplayReactionModel(
      id: id ?? this.id,
      post_id: post_id ?? this.post_id,
      post_single_item_id: post_single_item_id ?? this.post_single_item_id,
      user_id: user_id ?? this.user_id,
      comment_id: comment_id ?? this.comment_id,
      comment_replies_id: comment_replies_id ?? this.comment_replies_id,
      reaction_type: reaction_type ?? this.reaction_type,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'post_id': post_id,
      'post_single_item_id': post_single_item_id,
      'user_id': user_id,
      'comment_id': comment_id,
      'comment_replies_id': comment_replies_id,
      'reaction_type': reaction_type,
      '__v': v,
    };
  }

  factory ReplayReactionModel.fromMap(Map<String, dynamic> map) {
    return ReplayReactionModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
      post_single_item_id: map['post_single_item_id'] != null
          ? map['post_single_item_id'] as String
          : null,
      user_id: map['user_id'] != null ? map['user_id'] as String : null,
      comment_id:
          map['comment_id'] != null ? map['comment_id'] as String : null,
      comment_replies_id: map['comment_replies_id'] != null
          ? map['comment_replies_id'] as String
          : null,
      reaction_type:
          map['reaction_type'] != null ? map['reaction_type'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplayReactionModel.fromJson(String source) =>
      ReplayReactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReplayReactionModel(id: $id, post_id: $post_id, post_single_item_id: $post_single_item_id, user_id: $user_id, comment_id: $comment_id, comment_replies_id: $comment_replies_id, reaction_type: $reaction_type, v: $v)';
  }

  @override
  bool operator ==(covariant ReplayReactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.post_id == post_id &&
        other.post_single_item_id == post_single_item_id &&
        other.user_id == user_id &&
        other.comment_id == comment_id &&
        other.comment_replies_id == comment_replies_id &&
        other.reaction_type == reaction_type &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        post_id.hashCode ^
        post_single_item_id.hashCode ^
        user_id.hashCode ^
        comment_id.hashCode ^
        comment_replies_id.hashCode ^
        reaction_type.hashCode ^
        v.hashCode;
  }
}
