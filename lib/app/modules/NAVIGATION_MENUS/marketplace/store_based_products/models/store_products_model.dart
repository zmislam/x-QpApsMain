import '../../marketplace_products/models/all_product_model.dart';

class StoreDetailsModel {
  final String? id;
  final String? categoryName;
  final String? userId;
  final String? name;
  final String? description;
  final String? imagePath;
  final String? status;
  final String? shipping;
  final String? delivery;
  final String? returns;
  final String? ipAddress;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<StoreProductsDetails>? products;
  final int? totalProductCount;

  StoreDetailsModel({
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
    this.v,
    this.products,
    this.totalProductCount,
  });

  factory StoreDetailsModel.fromMap(Map<String, dynamic> map) {
    return StoreDetailsModel(
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
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      v: map['__v'] as int?,
      products: (map['products'] as List<dynamic>?)
          ?.map((e) => StoreProductsDetails.fromMap(e as Map<String, dynamic>))
          .toList(),
      totalProductCount: map['totalProductCount'] as int?,
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
      '__v': v,
      'products': products?.map((e) => e.toMap()).toList(),
      'totalProductCount': totalProductCount,
    };
  }
}

class StoreProductsDetails {
  final String? id;
  final String? productName;
  final String? categoryName;
  final String? brandName;
  final String? unit;
  final String? weight;
  final String? height;
  final String? width;
  final String? depth;
  final String? dimensionUnit;
  final int? baseMainPrice;
  final int? baseSellingPrice;
  final int? vat;
  final int? tax;
 bool? wishProduct;

  final String? productCondition;
  final String? userId;
  final String? storeId;
  final String? status;
  final int? shippingCharge;
  final String? description;
  final List<String>? media;
  final List<Specification>? specification;
  final bool? hasVariant;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<ProductVariant>? productVariants;
  final int? totalStock;
  ProductReview? productReview;

  StoreProductsDetails({
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
    this.v,
    this.productVariants,
    this.totalStock,
    this.productReview,
    this.wishProduct ,
  });

  factory StoreProductsDetails.fromMap(Map<String, dynamic> map) {
    return StoreProductsDetails(
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
      baseMainPrice: map['base_main_price'] as int?,
      baseSellingPrice: map['base_selling_price'] as int?,
      vat: map['vat'] as int?,
      tax: map['tax'] as int?,
      productCondition: map['product_condition'] as String?,
      userId: map['user_id'] as String?,
      storeId: map['store_id'] as String?,
      status: map['status'] as String?,
      shippingCharge: map['shipping_charge'] as int?,
      description: map['description'] as String?,
      media: List<String>.from(map['media'] ?? []),
      specification: (map['specification'] as List<dynamic>?)
          ?.map((e) => Specification.fromMap(e as Map<String, dynamic>))
          .toList(),
      hasVariant: map['hasVariant'] == 'true',
      createdBy: map['created_by'] as String?,
      updatedBy: map['updated_by'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      v: map['__v'] as int?,
      productVariants: (map['product_variants'] as List<dynamic>?)
              ?.whereType<
                  Map<String,
                      dynamic>>() // Ensure each item is a Map<String, dynamic>
              .map((e) => ProductVariant.fromMap(e))
              .toList() ??
          [],
      totalStock: map['totalStock'] as int?,
      wishProduct: map['wishProduct'] as bool?,
      productReview: map['product_review'] != null
          ? ProductReview.fromMap(map['product_review'])
          : null,
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
      '__v': v,
      'product_variants': productVariants?.map((e) => e.toMap()).toList(),
      'totalStock': totalStock,
      'product_review': productReview?.toMap(),
      'wishProduct': wishProduct,
    };
  }
}

class Specification {
  final String? label;
  final String? value;

  Specification({
    this.label,
    this.value,
  });

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

class ProductVariant {
  final String? id;
  final String? productId;
  final String? colorId;
  final String? sku;
  final String? isbnNumber;
  final String? image;
  final int? mainPrice;
  final int? sellPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final StockHistory? stockHistories;
  final int? totalStock;

  ProductVariant({
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
    this.v,
    this.stockHistories,
    this.totalStock,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['_id'] as String?,
      productId: map['product_id'] as String?,
      colorId: map['color_id'] as String?,
      sku: map['sku'] as String?,
      isbnNumber: map['isbn_number'] as String?,
      image: map['image'] as String?,
      mainPrice: map['main_price'] as int?,
      sellPrice: map['sell_price'] as int?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      v: map['__v'] as int?,
      stockHistories: map['stockHistories'] != null
          ? StockHistory.fromMap(map['stockHistories'] as Map<String, dynamic>)
          : null,
      totalStock: map['totalStock'] as int?,
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
      '__v': v,
      'stockHistories': stockHistories?.toMap(),
      'totalStock': totalStock,
    };
  }
}

class StockHistory {
  final String? id;
  final int? totalStock;

  StockHistory({
    this.id,
    this.totalStock,
  });

  factory StockHistory.fromMap(Map<String, dynamic> map) {
    return StockHistory(
      id: map['_id'] as String?,
      totalStock: map['total_stock'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'total_stock': totalStock,
    };
  }
}
