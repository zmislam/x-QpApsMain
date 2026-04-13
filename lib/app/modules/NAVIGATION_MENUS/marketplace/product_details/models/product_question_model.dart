class ProductQuestion {
  String? id;
  String? productId;
  String? question;
  String? answer;
  QuestionUser? user;
  DateTime? createdAt;
  DateTime? answeredAt;

  ProductQuestion({
    this.id,
    this.productId,
    this.question,
    this.answer,
    this.user,
    this.createdAt,
    this.answeredAt,
  });

  factory ProductQuestion.fromMap(Map<String, dynamic>? json) {
    if (json == null) return ProductQuestion();
    return ProductQuestion(
      id: json['_id'] as String?,
      productId: json['product_id'] as String?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      user: json['user_id'] is Map
          ? QuestionUser.fromMap(json['user_id'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      answeredAt: json['answered_at'] != null
          ? DateTime.tryParse(json['answered_at'].toString())
          : null,
    );
  }
}

class QuestionUser {
  String? id;
  String? firstName;
  String? lastName;
  String? profilePic;

  QuestionUser({this.id, this.firstName, this.lastName, this.profilePic});

  factory QuestionUser.fromMap(Map<String, dynamic>? json) {
    if (json == null) return QuestionUser();
    return QuestionUser(
      id: json['_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      profilePic: json['profile_pic'] as String?,
    );
  }
}
