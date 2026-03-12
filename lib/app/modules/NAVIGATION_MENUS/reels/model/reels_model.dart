// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:quantum_possibilities_flutter/app/modules/NAVIGATION_MENUS/reels/model/reels_reacted_user_model.dart';
import '../sub_menu/create_reels/model/create_reels_model.dart';
import 'reels_comment_model.dart';

class ReelsModel {
  String? id;
  String? campaign_id;
  String? description;
  String? user_id;
  String? video;
  String? reels_privacy;
  String? status;
  String? ipAddress;
  String? createdAt;
  String? updatedAt;
  ReelUserModel? reel_user;
  List<ReelsReactionModel>? reactions;
  List<String>? image;
  int? comment_count;
  int? reply_count;
  int? total_comments;
  int? reaction_count;
  int? dislike_reactions_count;
  int? view_count;
  num? aspectRatio;
  String? link;
  String? url;
  String? location;
  String? reelsType;
  bool? repost;
  int? total_share_count;
  bool? enabled_comment;
  String? repost_reel_id;
  String? music_id;
  String? live_post_id;
  String? data_sort_property;
  String? modification_date;
  String? key;
  bool? is_from_friend;
  bool? is_from_followed_page;
  PriorityInfo? priority_info;
  List<dynamic>? repost_reel;
  List<ReelsCommentModel>? comments;
  ReelsDataModel? reelsDataModel;
  RepostFromUser? repost_from_user;
  ReelsModel({
    this.id,
    this.campaign_id,
    this.description,
    this.user_id,
    this.video,
    this.reels_privacy,
    this.status,
    this.ipAddress,
    this.createdAt,
    this.updatedAt,
    this.reel_user,
    this.reactions,
    this.image,
    this.comment_count,
    this.reply_count,
    this.total_comments,
    this.reaction_count,
    this.dislike_reactions_count,
    this.view_count,
    this.aspectRatio,
    this.link,
    this.url,
    this.location,
    this.reelsType,
    this.repost,
    this.total_share_count,
    this.enabled_comment,
    this.repost_reel_id,
    this.music_id,
    this.live_post_id,
    this.data_sort_property,
    this.modification_date,
    this.key,
    this.is_from_friend,
    this.is_from_followed_page,
    this.priority_info,
    this.repost_reel,
    this.reelsDataModel,
    this.repost_from_user,
    this.comments,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'campaign_id': campaign_id,
      'description': description,
      'user_id': user_id,
      'video': video,
      'reels_privacy': reels_privacy,
      'status': status,
      'ip_address': ipAddress,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'reel_user': reel_user?.toMap(),
      'image': image?.toList(),
      // 'reactions': reactions.map((x) => x?.toMap()).toList(),
      'comment_count': comment_count,
      'reply_count': reply_count,
      'total_comments': total_comments,
      'reaction_count': reaction_count,
      'dislike_reactions_count': dislike_reactions_count,
      'view_count': view_count,
      'aspectRatio': aspectRatio,
      'location': location,
      'link': link,
      'url': url,
      'reels_type': reelsType,
      'repost': repost,
      'total_share_count': total_share_count,
      'enabled_comment': enabled_comment,
      'repost_reel_id': repost_reel_id,
      'music_id': music_id,
      'live_post_id': live_post_id,
      'data_sort_property': data_sort_property,
      'modification_date': modification_date,
      'key': key,
      'is_from_friend': is_from_friend,
      'is_from_followed_page': is_from_followed_page,
      'priority_info': priority_info?.toMap(),
      'repost_reel': repost_reel,
      'reels_data': reelsDataModel?.toMap(),
      'repost_from_user': repost_from_user?.toMap(),
      'comments': comments != null ? comments!.map((e) => e.toMap()).toList() : [],
    };
  }

