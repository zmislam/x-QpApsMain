class ReviewModel {
  int? status;
  int? totalCount;
  ReviewData? data;

  ReviewModel({this.status, this.totalCount, this.data});

  // fromMap
  factory ReviewModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ReviewModel();
    
    return ReviewModel(
      status: map['status'],
      totalCount: map['totalCount'],
      data: map['data'] != null ? ReviewData.fromMap(map['data']) : null,
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'totalCount': totalCount,
      'data': data?.toMap(),
    };
  }
}

class ReviewData {
  int? averageRating;
  int? oneStarRating;
  int? twoStarRating;
  int? threeStarRating;
  int? fourStarRating;
  int? fiveStarRating;
  List<ProductReviewDetails>? review;

  ReviewData({
    this.averageRating,
    this.oneStarRating,
    this.twoStarRating,
    this.threeStarRating,
    this.fourStarRating,
    this.fiveStarRating,
    this.review,
  });

  // fromMap
  factory ReviewData.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ReviewData();
    
    return ReviewData(
      averageRating: map['averageRating'],
      oneStarRating: map['oneStarRating'],
      twoStarRating: map['twoStarRating'],
      threeStarRating: map['threeStarRating'],
      fourStarRating: map['fourStarRating'],
      fiveStarRating: map['fiveStarRating'],
      review: map['review'] != null
          ? List<ProductReviewDetails>.from(map['review']?.map((x) => ProductReviewDetails.fromMap(x)))
          : null,
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'averageRating': averageRating,
      'oneStarRating': oneStarRating,
      'twoStarRating': twoStarRating,
      'threeStarRating': threeStarRating,
      'fourStarRating': fourStarRating,
      'fiveStarRating': fiveStarRating,
      'review': review?.map((x) => x.toMap()).toList(),
    };
  }
}

class ProductReviewDetails {
  String? id;
  String? productId;
  String? userId;
  String? orderId;
  int? rating;
  String? reviewTitle;
  String? reviewDescription;
  List<dynamic>? media;
  dynamic reply;
  dynamic replayedBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  ReviewUser? reviewUser;
  String? replyStatus;

  ProductReviewDetails({
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
    this.reviewUser,
    this.replyStatus,
  });

  // fromMap
  factory ProductReviewDetails.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ProductReviewDetails();
    
    return ProductReviewDetails(
      id: map['_id'],
      productId: map['product_id'],
      userId: map['user_id'],
      orderId: map['order_id'],
      rating: map['rating'],
      reviewTitle: map['review_title'],
      reviewDescription: map['review_description'],
      media: map['media'] != null ? List<dynamic>.from(map['media']) : null,
      reply: map['reply'],
      replayedBy: map['replayed_by'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      v: map['__v'],
      reviewUser: map['review_user'] != null
          ? ReviewUser.fromMap(map['review_user'])
          : null,
      replyStatus: map['reply_status'],
    );
  }

  // toMap
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'review_user': reviewUser?.toMap(),
      'reply_status': replyStatus,
    };
  }
}

class ReviewUser {
  String? id;
  String? firstName;
  String? lastName;
  String? profilePic;

  ReviewUser({
    this.id,
    this.firstName,
    this.lastName,
    this.profilePic,
  });

  // fromMap
  factory ReviewUser.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ReviewUser();
    
    return ReviewUser(
      id: map['_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      profilePic: map['profile_pic'],
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_pic': profilePic,
    };
  }
}
