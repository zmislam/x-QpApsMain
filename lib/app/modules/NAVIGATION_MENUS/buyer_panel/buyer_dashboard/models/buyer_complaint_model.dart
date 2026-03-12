class BuyerComplaintModel {
  String? id;
  String? name;
  String? email;
  String? userId;
  String? storeId;
  List<String>? productId;
  String? orderId;
  String? issueType;
  String? details;
  List<String>? media;
  String? adminNote;
  String? adminId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<BuyerCompalintProduct>? products;
  BueyrComplaintStore? store;
  BuyerComplaintOrder? order;

  BuyerComplaintModel({
    this.id,
    this.name,
    this.email,
    this.userId,
    this.storeId,
    this.productId,
    this.orderId,
    this.issueType,
    this.details,
    this.media,
    this.adminNote,
    this.adminId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.products,
    this.store,
    this.order,
  });

  factory BuyerComplaintModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerComplaintModel();

    return BuyerComplaintModel(
      id: map['_id'] as String?,
      name: map['name'] as String?,
      email: map['email'] as String?,
      userId: map['user_id'] as String?,
      storeId: map['store_id'] as String?,
      productId: (map['product_id'] as List?)?.map((e) => e as String).toList(),
      orderId: map['order_id'] as String?,
      issueType: map['issue_type'] as String?,
      details: map['details'] as String?,
      media: (map['media'] as List?)?.map((e) => e as String).toList(),
      adminNote: map['admin_note'] as String?,
      adminId: map['admin_id'] as String?,
      status: map['status'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      v: map['__v'] as int?,
      products: (map['products'] as List?)
          ?.map((e) => BuyerCompalintProduct.fromMap(e as Map<String, dynamic>?))
          .toList(),
      store: map['stores'] != null ? BueyrComplaintStore.fromMap(map['stores']) : null,
      order: map['orders'] != null ? BuyerComplaintOrder.fromMap(map['orders']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'user_id': userId,
      'store_id': storeId,
      'product_id': productId,
      'order_id': orderId,
      'issue_type': issueType,
      'details': details,
      'media': media,
      'admin_note': adminNote,
      'admin_id': adminId,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'products': products?.map((e) => e.toMap()).toList(),
      'stores': store?.toMap(),
      'orders': order?.toMap(),
    };
  }
}

class BuyerCompalintProduct {
  String? id;
  String? productName;
  List<String>? media;

  BuyerCompalintProduct({
    this.id,
    this.productName,
    this.media,
  });

  factory BuyerCompalintProduct.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerCompalintProduct();

    return BuyerCompalintProduct(
      id: map['_id'] as String?,
      productName: map['product_name'] as String?,
      media: (map['media'] as List?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_name': productName,
      'media': media,
    };
  }
}

class BueyrComplaintStore {
  String? id;
  String? name;

  BueyrComplaintStore({this.id, this.name});

  factory BueyrComplaintStore.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BueyrComplaintStore();

    return BueyrComplaintStore(
      id: map['_id'] as String?,
      name: map['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class BuyerComplaintOrder {
  String? id;
  String? invoiceNumber;

  BuyerComplaintOrder({this.id, this.invoiceNumber});

  factory BuyerComplaintOrder.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerComplaintOrder();

    return BuyerComplaintOrder(
      id: map['_id'] as String?,
      invoiceNumber: map['invoice_number'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'invoice_number': invoiceNumber,
    };
  }
}
