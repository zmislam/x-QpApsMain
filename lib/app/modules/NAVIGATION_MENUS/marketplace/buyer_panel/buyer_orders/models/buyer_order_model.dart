/// Model for buyer order list items.
/// Matches: GET /api/market-place/order/list-for-buyer
class BuyerOrderListItem {
  final String orderId;
  final String? invoiceNumber;
  final String? createdAt;
  final List<String> productImages;
  final OrderSubDetailInfo? subDetail;

  BuyerOrderListItem({
    required this.orderId,
    this.invoiceNumber,
    this.createdAt,
    this.productImages = const [],
    this.subDetail,
  });

  factory BuyerOrderListItem.fromMap(Map<String, dynamic> map) {
    return BuyerOrderListItem(
      orderId: map['_id'] as String? ?? '',
      invoiceNumber: map['invoice_number'] as String?,
      createdAt: map['createdAt'] as String?,
      productImages: (map['product_images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      subDetail: map['order_sub_details'] is Map<String, dynamic>
          ? OrderSubDetailInfo.fromMap(
              map['order_sub_details'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OrderSubDetailInfo {
  final String? status;
  final double totalAmount;
  final String? orderId;
  final StoreInfo? store;
  final List<OrderDetailItem> orderDetails;
  final int totalProductCount;

  OrderSubDetailInfo({
    this.status,
    this.totalAmount = 0,
    this.orderId,
    this.store,
    this.orderDetails = const [],
    this.totalProductCount = 0,
  });

  factory OrderSubDetailInfo.fromMap(Map<String, dynamic> map) {
    return OrderSubDetailInfo(
      status: map['status'] as String?,
      totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0,
      orderId: map['order_id'] as String?,
      store: map['store'] is Map<String, dynamic>
          ? StoreInfo.fromMap(map['store'] as Map<String, dynamic>)
          : null,
      orderDetails: (map['order_details'] as List<dynamic>?)
              ?.map((e) => OrderDetailItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalProductCount: map['total_product_count'] as int? ?? 0,
    );
  }
}

class StoreInfo {
  final String id;
  final String? name;

  StoreInfo({required this.id, this.name});

  factory StoreInfo.fromMap(Map<String, dynamic> map) {
    return StoreInfo(
      id: map['_id'] as String? ?? '',
      name: map['name'] as String?,
    );
  }
}

class OrderDetailItem {
  final String? productId;
  final int quantity;
  final double sellPrice;
  final List<ProductInfo> products;
  final List<String> productImages;

  OrderDetailItem({
    this.productId,
    this.quantity = 0,
    this.sellPrice = 0,
    this.products = const [],
    this.productImages = const [],
  });

  factory OrderDetailItem.fromMap(Map<String, dynamic> map) {
    return OrderDetailItem(
      productId: map['product_id'] as String?,
      quantity: map['quantity'] as int? ?? 0,
      sellPrice: (map['sell_price'] as num?)?.toDouble() ?? 0,
      products: (map['products'] as List<dynamic>?)
              ?.map((e) => ProductInfo.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      productImages: (map['product_images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class ProductInfo {
  final String id;
  final String? productName;
  final List<String> media;

  ProductInfo({required this.id, this.productName, this.media = const []});

  factory ProductInfo.fromMap(Map<String, dynamic> map) {
    return ProductInfo(
      id: map['_id'] as String? ?? '',
      productName: map['product_name'] as String?,
      media: (map['media'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
