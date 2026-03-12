import 'product_details_model.dart';

class AllRelatedProducts {
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
  int? baseMainPrice;
  int? baseSellingPrice;
  int? vat;
  int? tax;
  String? productCondition;
  String? userId;
  StoreDetails? storeId;
  String? status;
  int? shippingCharge;
  String? description;
  List<String>? media;
  List<Specification>? specification;
  bool? hasVariant;
  int? totalStock;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Store? store;
  List<ProductVariant>? productVariant;
  ProductReview? productReview;
  bool? wishProduct;

  AllRelatedProducts({
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
    this.totalStock,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.productVariant,
    this.productReview,
    this.wishProduct,
  });

  factory AllRelatedProducts.fromMap(Map<String, dynamic> json) =>
      AllRelatedProducts(
        id: json['_id'],
        productName: json['product_name'],
        categoryName: json['category_name'],
        brandName: json['brand_name'],
        unit: json['unit'],
        weight: json['weight'],
        height: json['height'],
        width: json['width'],
        depth: json['depth'],
        dimensionUnit: json['dimension_unit'],
        baseMainPrice: json['base_main_price'],
        baseSellingPrice: json['base_selling_price'],
        vat: json['vat'],
        tax: json['tax'],
        wishProduct: json['wishProduct'],
        productCondition: json['product_condition'],
        userId: json['user_id'],
        storeId: json['store_id'] != null
            ? StoreDetails.fromMap(json['store_id'])
            : null,
        status: json['status'],
        shippingCharge: json['shipping_charge'],
        description: json['description'],
        media: List<String>.from(json['media'] ?? []),
        specification: (json['specification'] as List<dynamic>?)
            ?.map((e) => Specification.fromMap(e))
            .toList(),
        hasVariant: json['hasVariant'] == 'true',
        totalStock: json['totalStock'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        store: json['store'] != null ? Store.fromMap(json['store']) : null,
        productVariant: (json['product_variants'] as List<dynamic>?)
            ?.map((e) => ProductVariant.fromMap(e))
            .toList(),
        productReview: json['product_review'] != null
            ? ProductReview.fromMap(json['product_review'])
            : null,
      );

  Map<String, dynamic> toMap() => {
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
        'wishProduct': wishProduct,
        'product_condition': productCondition,
        'user_id': userId,
        'store_id': storeId?.toMap(),
        'status': status,
        'shipping_charge': shippingCharge,
        'description': description,
        'media': media,
        'specification': specification?.map((e) => e.toMap()).toList(),
        'hasVariant': hasVariant.toString(),
        'totalStock': totalStock,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'store': store?.toMap(),
        'product_variants': productVariant?.map((e) => e.toMap()).toList(),
        'product_review': productReview?.toMap(),
      };
}

class StoreDetails {
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

  StoreDetails({
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

  factory StoreDetails.fromMap(Map<String, dynamic> json) => StoreDetails(
        id: json['_id'],
        categoryName: json['category_name'],
        userId: json['user_id'],
        name: json['name'],
        description: json['description'],
        imagePath: json['image_path'],
        status: json['status'],
        shipping: json['shipping'],
        delivery: json['delivery'],
        returns: json['returns'],
        ipAddress: json['ip_address'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
      );

  Map<String, dynamic> toMap() => {
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
