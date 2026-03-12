class RefundDetails {
  String? productId;
  String? variantId;
  int? refundQuantity;
  double? sellPrice;
  String? refundNote;

  RefundDetails(
      {this.productId,
      this.variantId,
      this.refundQuantity,
      this.sellPrice,
      this.refundNote});

  RefundDetails.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    variantId = json['variant_id'];
    refundQuantity = json['refund_quantity'];
    sellPrice = json['sell_price'];
    refundNote = json['refund_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['variant_id'] = variantId;
    data['refund_quantity'] = refundQuantity;
    data['sell_price'] = sellPrice;
    data['refund_note'] = refundNote;
    return data;
  }
}
