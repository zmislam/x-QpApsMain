import 'reply_comment_user_model.dart';
import 'user_id.dart';

class CommentModel {
  String? id;
  String? comment_name;
  String? post_id;
  String? post_single_item_id;
  UserIdModel? user_id;
  String? comment_type;
  bool? comment_edited;
  String? image_or_video;
  String? link;
  String? link_title;
  String? link_description;
  String? link_image;
  String? status;
  String? ip_address;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  List<CommentReaction>? comment_reactions;
  List<CommentReplay>? replies;
  List<CommentFiles>? comment_files;
  int? v;

  /// ✅ NEW FIELD
  String? key;

  CommentModel({
    this.id,
    this.comment_name,
    this.post_id,
    this.post_single_item_id,
    this.user_id,
    this.comment_type,
    this.comment_edited,
    this.image_or_video,
    this.link,
    this.link_title,
    this.link_description,
    this.link_image,
    this.status,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.comment_reactions,
    this.replies,
    this.comment_files,
    this.v,
    this.key,
  });

  CommentModel copyWith({
    String? id,
    String? comment_name,
    String? post_id,
    String? post_single_item_id,
    UserIdModel? user_id,
    String? comment_type,
    bool? comment_edited,
    String? image_or_video,
    String? link,
    String? link_title,
    String? link_description,
    String? link_image,
    String? status,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    List<CommentReaction>? comment_reactions,
    List<CommentReplay>? replies,
    List<CommentFiles>? comment_files,
    int? v,
    String? key,
  }) {
    return CommentModel(
      id: id ?? this.id,
      comment_name: comment_name ?? this.comment_name,
      post_id: post_id ?? this.post_id,
      post_single_item_id: post_single_item_id ?? this.post_single_item_id,
      user_id: user_id ?? this.user_id,
      comment_type: comment_type ?? this.comment_type,
      comment_edited: comment_edited ?? this.comment_edited,
      image_or_video: image_or_video ?? this.image_or_video,
      link: link ?? this.link,
      link_title: link_title ?? this.link_title,
      link_description: link_description ?? this.link_description,
      link_image: link_image ?? this.link_image,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comment_reactions: comment_reactions ?? this.comment_reactions,
      replies: replies ?? this.replies,
      comment_files: comment_files ?? this.comment_files,
      v: v ?? this.v,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'comment_name': comment_name,
      'post_id': post_id,
      'post_single_item_id': post_single_item_id,
      'user_id': user_id?.toMap(),
      'comment_type': comment_type,
      'comment_edited': comment_edited,
      'image_or_video': image_or_video,
      'link': link,
      'link_title': link_title,
      'link_description': link_description,
      'link_image': link_image,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'comment_reactions': comment_reactions?.map((e) => e.toMap()).toList(),
      'replies': replies?.map((e) => e.toMap()).toList(),
      'comment_files': comment_files?.map((e) => e.toMap()).toList(),
      '__v': v,
      'key': key,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['_id'],
      comment_name: map['comment_name'],
      post_id: map['post_id'],
      post_single_item_id: map['post_single_item_id'],
      user_id: map['user_id'] is Map<String, dynamic>
          ? UserIdModel.fromMap(map['user_id'])
          : null,
      comment_type: map['comment_type'],
      comment_edited: map['comment_edited'],
      image_or_video: map['image_or_video'],
      link: map['link'],
      link_title: map['link_title'],
      link_description: map['link_description'],
      link_image: map['link_image'],
      status: map['status'],
      ip_address: map['ip_address'],
      created_by: map['created_by'],
      updated_by: map['updated_by'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      comment_reactions: map['comment_reactions'] != null
          ? List<CommentReaction>.from(
          map['comment_reactions'].map((x) => CommentReaction.fromMap(x)))
          : null,
      replies: map['replies'] != null
          ? List<CommentReplay>.from(
          map['replies'].map((x) => CommentReplay.fromMap(x)))
          : null,
      comment_files: map['comment_files'] != null
          ? List<CommentFiles>.from(
          map['comment_files'].map((x) => CommentFiles.fromMap(x)))
          : null,
      v: map['__v'],
      key: map['key'],
    );
  }
}

// ─────────────────────────────────────────────
// COMMENT REACTION
// ─────────────────────────────────────────────

class CommentReaction {
  String? id;
  String? post_id;
  String? post_single_item_id;
  String? user_id;
  String? comment_id;
  String? comment_replies_id;
  String? reaction_type;
  int? v;

