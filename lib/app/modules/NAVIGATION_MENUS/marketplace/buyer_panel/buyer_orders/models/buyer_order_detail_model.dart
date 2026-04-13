/// Model for buyer order detail.
/// Matches: GET /api/market-place/order/show-for-buyer/:order_id/:store_id
class BuyerOrderDetailModel {
  final String orderId;
  final String? invoiceNumber;
  final String? buyerId;
  final String? createdAt;
  final OrderAddress? address;
  final OrderAddress? billingAddress;
  final List<StoreListItem> storeList;
  final OrderSubInfo? subDetails;

  BuyerOrderDetailModel({
    required this.orderId,
    this.invoiceNumber,
    this.buyerId,
    this.createdAt,
    this.address,
    this.billingAddress,
    this.storeList = const [],
    this.subDetails,
  });

  factory BuyerOrderDetailModel.fromMap(Map<String, dynamic> map) {
    return BuyerOrderDetailModel(
      orderId: map['_id'] as String? ?? '',
      invoiceNumber: map['invoice_number'] as String?,
      buyerId: map['buyer_id'] as String?,
      createdAt: map['createdAt'] as String?,
      address: map['address'] is Map<String, dynamic>
          ? OrderAddress.fromMap(map['address'] as Map<String, dynamic>)
          : null,
      billingAddress: map['billing_address'] is Map<String, dynamic>
          ? OrderAddress.fromMap(
              map['billing_address'] as Map<String, dynamic>)
          : null,
      storeList: (map['store_list'] as List<dynamic>?)
              ?.map(
                  (e) => StoreListItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      subDetails: map['sub_details'] is Map<String, dynamic>
          ? OrderSubInfo.fromMap(map['sub_details'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OrderAddress {
  final String? address;
  final String? address2;
  final String? country;
  final String? city;
  final String? district;
  final String? ward;
  final String? recipientsName;
  final String? recipientsPhone;
  final String? recipientsEmail;

  OrderAddress({
    this.address,
    this.address2,
    this.country,
    this.city,
    this.district,
    this.ward,
    this.recipientsName,
    this.recipientsPhone,
    this.recipientsEmail,
  });

  factory OrderAddress.fromMap(Map<String, dynamic> map) {
    return OrderAddress(
      address: map['address'] as String?,
      address2: map['address2'] as String?,
      country: map['country'] as String?,
      city: map['city'] as String?,
      district: map['district'] as String?,
      ward: map['ward'] as String?,
      recipientsName: map['recipients_name'] as String?,
      recipientsPhone: map['recipients_phone_number'] as String?,
      recipientsEmail: map['recipients_email'] as String?,
    );
  }

  String get fullAddress {
    final parts = [address, address2, ward, district, city, country]
        .where((e) => e != null && e.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}

class StoreListItem {
  final String? productId;
  final String? variantId;
  final String? storeId;
  final String? sellerId;
  final double sellMainPrice;
  final double sellPrice;
  final int quantity;
  final OrderProductDetail? product;
  final OrderVariant? variant;
  final dynamic refund;

  StoreListItem({
    this.productId,
    this.variantId,
    this.storeId,
    this.sellerId,
    this.sellMainPrice = 0,
    this.sellPrice = 0,
    this.quantity = 0,
    this.product,
    this.variant,
    this.refund,
  });

  factory StoreListItem.fromMap(Map<String, dynamic> map) {
    return StoreListItem(
      productId: map['product_id'] as String?,
      variantId: map['variant_id'] as String?,
      storeId: map['store_id'] as String?,
      sellerId: map['seller_id'] as String?,
      sellMainPrice: (map['sell_main_price'] as num?)?.toDouble() ?? 0,
      sellPrice: (map['sell_price'] as num?)?.toDouble() ?? 0,
      quantity: map['quantity'] as int? ?? 0,
      product: map['product'] is Map<String, dynamic>
          ? OrderProductDetail.fromMap(
              map['product'] as Map<String, dynamic>)
          : null,
      variant: map['variant'] is Map<String, dynamic>
          ? OrderVariant.fromMap(map['variant'] as Map<String, dynamic>)
          : null,
      refund: map['refund'],
    );
  }

  bool get hasReview => product?.review != null;
}

class OrderProductDetail {
  final String id;
  final String? productName;
  final List<String> media;
  final ProductReviewInfo? review;

  OrderProductDetail({
    required this.id,
    this.productName,
    this.media = const [],
    this.review,
  });

  factory OrderProductDetail.fromMap(Map<String, dynamic> map) {
    return OrderProductDetail(
      id: map['_id'] as String? ?? '',
      productName: map['product_name'] as String?,
      media: (map['media'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      review: map['review'] is Map<String, dynamic>
          ? ProductReviewInfo.fromMap(map['review'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProductReviewInfo {
  final int rating;
  final String? reviewTitle;
  final List<String> media;

  ProductReviewInfo({
    this.rating = 0,
    this.reviewTitle,
    this.media = const [],
  });

  factory ProductReviewInfo.fromMap(Map<String, dynamic> map) {
    return ProductReviewInfo(
      rating: map['rating'] as int? ?? 0,
      reviewTitle: map['review_title'] as String?,
      media: (map['media'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class OrderVariant {
  final List<VariantAttribute> attributes;
  final String? colorName;

  OrderVariant({this.attributes = const [], this.colorName});

  factory OrderVariant.fromMap(Map<String, dynamic> map) {
    return OrderVariant(
      attributes: (map['product_variant_detail'] as List<dynamic>?)
              ?.map((e) =>
                  VariantAttribute.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      colorName: map['color_name'] as String?,
    );
  }

  String get displayText {
    final parts = <String>[];
    if (colorName != null && colorName!.isNotEmpty) parts.add(colorName!);
    for (final attr in attributes) {
      parts.add('${attr.value}: ${attr.name}');
    }
    return parts.join(' • ');
  }
}

class VariantAttribute {
  final String name;
  final String value;

  VariantAttribute({required this.name, required this.value});

  factory VariantAttribute.fromMap(Map<String, dynamic> map) {
    return VariantAttribute(
      name: map['name'] as String? ?? '',
      value: map['value'] as String? ?? '',
    );
  }
}

class OrderSubInfo {
  final String? status;
  final double totalAmount;
  final String? storeName;
  final String? storeId;

  OrderSubInfo({
    this.status,
    this.totalAmount = 0,
    this.storeName,
    this.storeId,
  });

  factory OrderSubInfo.fromMap(Map<String, dynamic> map) {
    return OrderSubInfo(
      status: map['status'] as String?,
      totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0,
      storeName: map['store']?['name'] as String?,
      storeId: map['store']?['_id'] as String?,
    );
  }
}
