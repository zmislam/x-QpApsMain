import '../../../../marketplace/marketplace_cart/models/my_cart_model.dart';

class RefundResponse {
  String? id;
  String? orderSubDetailsId;
  String? status;
  bool? isOnboard;
  String? onboardBy;
  
  String? refundBy;
  String? actionBy;
  int? deliveryCharge;
  String? note;
  List<String>? images;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? courier;
  String? trackingNumber;
  String? qrCode;
  List<RefundReturnDetail>? refundDetails;
  RefundStore? store;

  RefundResponse({
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
    this.isOnboard,
    this.onboardBy,
    this.courier,
    this.trackingNumber,
    this.qrCode,
    this.refundDetails,
    this.store,
  });

  factory RefundResponse.fromMap(Map<String, dynamic> map) {
    return RefundResponse(
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
      isOnboard: map['is_onboard'] as bool?,
      onboardBy: map['onboard_by'] as String?,
      courier: map['courier'] as String?,
      trackingNumber: map['tracking_number'] as String?,
      qrCode: map['QR_code'] as String?,
      refundDetails: (map['refund_details'] as List<dynamic>?)
          ?.map((e) => RefundReturnDetail.fromMap(e as Map<String, dynamic>))
          .toList(),
      store: map['store'] != null ? RefundStore.fromMap(map['store']) : null,
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
      'is_onboard': isOnboard,
      'onboard_by': onboardBy,
      'refund_details': refundDetails?.map((e) => e.toMap()).toList(),
      'store': store?.toMap(),
    };
  }
}

class RefundReturnDetail {
  String? id;
  String? refundId;
  String? productId;
  String? variantId;
  int? refundQuantity;
  double? sellPrice;
  String? refundNote;
  DateTime? createdAt;
  DateTime? updatedAt;
  RefundProductVariant? productVariant;
  Product? product;

  RefundReturnDetail({
    this.id,
    this.refundId,
    this.productId,
    this.variantId,
    this.refundQuantity,
    this.sellPrice,
    this.refundNote,
    this.createdAt,
    this.updatedAt,
    this.productVariant,
    this.product,
  });

  factory RefundReturnDetail.fromMap(Map<String, dynamic> map) {
    return RefundReturnDetail(
      id: map['_id'] as String?,
      refundId: map['refund_id'] as String?,
      productId: map['product_id'] as String?,
      variantId: map['variant_id'] as String?,
      refundQuantity: map['refund_quantity'] as int?,
      sellPrice: (map['sell_price'] as num?)?.toDouble(),
      refundNote: map['refund_note'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      productVariant: map['product_variant'] != null
          ? RefundProductVariant.fromMap(map['product_variant'])
          : null,
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'refund_id': refundId,
      'product_id': productId,
      'variant_id': variantId,
      'refund_quantity': refundQuantity,
      'sell_price': sellPrice,
      'refund_note': refundNote,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'product_variant': productVariant?.toMap(),
      'product': product?.toMap(),
    };
  }
}

class RefundProductVariant {
  String? id;
  String? productId;
  String? colorId;
  String? sku;
  String? isbnNumber;
  String? image;
  double? mainPrice;
  double? sellPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Attribute>? attributes;
  RefundColor? color;

  RefundProductVariant({
    this.id,
    this.productId,
    this.colorId,
    this.sku,
    this.isbnNumber,
    this.image,
    this.mainPrice,
    this.sellPrice,
    this.createdAt,
    this.updatedAt,
    this.attributes,
    this.color,
  });

