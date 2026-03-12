class SuggestedProductModel {
  String? id;
  String? productName;

  SuggestedProductModel({
    this.id,
    this.productName,
  });

  factory SuggestedProductModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return SuggestedProductModel();

    return SuggestedProductModel(
      id: map['_id'] as String?,
      productName: map['product_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'product_name': productName,
    };
  }
}
