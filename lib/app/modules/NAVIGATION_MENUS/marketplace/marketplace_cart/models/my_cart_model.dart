import '../../product_details/models/product_details_model.dart';

class MyCart {
  int? status;
  List<StoreData>? data;

  MyCart({this.status, this.data});

  factory MyCart.fromMap(Map<String, dynamic>? map) {
    if (map == null) return MyCart();

    return MyCart(
      status: map['status'] as int?,
      data: (map['data'] as List<dynamic>?)
          ?.map((item) => StoreData.fromMap(item as Map<String, dynamic>?))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data?.map((item) => item.toMap()).toList(),
    };
  }
}

class StoreData {
  String? storeId;
  String? storeName;
  List<MyProduct>? myProduct;
  double? discountedSubTotal;

  StoreData(
      {this.storeId, this.storeName, this.myProduct, this.discountedSubTotal});

  factory StoreData.fromMap(Map<String, dynamic>? map) {
    if (map == null) return StoreData();

    // ! ADDED ?? '' FOR HANDLING NULL VALUE RECEIVED FROM API IN [storeId , storeName]
    return StoreData(
      storeId: map['storeId'] ?? '' as String?,
      storeName: map['store_name'] ?? '' as String?,
      myProduct: (map['products'] as List<dynamic>?)
          ?.map((item) => MyProduct.fromMap(item as Map<String, dynamic>?))
          .toList(),
      discountedSubTotal:
          (map['discount_sub_total_amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'store_name': storeName,
      'products': myProduct?.map((item) => item.toMap()).toList(),
      'discount_sub_total_amount': discountedSubTotal,
    };
  }
}

class MyProduct {
  String? cartId;
  DateTime? cartCreatedAt;
  String? id;
  String? productName;
  String? categoryName;
  String? brandName;
  String? unit;
  String? weight;
  String? height;
  String? width;
  dynamic depth;
  dynamic dimensionUnit;
  int? vat;
  dynamic tax;
  String? productCondition;
  String? userId;
  String? storeId;
  String? status;
  int? shippingCharge;
  String? description;
  List<String>? media;
  List<Specification>? specification;
  bool? hasVariant;
  int? quantity;
  Store? store;
  ProductVariant? productVariants;

  MyProduct({
    this.cartId,
    this.cartCreatedAt,
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
    this.quantity,
    this.store,
    this.productVariants,
  });

  factory MyProduct.fromMap(Map<String, dynamic>? map) {
    if (map == null) return MyProduct();

    return MyProduct(
      cartId: map['cart_id'] as String?,
      cartCreatedAt: map['cart_created_at']?.toDate(),
      id: map['_id'] as String?,
      productName: map['product_name'] as String?,
      categoryName: map['category_name'] as String?,
      brandName: map['brand_name'] as String?,
      unit: map['unit'] as String?,
      weight: map['weight'] as String?,
      height: map['height'] as String?,
      width: map['width'] as String?,
      depth: map['depth'],
      dimensionUnit: map['dimension_unit'],
      vat: map['vat'] as int?,
      tax: map['tax'],
      productCondition: map['product_condition'] as String?,
      userId: map['user_id'] as String?,
      storeId: map['store_id'] as String?,
      status: map['status'] as String?,
      shippingCharge: map['shipping_charge'] as int?,
      description: map['description'] as String?,
      media: (map['media'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      specification: (map['specification'] as List<dynamic>?)
          ?.map((item) => Specification.fromMap(item as Map<String, dynamic>?))
          .toList(),
      hasVariant: map['hasVariant'] == null
          ? null
          : map['hasVariant'] == 'true'
              ? true
              : false,
      quantity: map['quantity'] as int?,
      store: map['store'] == null
          ? null
          : Store.fromMap(map['store'] as Map<String, dynamic>?),
      productVariants: map['product_variants'] == null
          ? null
          : ProductVariant.fromMap(
              map['product_variants'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cart_id': cartId,
      'cart_created_at': cartCreatedAt?.toIso8601String(),
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
      'vat': vat,
      'tax': tax,
      'product_condition': productCondition,
      'user_id': userId,
      'store_id': storeId,
      'status': status,
      'shipping_charge': shippingCharge,
      'description': description,
      'media': media,
      'specification': specification?.map((item) => item.toMap()).toList(),
      'hasVariant': hasVariant,
      'quantity': quantity,
      'store': store?.toMap(),
      'product_variants': productVariants?.toMap(),
    };
  }
}

class Specification {
  String? value;
  String? label;

  Specification({this.value, this.label});

  factory Specification.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Specification();

    return Specification(
      value: map['value'] as String?,
      label: map['label'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'label': label,
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

  factory Store.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Store();

    return Store(
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

// class ProductVariant {
//   String? id;
//   String? productId;
//   String? colorId;
//   String? sku;
//   String? isbnNumber;
//   String? image;
//   double? mainPrice;
//   double? sellPrice;
//   List<Attribute>? attributes;
//   ColorDetails? color;

//   ProductVariant({
//     this.id,
//     this.productId,
//     this.colorId,
//     this.sku,
//     this.isbnNumber,
//     this.image,
//     this.mainPrice,
//     this.sellPrice,
//     this.attributes,
//     this.color,
//   });

//   factory ProductVariant.fromMap(Map<String, dynamic>? map) {
//     if (map == null) return ProductVariant();

//     return ProductVariant(
//       id: map['_id'] as String?,
//       productId: map['product_id'] as String?,
//       colorId: map['color_id'] as String?,
//       sku: map['sku'] as String?,
//       isbnNumber: map['isbn_number'] as String?,
//       image: map['image'] as String?,
//       mainPrice: (map['main_price'] as num?)?.toDouble(),
//       sellPrice: (map['sell_price'] as num?)?.toDouble(),
//       attributes: (map['attribute'] as List<dynamic>?)
//           ?.map((item) => Attribute.fromMap(item as Map<String, dynamic>?))
//           .toList(),
//       color: map['color'] == null
//           ? null
//           : ColorDetails.fromMap(map['color'] as Map<String, dynamic>?),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       '_id': id,
//       'product_id': productId,
//       'color_id': colorId,
//       'sku': sku,
//       'isbn_number': isbnNumber,
//       'image': image,
//       'main_price': mainPrice,
//       'sell_price': sellPrice,
//       'attribute': attributes?.map((item) => item.toMap()).toList(),
//       'color': color?.toMap(),
//     };
//   }
// }

class Attribute {
  String? id;
  String? name;
  String? value;

  Attribute({this.id, this.name, this.value});

  factory Attribute.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Attribute();

    return Attribute(
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

class ColorDetails {
  String? id;
  String? name;
  String? value;

  ColorDetails({this.id, this.name, this.value});

  factory ColorDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ColorDetails();

    return ColorDetails(
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
