class BuyerOrderModel {
  int? status;
  int? totalCount;
  List<BuyerOrderResult>? results;

  BuyerOrderModel({this.status, this.totalCount, this.results});

  factory BuyerOrderModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerOrderModel();

    return BuyerOrderModel(
      status: map['status'],
      totalCount: map['totalCount'],
      results: map['results'] != null
          ? List<BuyerOrderResult>.from(
              map['results']?.map((x) => BuyerOrderResult.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'totalCount': totalCount,
      'results': results?.map((x) => x.toMap()).toList(),
    };
  }
}

class BuyerOrderResult {
  String? id;
  String? invoiceNumber;
  String? buyerId;
  String? addressId;
  String? createdAt;
  String? updatedAt;
  int? v;
  List<BuyerOrderDetail>? orderDetails;
  OrderSubDetail? orderSubDetails;
  List<BuyersProduct>? products;
  int? totalProductCount;

  BuyerOrderResult({
    this.id,
    this.invoiceNumber,
    this.buyerId,
    this.addressId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.orderDetails,
    this.orderSubDetails,
    this.products,
    this.totalProductCount,
  });

  factory BuyerOrderResult.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerOrderResult();

    return BuyerOrderResult(
      id: map['_id'],
      invoiceNumber: map['invoice_number'],
      buyerId: map['buyer_id'],
      addressId: map['address_id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      v: map['__v'],
      orderDetails: map['order_details'] != null
          ? List<BuyerOrderDetail>.from(
              map['order_details']?.map((x) => BuyerOrderDetail.fromMap(x)))
          : null,
      orderSubDetails: map['order_sub_details'] != null
          ? OrderSubDetail.fromMap(map['order_sub_details'])
          : null,
      products: map['products'] != null
          ? List<BuyersProduct>.from(
              map['products']?.map((x) => BuyersProduct.fromMap(x)))
          : null,
      totalProductCount: map['total_product_count'],
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
      'order_details': orderDetails?.map((x) => x.toMap()).toList(),
      'order_sub_details': orderSubDetails?.toMap(),
      'products': products?.map((x) => x.toMap()).toList(),
      'total_product_count': totalProductCount,
    };
  }
}

class BuyerOrderDetail {
  String? id;
  String? orderId;
  String? productId;
  String? variantId;
  String? storeId;
  String? sellerId;
  int? sellMainPrice;
  int? sellPrice;
  int? quantity;
  int? v;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<BuyersProduct>? products;

  BuyerOrderDetail({
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
    this.products,
  });

  factory BuyerOrderDetail.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerOrderDetail();

    return BuyerOrderDetail(
      id: map['_id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      variantId: map['variant_id'],
      storeId: map['store_id'],
      sellerId: map['seller_id'],
      sellMainPrice: map['sell_main_price'],
      sellPrice: map['sell_price'],
      quantity: map['quantity'],
      v: map['__v'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      products: map['products'] != null
          ? List<BuyersProduct>.from(
              map['products']?.map((x) => BuyersProduct.fromMap(x)))
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
      'products': products?.map((x) => x.toMap()).toList(),
    };
  }
}

class OrderSubDetail {
  String? id;
  String? status;
  double? total_amount;
  BuyersStore? store;

  OrderSubDetail({this.id, this.status, this.store, this.total_amount});

  factory OrderSubDetail.fromMap(Map<String, dynamic>? map) {
    if (map == null) return OrderSubDetail();

    return OrderSubDetail(
      id: map['_id'],
      status: map['status'],
     total_amount: (map['total_amount'] as num?)?.toDouble(), 
      store: map['store'] != null ? BuyersStore.fromMap(map['store']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'status': status,
      'total_amount': total_amount,
      'store': store?.toMap(),
    };
  }
}

class BuyersStore {
  String? id;
  String? name;

  BuyersStore({this.id, this.name});

  factory BuyersStore.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyersStore();

    return BuyersStore(
      id: map['_id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class BuyersProduct {
  String? id;
  String? productName;
  List<String>? media;

  BuyersProduct({this.id, this.productName, this.media});

  factory BuyersProduct.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyersProduct();

    return BuyersProduct(
      id: map['_id'],
      productName: map['product_name'],
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
