class WishlistResponse {
  String? message;
  List<WishlistItem>? data;

  WishlistResponse({this.message, this.data});

  factory WishlistResponse.fromMap(Map<String, dynamic>? map) {
    if (map == null) return WishlistResponse();
    return WishlistResponse(
      message: map['message'],
      data: (map['data'] as List<dynamic>?)
          ?.map((item) => WishlistItem.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'data': data?.map((item) => item.toMap()).toList(),
    };
  }
}

class WishlistItem {
  String? id;
  String? userId;
  String? productId;
  String? productVariantId;
  String? storeId;
  String? createdAt;
  String? updatedAt;
  int? v;
  Product? product;
  WishListProductVariant? productVariant;
  Store? store;
  bool? isInCart;

  WishlistItem({
    this.id,
    this.userId,
    this.productId,
    this.productVariantId,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.product,
    this.productVariant,
    this.store,
    this.isInCart,
  });

  factory WishlistItem.fromMap(Map<String, dynamic>? map) {
    if (map == null) return WishlistItem();
    return WishlistItem(
      id: map['_id'],
      userId: map['user_id'],
      productId: map['product_id'],
      productVariantId: map['product_variant_id'],
      storeId: map['store_id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      v: map['__v'],
      product: Product.fromMap(map['product']),
      productVariant: WishListProductVariant.fromMap(map['product_variant']),
      store: Store.fromMap(map['store']),
      isInCart: map['isInCart'] == null ? false : map['isInCart'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': userId,
      'product_id': productId,
      'product_variant_id': productVariantId,
      'store_id': storeId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'product': product?.toMap(),
      'product_variant': productVariant?.toMap(),
      'store': store?.toMap(),
      'isInCart': isInCart,
    };
  }
}

class Product {
  String? id;
  String? productName;
  List<String>? media;

  Product({this.id, this.productName, this.media});

  factory Product.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Product();
    return Product(
      id: map['_id'],
      productName: map['product_name'],
      media: (map['media'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
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

class WishListProductVariant {
  String? id;
  num? sellPrice;
  int? totalStock;
  String? stockStatus;

  WishListProductVariant({this.id, this.sellPrice, this.totalStock, this.stockStatus});

  factory WishListProductVariant.fromMap(Map<String, dynamic>? map) {
    if (map == null) return WishListProductVariant();
    return WishListProductVariant(
      id: map['_id'],
      sellPrice: map['sell_price'],
      totalStock: map['totalStock'],
      stockStatus: map['stockStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'sell_price': sellPrice,
      'totalStock': totalStock,
      'stockStatus': stockStatus,
    };
  }
}

class Store {
  String? id;
  String? name;
  String? imagePath;

  Store({this.id, this.name, this.imagePath});

  factory Store.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Store();
    return Store(
      id: map['_id'],
      name: map['name'],
      imagePath: map['image_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'image_path': imagePath,
    };
  }
}
