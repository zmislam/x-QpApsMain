class BuyerOrderResultDetailModel {
  String? id;
  String? invoiceNumber;
  String? buyerId;
  String? addressId;
  String? createdAt;
  String? updatedAt;
  int? v;
  BuyersAddress? address;
  List<BuyersStoreList>? storeList;

  BuyerOrderResultDetailModel({
    this.id,
    this.invoiceNumber,
    this.buyerId,
    this.addressId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.address,
    this.storeList,
  });

  factory BuyerOrderResultDetailModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerOrderResultDetailModel();

    return BuyerOrderResultDetailModel(
      id: map['_id'] as String?,
      invoiceNumber: map['invoice_number'] as String?,
      buyerId: map['buyer_id'] as String?,
      addressId: map['address_id'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] as int?,
      address: map['address'] != null
          ? BuyersAddress.fromMap(map['address'] as Map<String, dynamic>?)
          : null,
      storeList: map['store_list'] != null
          ? List<BuyersStoreList>.from((map['store_list'] as List<dynamic>)
              .map((x) => BuyersStoreList.fromMap(x as Map<String, dynamic>?)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'invoice_number': invoiceNumber,
      'buyer_id': buyerId,
      'address_id': addressId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'address': address?.toMap(),
      'store_list': storeList?.map((x) => x.toMap()).toList(),
    };
  }
}

class BuyersAddress {
  String? id;
  String? userId;
  String? address;
  String? city;
  String? district;
  String? ward;
  String? recipientsName;
  String? recipientsPhoneNumber;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? email;

  BuyersAddress({
    this.id,
    this.userId,
    this.address,
    this.city,
    this.district,
    this.ward,
    this.recipientsName,
    this.recipientsPhoneNumber,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.email,
  });

  factory BuyersAddress.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyersAddress();

    return BuyersAddress(
      id: map['_id'] as String?,
      userId: map['user_id'] as String?,
      address: map['address'] as String?,
      city: map['city'] as String?,
      district: map['district'] as String?,
      ward: map['ward'] as String?,
      recipientsName: map['recipients_name'] as String?,
      recipientsPhoneNumber: map['recipients_phone_number'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] as int?,
      email: map['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': userId,
      'address': address,
      'city': city,
      'district': district,
      'ward': ward,
      'recipients_name': recipientsName,
      'recipients_phone_number': recipientsPhoneNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'email': email,
    };
  }
}

class BuyersStoreList {
  String? id;
  List<OrderDetails>? orderDetails;
  BuyersStore? store;
  SubDetails? subDetails;

  BuyersStoreList({
    this.id,
    this.orderDetails,
    this.store,
    this.subDetails,
  });

  factory BuyersStoreList.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyersStoreList();

    return BuyersStoreList(
      id: map['_id'] as String?,
      orderDetails: map['order_details'] != null
          ? List<OrderDetails>.from((map['order_details'] as List<dynamic>)
              .map((x) => OrderDetails.fromMap(x as Map<String, dynamic>?)))
          : null,
      store: map['store'] != null
          ? BuyersStore.fromMap(map['store'] as Map<String, dynamic>?)
          : null,
      subDetails: map['sub_details'] != null
          ? SubDetails.fromMap(map['sub_details'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'order_details': orderDetails?.map((x) => x.toMap()).toList(),
      'store': store?.toMap(),
      'sub_details': subDetails?.toMap(),
    };
  }
}

class OrderDetails {
  String? id;
  String? orderId;
  String? productId;
  String? variantId;
  String? storeId;
  String? sellerId;
  double? sellMainPrice;
  double? sellPrice;
  int? quantity;
  int? v;
  String? createdAt;
  String? updatedAt;
  BuyersProductDetails? product;
  Variant? variant;

  OrderDetails({
    this.id,
    this.orderId,
    this.productId,
    this.variantId,
    this.storeId,
    this.sellerId,
    this.sellMainPrice,
    this.sellPrice,
    this.quantity,
    this.v,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.variant,
  });

  factory OrderDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return OrderDetails();

    return OrderDetails(
      id: map['_id'] as String?,
      orderId: map['order_id'] as String?,
      productId: map['product_id'] as String?,
      variantId: map['variant_id'] as String?,
      storeId: map['store_id'] as String?,
      sellerId: map['seller_id'] as String?,
      sellMainPrice: map['sell_main_price'] != null
          ? (map['sell_main_price'] as num).toDouble()
          : null,
      sellPrice: map['sell_price'] != null
          ? (map['sell_price'] as num).toDouble()
          : null,
      quantity: map['quantity'] as int?,
      v: map['__v'] as int?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      product: map['product'] != null
          ? BuyersProductDetails.fromMap(map['product'] as Map<String, dynamic>?)
          : null,
      variant: map['variant'] != null
          ? Variant.fromMap(map['variant'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'order_id': orderId,
      'product_id': productId,
      'variant_id': variantId,
      'store_id': storeId,
      'seller_id': sellerId,
      'sell_main_price': sellMainPrice,
      'sell_price': sellPrice,
      'quantity': quantity,
      '__v': v,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'product': product?.toMap(),
      'variant': variant?.toMap(),
    };
  }
}

class BuyersStore {
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
  String? createdAt;
  String? updatedAt;
  int? v;

  BuyersStore({
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
  });

  factory BuyersStore.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyersStore();

    return BuyersStore(
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
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] as int?,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class BuyersProductDetails {
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
  List<ProductSpecification>? specification;
  String? hasVariant;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  BuyersProductDetails({
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
  });

  factory BuyersProductDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyersProductDetails();

    return BuyersProductDetails(
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
      baseMainPrice: map['base_main_price'] != null
          ? (map['base_main_price'] as num).toDouble()
          : null,
      baseSellingPrice: map['base_selling_price'] != null
          ? (map['base_selling_price'] as num).toDouble()
          : null,
      vat: map['vat'] != null ? (map['vat'] as num).toDouble() : null,
      tax: map['tax'] != null ? (map['tax'] as num).toDouble() : null,
      productCondition: map['product_condition'] as String?,
      userId: map['user_id'] as String?,
      storeId: map['store_id'] as String?,
      status: map['status'] as String?,
      shippingCharge: map['shipping_charge'] != null
          ? (map['shipping_charge'] as num).toDouble()
          : null,
      description: map['description'] as String?,
      media: map['media'] != null
          ? List<String>.from(map['media'] as List<dynamic>)
          : null,
      specification: map['specification'] != null
          ? List<ProductSpecification>.from(
              (map['specification'] as List<dynamic>).map(
                  (x) => ProductSpecification.fromMap(x as Map<String, dynamic>?)))
          : null,
      hasVariant: map['hasVariant'] as String?,
      createdBy: map['created_by'] as String?,
      updatedBy: map['updated_by'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] as int?,
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
      'specification': specification?.map((x) => x.toMap()).toList(),
      'hasVariant': hasVariant,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class ProductSpecification {
  String? label;
  String? value;

  ProductSpecification({
    this.label,
    this.value,
  });

  factory ProductSpecification.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ProductSpecification();

    return ProductSpecification(
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

class Variant {
  String? id;
  String? productId;
  String? colorId;
  String? sku;
  String? isbnNumber;
  String? image;
  double? mainPrice;
  double? sellPrice;
  String? createdAt;
  String? updatedAt;
  int? v;

  Variant({
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
  });

  factory Variant.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Variant();

    return Variant(
      id: map['_id'] as String?,
      productId: map['product_id'] as String?,
      colorId: map['color_id'] as String?,
      sku: map['sku'] as String?,
      isbnNumber: map['isbn_number'] as String?,
      image: map['image'] as String?,
      mainPrice: map['main_price'] != null
          ? (map['main_price'] as num).toDouble()
          : null,
      sellPrice: map['sell_price'] != null
          ? (map['sell_price'] as num).toDouble()
          : null,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      v: map['__v'] as int?,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class SubDetails {
  String? id;
  String? trackingNumber;
  String? couponCode;
  double? deliveryCharge;
  String? status;
  double? couponAmount;

  SubDetails({
    this.id,
    this.trackingNumber,
    this.couponCode,
    this.deliveryCharge,
    this.status,
    this.couponAmount,
  });

  factory SubDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SubDetails();

    return SubDetails(
      id: map['_id'] as String?,
      trackingNumber: map['tracking_number'] as String?,
      couponCode: map['coupon_code'] as String?,
      deliveryCharge: map['delivery_charge'] != null
          ? (map['delivery_charge'] as num).toDouble()
          : null,
      status: map['status'] as String?,
      couponAmount: map['coupon_amount'] != null
          ? (map['coupon_amount'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'tracking_number': trackingNumber,
      'coupon_code': couponCode,
      'delivery_charge': deliveryCharge,
      'status': status,
      'coupon_amount': couponAmount,
    };
  }
}
