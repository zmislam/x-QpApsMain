class SellerDetailOrderList {
  String? id;
  String? storeId;
  double? totalSellPrice;
  String? invoiceNumber;
  String? buyerId;
  String? addressId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  List<String>? productImages;
  int? productCount;

  SellerDetailOrderList({
    this.id,
    this.storeId,
    this.totalSellPrice,
    this.invoiceNumber,
    this.buyerId,
    this.addressId,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.productImages,
    this.productCount,
  });

  factory SellerDetailOrderList.fromMap(Map<String, dynamic> map) {
    return SellerDetailOrderList(
      id: map['_id'] as String?,
      storeId: map['store_id'] as String?,
      totalSellPrice: map['total_sell_price'] != null
          ? (map['total_sell_price'] as num).toDouble()
          : null,
      invoiceNumber: map['invoice_number'] as String?,
      buyerId: map['buyer_id'] as String?,
      addressId: map['address_id'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      status: map['status'] as String?,
      productImages: map['product_images'] != null
          ? List<String>.from(map['product_images'])
          : null,
      productCount: map['productCount'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'store_id': storeId,
      'total_sell_price': totalSellPrice,
      'invoice_number': invoiceNumber,
      'buyer_id': buyerId,
      'address_id': addressId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status,
      'product_images': productImages,
      'productCount': productCount,
    };
  }
}

class SellerOrderList {
  int? totalCount;
  List<SellerDetailOrderList>? orderList;

  SellerOrderList({
    this.totalCount,
    this.orderList,
  });

  factory SellerOrderList.fromMap(Map<String, dynamic> map) {
    return SellerOrderList(
      totalCount: map['total_count'] as int?,
      orderList: map['order_list'] != null
          ? List<SellerDetailOrderList>.from(map['order_list'].map((x) => SellerDetailOrderList.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_count': totalCount,
      'order_list': orderList?.map((x) => x.toMap()).toList(),
    };
  }
}

class ApiResponse {
  int? status;
  List<SellerOrderList>? results;

  ApiResponse({
    this.status,
    this.results,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      status: map['status'] as int?,
      results: map['results'] != null
          ? List<SellerOrderList>.from(map['results'].map((x) => SellerOrderList.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'results': results?.map((x) => x.toMap()).toList(),
    };
  }
}