  factory ReelsModel.fromMap(Map<String, dynamic> map) {
    return ReelsModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      campaign_id:
      map['campaign_id'] != null ? map['campaign_id'] as String : null,
      description:
      map['description'] != null ? map['description'] as String : null,
      user_id: map['user_id'] != null
          ? (map['user_id'] is Map ? map['user_id']['_id'] as String : map['user_id'] as String)
          : null,
      video: map['video'] != null ? map['video'] as String : null,
      reels_privacy:
      map['reels_privacy'] != null ? map['reels_privacy'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ipAddress: map['ip_address'] != null
          ? map['ip_address'] as String
          : map['ipAddress'] != null
              ? map['ipAddress'] as String
              : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      reel_user: map['reel_user'] != null
          ? ReelUserModel.fromMap(map['reel_user'] as Map<String, dynamic>)
          : map['user'] != null
              ? ReelUserModel.fromMap(map['user'] as Map<String, dynamic>)
              : (map['user_id'] != null && map['user_id'] is Map)
                  ? ReelUserModel.fromMap(map['user_id'] as Map<String, dynamic>)
                  : null,
      reelsDataModel: map['reels_data'] != null
          ? ReelsDataModel.fromMap(map['reels_data'])
          : null,
      repost_from_user: map['repost_from_user'] != null
          ? RepostFromUser.fromMap(map['repost_from_user'])
          : null,
      reactions: map['reactions'] != null
          ? (map['reactions'] as List)
          .map((e) => ReelsReactionModel.fromMap(e))
          .toList()
          : null,
      image: map['image'] != null
          ? (map['image'] as List).map((e) => e.toString()).toList()
          : null,
      comment_count:
      map['comment_count'] != null ? map['comment_count'] as int : null,
      reply_count: map['reply_count'] != null ? map['reply_count'] as int : null,
      total_comments:
      map['total_comments'] != null ? map['total_comments'] as int : null,
      reaction_count:
      map['reaction_count'] != null ? map['reaction_count'] as int
          : map['like_count'] != null ? map['like_count'] as int
          : null,
      dislike_reactions_count: map['dislike_reactions_count'] != null
          ? map['dislike_reactions_count'] as int
          : null,
      view_count: map['view_count'] != null ? map['view_count'] as int : null,
      aspectRatio:
      map['aspectRatio'] != null ? map['aspectRatio'] as num : null,
      repost: map['repost'] != null ? map['repost'] as bool : null,
      link: map['link'] != null ? map['link'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      reelsType: map['reels_type'] != null ? map['reels_type'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      is_from_friend: map['is_from_friend'] != null
          ? map['is_from_friend'] as bool
          : null,
      is_from_followed_page: map['is_from_followed_page'] != null
          ? map['is_from_followed_page'] as bool
          : null,
      priority_info: map['priority_info'] != null
          ? PriorityInfo.fromMap(map['priority_info'] as Map<String, dynamic>)
          : null,
      data_sort_property: map['data_sort_property'] != null
          ? map['data_sort_property'] as String
          : null,
      modification_date: map['modification_date'] != null
          ? map['modification_date'] as String
          : null,
      key: map['key'] != null ? map['key'] as String : null,
      enabled_comment: map['enabled_comment'] != null
          ? map['enabled_comment'] as bool
          : null,
      repost_reel_id: map['repost_reel_id'] != null
          ? map['repost_reel_id'] as String
          : null,
      music_id: map['music_id'] != null ? map['music_id'] as String : null,
      live_post_id:
      map['live_post_id'] != null ? map['live_post_id'] as String : null,
      repost_reel: map['repost_reel'] != null
          ? List<dynamic>.from(map['repost_reel'] as List)
          : null,
      comments: map['comments'] != null ?(map['comments'] as List)
          .map((e) => ReelsCommentModel.fromMap(e))
          .toList()
          : null,
      total_share_count: map['total_share_count'] != null ? map['total_share_count'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsModel.fromJson(String source) =>
      ReelsModel.fromMap(json.decode(source) as Map<String, dynamic>);




  @override
  String toString() {
    return 'ReelsModel(id: $id, view_count:$view_count, campaign_id:$campaign_id, image: $image, reels_type:$reelsType, repost_from_user: $repost_from_user, repost: $repost, total_share_count: $total_share_count, description: $description, user_id: $user_id, video: $video, reels_privacy: $reels_privacy, status: $status, ipAddress: $ipAddress, createdAt: $createdAt, updatedAt: $updatedAt, reel_user: $reel_user, reactions: $reactions, commentCount: $comment_count, replyCount: $reply_count, totalComments: $total_comments, reactionCount: $reaction_count, dislikeReactionsCount: $dislike_reactions_count, location: $location, link: $link, enabled_comment: $enabled_comment, data_sort_property: $data_sort_property, is_from_friend: $is_from_friend, is_from_followed_page: $is_from_followed_page, priority_info: $priority_info)';
  }

  @override
  bool operator ==(covariant ReelsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.campaign_id == campaign_id &&
        other.user_id == user_id &&
        other.video == video &&
        other.view_count == view_count &&
        other.reelsType == reelsType &&
        other.repost_from_user == repost_from_user &&
        other.reels_privacy == reels_privacy &&
        other.status == status &&
        other.ipAddress == ipAddress &&
        other.link == link &&
        other.location == location &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.reel_user == reel_user &&
        listEquals(other.reactions, reactions) &&
        listEquals(other.image, image) &&
        other.comment_count == comment_count &&
        other.reply_count == reply_count &&
        other.total_comments == total_comments &&
        other.reaction_count == reaction_count &&
        other.dislike_reactions_count == dislike_reactions_count &&
        other.repost == repost &&
        other.total_share_count == total_share_count &&
        other.enabled_comment == enabled_comment &&
        other.repost_reel_id == repost_reel_id &&
        other.music_id == music_id &&
        other.live_post_id == live_post_id &&
        other.data_sort_property == data_sort_property &&
        other.modification_date == modification_date &&
        other.key == key &&
        other.is_from_friend == is_from_friend &&
        other.is_from_followed_page == is_from_followed_page &&
        other.priority_info == priority_info &&
        listEquals(other.repost_reel, repost_reel);
  }

  @override
  int get hashCode {
    return id.hashCode ^
    description.hashCode ^
    campaign_id.hashCode ^
    user_id.hashCode ^
    video.hashCode ^
    reels_privacy.hashCode ^
    status.hashCode ^
    view_count.hashCode ^
    reelsType.hashCode ^
    ipAddress.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    reel_user.hashCode ^
    reactions.hashCode ^
    image.hashCode ^
    location.hashCode ^
    link.hashCode ^
    repost_from_user.hashCode ^
    comment_count.hashCode ^
    reply_count.hashCode ^
    total_comments.hashCode ^
    reaction_count.hashCode ^
    dislike_reactions_count.hashCode ^
    repost.hashCode ^
    total_share_count.hashCode ^
    enabled_comment.hashCode ^
    repost_reel_id.hashCode ^
    music_id.hashCode ^
    live_post_id.hashCode ^
    data_sort_property.hashCode ^
    modification_date.hashCode ^
    key.hashCode ^
    is_from_friend.hashCode ^
    is_from_followed_page.hashCode ^
    priority_info.hashCode ^
    repost_reel.hashCode;
  }

  ReelsModel copyWith({
    String? id,
    String? campaign_id,
    String? description,
    String? user_id,
    String? video,
    String? reels_privacy,
    String? status,
    String? ipAddress,
    String? createdAt,
    String? updatedAt,
    ReelUserModel? reel_user,
    List<ReelsReactionModel>? reactions,
    List<String>? image,
    int? comment_count,
    int? reaction_count,
    int? view_count,
    num? aspectRatio,
    String? link,
    String? url,
    String? location,
    String? reelsType,
    bool? repost,
    int? total_share_count,
    List<ReelsCommentModel>? comments,
    ReelsDataModel? reelsDataModel,
    RepostFromUser? repost_from_user,
    bool? enabled_comment,
    String? repost_reel_id,
    String? music_id,
    String? live_post_id,
    String? data_sort_property,
    String? modification_date,
    String? key,
    bool? is_from_friend,
    bool? is_from_followed_page,
    PriorityInfo? priority_info,
    List<dynamic>? repost_reel,
    int? reply_count,
    int? total_comments,
    int? dislike_reactions_count,
  }) {
    return ReelsModel(
      id: id ?? this.id,
      campaign_id: campaign_id ?? this.campaign_id,
      description: description ?? this.description,
      user_id: user_id ?? this.user_id,
      video: video ?? this.video,
      reels_privacy: reels_privacy ?? this.reels_privacy,
      status: status ?? this.status,
      ipAddress: ipAddress ?? this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reel_user: reel_user ?? this.reel_user,
      reactions: reactions ?? this.reactions,
      image: image ?? this.image,
      comment_count: comment_count ?? this.comment_count,
      reply_count: reply_count ?? this.reply_count,
      total_comments: total_comments ?? this.total_comments,
      reaction_count: reaction_count ?? this.reaction_count,
      dislike_reactions_count:
      dislike_reactions_count ?? this.dislike_reactions_count,
      view_count: view_count ?? this.view_count,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      link: link ?? this.link,
      url: url ?? this.url,
      location: location ?? this.location,
      reelsType: reelsType ?? this.reelsType,
      repost: repost ?? this.repost,
      total_share_count: total_share_count ?? this.total_share_count,
      comments: comments ?? this.comments,
      reelsDataModel: reelsDataModel ?? this.reelsDataModel,
      repost_from_user: repost_from_user ?? this.repost_from_user,
      enabled_comment: enabled_comment ?? this.enabled_comment,
      repost_reel_id: repost_reel_id ?? this.repost_reel_id,
      music_id: music_id ?? this.music_id,
      live_post_id: live_post_id ?? this.live_post_id,
      data_sort_property: data_sort_property ?? this.data_sort_property,
      modification_date: modification_date ?? this.modification_date,
      key: key ?? this.key,
      is_from_friend: is_from_friend ?? this.is_from_friend,
      is_from_followed_page:
      is_from_followed_page ?? this.is_from_followed_page,
      priority_info: priority_info ?? this.priority_info,
      repost_reel: repost_reel ?? this.repost_reel,
    );
  }
}

class RepostFromUser {
  String? id;
  String? page_id;
  String? page_user_name;
  String? first_name;
  String? last_name;
  String? username;
  String? profile_pic;
  RepostFromUser({
    this.id,
    this.page_id,
    this.first_name,
    this.last_name,
    this.username,
    this.page_user_name,
    this.profile_pic,
  });

  RepostFromUser copyWith({
    String? id,
    String? page_id,
    String? first_name,
    String? last_name,
    String? username,
    String? page_user_name,
    String? profile_pic,
  }) {
    return RepostFromUser(
      id: id ?? this.id,
      page_id: page_id ?? this.page_id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      username: username ?? this.username,
      page_user_name: page_user_name ?? this.page_user_name,
      profile_pic: profile_pic ?? this.profile_pic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'page_id': page_id,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'page_user_name': page_user_name,
      'profile_pic': profile_pic,
    };
  }

  factory RepostFromUser.fromMap(Map<String, dynamic> map) {
    return RepostFromUser(
      id: map['_id'] != null ? map['_id'] as String : null,
      page_id: map['page_id'] != null ? map['page_id'] as String : null,
      first_name:
      map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      username: map['username'] != null ? map['username'] as String : null,
      page_user_name: map['page_user_name'] != null ? map['page_user_name'] as String : null,
      profile_pic:
      map['profile_pic'] != null ? map['profile_pic'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RepostFromUser.fromJson(String source) =>
      RepostFromUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RepostFromUser(_id: $id,page_id: $page_id, first_name: $first_name, last_name: $last_name, username: $username,page_user_name:$page_user_name, profile_pic: $profile_pic)';
  }

  @override
  bool operator ==(covariant RepostFromUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.first_name == first_name &&
        other.page_user_name == page_user_name &&
        other.last_name == last_name &&
        other.page_id == page_id &&
        other.username == username &&
        other.profile_pic == profile_pic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    first_name.hashCode ^
    last_name.hashCode ^
    username.hashCode ^
    page_user_name.hashCode ^
    page_id.hashCode ^
    profile_pic.hashCode;
  }
}

class PriorityInfo {
  num? priority_no;
  num? relationship_multiplier;
  num? engagement_score;
  num? recency_score;
  bool? is_friend;
  bool? is_followed_page;
  num? view_priority_like_count;
  num? view_priority_comment_count;
  num? view_priority_view_count;
  PriorityInfo({
    this.priority_no,
    this.relationship_multiplier,
    this.engagement_score,
    this.recency_score,
    this.is_friend,
    this.is_followed_page,
    this.view_priority_like_count,
    this.view_priority_comment_count,
    this.view_priority_view_count,
  });

  PriorityInfo copyWith({
    num? priority_no,
    num? relationship_multiplier,
    num? engagement_score,
    num? recency_score,
    bool? is_friend,
    bool? is_followed_page,
    num? view_priority_like_count,
    num? view_priority_comment_count,
    num? view_priority_view_count,
  }) {
    return PriorityInfo(
      priority_no: priority_no ?? this.priority_no,
      relationship_multiplier:
      relationship_multiplier ?? this.relationship_multiplier,
      engagement_score: engagement_score ?? this.engagement_score,
      recency_score: recency_score ?? this.recency_score,
      is_friend: is_friend ?? this.is_friend,
      is_followed_page: is_followed_page ?? this.is_followed_page,
      view_priority_like_count:
      view_priority_like_count ?? this.view_priority_like_count,
      view_priority_comment_count:
      view_priority_comment_count ?? this.view_priority_comment_count,
      view_priority_view_count:
      view_priority_view_count ?? this.view_priority_view_count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'priority_no': priority_no,
      'relationship_multiplier': relationship_multiplier,
      'engagement_score': engagement_score,
      'recency_score': recency_score,
      'is_friend': is_friend,
      'is_followed_page': is_followed_page,
      'view_priority_like_count': view_priority_like_count,
      'view_priority_comment_count': view_priority_comment_count,
      'view_priority_view_count': view_priority_view_count,
    };
  }

  factory PriorityInfo.fromMap(Map<String, dynamic> map) {
    return PriorityInfo(
      priority_no:
      map['priority_no'] != null ? map['priority_no'] as num : null,
      relationship_multiplier: map['relationship_multiplier'] != null
          ? map['relationship_multiplier'] as num
          : null,
      engagement_score:
      map['engagement_score'] != null ? map['engagement_score'] as num : null,
      recency_score:
      map['recency_score'] != null ? map['recency_score'] as num : null,
      is_friend: map['is_friend'] != null ? map['is_friend'] as bool : null,
      is_followed_page: map['is_followed_page'] != null
          ? map['is_followed_page'] as bool
          : null,
      view_priority_like_count: map['view_priority_like_count'] != null
          ? map['view_priority_like_count'] as num
          : null,
      view_priority_comment_count: map['view_priority_comment_count'] != null
          ? map['view_priority_comment_count'] as num
          : null,
      view_priority_view_count: map['view_priority_view_count'] != null
          ? map['view_priority_view_count'] as num
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PriorityInfo.fromJson(String source) =>
      PriorityInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PriorityInfo(priority_no: $priority_no, relationship_multiplier: $relationship_multiplier, engagement_score: $engagement_score, recency_score: $recency_score, is_friend: $is_friend, is_followed_page: $is_followed_page, view_priority_like_count: $view_priority_like_count, view_priority_comment_count: $view_priority_comment_count, view_priority_view_count: $view_priority_view_count)';
  }

  @override
  bool operator ==(covariant PriorityInfo other) {
    if (identical(this, other)) return true;

    return other.priority_no == priority_no &&
        other.relationship_multiplier == relationship_multiplier &&
        other.engagement_score == engagement_score &&
        other.recency_score == recency_score &&
        other.is_friend == is_friend &&
        other.is_followed_page == is_followed_page &&
        other.view_priority_like_count == view_priority_like_count &&
        other.view_priority_comment_count == view_priority_comment_count &&
        other.view_priority_view_count == view_priority_view_count;
  }

  @override
  int get hashCode {
    return priority_no.hashCode ^
    relationship_multiplier.hashCode ^
    engagement_score.hashCode ^
    recency_score.hashCode ^
    is_friend.hashCode ^
    is_followed_page.hashCode ^
    view_priority_like_count.hashCode ^
    view_priority_comment_count.hashCode ^
    view_priority_view_count.hashCode;
  }
}
class ReelUserModel {
  String? id;
  String? page_id;
  String? page_user_name;
  String? first_name;
  String? last_name;
  String? username;
  String? email;
  String? phone;
  String? password;
  bool? isFollowing;
  String? profile_pic;
  String? cover_pic;
  String? user_status;
  String? gender;
  String? religion;
  String? date_of_birth;
  String? user_bio;
  String? language;
  ReelUserModel({
    this.id,
    this.page_id,
    this.page_user_name,
    this.first_name,
    this.last_name,
    this.username,
    this.email,
    this.phone,
    this.password,
    this.isFollowing,
    this.profile_pic,
    this.cover_pic,
    this.user_status,
    this.gender,
    this.religion,
    this.date_of_birth,
    this.user_bio,
    this.language,
  });

  ReelUserModel copyWith({
    String? id,
    String? page_id,
    String? page_user_name,
    String? first_name,
    String? last_name,
    String? username,
    String? email,
    String? phone,
    String? password,
    bool? isFollowing,
    String? profile_pic,
    String? cover_pic,
    String? user_status,
    String? gender,
    String? religion,
    String? date_of_birth,
    String? user_bio,
    String? language,
  }) {
    return ReelUserModel(
      id: id ?? this.id,
      page_id: page_id ?? this.page_id,
      page_user_name: page_user_name ?? this.page_user_name,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isFollowing: isFollowing ?? this.isFollowing,
      profile_pic: profile_pic ?? this.profile_pic,
      cover_pic: cover_pic ?? this.cover_pic,
      user_status: user_status ?? this.user_status,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      user_bio: user_bio ?? this.user_bio,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'page_id': page_id,
      'page_user_name': page_user_name,
      'first_name': first_name,
      'last_name': last_name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'isFollowing': isFollowing,
      'profile_pic': profile_pic,
      'cover_pic': cover_pic,
      'user_status': user_status,
      'gender': gender,
      'religion': religion,
      'date_of_birth': date_of_birth,
      'user_bio': user_bio,
      'language': language,
    };
  }

  factory ReelUserModel.fromMap(Map<String, dynamic> map) {
    return ReelUserModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      page_id: map['page_id'] != null ? map['page_id'] as String : null,
      page_user_name: map['page_user_name'] != null
          ? map['page_user_name'] as String
          : null,
      first_name:
      map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : '',
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      isFollowing: map['isFollowing'] != null ? map['isFollowing'] as bool : false,
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
      // language: map['language'] != null ? map['language'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelUserModel.fromJson(String source) =>
      ReelUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReelUserModel(id: $id,page_id:$page_id,page_user_name:$page_user_name, first_name: $first_name, last_name: $last_name, username: $username, email: $email, phone: $phone, password: $password, isFollowing:$isFollowing,profile_pic: $profile_pic, cover_pic: $cover_pic, user_status: $user_status, gender: $gender, religion: $religion, date_of_birth: $date_of_birth, user_bio: $user_bio, language: $language)';
  }

  @override
  bool operator ==(covariant ReelUserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.username == username &&
        other.isFollowing == isFollowing &&
        other.page_user_name == page_user_name &&
        other.email == email &&
        other.page_id == page_id &&
        other.phone == phone &&
        other.password == password &&
        other.profile_pic == profile_pic &&
        other.cover_pic == cover_pic &&
        other.user_status == user_status &&
        other.gender == gender &&
        other.religion == religion &&
        other.date_of_birth == date_of_birth &&
        other.user_bio == user_bio &&
        other.language == language;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    first_name.hashCode ^
    last_name.hashCode ^
    username.hashCode ^
    isFollowing.hashCode ^
    page_user_name.hashCode ^
    page_id.hashCode ^
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
    language.hashCode;
  }
}

class ReelsReactionModel {
  ReelsReactedUserIdModel? user_id;
  ReelsReactedUserIdModel? user_id_2;
  ReelsReactedUserIdModel? reacted_user;
  String? reaction_type;
  ReelsReactionModel(
      {this.user_id, this.user_id_2, this.reaction_type, this.reacted_user});

  ReelsReactionModel copyWith({
    ReelsReactedUserIdModel? user_id,
    ReelsReactedUserIdModel? user_id_2,
    String? reaction_type,
    ReelsReactedUserIdModel? reacted_user,
  }) {
    return ReelsReactionModel(
        user_id: user_id ?? this.user_id,
        user_id_2: user_id ?? this.user_id_2,
        reaction_type: reaction_type ?? this.reaction_type,
        reacted_user: reacted_user ?? this.reacted_user);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': user_id ?? user_id_2,
      'reaction_type': reaction_type,
      'reacted_user': reacted_user
    };
  }

  factory ReelsReactionModel.fromMap(Map<String, dynamic> map) {
    return ReelsReactionModel(
      user_id: map['reacted_user'] != null
          ? ReelsReactedUserIdModel.fromMap(
          map['reacted_user'] as Map<String, dynamic>)
          : null,
      user_id_2: map['user_id'] != null
          ? ReelsReactedUserIdModel.fromMap(
          map['user_id'] as Map<String, dynamic>)
          : null,
      reaction_type:
      map['reaction_type'] != null ? map['reaction_type'] as String : null,
      reacted_user: map['reacted_user'] != null
          ? ReelsReactedUserIdModel.fromMap(
          map['reacted_user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelsReactionModel.fromJson(String source) =>
      ReelsReactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ReelsReactionModel( reaction_type: $reaction_type, reacted_user:$reacted_user)';

  @override
  bool operator ==(covariant ReelsReactionModel other) {
    if (identical(this, other)) return true;

    return
      // other.user_id == user_id &&
      other.reaction_type == reaction_type &&
          other.reacted_user == reacted_user;
  }

  @override
  int get hashCode =>
      //  user_id.hashCode ^
  reaction_type.hashCode ^ reacted_user.hashCode;
}