  /// ✅ NEW FIELD
  String? key;

  CommentReaction({
    this.id,
    this.post_id,
    this.post_single_item_id,
    this.user_id,
    this.comment_id,
    this.comment_replies_id,
    this.reaction_type,
    this.v,
    this.key,
  });

  CommentReaction copyWith({
    String? id,
    String? post_id,
    String? post_single_item_id,
    String? user_id,
    String? comment_id,
    String? comment_replies_id,
    String? reaction_type,
    int? v,
    String? key,
  }) {
    return CommentReaction(
      id: id ?? this.id,
      post_id: post_id ?? this.post_id,
      post_single_item_id: post_single_item_id ?? this.post_single_item_id,
      user_id: user_id ?? this.user_id,
      comment_id: comment_id ?? this.comment_id,
      comment_replies_id: comment_replies_id ?? this.comment_replies_id,
      reaction_type: reaction_type ?? this.reaction_type,
      v: v ?? this.v,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': post_id,
      'post_single_item_id': post_single_item_id,
      'user_id': user_id,
      'comment_id': comment_id,
      'comment_replies_id': comment_replies_id,
      'reaction_type': reaction_type,
      'v': v,
      'key': key,
    };
  }

  factory CommentReaction.fromMap(Map<String, dynamic> map) {
    return CommentReaction(
      id: map['id'],
      post_id: map['post_id'],
      post_single_item_id: map['post_single_item_id'],
      user_id: map['user_id'],
      comment_id: map['comment_id'],
      comment_replies_id: map['comment_replies_id'],
      reaction_type: map['reaction_type'],
      v: map['v'],
      key: map['key'],
    );
  }
}

// ─────────────────────────────────────────────
// COMMENT REPLAY
// ─────────────────────────────────────────────

class CommentReplay {
  String? id;
  String? comment_id;
  ReplyCommentUserIdModel? replies_user_id;
  String? post_id;
  String? replies_comment_name;
  String? comment_type;
  bool? comment_edited;
  String? image_or_video;
  String? link;
  String? link_title;
  String? link_description;
  String? link_image;
  String? status;
  String? ip_address;
  String? created_by;
  String? updated_by;
  String? createdAt;
  String? updatedAt;
  List<RepliesCommentReaction>? replies_comment_reactions;
  int? v;

  /// ✅ NEW FIELD
  String? key;

  CommentReplay({
    this.id,
    this.comment_id,
    this.replies_user_id,
    this.post_id,
    this.replies_comment_name,
    this.comment_type,
    this.comment_edited,
    this.image_or_video,
    this.link,
    this.link_title,
    this.link_description,
    this.link_image,
    this.status,
    this.ip_address,
    this.created_by,
    this.updated_by,
    this.createdAt,
    this.updatedAt,
    this.replies_comment_reactions,
    this.v,
    this.key,
  });

  CommentReplay copyWith({
    String? id,
    String? comment_id,
    ReplyCommentUserIdModel? replies_user_id,
    String? post_id,
    String? replies_comment_name,
    String? comment_type,
    bool? comment_edited,
    String? image_or_video,
    String? link,
    String? link_title,
    String? link_description,
    String? link_image,
    String? status,
    String? ip_address,
    String? created_by,
    String? updated_by,
    String? createdAt,
    String? updatedAt,
    List<RepliesCommentReaction>? replies_comment_reactions,
    int? v,
    String? key,
  }) {
    return CommentReplay(
      id: id ?? this.id,
      comment_id: comment_id ?? this.comment_id,
      replies_user_id: replies_user_id ?? this.replies_user_id,
      post_id: post_id ?? this.post_id,
      replies_comment_name: replies_comment_name ?? this.replies_comment_name,
      comment_type: comment_type ?? this.comment_type,
      comment_edited: comment_edited ?? this.comment_edited,
      image_or_video: image_or_video ?? this.image_or_video,
      link: link ?? this.link,
      link_title: link_title ?? this.link_title,
      link_description: link_description ?? this.link_description,
      link_image: link_image ?? this.link_image,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      updated_by: updated_by ?? this.updated_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      replies_comment_reactions:
      replies_comment_reactions ?? this.replies_comment_reactions,
      v: v ?? this.v,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment_id': comment_id,
      'replies_user_id': replies_user_id?.toMap(),
      'post_id': post_id,
      'replies_comment_name': replies_comment_name,
      'comment_type': comment_type,
      'comment_edited': comment_edited,
      'image_or_video': image_or_video,
      'link': link,
      'link_title': link_title,
      'link_description': link_description,
      'link_image': link_image,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'updated_by': updated_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'replies_comment_reactions':
      replies_comment_reactions?.map((e) => e.toMap()).toList(),
      'v': v,
      'key': key,
    };
  }

