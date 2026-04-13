/// Model for buyer review list items.
/// Matches: GET /api/market-place/buyer/all-review
class BuyerReviewItem {
  final String id;
  final String? productId;
  final String? userId;
  final String? orderId;
  final int rating;
  final String? reviewTitle;
  final String? reviewDescription;
  final List<String> media;
  final String? reply;
  final String? repliedBy;
  final String? createdAt;
  final ReviewProduct? product;

  BuyerReviewItem({
    required this.id,
    this.productId,
    this.userId,
    this.orderId,
    this.rating = 0,
    this.reviewTitle,
    this.reviewDescription,
    this.media = const [],
    this.reply,
    this.repliedBy,
    this.createdAt,
    this.product,
  });

  factory BuyerReviewItem.fromMap(Map<String, dynamic> map) {
    return BuyerReviewItem(
      id: map['_id'] as String? ?? '',
      productId: map['product_id'] as String?,
      userId: map['user_id'] as String?,
      orderId: map['order_id'] as String?,
      rating: map['rating'] as int? ?? 0,
      reviewTitle: map['review_title'] as String?,
      reviewDescription: map['review_description'] as String?,
      media: (map['media'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      reply: map['reply'] as String?,
      repliedBy: map['replayed_by'] as String?,
      createdAt: map['createdAt'] as String?,
      product: map['products'] is Map<String, dynamic>
          ? ReviewProduct.fromMap(map['products'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ReviewProduct {
  final String id;
  final String? productName;
  final List<String> media;

  ReviewProduct({required this.id, this.productName, this.media = const []});

  factory ReviewProduct.fromMap(Map<String, dynamic> map) {
    return ReviewProduct(
      id: map['_id'] as String? ?? '',
      productName: map['product_name'] as String?,
      media: (map['media'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
