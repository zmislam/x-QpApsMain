class RefundDetailsModel {
  String? id;
  String? orderSubDetailsId;
  String? status;
  String? refundBy;
  String? actionBy;
  int? deliveryCharge;
  String? note;
  List<String>? images;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? productQuantity;
  BuyerRefundStore? store;

  RefundDetailsModel({
    this.id,
    this.orderSubDetailsId,
    this.status,
    this.refundBy,
    this.actionBy,
    this.deliveryCharge,
    this.note,
    this.images,
    this.createdAt,
    this.updatedAt,
    this.productQuantity,
    this.store,
  });

  factory RefundDetailsModel.fromMap(Map<String, dynamic> map) {
    return RefundDetailsModel(
      id: map['_id'] as String?,
      orderSubDetailsId: map['order_sub_details_id'] as String?,
      status: map['status'] as String?,
      refundBy: map['refund_by'] as String?,
      actionBy: map['action_by'] as String?,
      deliveryCharge: map['delivery_charge'] as int?,
      note: map['note'] as String?,
      images: (map['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      productQuantity: map['product_quantity'] as int?,
      store: map['store'] != null ? BuyerRefundStore.fromMap(map['store']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'order_sub_details_id': orderSubDetailsId,
      'status': status,
      'refund_by': refundBy,
      'action_by': actionBy,
      'delivery_charge': deliveryCharge,
      'note': note,
      'images': images,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'product_quantity': productQuantity,
      'store': store?.toMap(),
    };
  }
}

class BuyerRefundStore {
  String? id;
  String? categoryName;
  String? userId;
  String? name;
  String? description;
  String? imagePath;

  BuyerRefundStore({
    this.id,
    this.categoryName,
    this.userId,
    this.name,
    this.description,
    this.imagePath,
  });

  factory BuyerRefundStore.fromMap(Map<String, dynamic> map) {
    return BuyerRefundStore(
      id: map['_id'] as String?,
      categoryName: map['category_name'] as String?,
      userId: map['user_id'] as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      imagePath: map['image_path'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'category_name': categoryName,
      'user_id': userId,
      'name': name,
      'description': description,
      'image_path': imagePath,
    };
  }
}
