import 'dart:convert';

/// V2 Reel Comment model — maps to backend `reel_v2_comments` collection.
class ReelCommentModel {
  String? id;
  String? reelId;
  String? userId;
  String? parentId;
  String? text;
  List<String>? mentionedUserIds;
  String? gifUrl;
  int? likeCount;
  int? replyCount;
  bool? isPinned;
  bool? isEdited;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  // Populated data
  CommentAuthorModel? user;
  bool? isLiked;
  String? myReaction;
  List<ReelCommentModel>? replies;

  ReelCommentModel({
    this.id,
    this.reelId,
    this.userId,
    this.parentId,
    this.text,
    this.mentionedUserIds,
    this.gifUrl,
    this.likeCount,
    this.replyCount,
    this.isPinned,
    this.isEdited,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.isLiked,
    this.myReaction,
    this.replies,
  });

  factory ReelCommentModel.fromMap(Map<String, dynamic> map) {
    return ReelCommentModel(
      id: map['_id'] as String?,
      reelId: map['reel_id'] as String?,
      userId: map['user_id'] is String
          ? map['user_id'] as String?
          : (map['user_id'] is Map ? map['user_id']['_id'] as String? : null),
      parentId: map['parent_id'] as String?,
      text: map['text'] as String?,
      mentionedUserIds: map['mentioned_user_ids'] != null
          ? List<String>.from(map['mentioned_user_ids'])
          : null,
      gifUrl: map['gif_url'] as String?,
      likeCount: map['like_count'] as int? ?? 0,
      replyCount: map['reply_count'] as int? ?? 0,
      isPinned: map['is_pinned'] as bool?,
      isEdited: map['is_edited'] as bool?,
      isDeleted: map['is_deleted'] as bool?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      user: map['user_id'] is Map
          ? CommentAuthorModel.fromMap(map['user_id'] as Map<String, dynamic>)
          : null,
      isLiked: map['is_liked'] as bool?,
      myReaction: map['my_reaction'] as String?,
      replies: map['replies'] != null
          ? (map['replies'] as List)
              .map((r) => ReelCommentModel.fromMap(r as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) '_id': id,
      'reel_id': reelId,
      'text': text,
      if (parentId != null) 'parent_id': parentId,
      if (mentionedUserIds != null) 'mentioned_user_ids': mentionedUserIds,
      if (gifUrl != null) 'gif_url': gifUrl,
    };
  }

  String toJson() => json.encode(toMap());

  factory ReelCommentModel.fromJson(String source) =>
      ReelCommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CommentAuthorModel {
  String? id;
  String? firstName;
  String? lastName;
  String? profileImg;
  bool? isVerified;

  CommentAuthorModel({
    this.id,
    this.firstName,
    this.lastName,
    this.profileImg,
    this.isVerified,
  });

  String get displayName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory CommentAuthorModel.fromMap(Map<String, dynamic> map) {
    return CommentAuthorModel(
      id: map['_id'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      profileImg: map['profile_img'] as String?,
      isVerified: map['is_verified'] as bool?,
    );
  }
}
