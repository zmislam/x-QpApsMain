import 'reels_comment_model.dart';
import 'reels_relpy_comment_reaction_model.dart';

class ReelsCommentReplyModel {
  String? id;
  String? comment_id;
  ReelsUserIdModel? replies_user_id;
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
  String? key; // <-- added
  List<ReelsRepliesCommentReaction>? replies_comment_reactions;
  int? v;

  ReelsCommentReplyModel({
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
    this.key, // <-- added
    this.replies_comment_reactions,
    this.v,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      'key': key, // <-- added
      'replies_comment_reactions': replies_comment_reactions,
      'v': v,
    };
  }

  factory ReelsCommentReplyModel.fromMap(Map<String, dynamic> map) {
    return ReelsCommentReplyModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      comment_id:
          map['comment_id'] != null ? map['comment_id'] as String : null,
      replies_user_id: map['replies_user_id'] != null
          ? ReelsUserIdModel.fromMap(
              map['replies_user_id'] as Map<String, dynamic>)
          : null,
      post_id: map['post_id'] != null ? map['post_id'] as String : null,
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
      link: map['link'] != null ? map['link'] as String : null,
      link_title:
          map['link_title'] != null ? map['link_title'] as String : null,
      link_description: map['link_description'] != null
          ? map['link_description'] as String
          : null,
      link_image:
          map['link_image'] != null ? map['link_image'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      updated_by:
          map['updated_by'] != null ? map['updated_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      key: map['key'] != null ? map['key'] as String : null, // <-- added
      replies_comment_reactions: map['replies_comment_reactions'] != null
          ? (map['replies_comment_reactions'] as List)
              .map((e) => ReelsRepliesCommentReaction.fromMap(e))
              .toList()
          : null,
      v: map['v'] != null ? map['v'] as int : null,
    );
  }

  @override
  String toString() {
    return 'ReelsCommentReplyModel(id: $id, comment_id: $comment_id, replies_user_id: $replies_user_id, post_id: $post_id, replies_comment_name: $replies_comment_name, comment_type: $comment_type, comment_edited: $comment_edited, image_or_video: $image_or_video, link: $link, link_title: $link_title, link_description: $link_description, link_image: $link_image, status: $status, ip_address: $ip_address, created_by: $created_by, updated_by: $updated_by, createdAt: $createdAt, updatedAt: $updatedAt, key: $key, v: $v)';
  }
}
