// To parse this JSON data, do
//
//     final withdrawMoneyModel = withdrawMoneyModelFromJson(jsonString);

import 'dart:convert';

WithdrawMoneyModel withdrawMoneyModelFromJson(String str) => WithdrawMoneyModel.fromJson(json.decode(str));

String withdrawMoneyModelToJson(WithdrawMoneyModel data) => json.encode(data.toJson());

class WithdrawMoneyModel {
  final String id;
  final String userId;
  final String type;
  final num amount;
  final String? trxId;
  final String? referenceWalletBillId;
  final String? sendMoneyDetailsId;
  final String withdrawRequestQueueId;
  final String? orderId;
  final String? refundId;
  final bool isOrder;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final int v;
  final WithdrawRequestDetails? withdrawRequestDetails;

  WithdrawMoneyModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.trxId,
    this.referenceWalletBillId,
    this.sendMoneyDetailsId,
    required this.withdrawRequestQueueId,
    this.orderId,
    this.refundId,
    required this.isOrder,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.withdrawRequestDetails,
  });

  factory WithdrawMoneyModel.fromJson(Map<String, dynamic> json) {
    return WithdrawMoneyModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? '',
      amount: json['amount'] ?? 0,
      trxId: json['trxId'],
      referenceWalletBillId: json['reference_wallet_bill_id'],
      sendMoneyDetailsId: json['send_money_details_id'],
      withdrawRequestQueueId: json['withdraw_request_queue_id'] ?? '',
      orderId: json['order_id'],
      refundId: json['refund_id'],
      isOrder: json['is_order'] ?? false,
      createdBy: json['created_by'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'] ?? 0,
      withdrawRequestDetails: json['withdrawrequestDetails'] != null ? WithdrawRequestDetails.fromJson(json['withdrawrequestDetails']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'trxId': trxId,
      'reference_wallet_bill_id': referenceWalletBillId,
      'send_money_details_id': sendMoneyDetailsId,
      'withdraw_request_queue_id': withdrawRequestQueueId,
      'order_id': orderId,
      'refund_id': refundId,
      'is_order': isOrder,
      'created_by': createdBy,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      '__v': v,
      'withdrawrequestDetails': withdrawRequestDetails?.toJson(),
    };
  }

  @override
  String toString() {
    return 'WithdrawMoneyModel{id: $id, userId: $userId, type: $type, amount: $amount, trxId: $trxId, referenceWalletBillId: $referenceWalletBillId, sendMoneyDetailsId: $sendMoneyDetailsId, withdrawRequestQueueId: $withdrawRequestQueueId, orderId: $orderId, refundId: $refundId, isOrder: $isOrder, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, withdrawRequestDetails: $withdrawRequestDetails}';
  }
}

class WithdrawRequestDetails {
  final String id;
  final String requestedUserId;
  final String? cardId;
  final num amount;
  final String status;
  final String remarks;
  final String? approvedBy;
  final String? accountHolderName;
  final String? bankName;
  final dynamic accountNumber;
  final dynamic routingNumber;
  final String? method;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  WithdrawRequestDetails({
    required this.id,
    required this.requestedUserId,
    this.cardId,
    required this.amount,
    required this.status,
    required this.remarks,
    this.approvedBy,
    this.accountHolderName,
    this.bankName,
    this.accountNumber,
    this.routingNumber,
    this.method,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory WithdrawRequestDetails.fromJson(Map<String, dynamic> json) {
    return WithdrawRequestDetails(
      id: json['_id'] ?? '',
      requestedUserId: json['requested_user_id'] ?? '',
      cardId: json['card_id'],
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
      approvedBy: json['approved_by'],
      accountHolderName: json['account_holder_name'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      routingNumber: json['routing_number'],
      method: json['method'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'requested_user_id': requestedUserId,
      'card_id': cardId,
      'amount': amount,
      'status': status,
      'remarks': remarks,
      'approved_by': approvedBy,
      'account_holder_name': accountHolderName,
      'bank_name': bankName,
      'account_number': accountNumber,
      'routing_number': routingNumber,
      'method': method,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  @override
  String toString() {
    return 'WithdrawRequestDetails{id: $id, requestedUserId: $requestedUserId, cardId: $cardId, amount: $amount, status: $status, remarks: $remarks, approvedBy: $approvedBy, accountHolderName: $accountHolderName, bankName: $bankName, accountNumber: $accountNumber, routingNumber: $routingNumber, method: $method, createdAt: $createdAt, updatedAt: $updatedAt, v: $v}';
  }
}
