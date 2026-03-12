class SellerOrderResponse {
  int? status;
  int? totalCount;
  double? pendingBalance;
  double? paidBalance;
  List<SellerOrderDataList>? data;

  SellerOrderResponse({
    this.status,
    this.totalCount,
    this.pendingBalance,
    this.paidBalance,
    this.data,
  });

  factory SellerOrderResponse.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SellerOrderResponse();
    return SellerOrderResponse(
      status: map['status'] as int?,
      totalCount: map['totalCount'] as int?,
      pendingBalance: (map['pending_balance'] as num?)?.toDouble(),
      paidBalance: (map['paid_balance'] as num?)?.toDouble(),
      data: (map['data'] as List<dynamic>?)
          ?.map((e) => SellerOrderDataList.fromMap(e as Map<String, dynamic>?))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'totalCount': totalCount,
      'pending_balance': pendingBalance,
      'paid_balance': paidBalance,
      'data': data?.map((e) => e.toMap()).toList(),
    };
  }
}

class SellerOrderDataList {
  String? id;
  String? invoiceNumber;
  String? buyerId;
  String? addressId;
  String? billingAddressId;
  DateTime? createdAt;
  DateTime? updatedAt;
  SellerOrderDetails? orderDetails;
  double? amount;

  SellerOrderDataList({
    this.id,
    this.invoiceNumber,
    this.buyerId,
    this.addressId,
    this.billingAddressId,
    this.createdAt,
    this.updatedAt,
    this.orderDetails,
    this.amount,
  });

  factory SellerOrderDataList.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SellerOrderDataList();
    return SellerOrderDataList(
      id: map['_id'] as String?,
      invoiceNumber: map['invoice_number'] as String?,
      buyerId: map['buyer_id'] as String?,
      addressId: map['address_id'] as String?,
      billingAddressId: map['billing_address_id'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
   orderDetails: map['order_details'] != null
    ? SellerOrderDetails.fromMap(map['order_details'] as Map<String, dynamic>?)
    : null,

      amount: (map['amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'invoice_number': invoiceNumber,
      'buyer_id': buyerId,
      'address_id': addressId,
      'billing_address_id': billingAddressId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'order_details': orderDetails?.toMap(),
      'amount': amount,
    };
  }
}

class SellerOrderDetails {
  String? id;
  String? orderId;
  String? productId;
  String? variantId;
  String? storeId;
  String? sellerId;
  double? sellMainPrice;
  double? sellPrice;
  int? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;
  SellerOrderSubDetails? orderSubDetails;
  Product? product;
  int? additionalProducts;

  SellerOrderDetails({
    this.id,
    this.orderId,
    this.productId,
    this.variantId,
    this.storeId,
    this.sellerId,
    this.sellMainPrice,
    this.sellPrice,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.orderSubDetails,
    this.product,
    this.additionalProducts,
  });

  factory SellerOrderDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SellerOrderDetails();
    return SellerOrderDetails(
      id: map['_id'] as String?,
      orderId: map['order_id'] as String?,
      productId: map['product_id'] as String?,
      variantId: map['variant_id'] as String?,
      storeId: map['store_id'] as String?,
      sellerId: map['seller_id'] as String?,
      sellMainPrice: (map['sell_main_price'] as num?)?.toDouble(),
      sellPrice: (map['sell_price'] as num?)?.toDouble(),
      quantity: map['quantity'] as int?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
    orderSubDetails: map['order_sub_details'] != null
    ? SellerOrderSubDetails.fromMap(map['order_sub_details'] as Map<String, dynamic>?)
    : null,
product: map['product'] != null
    ? Product.fromMap(map['product'] as Map<String, dynamic>?)
    : null,

      additionalProducts: map['additionalProducts'] as int?,
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'order_sub_details': orderSubDetails?.toMap(),
      'product': product?.toMap(),
      'additionalProducts': additionalProducts,
    };
  }
}

class SellerOrderSubDetails {
  String? id;
  String? orderId;
  String? storeId;
  String? trackingNumber;
  String? couponCode;
  String? trackingId;
  double? deliveryCharge;
  String? status;
  String? cancelNote;
  double? couponAmount;
  String? paymentStatus;
  String? courierSlug;
  double? subTotalAmount;
  double? vat;
  double? totalAmount;
  DateTime? createdAt;
  DateTime? updatedAt;

  SellerOrderSubDetails({
    this.id,
    this.orderId,
    this.storeId,
    this.trackingNumber,
    this.couponCode,
    this.trackingId,
    this.deliveryCharge,
    this.status,
    this.cancelNote,
    this.couponAmount,
    this.paymentStatus,
    this.courierSlug,
    this.subTotalAmount,
    this.vat,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory SellerOrderSubDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SellerOrderSubDetails();
    return SellerOrderSubDetails(
      id: map['_id'] as String?,
      orderId: map['order_id'] as String?,
      storeId: map['store_id'] as String?,
      trackingNumber: map['tracking_number'] as String?,
      couponCode: map['coupon_code'] as String?,
      trackingId: map['tracking_id'] as String?,
      deliveryCharge: (map['delivery_charge'] as num?)?.toDouble(),
      status: map['status'] as String?,
      cancelNote: map['cancel_note'] as String?,
      couponAmount: (map['coupon_amount'] as num?)?.toDouble(),
      paymentStatus: map['payment_status'] as String?,
      courierSlug: map['courier_slug'] as String?,
      subTotalAmount: (map['sub_total_amount'] as num?)?.toDouble(),
      vat: (map['vat'] as num?)?.toDouble(),
      totalAmount: (map['total_amount'] as num?)?.toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'order_id': orderId,
      'store_id': storeId,
      'tracking_number': trackingNumber,
      'coupon_code': couponCode,
      'tracking_id': trackingId,
      'delivery_charge': deliveryCharge,
      'status': status,
      'cancel_note': cancelNote,
      'coupon_amount': couponAmount,
      'payment_status': paymentStatus,
      'courier_slug': courierSlug,
      'sub_total_amount': subTotalAmount,
      'vat': vat,
      'total_amount': totalAmount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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
      id: map['_id'] as String?,
      productName: map['product_name'] as String?,
      media: (map['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
