/// Model for refund list items.
/// Matches: GET /api/market-place/order/refund-list-for-buyer
class RefundListItem {
  final String id;
  final String? orderSubDetailsId;
  final String? status;
  final double deliveryCharge;
  final String? note;
  final List<String> images;
  final String? createdAt;
  final RefundStore? store;
  final int productQuantity;

  RefundListItem({
    required this.id,
    this.orderSubDetailsId,
    this.status,
    this.deliveryCharge = 0,
    this.note,
    this.images = const [],
    this.createdAt,
    this.store,
    this.productQuantity = 0,
  });

  factory RefundListItem.fromMap(Map<String, dynamic> map) {
    return RefundListItem(
      id: map['_id'] as String? ?? '',
      orderSubDetailsId: map['order_sub_details_id'] as String?,
      status: map['status'] as String?,
      deliveryCharge: (map['delivery_charge'] as num?)?.toDouble() ?? 0,
      note: map['note'] as String?,
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: map['createdAt'] as String?,
      store: map['store'] is Map<String, dynamic>
          ? RefundStore.fromMap(map['store'] as Map<String, dynamic>)
          : null,
      productQuantity: map['product_quantity'] as int? ?? 0,
    );
  }
}

class RefundStore {
  final String id;
  final String? name;
  final String? description;
  final String? imagePath;
  final String? categoryName;

  RefundStore({
    required this.id,
    this.name,
    this.description,
    this.imagePath,
    this.categoryName,
  });

  factory RefundStore.fromMap(Map<String, dynamic> map) {
    return RefundStore(
      id: map['_id'] as String? ?? '',
      name: map['name'] as String?,
      description: map['description'] as String?,
      imagePath: map['image_path'] as String?,
      categoryName: map['category_name'] as String?,
    );
  }
}

/// Model for a refund detail.
/// Matches: GET /api/market-place/order/refund-details/:refund_id
class RefundDetailModel {
  final String id;
  final String? orderSubDetailsId;
  final String? status;
  final double deliveryCharge;
  final String? note;
  final List<String> images;
  final String? refundBy;
  final String? createdAt;
  final List<RefundDetailItem> refundDetails;
  final RefundStore? store;

  RefundDetailModel({
    required this.id,
    this.orderSubDetailsId,
    this.status,
    this.deliveryCharge = 0,
    this.note,
    this.images = const [],
    this.refundBy,
    this.createdAt,
    this.refundDetails = const [],
    this.store,
  });

  factory RefundDetailModel.fromMap(Map<String, dynamic> map) {
    return RefundDetailModel(
      id: map['_id'] as String? ?? '',
      orderSubDetailsId: map['order_sub_details_id'] as String?,
      status: map['status'] as String?,
      deliveryCharge: (map['delivery_charge'] as num?)?.toDouble() ?? 0,
      note: map['note'] as String?,
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      refundBy: map['refund_by'] as String?,
      createdAt: map['createdAt'] as String?,
      refundDetails: (map['refund_details'] as List<dynamic>?)
              ?.map((e) =>
                  RefundDetailItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      store: map['store'] is Map<String, dynamic>
          ? RefundStore.fromMap(map['store'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RefundDetailItem {
  final String? refundId;
  final String? productId;
  final String? variantId;
  final int refundQuantity;
  final double sellPrice;
  final String? refundNote;
  final RefundProduct? product;
  final RefundVariant? productVariant;

  RefundDetailItem({
    this.refundId,
    this.productId,
    this.variantId,
    this.refundQuantity = 0,
    this.sellPrice = 0,
    this.refundNote,
    this.product,
    this.productVariant,
  });

  factory RefundDetailItem.fromMap(Map<String, dynamic> map) {
    return RefundDetailItem(
      refundId: map['refund_id'] as String?,
      productId: map['product_id'] as String?,
      variantId: map['variant_id'] as String?,
      refundQuantity: map['refund_quantity'] as int? ?? 0,
      sellPrice: (map['sell_price'] as num?)?.toDouble() ?? 0,
      refundNote: map['refund_note'] as String?,
      product: map['product'] is Map<String, dynamic>
          ? RefundProduct.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      productVariant: map['product_variant'] is Map<String, dynamic>
          ? RefundVariant.fromMap(
              map['product_variant'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RefundProduct {
  final String id;
  final String? productName;
  final List<String> media;

  RefundProduct({required this.id, this.productName, this.media = const []});

  factory RefundProduct.fromMap(Map<String, dynamic> map) {
    return RefundProduct(
      id: map['_id'] as String? ?? '',
      productName: map['product_name'] as String?,
      media: (map['media'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class RefundVariant {
  final List<RefundAttribute> attributes;
  final RefundColor? color;

  RefundVariant({this.attributes = const [], this.color});

  factory RefundVariant.fromMap(Map<String, dynamic> map) {
    return RefundVariant(
      attributes: (map['attributes'] as List<dynamic>?)
              ?.map((e) =>
                  RefundAttribute.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      color: map['color'] is Map<String, dynamic>
          ? RefundColor.fromMap(map['color'] as Map<String, dynamic>)
          : null,
    );
  }

  String get displayText {
    final parts = <String>[];
    if (color?.name != null) parts.add(color!.name!);
    for (final attr in attributes) {
      parts.add('${attr.value}: ${attr.name}');
    }
    return parts.join(' • ');
  }
}

class RefundAttribute {
  final String name;
  final String value;

  RefundAttribute({required this.name, required this.value});

  factory RefundAttribute.fromMap(Map<String, dynamic> map) {
    return RefundAttribute(
      name: map['name'] as String? ?? '',
      value: map['value'] as String? ?? '',
    );
  }
}

class RefundColor {
  final String? name;
  final String? value;

  RefundColor({this.name, this.value});

  factory RefundColor.fromMap(Map<String, dynamic> map) {
    return RefundColor(
      name: map['name'] as String?,
      value: map['value'] as String?,
    );
  }
}

/// Refund chat message model.
/// Matches: GET /api/market-place/order/get-refund-chat/:refund_id
class RefundChatMessage {
  final String id;
  final String? refundId;
  final String? sendBy;
  final String? adminId;
  final String? message;
  final List<String> images;
  final String? createdAt;
  final ChatSender? sender;
  final ChatAdmin? admin;

  RefundChatMessage({
    required this.id,
    this.refundId,
    this.sendBy,
    this.adminId,
    this.message,
    this.images = const [],
    this.createdAt,
    this.sender,
    this.admin,
  });

  factory RefundChatMessage.fromMap(Map<String, dynamic> map) {
    return RefundChatMessage(
      id: map['_id'] as String? ?? '',
      refundId: map['refund_id'] as String?,
      sendBy: map['send_by'] as String?,
      adminId: map['admin_id'] as String?,
      message: map['message'] as String?,
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: map['createdAt'] as String?,
      sender: map['sender'] is Map<String, dynamic>
          ? ChatSender.fromMap(map['sender'] as Map<String, dynamic>)
          : null,
      admin: map['admin'] is Map<String, dynamic>
          ? ChatAdmin.fromMap(map['admin'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ChatSender {
  final String? firstName;
  final String? lastName;

  ChatSender({this.firstName, this.lastName});

  factory ChatSender.fromMap(Map<String, dynamic> map) {
    return ChatSender(
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
    );
  }

  String get fullName =>
      [firstName, lastName].where((e) => e != null).join(' ');
}

class ChatAdmin {
  final String? name;

  ChatAdmin({this.name});

  factory ChatAdmin.fromMap(Map<String, dynamic> map) {
    return ChatAdmin(name: map['name'] as String?);
  }
}
