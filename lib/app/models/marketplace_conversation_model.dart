class MarketplaceConversationModel {
  final String? conversationId;
  final ConversationUser? otherUser;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final ConversationProduct? product;
  final String? orderStatus;
  final int unreadCount;

  MarketplaceConversationModel({
    this.conversationId,
    this.otherUser,
    this.lastMessage,
    this.lastMessageAt,
    this.product,
    this.orderStatus,
    this.unreadCount = 0,
  });

  factory MarketplaceConversationModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceConversationModel(
      conversationId: json['conversation_id']?.toString() ?? json['_id']?.toString(),
      otherUser: json['other_user'] is Map
          ? ConversationUser.fromJson(Map<String, dynamic>.from(json['other_user']))
          : null,
      lastMessage: json['last_message']?.toString(),
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.tryParse(json['last_message_at'].toString())
          : null,
      product: json['product'] is Map
          ? ConversationProduct.fromJson(Map<String, dynamic>.from(json['product']))
          : null,
      orderStatus: json['order_status']?.toString(),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}

class ConversationUser {
  final String? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? profileImage;

  ConversationUser({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.profileImage,
  });

  factory ConversationUser.fromJson(Map<String, dynamic> json) {
    return ConversationUser(
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

class ConversationProduct {
  final String? id;
  final String? productName;
  final num? baseMainPrice;
  final num? sellPrice;
  final List<String> images;

  ConversationProduct({
    this.id,
    this.productName,
    this.baseMainPrice,
    this.sellPrice,
    this.images = const [],
  });

  factory ConversationProduct.fromJson(Map<String, dynamic> json) {
    List<String> imgs = [];
    if (json['images'] is List) {
      imgs = (json['images'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (json['media'] is List && (json['media'] as List).isNotEmpty) {
      imgs = (json['media'] as List)
          .map((e) => e is Map ? (e['url'] ?? e['path'] ?? '').toString() : e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return ConversationProduct(
      id: json['_id']?.toString(),
      productName: json['product_name']?.toString(),
      baseMainPrice: json['base_main_price'] as num?,
      sellPrice: json['sell_price'] as num?,
      images: imgs,
    );
  }

  String? get firstImage => images.isNotEmpty ? images.first : null;
}
