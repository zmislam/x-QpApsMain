// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:quantum_possibilities_flutter/app/models/user_id.dart';

class NotificationModel {
  String? id;
  String? notification_type;
  NotificationData? notification_data;
  String? message;
  String? resource_title;
  String? resource_id;
  ResourceObject? resourceObject;
  UserIdModel? notification_sender_id;
  UserIdModel? notification_receiver_id;
  bool? notification_seen;
  String? status;
  String? ip_address;
  String? created_by;
  String? update_by;
  String? createdAt;
  String? updatedAt;
  int? v;
  NotificationModel({
    this.id,
    this.notification_type,
    this.notification_data,
    this.message,
    this.resource_title,
    this.resource_id,
    this.resourceObject,
    this.notification_sender_id,
    this.notification_receiver_id,
    this.notification_seen,
    this.status,
    this.ip_address,
    this.created_by,
    this.update_by,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  NotificationModel copyWith({
    String? id,
    String? notification_type,
    NotificationData? notification_data,
    String? message,
    String? resource_title,
    String? resource_id,
    ResourceObject? resourceObject,
    UserIdModel? notification_sender_id,
    UserIdModel? notification_receiver_id,
    bool? notification_seen,
    String? status,
    String? ip_address,
    String? created_by,
    String? update_by,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notification_type: notification_type ?? this.notification_type,
      notification_data: notification_data ?? this.notification_data,
      message: message ?? this.message,
      resource_title: resource_title ?? this.resource_title,
      resource_id: resource_id ?? this.resource_id,
      resourceObject: resourceObject ?? this.resourceObject,
      notification_sender_id:
          notification_sender_id ?? this.notification_sender_id,
      notification_receiver_id:
          notification_receiver_id ?? this.notification_receiver_id,
      notification_seen: notification_seen ?? this.notification_seen,
      status: status ?? this.status,
      ip_address: ip_address ?? this.ip_address,
      created_by: created_by ?? this.created_by,
      update_by: update_by ?? this.update_by,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'notification_type': notification_type,
      'notification_data': notification_data,
      'message': message,
      'resource_title': resource_title,
      'resource_id': resource_id,
      'resource_object': resourceObject,
      'notification_sender_id': notification_sender_id,
      'notification_receiver_id': notification_receiver_id,
      'notification_seen': notification_seen,
      'status': status,
      'ip_address': ip_address,
      'created_by': created_by,
      'update_by': update_by,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      notification_type: map['notification_type'] != null
          ? map['notification_type'] as String
          : null,
      notification_data: map['notification_data'] != null
          ? NotificationData.fromJson(map['notification_data'])
          : null,
      message: map['message'] != null ? map['message'] as String : null,
      resource_title: map['resource_title'] != null
          ? map['resource_title'] as String
          : null,
      resource_id:
          map['resource_id'] != null ? map['resource_id'] as String : null,
      resourceObject: map['resource_object'] != null
          ? ResourceObject.fromJson(map['resource_object'])
          : null,
      notification_sender_id: map['notification_sender_id'] != null
          ? UserIdModel.fromMap(map['notification_sender_id'])
          : null,
      notification_receiver_id: map['notification_receiver_id'] != null
          ? UserIdModel.fromMap(map['notification_receiver_id'])
          : null,
      notification_seen: map['notification_seen'] != null
          ? map['notification_seen'] as bool
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      ip_address:
          map['ip_address'] != null ? map['ip_address'] as String : null,
      created_by:
          map['created_by'] != null ? map['created_by'] as String : null,
      update_by: map['update_by'] != null ? map['update_by'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      v: map['__v'] != null ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, notification_type: $notification_type, notification_data: $notification_data, message: $message, resource_title: $resource_title, resource_id: $resource_id, '
        'resource_object: $resourceObject, '
        'notification_sender_id: $notification_sender_id, notification_receiver_id: $notification_receiver_id, notification_seen: $notification_seen, status: $status, ip_address: $ip_address, created_by: $created_by, update_by: $update_by, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.notification_type == notification_type &&
        other.message == message &&
        other.resource_title == resource_title &&
        other.resource_id == resource_id &&
        other.resourceObject == resourceObject &&
        other.notification_seen == notification_seen &&
        other.status == status &&
        other.ip_address == ip_address &&
        other.created_by == created_by &&
        other.update_by == update_by &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        notification_type.hashCode ^
        notification_data.hashCode ^
        message.hashCode ^
        resource_title.hashCode ^
        resource_id.hashCode ^
        resourceObject.hashCode ^
        notification_sender_id.hashCode ^
        notification_receiver_id.hashCode ^
        notification_seen.hashCode ^
        status.hashCode ^
        ip_address.hashCode ^
        created_by.hashCode ^
        update_by.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        v.hashCode;
  }
}

class NotificationData {
  PostId? postId;
  CommentId? commentId;
  CommentRepliesId? commentRepliesId;
  String? id;
  String? reelId;
  String? reactionType;
  String? userId;

  NotificationData({
    required this.postId,
    required this.commentId,
    required this.commentRepliesId,
    required this.id,
    this.reelId,
    this.reactionType,
    this.userId,
  });

  NotificationData copyWith({
    PostId? postId,
    CommentId? commentId,
    CommentRepliesId? commentRepliesId,
    String? id,
    String? reelId,
    String? reactionType,
    String? userId,
  }) =>
      NotificationData(
        postId: postId ?? this.postId,
        commentId: commentId ?? this.commentId,
        commentRepliesId: commentRepliesId ?? this.commentRepliesId,
        id: id ?? this.id,
        reelId: reelId ?? this.reelId,
        reactionType: reactionType ?? this.reactionType,
        userId: userId ?? this.userId,
      );

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        postId:
            json['post_id'] == null ? null : PostId.fromJson(json['post_id']),
        commentId: json['comment_id'] == null
            ? null
            : CommentId.fromJson(json['comment_id']),
        commentRepliesId: json['comment_replies_id'] == null
            ? null
            : CommentRepliesId.fromJson(json['comment_replies_id']),
        id: json['_id'],
        reelId: json['reel_id'],
        reactionType: json['reaction_type'],
        userId: json['user_id'],
      );

  Map<String, dynamic> toJson() => {
        'post_id': postId?.toJson(),
        'comment_id': commentId?.toJson(),
        'comment_replies_id': commentRepliesId?.toJson(),
        '_id': id,
        'reel_id': reelId,
        'reaction_type': reactionType,
        'user_id': userId,
      };
}

class CommentId {
  String? id;
  String? commentName;
  String? userId;
  String? commentType;

  CommentId({
    required this.id,
    required this.commentName,
    required this.userId,
    required this.commentType,
  });

  CommentId copyWith({
    String? id,
    String? commentName,
    String? userId,
    String? commentType,
  }) =>
      CommentId(
        id: id ?? this.id,
        commentName: commentName ?? this.commentName,
        userId: userId ?? this.userId,
        commentType: commentType ?? this.commentType,
      );

  factory CommentId.fromJson(Map<String, dynamic> json) => CommentId(
        id: json['_id'],
        commentName: json['comment_name'],
        userId: json['user_id'],
        commentType: json['comment_type'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'comment_name': commentName,
        'user_id': userId,
        'comment_type': commentType,
      };
}

class CommentRepliesId {
  String? id;
  String? repliesUserId;
  String? repliesCommentName;
  String? commentType;

  CommentRepliesId({
    required this.id,
    required this.repliesUserId,
    required this.repliesCommentName,
    required this.commentType,
  });

  CommentRepliesId copyWith({
    String? id,
    String? repliesUserId,
    String? repliesCommentName,
    String? commentType,
  }) =>
      CommentRepliesId(
        id: id ?? this.id,
        repliesUserId: repliesUserId ?? this.repliesUserId,
        repliesCommentName: repliesCommentName ?? this.repliesCommentName,
        commentType: commentType ?? this.commentType,
      );

  factory CommentRepliesId.fromJson(Map<String, dynamic> json) =>
      CommentRepliesId(
        id: json['_id'],
        repliesUserId: json['replies_user_id']!,
        repliesCommentName: json['replies_comment_name'],
        commentType: json['comment_type'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'replies_user_id': repliesUserId,
        'replies_comment_name': repliesCommentName,
        'comment_type': commentType,
      };
}

class PostId {
  String id;
  String? description;
  String? postType;
  String? userId;

  PostId({
    required this.id,
    required this.description,
    required this.postType,
    required this.userId,
  });

  PostId copyWith({
    String? id,
    String? description,
    String? postType,
    String? userId,
  }) =>
      PostId(
        id: id ?? this.id,
        description: description ?? this.description,
        postType: postType ?? this.postType,
        userId: userId ?? this.userId,
      );

  factory PostId.fromJson(Map<String, dynamic> json) => PostId(
        id: json['_id'],
        description: json['description'],
        postType: json['post_type'],
        userId: json['user_id']!,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'description': description,
        'post_type': postType,
        'user_id': userId,
      };
}

class ResourceObject {
  String? pageUserName;
  String? pageName;
  String? groupId;
  String? groupName;
  String? ticketId;
  String? campaignId;

  ResourceObject(
      {this.pageUserName,
      this.pageName,
      this.groupName,
      this.groupId,
      this.campaignId,
      this.ticketId});

  ResourceObject copyWith({
    String? pageUserName,
    String? pageName,
    String? groupId,
    String? campaignId,
    String? groupName,
    String? ticketId,
  }) =>
      ResourceObject(
        pageUserName: pageUserName ?? this.pageUserName,
        pageName: pageName ?? this.pageName,
        campaignId: campaignId ?? this.campaignId,
        groupId: groupId ?? this.groupId,
        groupName: groupName ?? this.groupName,
        ticketId: ticketId ?? this.ticketId,
      );

  factory ResourceObject.fromJson(Map<String, dynamic> json) => ResourceObject(
        pageUserName: json['page_user_name'],
        pageName: json['page_name'],
        groupId: json['group_id'],
        groupName: json['group_name'],
        ticketId: json['ticket_id'],
        campaignId: json['campaign_id'],
      );

  Map<String, dynamic> toJson() => {
        'page_user_name': pageUserName,
        'page_name': pageName,
        'group_id': groupId,
        'group_name': groupName,
        'ticket_id': ticketId,
        'campaign_id': campaignId,
      };
}
