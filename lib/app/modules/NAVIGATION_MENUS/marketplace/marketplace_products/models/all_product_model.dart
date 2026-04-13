class ProductResponse {
  int? status;
  int? totalCount;
  int? maxPrice;
  List<AllProducts>? data;

  ProductResponse({
    this.status,
    this.totalCount,
    this.maxPrice,
    this.data,
  });

  factory ProductResponse.fromMap(Map<String, dynamic> json) => ProductResponse(
        status: json['status'],
        totalCount: json['totalCount'],
        maxPrice: json['maxPrice'],
        data: (json['data'] as List<dynamic>?)
            ?.map((item) => AllProducts.fromMap(item))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'totalCount': totalCount,
        'maxPrice': maxPrice,
        'data': data?.map((item) => item.toMap()).toList(),
      };
}

class AllProducts {
  String? id;
  String? productName;
  String? categoryName;
  String? brandName;
  String? unit;
  String? weight;
  int? vat;
  int? tax;
  int? totalStock;
  bool? wishProduct;
  String? productCondition;
  String? userId;
  String? storeId;
  String? status;
  int? shippingCharge;
  String? description;
  List<String>? media;
  List<Specification>? specification;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Store? store;
  List<ProductVariant>? productVariant;
  ProductReview? productReview;
  bool? isSponsored;
  String? activePromotionId;
  String? promotionBadge;

  AllProducts(
      {this.id,
      this.productName,
      this.categoryName,
      this.brandName,
      this.unit,
      this.weight,
      this.vat,
      this.tax,
      this.totalStock,
      this.wishProduct,
      this.productCondition,
      this.userId,
      this.storeId,
      this.status,
      this.shippingCharge,
      this.description,
      this.media,
      this.specification,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.store,
      this.productVariant,
      this.productReview,
      this.isSponsored,
      this.activePromotionId,
      this.promotionBadge});

  factory AllProducts.fromMap(Map<String, dynamic> json) => AllProducts(
        id: json['_id'] ,
        productName: json['product_name'],
        categoryName: json['category_name'],
        brandName: json['brand_name'],
        unit: json['unit'],
        weight: json['weight'],
        vat: json['vat'],
        tax: json['tax'],
        totalStock: json['totalStock'],
        wishProduct: json['wishProduct'] as bool?,
        productCondition: json['product_condition'],
        userId: json['user_id'],
        storeId: json['store_id'],
        status: json['status'],
        shippingCharge: json['shipping_charge'],
        description: json['description'],
        media: List<String>.from(json['media'] ?? []),
        specification: (json['specification'] as List<dynamic>?)
            ?.map((e) => Specification.fromMap(e))
            .toList(),
        createdBy: json['created_by'],
        updatedBy: json['updated_by'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        store: json['store'] != null ? Store.fromMap(json['store']) : null,
        productVariant: (json['product_variant'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>() // Ensure each item is a Map
            .map((e) => ProductVariant.fromMap(e))
            .toList(),
        productReview: json['product_review'] != null
            ? ProductReview.fromMap(json['product_review'])
            : null,
        isSponsored: json['is_sponsored'] == true || json['is_promoted'] == true,
        activePromotionId: json['_promotion_id']?.toString() ?? json['active_promotion_id']?.toString(),
        promotionBadge: json['promotion_badge']?.toString(),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'product_name': productName,
        'category_name': categoryName,
        'brand_name': brandName,
        'unit': unit,
        'weight': weight,
        'vat': vat,
        'tax': tax,
        'totalStock': totalStock,
        'wishProduct': wishProduct,
        'product_condition': productCondition,
        'user_id': userId,
        'store_id': storeId,
        'status': status,
        'shipping_charge': shippingCharge,
        'description': description,
        'media': media,
        'specification': specification?.map((e) => e.toMap()).toList(),
        'created_by': createdBy,
        'updated_by': updatedBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'store': store?.toMap(),
        'product_variant': productVariant?.map((e) => e.toMap()).toList(),
        'product_review': productReview?.toMap(),
        'is_sponsored': isSponsored,
        'active_promotion_id': activePromotionId,
        'promotion_badge': promotionBadge,
      };
}

class Specification {
  String? value;
  String? label;

  Specification({
    this.value,
    this.label,
  });

  factory Specification.fromMap(Map<String, dynamic> json) => Specification(
        value: json['value'],
        label: json['label'],
      );

  Map<String, dynamic> toMap() => {
        'value': value,
        'label': label,
      };
}

class Store {
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

  Store({
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
  });

  factory Store.fromMap(Map<String, dynamic> json) => Store(
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
      };
}

class ProductReview {
  int? totalReview;
  double? rating; // Assuming rating can be a double

  ProductReview({
    this.totalReview,
    this.rating,
  });

  factory ProductReview.fromMap(Map<String, dynamic> json) => ProductReview(
        totalReview: json['totalReview'],
        rating: (json['rating'] as num?)
            ?.toDouble(), // Safely convert rating to double
      );

  Map<String, dynamic> toMap() => {
        'totalReview': totalReview,
        'rating': rating,
      };
}

class ProductVariant {
  String? id;
  String? productId;
  String? colorId;
  String? sku;
  String? isbnNumber;
  String? image;
  double? mainPrice;
  double? sellPrice;
  int? stock;

  ProductVariant({
    this.id,
    this.productId,
    this.colorId,
    this.sku,
    this.isbnNumber,
    this.image,
    this.mainPrice,
    this.sellPrice,
    this.stock,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> json) => ProductVariant(
        id: json['_id'],
        productId: json['product_id'],
        colorId: json['color_id'],
        sku: json['sku'],
        isbnNumber: json['isbn_number'],
        image: json['image'],
        mainPrice: (json['main_price'] as num?)?.toDouble(),
        sellPrice: (json['sell_price'] as num?)?.toDouble(),
        stock: json['stock'],
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'product_id': productId,
        'color_id': colorId,
        'sku': sku,
        'isbn_number': isbnNumber,
        'image': image,
        'main_price': mainPrice,
        'sell_price': sellPrice,
        'stock': stock,
      };
}