  factory CommentReplay.fromMap(Map<String, dynamic> map) {
    return CommentReplay(
      id: map['_id'],
      comment_id: map['comment_id'],
      replies_user_id: map['replies_user_id'] != null
          ? ReplyCommentUserIdModel.fromMap(map['replies_user_id'])
          : null,
      post_id: map['post_id'],
      replies_comment_name: map['replies_comment_name'],
      comment_type: map['comment_type'],
      comment_edited: map['comment_edited'],
      image_or_video: map['image_or_video'],
      link: map['link'],
      link_title: map['link_title'],
      link_description: map['link_description'],
      link_image: map['link_image'],
      status: map['status'],
      ip_address: map['ip_address'],
      created_by: map['created_by'],
      updated_by: map['updated_by'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      replies_comment_reactions: map['replies_comment_reactions'] != null
          ? List<RepliesCommentReaction>.from(map['replies_comment_reactions']
          .map((x) => RepliesCommentReaction.fromMap(x)))
          : null,
      v: map['v'],
      key: map['key'],
    );
  }
}

// ─────────────────────────────────────────────
// REPLIES COMMENT REACTION
// ─────────────────────────────────────────────

class RepliesCommentReaction {
  String? id;
  String? post_id;
  String? post_single_item_id;
  String? user_id;
  String? comment_id;
  String? comment_replies_id;
  String? reaction_type;
  int? v;

  /// ✅ NEW FIELD
  String? key;

  RepliesCommentReaction({
    this.id,
    this.post_id,
    this.post_single_item_id,
    this.user_id,
    this.comment_id,
    this.comment_replies_id,
    this.reaction_type,
    this.v,
    this.key,
  });

  RepliesCommentReaction copyWith({
    String? id,
    String? post_id,
    String? post_single_item_id,
    String? user_id,
    String? comment_id,
    String? comment_replies_id,
    String? reaction_type,
    int? v,
    String? key,
  }) {
    return RepliesCommentReaction(
      id: id ?? this.id,
      post_id: post_id ?? this.post_id,
      post_single_item_id: post_single_item_id ?? this.post_single_item_id,
      user_id: user_id ?? this.user_id,
      comment_id: comment_id ?? this.comment_id,
      comment_replies_id: comment_replies_id ?? this.comment_replies_id,
      reaction_type: reaction_type ?? this.reaction_type,
      v: v ?? this.v,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'post_id': post_id,
      'post_single_item_id': post_single_item_id,
      'user_id': user_id,
      'comment_id': comment_id,
      'comment_replies_id': comment_replies_id,
      'reaction_type': reaction_type,
      '__v': v,
      'key': key,
    };
  }

  factory RepliesCommentReaction.fromMap(Map<String, dynamic> map) {
    return RepliesCommentReaction(
      id: map['_id'],
      post_id: map['post_id'],
      post_single_item_id: map['post_single_item_id'],
      user_id: map['user_id'],
      comment_id: map['comment_id'],
      comment_replies_id: map['comment_replies_id'],
      reaction_type: map['reaction_type'],
      v: map['__v'],
      key: map['key'],
    );
  }
}

// ─────────────────────────────────────────────
// COMMENT FILES
// ─────────────────────────────────────────────

class CommentFiles {
  String? id;
  String? file;
  String? key;

  CommentFiles({
    this.id,
    this.file,
    this.key,
  });

  CommentFiles copyWith({
    String? id,
    String? file,
    String? key,
  }) {
    return CommentFiles(
      id: id ?? this.id,
      file: file ?? this.file,
      key: key ?? this.key,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'file': file,
      'key': key,
    };
  }

  factory CommentFiles.fromMap(Map<String, dynamic> map) {
    return CommentFiles(
      id: map['_id'],
      file: map['file'],
      key: map['key'],
    );
  }
}

