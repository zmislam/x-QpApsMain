class BuyerReviewModel {
  String? id;
  String? productId;
  String? userId;
  String? orderId;
  int? rating;
  String? reviewTitle;
  String? reviewDescription;
  List<String>? media;
  String? reply;
  String? replayedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  BuyerReviewedProduct? product;

  BuyerReviewModel({
    this.id,
    this.productId,
    this.userId,
    this.orderId,
    this.rating,
    this.reviewTitle,
    this.reviewDescription,
    this.media,
    this.reply,
    this.replayedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.product,
  });

  factory BuyerReviewModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerReviewModel();

    return BuyerReviewModel(
      id: map['_id'] as String?,
      productId: map['product_id'] as String?,
      userId: map['user_id'] as String?,
      orderId: map['order_id'] as String?,
      rating: map['rating'] as int?,
      reviewTitle: map['review_title'] as String?,
      reviewDescription: map['review_description'] as String?,
      media: (map['media'] as List?)?.map((e) => e as String).toList(),
      reply: map['reply'] as String?,
      replayedBy: map['replayed_by'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      v: map['__v'] as int?,
      product: map['products'] != null ? BuyerReviewedProduct.fromMap(map['products']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_id': productId,
      'user_id': userId,
      'order_id': orderId,
      'rating': rating,
      'review_title': reviewTitle,
      'review_description': reviewDescription,
      'media': media,
      'reply': reply,
      'replayed_by': replayedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'products': product?.toMap(),
    };
  }
}

class BuyerReviewedProduct {
  String? id;
  String? productName;
  List<String>? media;

  BuyerReviewedProduct({
    this.id,
    this.productName,
    this.media,
  });

  factory BuyerReviewedProduct.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerReviewedProduct();

    return BuyerReviewedProduct(
      id: map['_id'] as String?,
      productName: map['product_name'] as String?,
      media: (map['media'] as List?)?.map((e) => e as String).toList(),
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
