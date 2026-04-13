class MarketplaceNotificationModel {
  final String? id;
  final String? userId;
  final String? type;
  final String? title;
  final String? body;
  final String? imageUrl;
  final String? referenceType;
  final String? referenceId;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MarketplaceNotificationModel({
    this.id,
    this.userId,
    this.type,
    this.title,
    this.body,
    this.imageUrl,
    this.referenceType,
    this.referenceId,
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  factory MarketplaceNotificationModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceNotificationModel(
      id: json['_id']?.toString(),
      userId: json['user_id'] is Map
          ? json['user_id']['_id']?.toString()
          : json['user_id']?.toString(),
      type: json['type']?.toString(),
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      imageUrl: json['image_url']?.toString(),
      referenceType: json['reference_type']?.toString(),
      referenceId: json['reference_id']?.toString(),
      isRead: json['is_read'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  MarketplaceNotificationModel copyWith({bool? isRead}) {
    return MarketplaceNotificationModel(
      id: id,
      userId: userId,
      type: type,
      title: title,
      body: body,
      imageUrl: imageUrl,
      referenceType: referenceType,
      referenceId: referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
