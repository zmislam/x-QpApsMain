import 'page_info_model.dart';

class AdProduct {
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
  double? vat;
  double? tax;
  String? productCondition;
  String? userId;
  String? storeId;
  String? status;
  double? shippingCharge;
  String? description;
  List<String>? media;
  bool? hasVariant;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  AdProductVariant? productVariant;
  List<dynamic>? activeCoupon;
  PageInfo? pageInfo;

  AdProduct({
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
    this.hasVariant,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.productVariant,
    this.activeCoupon,
    this.pageInfo
  });

  factory AdProduct.fromJson(Map<String, dynamic> map) {
    return AdProduct(
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
      vat: (map['vat'] as num?)?.toDouble(),
      tax: (map['tax'] as num?)?.toDouble(),
      productCondition: map['product_condition'] as String?,
      userId: map['user_id'] as String?,
      storeId: map['store_id'] as String?,
      status: map['status'] as String?,
      shippingCharge: (map['shipping_charge'] as num?)?.toDouble(),
      description: map['description'] as String?,
      media: (map['media'] as List<dynamic>?)?.cast<String>(),
      hasVariant: map['hasVariant'] == 'true',
      createdBy: map['created_by'] as String?,
      updatedBy: map['updated_by'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
      productVariant: map['product_variants'] != null
          ? AdProductVariant.fromJson(map['product_variants'] as Map<String, dynamic>)
          : null,
      activeCoupon: map['active_coupon'] as List<dynamic>?,
        pageInfo: map['page_info'] != null
          ? PageInfo.fromJson(map['page_info'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
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
      'hasVariant': hasVariant,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'product_variants': productVariant?.toJson(),
      'active_coupon': activeCoupon,
      'page_info': pageInfo?.toJson(),
    };
  }
}

class AdProductVariant {
  String? id;
  String? productId;
  String? colorId;
  String? sku;
  String? isbnNumber;
  String? image;
  double? mainPrice;
  double? sellPrice;
  int? stock;
  DateTime? createdAt;
  DateTime? updatedAt;

  AdProductVariant({
    this.id,
    this.productId,
    this.colorId,
    this.sku,
    this.isbnNumber,
    this.image,
    this.mainPrice,
    this.sellPrice,
    this.stock,
    this.createdAt,
    this.updatedAt,
  });

  factory AdProductVariant.fromJson(Map<String, dynamic> map) {
    return AdProductVariant(
      id: map['_id'] as String?,
      productId: map['product_id'] as String?,
      colorId: map['color_id'] as String?,
      sku: map['sku'] as String?,
      isbnNumber: map['isbn_number'] as String?,
      image: map['image'] as String?,
      mainPrice: (map['main_price'] as num?)?.toDouble(),
      sellPrice: (map['sell_price'] as num?)?.toDouble(),
      stock: map['stock'] as int?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product_id': productId,
      'color_id': colorId,
      'sku': sku,
      'isbn_number': isbnNumber,
      'image': image,
      'main_price': mainPrice,
      'sell_price': sellPrice,
      'stock': stock,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
