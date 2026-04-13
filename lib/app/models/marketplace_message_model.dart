class MarketplaceMessageModel {
  final String? id;
  final String? conversationId;
  final MessageSender? sender;
  final String? message;
  final bool read;
  final DateTime? createdAt;

  MarketplaceMessageModel({
    this.id,
    this.conversationId,
    this.sender,
    this.message,
    this.read = false,
    this.createdAt,
  });

  factory MarketplaceMessageModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceMessageModel(
      id: json['_id']?.toString(),
      conversationId: json['conversation_id']?.toString(),
      sender: json['sender_id'] is Map
          ? MessageSender.fromJson(Map<String, dynamic>.from(json['sender_id']))
          : (json['sender_id'] != null
              ? MessageSender(id: json['sender_id'].toString())
              : null),
      message: json['message']?.toString(),
      read: json['read'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class MessageSender {
  final String? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? profileImage;

  MessageSender({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.profileImage,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      id: json['_id']?.toString(),
      username: json['username']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      profileImage: json['profile_image']?.toString(),
    );
  }

  String get displayName {
    final parts = [firstName, lastName].where((p) => p != null && p.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : (username ?? 'User');
  }
}
