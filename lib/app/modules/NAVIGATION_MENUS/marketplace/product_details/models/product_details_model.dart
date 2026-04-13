class ProductDetails {
  String? id;
  String? productName;
  String? categoryName;
  String? brandName;
  String? unit;
  String? weight;
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
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Store? store;
  List<ProductVariant>? productVariant;
  ProductReview? productReview;
  Colour? color;
  List<Combination>? combinations;
  int? totalReview;
  String? rating;
  int? sold;
  bool? hasVariant;
  bool? wishProduct;
  TrustedSeller? trustedSeller;
  ProductLocation? location;
  ProductDetails({
    this.id,
    this.productName,
    this.categoryName,
    this.brandName,
    this.unit,
    this.weight,
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
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.productVariant,
    this.productReview,
    this.color,
    this.combinations,
    this.totalReview,
    this.rating,
    this.sold,
    this.hasVariant,
    this.wishProduct,
    this.trustedSeller,
    this.location,
  });

  factory ProductDetails.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return ProductDetails();
    }

    return ProductDetails(
      id: json['_id'] as String?,
      productName: json['product_name'] as String?,
      categoryName: json['category_name'] as String?,
      brandName: json['brand_name'] as String?,
      unit: json['unit'] as String?,
      weight: json['weight'] as String?,
      vat: json['vat'] as int?,
      tax: json['tax'] as int?,
      productCondition: json['product_condition'] as String?,
      userId: json['user_id'] as String?,
      storeId: json['store_id'] as String?,
      status: json['status'] as String?,
      shippingCharge: json['shipping_charge'] as int?,
      description: json['description'] as String?,
      media: (json['media'] != null) ? List<String>.from(json['media']) : null,
      specification: (json['specification'] as List<dynamic>?)
          ?.map((e) => Specification.fromMap(e as Map<String, dynamic>?))
          .toList(),
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      createdAt: (json['createdAt'] != null)
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: (json['updatedAt'] != null)
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      store: json['store'] != null
          ? Store.fromMap(json['store'] as Map<String, dynamic>?)
          : null,
      productVariant: (json['product_variant'] as List<dynamic>?)
          ?.map((e) => ProductVariant.fromMap(e as Map<String, dynamic>?))
          .toList(),
      productReview: json['product_review'] != null
          ? ProductReview.fromMap(json['product_review'] as Map<String, dynamic>?)
          : null,
      color: json['color'] != null
          ? Colour.fromMap(json['color'] as Map<String, dynamic>?)
          : null,
      combinations: (json['combinations'] as List<dynamic>?)
          ?.map((e) => Combination.fromMap(e as Map<String, dynamic>?))
          .toList(),
      totalReview: json['totalReview'] as int?,
      rating: json['rating'] as String?,
      sold: json['sold'] as int?,
      hasVariant: json['hasVariant'] as bool?,
      wishProduct: json['wishProduct'] as bool?,
      trustedSeller: json['trusted_seller'] != null
          ? TrustedSeller.fromMap(json['trusted_seller'] as Map<String, dynamic>?)
          : null,
      location: json['location'] != null
          ? ProductLocation.fromMap(json['location'] as Map<String, dynamic>?)
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
      'created_by': createdBy,
      'updated_by': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'store': store?.toMap(),
      'product_variant': productVariant?.map((e) => e.toMap()).toList(),
      'product_review': productReview?.toMap(),
      'color': color?.toMap(),
      'combinations': combinations?.map((e) => e.toMap()).toList(),
      'totalReview': totalReview,
      'rating': rating,
      'sold': sold,
      'hasVariant': hasVariant,
      'wishProduct': wishProduct,
      'trusted_seller': trustedSeller?.toMap(),
      'location': location?.toMap(),
    };
  }
}

class ProductLocation {
  double? lat;
  double? lng;
  String? city;
  String? country;
  double? radius;

  ProductLocation({
    this.lat,
    this.lng,
    this.city,
    this.country,
    this.radius,
  });

  factory ProductLocation.fromMap(Map<String, dynamic>? json) {
    if (json == null) return ProductLocation();
    return ProductLocation(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      city: json['city'] as String?,
      country: json['country'] as String?,
      radius: (json['radius'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'city': city,
      'country': country,
      'radius': radius,
    };
  }

  bool get hasCoordinates => lat != null && lng != null;
  bool get hasAddress => city != null || country != null;

  String get displayAddress {
    final parts = <String>[];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }
}

class TrustedSeller {
  String? id;


  TrustedSeller({
    this.id,
   
  });

  factory TrustedSeller.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return TrustedSeller();
    }

    return TrustedSeller(
      id: json['_id'] as String?,
   
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
   
    };
  }
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
  Colour? color;
  List<Attribute>? attribute;

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
    this.color,
    this.attribute,
  });

  factory ProductVariant.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return ProductVariant();
    }

    return ProductVariant(
      id: json['_id'] as String?,
      productId: json['product_id'] as String?,
      colorId: json['color_id'] as String?,
      sku: json['sku'] as String?,
      isbnNumber: json['isbn_number'] as String?,
      image: json['image'] as String?,
        mainPrice: (json['main_price'] as num?)?.toDouble(),
        sellPrice: (json['sell_price'] as num?)?.toDouble(),
      stock: json['stock'] as int?,
      color: json['color'] != null
          ? Colour.fromMap(json['color'] as Map<String, dynamic>?)
          : null,
      attribute: (json['attribute'] as List<dynamic>?)
          ?.map((e) => Attribute.fromMap(e as Map<String, dynamic>?))
          .toList(),
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
      'stock': stock,
      'color': color?.toMap(),
      'attribute': attribute?.map((e) => e.toMap()).toList(),
    };
  }
}

class Colour {
  String? id;
  String? name;
  String? value;

  Colour({
    this.id,
    this.name,
    this.value,
  });

  factory Colour.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return Colour();
    }

    return Colour(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
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

class ProductReview {
  int? totalReview;
  double? rating;

  ProductReview({this.totalReview, this.rating});

  factory ProductReview.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return ProductReview();
    }

    return ProductReview(
      totalReview: json['totalReview'] as int?,
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalReview': totalReview,
      'rating': rating,
    };
  }
}

class Combination {
  String? name;
  String? value;

  Combination({
    this.name,
    this.value,
  });

  factory Combination.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return Combination();
    }

    return Combination(
      name: json['name'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
    };
  }
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

  factory Store.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return Store();
    }

    return Store(
      id: json['_id'] as String?,
      categoryName: json['category_name'] as String?,
      userId: json['user_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      imagePath: json['image_path'] as String?,
      status: json['status'] as String?,
      shipping: json['shipping'] as String?,
      delivery: json['delivery'] as String?,
      returns: json['returns'] as String?,
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
    };
  }
}

class Attribute {
  String? id;
  String? name;
  String? value;

  Attribute({
    this.id,
    this.name,
    this.value,
  });

  factory Attribute.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return Attribute();
    }

    return Attribute(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
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

class Specification {
  String? value;
  String? label;

  Specification({
    this.value,
    this.label,
  });

  factory Specification.fromMap(Map<String, dynamic>? json) {
    if (json == null) {
      return Specification();
    }

    return Specification(
      value: json['value'] as String?,
      label: json['label'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'label': label,
    };
  }
}
