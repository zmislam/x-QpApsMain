class NotificationSeenModel {
  int? status;
  Notification? notification;

  NotificationSeenModel({this.status, this.notification});

  NotificationSeenModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    notification = json['notification'] != null
        ? Notification.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    return data;
  }
}

class Notification {
  String? sId;
  String? notificationType;
  NotificationData? notificationData;
  String? message;
  String? resourceTitle;
  String? resourceId;
  String? resourceObject;
  String? notificationSenderId;
  String? notificationReceiverId;
  bool? notificationSeen;
  String? status;
  String? ipAddress;
  String? createdBy;
  String? updateBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Notification(
      {this.sId,
      this.notificationType,
      this.notificationData,
      this.message,
      this.resourceTitle,
      this.resourceId,
      this.resourceObject,
      this.notificationSenderId,
      this.notificationReceiverId,
      this.notificationSeen,
      this.status,
      this.ipAddress,
      this.createdBy,
      this.updateBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Notification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    notificationType = json['notification_type'];
    notificationData = json['notification_data'] != null
        ? NotificationData.fromJson(json['notification_data'])
        : null;
    message = json['message'];
    resourceTitle = json['resource_title'];
    resourceId = json['resource_id'];
    resourceObject = json['resource_object'];
    notificationSenderId = json['notification_sender_id'];
    notificationReceiverId = json['notification_receiver_id'];
    notificationSeen = json['notification_seen'];
    status = json['status'];
    ipAddress = json['ip_address'];
    createdBy = json['created_by'];
    updateBy = json['update_by'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['notification_type'] = notificationType;
    if (notificationData != null) {
      data['notification_data'] = notificationData!.toJson();
    }
    data['message'] = message;
    data['resource_title'] = resourceTitle;
    data['resource_id'] = resourceId;
    data['resource_object'] = resourceObject;
    data['notification_sender_id'] = notificationSenderId;
    data['notification_receiver_id'] = notificationReceiverId;
    data['notification_seen'] = notificationSeen;
    data['status'] = status;
    data['ip_address'] = ipAddress;
    data['created_by'] = createdBy;
    data['update_by'] = updateBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class NotificationData {
  String? postId;
  String? commentId;
  String? commentRepliesId;
  String? sId;

  NotificationData(
      {this.postId, this.commentId, this.commentRepliesId, this.sId});

  NotificationData.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    commentId = json['comment_id'];
    commentRepliesId = json['comment_replies_id'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['comment_id'] = commentId;
    data['comment_replies_id'] = commentRepliesId;
    data['_id'] = sId;
    return data;
  }
}
