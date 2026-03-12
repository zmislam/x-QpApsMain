class SellerOrderData {
  int? totalOrders;
  int? pendingCount;
  int? processingCount;
  int? deliveredCount;
  int? refundCount;
  int? cancelOrder;
  List<SellerOrderModel>? orders;

  SellerOrderData({
    this.totalOrders,
    this.pendingCount,
    this.processingCount,
    this.deliveredCount,
    this.refundCount,
    this.cancelOrder,
    this.orders,
  });

  factory SellerOrderData.fromMap(Map<String, dynamic> map) {
    return SellerOrderData(
      totalOrders: map['totalOrders'] as int?,
      pendingCount: map['pendingCount'] as int?,
      processingCount: map['processingCount'] as int?,
      deliveredCount: map['deliveredCount'] as int?,
      refundCount: map['refundCount'] as int?,
      cancelOrder: map['cancelOrder'] as int?,
      orders: map['orders'] != null
          ? List<SellerOrderModel>.from(
              map['orders']?.map((x) => SellerOrderModel.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': {
        'totalOrders': totalOrders,
        'pendingCount': pendingCount,
        'processingCount': processingCount,
        'deliveredCount': deliveredCount,
        'refundCount': refundCount,
        'cancelOrder': cancelOrder,
        'orders': orders?.map((x) => x.toMap()).toList(),
      },
    };
  }
}

class SellerOrderModel {
  String? id;
  String? invoiceNumber;
  String? buyerId;
  String? addressId;
  DateTime? createdAt;
  DateTime? updatedAt;
  SellerOrderDetails? orderDetails;
  SellerOrderSubDetails? orderSubDetails;

  SellerOrderModel({
    this.id,
    this.invoiceNumber,
    this.buyerId,
    this.addressId,
    this.createdAt,
    this.updatedAt,
    this.orderDetails,
    this.orderSubDetails,
  });

  factory SellerOrderModel.fromMap(Map<String, dynamic> map) {
    return SellerOrderModel(
      id: map['_id'] as String?,
      invoiceNumber: map['invoice_number'] as String?,
      buyerId: map['buyer_id'] as String?,
      addressId: map['address_id'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      orderDetails: map['order_details'] != null
          ? SellerOrderDetails.fromMap(map['order_details'])
          : null,
      orderSubDetails: map['order_sub_details'] != null
          ? SellerOrderSubDetails.fromMap(map['order_sub_details'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'invoice_number': invoiceNumber,
      'buyer_id': buyerId,
      'address_id': addressId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'order_details': orderDetails?.toMap(),
      'order_sub_details': orderSubDetails?.toMap(),
    };
  }
}

class SellerOrderDetails {
  int? sellPrice;
  String? storeId;
  int? productQuantity;
  Product? product;

  SellerOrderDetails({
    this.sellPrice,
    this.storeId,
    this.productQuantity,
    this.product,
  });

  factory SellerOrderDetails.fromMap(Map<String, dynamic> map) {
    return SellerOrderDetails(
      sellPrice: map['sell_price'] as int?,
      storeId: map['store_id'] as String?,
      productQuantity: map['productQuantity'] as int?,
      product: map['product'] != null
          ? Product.fromMap(map['product'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sell_price': sellPrice,
      'store_id': storeId,
      'productQuantity': productQuantity,
      'product': product?.toMap(),
    };
  }
}

class Product {
  String? id;
  String? productName;
  List<String>? media;

  Product({
    this.id,
    this.productName,
    this.media,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as String?,
      productName: map['product_name'] as String?,
      media: map['media'] != null ? List<String>.from(map['media']) : null,
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

class SellerOrderSubDetails {
  String? status;
  double? totalAmount;
  String? refundStatus;

  SellerOrderSubDetails({
    this.status,
    this.totalAmount,
    this.refundStatus,
  });

  factory SellerOrderSubDetails.fromMap(Map<String, dynamic> map) {
    return SellerOrderSubDetails(
      status: map['status'] as String?,
     totalAmount: map['total_amount'] is int
          ? (map['total_amount'] as int).toDouble()  // Convert int to double
          : map['total_amount'] as double?, 
      refundStatus: map['refund_status'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'total_amount': totalAmount,
      'refund_status': refundStatus,
    };
  }
}