  factory RefundProductVariant.fromMap(Map<String, dynamic> map) {
    return RefundProductVariant(
      id: map['_id'] as String?,
      productId: map['product_id'] as String?,
      colorId: map['color_id'] as String?,
      sku: map['sku'] as String?,
      isbnNumber: map['isbn_number'] as String?,
      image: map['image'] as String?,
      mainPrice: (map['main_price'] as num?)?.toDouble(),
      sellPrice: (map['sell_price'] as num?)?.toDouble(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
           attributes: (map['attributes'] as List<dynamic>?)
          ?.map((item) => Attribute.fromMap(item as Map<String, dynamic>?))
          .toList(),
          
      color: map['color'] != null ? RefundColor.fromMap(map['color']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_id': productId,
      'color_id': colorId,
      'sku': sku,
      'isbn_number': isbnNumber,
      'image': image,
      'main_price': mainPrice,
      'sell_price': sellPrice,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
           'attribute': attributes?.map((item) => item.toMap()).toList(),
      'color': color?.toMap(),
    };
  }
}

class RefundColor {
  String? id;
  String? name;
  String? value;

  RefundColor({this.id, this.name, this.value});

  factory RefundColor.fromMap(Map<String, dynamic> map) {
    return RefundColor(
      id: map['_id'] as String?,
      name: map['name'] as String?,
      value: map['value'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'value': value,
    };
  }
}

class Product {
  String? id;
  String? productName;
  String? categoryName;
  String? brandName;
  String? unit;
  String? weight;
  String? height;
  String? width;
  String? depth;
  String? dimensionUnit;
  double? baseMainPrice;
  double? baseSellingPrice;
  int? vat;
  int? tax;
  String? productCondition;
  String? userId;
  String? storeId;
  String? status;
  int? shippingCharge;
  String? description;
  List<String>? media;
  List<Specification>? specification;
  String? hasVariant;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Product({
    this.id,
    this.productName,
    this.categoryName,
    this.brandName,
    this.unit,
    this.weight,
    this.height,
    this.width,
    this.depth,
    this.dimensionUnit,
    this.baseMainPrice,
    this.baseSellingPrice,
    this.vat,
    this.tax,
    this.productCondition,
    this.userId,
    this.storeId,
    this.status,
    this.shippingCharge,
    this.description,
    this.media,
    this.specification,
    this.hasVariant,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as String?,
      productName: map['product_name'] as String?,
      categoryName: map['category_name'] as String?,
      brandName: map['brand_name'] as String?,
      unit: map['unit'] as String?,
      weight: map['weight'] as String?,
      height: map['height'] as String?,
      width: map['width'] as String?,
      depth: map['depth'] as String?,
      dimensionUnit: map['dimension_unit'] as String?,
      baseMainPrice: (map['base_main_price'] as num?)?.toDouble(),
      baseSellingPrice: (map['base_selling_price'] as num?)?.toDouble(),
      vat: map['vat'] as int?,
      tax: map['tax'] as int?,
      productCondition: map['product_condition'] as String?,
      userId: map['user_id'] as String?,
      storeId: map['store_id'] as String?,
      status: map['status'] as String?,
      shippingCharge: map['shipping_charge'] as int?,
      description: map['description'] as String?,
      media: (map['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
      specification: (map['specification'] as List<dynamic>?)
          ?.map((e) => Specification.fromMap(e as Map<String, dynamic>))
          .toList(),
      hasVariant: map['hasVariant'] as String?,
      createdBy: map['created_by'] as String?,
      updatedBy: map['updated_by'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_name': productName,
      'category_name': categoryName,
      'brand_name': brandName,
      'unit': unit,
      'weight': weight,
      'height': height,
      'width': width,
      'depth': depth,
      'dimension_unit': dimensionUnit,
      'base_main_price': baseMainPrice,
      'base_selling_price': baseSellingPrice,
      'vat': vat,
      'tax': tax,
      'product_condition': productCondition,
      'user_id': userId,
      'store_id': storeId,
      'status': status,
      'shipping_charge': shippingCharge,
      'description': description,
      'media': media,
      'specification': specification?.map((e) => e.toMap()).toList(),
      'hasVariant': hasVariant,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Specification {
  String? label;
  String? value;

  Specification({this.label, this.value});

  factory Specification.fromMap(Map<String, dynamic> map) {
    return Specification(
      label: map['label'] as String?,
      value: map['value'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
    };
  }
}

class RefundStore {
  String? id;
  String? categoryName;
  String? userId;
  String? name;
  String? description;
  String? imagePath;
  String? status;
  String? shipping;
  String? delivery;
  String? returns;
  String? ipAddress;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  RefundStore({
    this.id,
    this.categoryName,
    this.userId,
    this.name,
    this.description,
    this.imagePath,
    this.status,
    this.shipping,
    this.delivery,
    this.returns,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory RefundStore.fromMap(Map<String, dynamic> map) {
    return RefundStore(
      id: map['_id'] as String?,
      categoryName: map['category_name'] as String?,
      userId: map['user_id'] as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      imagePath: map['image_path'] as String?,
      status: map['status'] as String?,
      shipping: map['shipping'] as String?,
      delivery: map['delivery'] as String?,
      returns: map['returns'] as String?,
      ipAddress: map['ip_address'] as String?,
      createdBy: map['created_by'] as String?,
      updatedBy: map['updated_by'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
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
      'status': status,
      'shipping': shipping,
      'delivery': delivery,
      'returns': returns,
      'ip_address': ipAddress,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
