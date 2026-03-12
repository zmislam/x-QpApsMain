class BuyerOrderSummary {
  BuyerOrderData? data;

  BuyerOrderSummary({this.data});

  factory BuyerOrderSummary.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerOrderSummary();

    return BuyerOrderSummary(
      data: map['data'] != null ? BuyerOrderData.fromMap(map['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.toMap(),
    };
  }
}

class BuyerOrderData {
  int? totalOrders;
  int? pendingOrders;
  int? processingCount;
  int? completeOrder;
  int? refundCount;
  double? paidBalance;
  double? qpInEscrow;
  double? refundBalance;

  BuyerOrderData({
    this.totalOrders,
    this.pendingOrders,
    this.processingCount,
    this.completeOrder,
    this.refundCount,
    this.paidBalance,
    this.qpInEscrow,
    this.refundBalance,
  });

  factory BuyerOrderData.fromMap(Map<String, dynamic>? map) {
    if (map == null) return BuyerOrderData();

    return BuyerOrderData(
      totalOrders: map['totalOrders'],
      pendingOrders: map['pending_orders'],
      processingCount: map['processingCount'],
      completeOrder: map['complete_order'],
      refundCount: map['refundCount'],
      paidBalance: (map['paid_balance'] as num?)?.toDouble(),
      qpInEscrow: (map['qp_in_escrow'] as num?)?.toDouble(),
      refundBalance: (map['refund_balance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalOrders': totalOrders,
      'pending_orders': pendingOrders,
      'processingCount': processingCount,
      'complete_order': completeOrder,
      'refundCount': refundCount,
      'paid_balance': paidBalance,
      'qp_in_escrow': qpInEscrow,
      'refund_balance': refundBalance,
    };
  }
}
